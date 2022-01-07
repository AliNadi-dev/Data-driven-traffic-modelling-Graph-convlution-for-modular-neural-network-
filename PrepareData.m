function [VLH_T,VLH_P,ExpectedSpeed, Containerflow, SpeedAll, FlowAll, Nontruck_flow,PTagg]=PrepareData(Cflow,flow,hectos_asm,speed,TFlow,TruckHectos,agg,link)
    % agg : aggregation level
    %% prepare input and output data
    
    TFlow=reshape(TFlow,[size(TFlow,1),1440,181]);
    Cflow=Cflow(1:181,:);
    Cflow=reshape(Cflow,[1,1440,181]);
    baddays=[17,18,46,48,77,78,79,80,81,82,85,88,93,94,95,96,97,98,99,100,...
        101,115,125,143,144,145,146,147,148,154,155,156,157,175,176];
    %  fill missing values for all links 
    speed(:,:,84)=fillmissing(speed(:,:,84),'nearest',2);
    flow(:,:,84)=fillmissing(flow(:,:,84),'nearest',2);
    speed(:,:,90)=fillmissing(speed(:,:,90),'nearest',2);
    flow(:,:,90)=fillmissing(flow(:,:,90),'nearest',2);

    % impute missing value for specific links 
    if strcmp(link,'A4')
        speed(:,:,76)=fillmissing(speed(:,:,76),'nearest',1);
        flow(:,:,76)=fillmissing(flow(:,:,76),'nearest',1);
        speed(:,:,83)=fillmissing(speed(:,:,83),'previous',1);
        flow(:,:,83)=fillmissing(flow(:,:,83),'previous',1);
        speed(:,:,92)=fillmissing(speed(:,:,92),'previous',1);
        flow(:,:,92)=fillmissing(flow(:,:,92),'previous',1);
        speed(:,:,114)=fillmissing(speed(:,:,114),'previous',1);
        flow(:,:,114)=fillmissing(flow(:,:,114),'previous',1);
        S=speed(:,:,:);
        d=zeros(size(S,2),size(S,1)/3);
        Aggspeed=zeros(size(S,1)/3,1440,181);
        for j=1:181
            temp1=S(:,:,j)';
            for i=1:1440
                d(i,:)=mean(reshape(temp1(i,:),[3,size(S,1)/3]));
                Aggspeed(:,:,j)=d';
                
            end
        end
    elseif strcmp(link,'A29')
        speed(:,:,27)=fillmissing(speed(:,:,27),'nearest',1);
        flow(:,:,27)=fillmissing(flow(:,:,27),'nearest',1);
        speed(:,:,28)=fillmissing(speed(:,:,28),'nearest',1);
        flow(:,:,28)=fillmissing(flow(:,:,28),'nearest',1);
        speed(:,:,34)=fillmissing(speed(:,:,34),'nearest',1);
        flow(:,:,34)=fillmissing(flow(:,:,34),'nearest',1);
        speed(:,:,159)=fillmissing(speed(:,:,159),'nearest',1);
        flow(:,:,159)=fillmissing(flow(:,:,159),'nearest',1);
        speed(:,:,174)=fillmissing(speed(:,:,174),'nearest',1);
        flow(:,:,174)=fillmissing(flow(:,:,174),'nearest',1);
        S=speed(1:end-1,:,:);
        d=zeros(size(S,2),size(S,1)/3);
        Aggspeed=zeros(size(S,1)/3,1440,181);
        for j=1:181
            temp1=S(:,:,j)';
            for i=1:1440
                d(i,:)=mean(reshape(temp1(i,:),[3,size(S,1)/3]));
                Aggspeed(:,:,j)=d';
                
            end
        end

    elseif strcmp(link,'A16N')
        speed(:,:,12)=fillmissing(speed(:,:,12),'nearest',1);
        flow(:,:,12)=fillmissing(flow(:,:,12),'nearest',1);
        speed(:,:,158)=fillmissing(speed(:,:,158),'nearest',1);
        flow(:,:,158)=fillmissing(flow(:,:,158),'nearest',1);
        S=speed(:,:,:);
        d=zeros(size(S,2),size(S,1)/3);
        Aggspeed=zeros(size(S,1)/3,1440,181);
        for j=1:181
            temp1=S(:,:,j)';
            for i=1:1440
                d(i,:)=mean(reshape(temp1(i,:),[3,size(S,1)/3]));
                Aggspeed(:,:,j)=d';
                
            end
        end
        
    elseif strcmp(link,'A16S')
        speed(:,:,121)=fillmissing(speed(:,:,121),'nearest',1);
        flow(:,:,121)=fillmissing(flow(:,:,121),'nearest',1);
        speed(:,:,158)=fillmissing(speed(:,:,158),'nearest',1);
        flow(:,:,158)=fillmissing(flow(:,:,158),'nearest',1);
        speed(:,:,169)=fillmissing(speed(:,:,169),'nearest',1);
        flow(:,:,169)=fillmissing(flow(:,:,169),'nearest',1);
        S=speed(1:end-1,:,:);
        d=zeros(size(S,2),size(S,1)/3);
        Aggspeed=zeros(size(S,1)/3,1440,181);
        for j=1:181
            temp1=S(:,:,j)';
            for i=1:1440
                d(i,:)=mean(reshape(temp1(i,:),[3,size(S,1)/3]));
                Aggspeed(:,:,j)=d';
                
            end
        end
    elseif strcmp(link,'A15')
        S=speed(5:274,:,:);
        d=zeros(1440,size(S,1)/3);
        Aggspeed=zeros(size(S,1)/3,1440,181);
        for j=1:181
            temp1=S(:,:,j)';
            for i=1:1440
                d(i,:)=mean(reshape(temp1(i,:),[3,size(S,1)/3]));
                Aggspeed(:,:,j)=d';
                
            end
        end
    end
        
%     

%     

     % take out the weekends and the days with problematic speed profile
    ExpectedSpeed.index.All=1:1:181;
    ExpectedSpeed.index.sundays=1:7:181;
    ExpectedSpeed.index.saturdays=7:7:181;
    ExpectedSpeed.index.mondays=2:7:181;
    ExpectedSpeed.index.tuesdays=3:7:181;
    ExpectedSpeed.index.wednesdays=4:7:181;
    ExpectedSpeed.index.thursdays=5:7:181;
    ExpectedSpeed.index.fridays=6:7:181;
    % take the bad days out from the indexes 
    ExpectedSpeed.index.sundays(ismember(ExpectedSpeed.index.sundays,baddays))=[];
    ExpectedSpeed.index.saturdays(ismember(ExpectedSpeed.index.saturdays,baddays))=[];
    ExpectedSpeed.index.mondays(ismember(ExpectedSpeed.index.mondays,baddays))=[];
    ExpectedSpeed.index.tuesdays(ismember(ExpectedSpeed.index.tuesdays,baddays))=[];
    ExpectedSpeed.index.wednesdays(ismember(ExpectedSpeed.index.wednesdays,baddays))=[];
    ExpectedSpeed.index.thursdays(ismember(ExpectedSpeed.index.thursdays,baddays))=[];
    ExpectedSpeed.index.fridays(ismember(ExpectedSpeed.index.fridays,baddays))=[];
    ExpectedSpeed.index.All(ismember(ExpectedSpeed.index.All,baddays))=[];
    % calculate expected speed for every weekday
    ExpectedSpeed.Saturday=mean(Aggspeed(:,:,ExpectedSpeed.index.saturdays),3);
    ExpectedSpeed.Sunday=mean(Aggspeed(:,:,ExpectedSpeed.index.sundays),3);
    ExpectedSpeed.Monday=mean(Aggspeed(:,:,ExpectedSpeed.index.mondays),3);
    ExpectedSpeed.Tuesday=mean(Aggspeed(:,:,ExpectedSpeed.index.tuesdays),3);
    ExpectedSpeed.Wednesday=mean(Aggspeed(:,:,ExpectedSpeed.index.wednesdays),3);
    ExpectedSpeed.Thursday=mean(Aggspeed(:,:,ExpectedSpeed.index.thursdays),3);
    ExpectedSpeed.Friday=mean(Aggspeed(:,:,ExpectedSpeed.index.fridays),3);
    % aggregte expected speed
    
    if agg>1
        Saturday=zeros(size(Aggspeed,1),1440/agg);
        Sunday=zeros(size(Aggspeed,1),1440/agg);
        Monday=zeros(size(Aggspeed,1),1440/agg);
        Tuesday=zeros(size(Aggspeed,1),1440/agg);
        Wednesday=zeros(size(Aggspeed,1),1440/agg);
        Thursday=zeros(size(Aggspeed,1),1440/agg);
        Friday=zeros(size(Aggspeed,1),1440/agg);
        for i=1:size(Aggspeed,1)
        Saturday(i,:)=mean(reshape(ExpectedSpeed.Saturday(i,:),[agg,1440/agg]));
        Sunday(i,:)=mean(reshape(ExpectedSpeed.Sunday(i,:),[agg,1440/agg]));
        Monday(i,:)=mean(reshape(ExpectedSpeed.Monday(i,:),[agg,1440/agg]));
        Tuesday(i,:)=mean(reshape(ExpectedSpeed.Tuesday(i,:),[agg,1440/agg]));
        Wednesday(i,:)=mean(reshape(ExpectedSpeed.Wednesday(i,:),[agg,1440/agg]));
        Thursday(i,:)=mean(reshape(ExpectedSpeed.Thursday(i,:),[agg,1440/agg]));
        Friday(i,:)=mean(reshape(ExpectedSpeed.Friday(i,:),[agg,1440/agg]));
        end
%         ExpectedSpeed.Saturday=Saturday(5:end,:);
%         ExpectedSpeed.Sunday=Sunday(5:end,:);
%         ExpectedSpeed.Monday=Monday(5:end,:);
%         ExpectedSpeed.Tuesday=Tuesday(5:end,:);
%         ExpectedSpeed.Wednesday=Wednesday(5:end,:);
%         ExpectedSpeed.Thursday=Thursday(5:end,:);
%         ExpectedSpeed.Friday=Friday(5:end,:);
    end
    % Remove bad signals from the data
    flow(:,:,baddays)=[];
    speed(:,:,baddays)=[];
    TFlow(:,:,baddays)=[];
    Cflow(:,:,baddays)=[];

    %aggrigation and truck percentage calculation 
    
        TruckFlows=zeros(size(flow,1),1440/agg,size(flow,3));
        PT=zeros(size(flow,1),1440/agg,size(flow,3));
        for i=1:size(flow,3)
            [PT(:,:,i), TruckFlows(:,:,i)]=truckpercentage(flow(:,:,i),TFlow(:,:,i),TruckHectos,hectos_asm,agg);  
        end
%     flow=flow(5:end,:,:);
%     speed=speed(5:end,:,:);

    % aggregation
    flowAll=zeros(size(flow,1),1440/agg,size(flow,3));
    speedAll=zeros(size(flow,1),1440/agg,size(flow,3));
    if agg>1 
       for i=1:size(flow,3)
           for j=1:size(flow,1)
               flowAll(j,:,i)=mean(reshape(flow(j,:,i),[agg,1440/agg]),'omitnan');
               speedAll(j,:,i)=mean(reshape(speed(j,:,i),[agg,1440/agg]),'omitnan');
           end
       end
    else
      flowAll=fillmissing(flow,'linear',1);
      speedAll=fillmissing(speed,'linear',1);
    end
    
    TFlows=fillmissing(TruckFlows,'linear',2);
    TFlows(TFlows<0)=0;    
    q_n=flowAll-TFlows;
    q_n(q_n<0)=0;
    Containerflow=zeros(1,1440/agg,size(flow,3));
    if agg>1
        for i=1:size(flow,3)
            Containerflow(:,:,i)=sum(reshape(Cflow(:,:,i),[agg,1440/agg]));
        end
    else
        Containerflow=Cflow;
    end
    nontruck_flow=q_n;
    PT(PT<0)=0;
    if strcmp(link,'A15')
        sp=270;
    elseif strcmp(link,'A4')
        sp=24;
    elseif strcmp(link,'A29')
        sp=60;
    elseif strcmp(link,'A16S')
        sp=105;
    elseif strcmp(link,'A16N')
        sp=39;
    end
        
    flowAll=flowAll(1:sp,:,:);
    speedAll=speedAll(1:sp,:,:);
    nontruck_flow=nontruck_flow(1:sp,:,:);
    TruckFlows=TruckFlows(1:sp,:,:);
    PT=PT(1:sp,:,:);
    a=zeros(1440/agg,sp/3);
    b=zeros(1440/agg,sp/3);
    c=zeros(1440/agg,sp/3);
    d=zeros(1440/agg,sp/3);
    e=zeros(1440/agg,sp/3);
    for j=1:size(flow,3)
        temp1=flowAll(:,:,j)';
        temp2=speedAll(:,:,j)';
        temp3=nontruck_flow(:,:,j)';
        temp4=PT(:,:,j)';
        temp5=TruckFlows(:,:,j)';
    for i=1:1440/agg
        a(i,:)=mean(reshape(temp1(i,:),[3,sp/3]));
        FlowAll(:,:,j)=a';
         b(i,:)=mean(reshape(temp2(i,:),[3,sp/3]));
        SpeedAll(:,:,j)=b';
        c(i,:)=mean(reshape(temp3(i,:),[3,sp/3]));
        Nontruck_flow(:,:,j)=c';
        d(i,:)=mean(reshape(temp4(i,:),[3,sp/3]));
        PTagg(:,:,j)=d';
        e(i,:)=mean(reshape(temp5(i,:),[3,sp/3]));
        TruckFlowsagg(:,:,j)=e';
    end
    end
    %  monetary vehicle loss hour for trucks ( 45 euro per hour)
    VLH_T=zeros(sp/3,1440/agg,size(flow,3));
    for i=1:size(flow,3)
%     VLH_T(:,:,i)=45.*Loss_hour_computation(PTagg(:,:,i).*FlowAll(:,:,i),SpeedAll(:,:,i),80);
    VLH_T(:,:,i)=45.*Loss_hour_computation(TruckFlowsagg(:,:,i),SpeedAll(:,:,i),80);
     end
    
    % monetary vehicle loss hour for passengers (10 euro per hour)
    VLH_P=zeros(sp/3,1440/agg,size(flow,3));
    for i=1:size(flow,3)
    VLH_P(:,:,i)=10.*Loss_hour_computation(Nontruck_flow(:,:,i),SpeedAll(:,:,i),100);
    
    end
    
    
    %  vehicle loss hour for all (10 euro per hour)
%     VLH_all=zeros(sp/3,1440/agg,size(flow,3));
%     for i=1:size(flow,3)
%     VLH_P(:,:,i)=Loss_hour_computation(FlowAll(:,:,i),SpeedAll(:,:,i),85);
%     
%     end
    
    
end

