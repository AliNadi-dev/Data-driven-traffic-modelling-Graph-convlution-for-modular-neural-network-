function [NLTT, TT] = rl_trajectory(method,u,x,res,T);
% function [NLTT, TT] = rl_trajectory(method,u,x,res,T);
%
%	calculates travel time estimates.
%
%	INPUT:
%		method: -2: instantaneous travel time based on piece wise constant speeds
%               -1: instantaneous travel time based on piece wise linear speeds
%				 0: trajectory method based on piece wise constant speeds (PCSB)
%				 1: trajectory method based on piece wise linear speeds (PLSB)
%				 2: trajectory method based on space mean section speeds
%				    (e.g. outcome of simulations or filters!)
%				 3: trajectory method based on space mean pace, i.e.
%                   1/average speed !
%		u: a DxTS matrix of speed measurements (D=Nr detectors; TS is nr
%                           Timesteps) in [m/s]
%          or in case of method ==3
%          a NxTS matrix of space mean speeds (N=Nr sections; TS is nr Timesteps)
%		x: a 1xD (or N) vector of longitudinal postions of detectors (section lengths) [m]
%		res: resolution of the trajectory method (default=60) [s]
%		     res is either a skalar, in which case every res seconds a vehicle is simulated
%			  or a vector with predefined start times, e.g. [0 60 120 200 230 ...]
%		T: measurement frequency at detectors (default=60) [s]
%
%	OUTPUT:
%		NLTT: matrix of DxTS*, (TS*<=TS) of time instants each trajectory passes a detector
%		TT: matrix of 2xTS*, with | startingtime | of each trajectory
%								  |  traveltime  |

% argument checking
if nargin<3
   eval('help trajectory;');
   error('rl_trajectory: incorrect nr inputs');
elseif nargin==3
   res=60;
   T=60;
elseif nargin==4
   T=60;
end

% preliminaries
NLTT=[];
[K,P] = size(u);
if length(res)>1
   idx=find(res>P*T);
   if ~isempty(idx)
      tstart=res(1:idx(1)-1);
      if isempty(tstart)
         warning('rl_trajectory: resolution is outside domain, applying default');
         tstart=0:60:P*T;
      end;
   else
      tstart=res;
   end;
else
   if method<0 % instantaneous case
      tstart=0:T:(P-1)*T;
   else % trajectory case
      tstart=0:res:(P-1)*T;
   end;
end;


if method<-2 || method >3
   method=0;
end

% then deal with corruption

% replace missing data with NaN
u(u<0 | isnan(u)) = NaN;

% remove zeros and replace with small number
if method==3
    tolU = 1e-3; % s/m
else
    tolU = 1e-1; % m/s
end;
idx0 = find(u<=tolU);
u(idx0) = tolU*ones(size(idx0));

% then remove structurally missing detectors
nans = isnan(u);
nansums = sum(nans,2);
idxgood =nansums < P;
x = x(idxgood);
u = u(idxgood,:);
K = numel(x);

% default speeds per time period
u_def = nanmean(u,1);
% overall mean speed
U_DEF = nanmean(u(:));

%%%%%%%%%%%%%% instantaneous %%%%%%%%%%%%%%%%%%%%%%
if method<=-1
   % lets go
   X = x(2:end) - x(1:end-1);
   if method==-1
      U = 0.5 .* (u(1:K-1,1:P-1) + u(2:K,1:P-1));
   else
      U = 1./u(:,1:P-1);
      U = 2 ./(U(1:K-1,:) + U(2:K,:));
   end;
   NLTT = tstart;
   for k=1:K-1;
      NLTT = [ NLTT; ...
         NLTT(k,:) + X(k)./[U(k,1) U(k,:)] ];
   end;

%%%%%%%%%%%%%% dynamic %%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
   
   for t=tstart

      p   = 1+floor(t/T); % start period
      k   = 1;          %  start location
      x_1 = x(k);   % 'previous' endlocation
      t_1 = t;      % 'previous' end time
      tr  = [t_1];
      u1  = u_def(p);  % last speed	

      while k<K && p<=P
         % prepare variables
         t0 = (p-1)*T; % start of period
         t1 = t0+T;    % end of period

         % find the last valid upstream detector
         x0 = x(k);
         u0 = u(k,p);
         if isnan(u0)
            % if the value of the upstream detector is missing, replace it with
            % the last speed this vehicle drove
            u0=u1;
            % or - if that doesn't work the speed from the last valid
            % measurement on this detector.
            for kk = k:-1:1
               pp=find(~isnan(u(kk,1:p)));
               if ~isempty(pp)
                  pp = max(pp);
                  x0 = x(kk);
                  u0 = u(kk,pp);
                  break;
               end;
            end;
            % to be sure
            if isnan(u0)
               u0 = U_DEF;
            end;
         end;

         % find the first valid measurement downstream
         x1 = x(k+1);
         u1 = u(k+1,p);
         if isnan(u1)
            % go to further downstream detectors and take first valid
            % measurement there 
            for pp = p:P
               kk=find(~isnan(u(k+1:end,pp)));
               if ~isempty(kk)
                  knext=k+min(kk);
                  x1 = x(knext);
                  u1 = u(knext,pp);
                  break;
               end;
            end;
         end;
         % to be sure
         if isnan(u1)
            u1 = U_DEF;
         end;

% ----------------------------------------------------------------------- 

         x_0 = x_1;    % startlocation is previous endlocation
         t_0 = t_1;    % starttime is previous start time

         % calculate exit {location, time} for
         % - piece-wise constant speeds (method = 0) trajectory
         % - piece-wise linear speeds (method = 1) trajectory
         % - space mean speeds (method = 2) trajectory
         % - space mean slowness (method = 3) trajectory

         if x1>x0
            [x_1,t_1] = rl_traj(method,x_0,t_0,x0,x1,t0,t1,u0,u1);
         else
            x_1 = x_0;
            t_1 = t_0;
         end;

% -----------------------------------------------------------------------         
         
         % did we reach next section? should be always TRUE for methods <3
         if x_1 >= x1
            k=k+1;
            tr=[tr; t_1];
         end;

         % did we reach next period? should be always TRUE for method 3
         % do not change periods if instantaneous travel times are calculated!!!!
         if t_1>=t1
            p=p+1;
         end;

      end;

      if size(tr,1)==K

         NLTT=[NLTT tr];

      end;

   end;

end; % instantaneous or dynamic

if ~isempty(NLTT)
   TT=[NLTT(1,:); NLTT(K,:)-NLTT(1,:)];
else
   TT=[];
end;
