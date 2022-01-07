function [x_1,t_1] = dittlab_traj(mode,x_0,t_0,x0,x1,t0,t1,V0,V1,pars)
% function [x_1,t_1] = traj(mode,x_0,t_0,x0,x1,t0,t1,V0,V1,pars);
%     or 
% function [x_1,t_1] = traj(mode,x_0,t_0,x0,x1,t0,t1,V0,V1);
% function [x_1,t_1] = traj(mode,x_0,t_0,x0,x1,t0,t1,V0);
% 
% depending on mode
%
%   traj returns the exit location x_1 and exit time t_1 based on either one
%   of the following link travel time estimators:
%
%   mode = 'PCSB' (standard trajectory method)
%      up- and downstream speeds V0 and V1 are conceived stationary until the vehicle
%      exits the space time region [x0, x1, t0, t1]. Speed is considered constant in this region:
%      V0 on the first half of the link, V1 on the second half 
%   mode = 'PLSB' (improved trajectory method)
%      up- and downstream speeds V0 and V1 are conceived stationary until the vehicle
%      exits the space time region [x0, x1, t0, t1]. Speed is considered a linear function of x 
%      on the space time region [x0, x1, t0, t1].
%   mode = 'TRUE' space mean speed trajectory method
%      V0 is considered the true space mean speed in the space time region
%      [x0, x1, t0, t1]. This is the method to be used with simulation
%      results
%   mode = 'SLOWNESS' space mean slowness trajectory method
%      V0 is considered the true speed and we use 1/V0 in the space time region
%      [x0, x1, t0, t1] to reconstruct travel time. This is the method to be used with simulation
%      results
%   mode = 'TRIANGULAR' Coifman (02) trajectory method
%      the speed between V0 and V1 is determined by a triangular
%      fundamental diagram over [x0, x1, t0, t1]. In this case pars is a
%      vector containing [cfree, ccong, vcrit, res] (the last equalling the
%      resolution of the trajectory method) 

if nargin<9
    V1=V0;
end;
if nargin<10
    pars=[];
end;

modes = {'pcsb','plsb','true','slowness'};

if isnumeric(mode)
    if mode > numel(modes) || mode<0
        mode='pcsb';
    else
        mode = modes{mode+1};
    end;
end

switch lower(mode(1:4))
    case 'pcsb'
       [x_1,t_1] = traj_pcsb(x_0,t_0,x0,x1,t0,t1,V0,V1);
    case 'plsb'
       [x_1,t_1] = traj_plsb(x_0,t_0,x0,x1,t0,t1,V0,V1);
    case 'true'
       [x_1,t_1] = traj_true(x_0,t_0,x0,x1,t0,t1,V0);
    case 'slow'
       [x_1,t_1] = traj_slow(x_0,t_0,x0,x1,t0,t1,V0);
    %case 'tria'
    %   [x_1,t_1] = traj_tria(x_0,t_0,x0,x1,t0,t1,V0,V1,pars);
    otherwise
       [x_1,t_1] = traj_pcsb(x_0,t_0,x0,x1,t0,t1,V0,V1);        
end


function [x_1,t_1] = traj_true(x_0,t_0,x0,x1,t0,t1,V0)
x_1 = min(x1, V0*(t1-t_0) + x_0);
t_1 = min(t1, (x1-x_0)/V0 + t_0);


function [x_1,t_1] = traj_slow(x_0,t_0,x0,x1,t0,t1,V0)
W0 = 1/V0;
x_1 = min(x1, (t1-t_0)/W0 + x_0);
t_1 = min(t1, W0*(x1-x_0) + t_0);


function [x_1,t_1] = traj_tria(x_0,t_0,x0,x1,t0,t1,V0,V1, pars)
cfree = pars(1);
ccong = pars(2);
vcrit = pars(3);
h = pars(4);
x_1 = min(x1, (t1-t_0)/W0 + x_0);
t_1 = min(t1, W0*(x1-x_0) + t_0);


function [x_1,t_1] = traj_pcsb(x_0,t_0,x0,x1,t0,t1,V0,V1)
Err=1e-3;
%first half if applicable
if x_0<((x0+x1)/2)
   % first half speed=V0
	x_tmp = min((x0+x1)/2, V0*(t1-t_0) + x_0);
	if V0>0
   	t_tmp = min(t1, ((x0+x1)/2-x_0)/V0 + t_0);
	else
   	t_tmp = t1;
   end;
else
   x_tmp=x_0;
   t_tmp=t_0;
end;
%second half if applicable
if t_tmp < t1
   x_1 = min(x1, V1*(t1-t_tmp) + x_tmp);
   if V1>0
      t_1 = min(t1, (x1-x_tmp)/V1 +t_tmp);
   else
      t_1 = t1;
   end;
else
   x_1=x_tmp;
   t_1=t_tmp;
end

   
function [x_1,t_1] = traj_plsb(x_0,t_0,x0,x1,t0,t1,V0,V1)
% the ALL important A term:
Err=1e-3;
A= (V1 - V0)/(x1-x0);
if abs(A)>=Err
   x_1 = min(x1, x_0 + (V0/A + x_0 - x0)*(exp(A*(t1-t_0))-1));
   if V0>0
      logterm=max(Err,((V0/A) + x1 - x0) / ((V0/A) + x_0 - x0));
      t_1 = min(t1, t_0 + (1/A)*log(logterm));
   else
      t_1 = t1;
   end;
else
   [x_1,t_1] = traj_pcsb(x_0,t_0,x0,x1,t0,t1,V0,V1);
end;

