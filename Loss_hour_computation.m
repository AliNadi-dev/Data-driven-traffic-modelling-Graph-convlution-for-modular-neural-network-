function veh_loss_hr = Loss_hour_computation(q,v,v_free)
    %section is 200 m long
%     dt=1/60; %min
%     dx=0.6;
    v(v==0) = 1; % threshold
    v_free = v_free; %kmph
%     vh=max(0,q.*(dx./v - dx./v_free ).*dt);
   
    veh_hr = (q.*(600*1e-3))./v;
%    weighted_veh_hr = q*veh_hr./sum(q, 2);
    veh_loss_hr = max(0, veh_hr - (q.*(600*1e-3))./v_free);
%     f = sum(veh_loss_hr, 'all');%/sum(q, 'all');
end