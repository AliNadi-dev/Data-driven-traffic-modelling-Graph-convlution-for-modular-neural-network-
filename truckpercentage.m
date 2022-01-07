function [p, H2]=truckpercentage(flow,TruckFlow,TruckHectos,hectos_asm,agg)
%     trucks=wegdata_new3(910);
%     truck_flow=trucks.flow.rijbaanflow(1:24,:);
%     vehicle_flow=flow(5:end,:);
%     hectos=hectos_asm(1,5:end);
    vehicle_flow=flow;
    hectos=hectos_asm;
    j=1;
    I=zeros(size(TruckHectos'));
    for i=TruckHectos'
        dif=hectos-i;
        [~,I(j)]=min(abs(dif));
        j=j+1;
    end
    H=interpolation(TruckFlow,I,size(flow,1));

    H(H<0)=0;
    if agg>1
    for i=1:size(flow,1)
    vehicle_flow2(i,:)=mean(reshape(vehicle_flow(i,:),[agg,(1440/agg)]),'omitnan');
    H2(i,:)=mean(reshape(H(i,:),[agg,(1440/agg)]),'omitnan');
    end
    p=(H2./(vehicle_flow2./(60/agg)));
%     p=mean(p,1,'omitnan');
    else
        p=(H./(vehicle_flow)./(60/agg));
        p=fillmissing(p,'linear',1);
%     	p=mean(p,1,'omitnan');
        H2=H;
    end
% %     p=p*100;
end

function H= interpolation(m,I,n)
    q.truck=nan(n,size(m,2));
%     matchingIndex=[3;8;9;14;32;35;38;41;47;50;57;58;66;74;77;79;83;87;90;91;97;118;133;135];
%     matchingIndex=matchingIndex-2;
    q.truck(I',:)=m;
    q.truck=round(fillmissing(q.truck,'linear',1));
    H=q.truck;
end