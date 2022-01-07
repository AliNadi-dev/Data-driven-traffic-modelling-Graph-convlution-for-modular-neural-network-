function [Model]=TrainModels(VLH_P,VLH_T,agg,model,model_A15,flowAll,speedAll,PT,Containerflow,nontruck_flow,ExpectedSpeed,node,link)
%% initialization 
if strcmp(link,"A15")
    endnode=90;
elseif strcmp(link,"A4")
    endnode=8;
    connectionNode=40;
elseif strcmp(link,"A29")
    endnode=20;
    connectionNode=56;
elseif strcmp(link,"A16S")
    endnode=35;
    connectionNode=68;
elseif strcmp(link,"A16N")
    endnode=13;
    connectionNode=63;
end
%% prepare the input and target data
    if strcmp(link,"A15") 
        if node>1
            Predictedflow=model{node-1,1}.output.flow;
        end
    else 
        if node>1
            Predictedflow=model{node-1,1}.output.flow;
        else
            Predictedflow=model_A15{connectionNode,1}.output.flow;
        end
        
    end
    % all these spatial and temporal delays are tuned with an global
    % optimizer. the optimizer is decouped from the training phase to decrease the training time
    % the results from the tuning phase is now set manuall here as follows 
    if strcmp(link,'A15')
    dc= 0:16;             % list of delays for the container flow
    df_n=1:12;            % list of delays for the non truck flow or flow
    ds=0:4;              % list of delays for the speed profile
    spetialdelay= 3;    % number of spetial location for speed convolution 
    df=1:12;              % list of delays for the predicted flow coming from previous node
    elseif strcmp(link,'A4')
        dc= 0:16;             % list of delays for the container flow
        df_n=1:8;            % list of delays for the non truck flow or flow
        ds=0:3;              % list of delays for the speed profile
        spetialdelay= 2;    % number of spetial location for speed convolution 
        df=1:8;              % list of delays for the predicted flow coming from previous node
    elseif strcmp(link,'A29')
         dc= 0:16;             % list of delays for the container flow
        df_n=1:8;            % list of delays for the non truck flow or flow
        ds=0:1;              % list of delays for the speed profile
        spetialdelay= 1;    % number of spetial location for speed convolution 
        df=1:8;              % list of delays for the predicted flow coming from previous node
    elseif strcmp(link,'A16N')
        dc= 0:16;             % list of delays for the container flow
        df_n=1:8;            % list of delays for the non truck flow or flow
        ds=0:3;              % list of delays for the speed profile
        spetialdelay= 2;    % number of spetial location for speed convolution 
        df=1:8;              % list of delays for the predicted flow coming from previous node
    elseif strcmp(link,'A16S')
        dc= 0:16;             % list of delays for the container flow
        df_n=1:8;            % list of delays for the non truck flow or flow
        ds=0:3;              % list of delays for the speed profile
        spetialdelay= 2;    % number of spetial location for speed convolution 
        df=1:8;              % list of delays for the predicted flow coming from previous node
    end
    nDelay_c=numel(dc);
    nDelay_fn=numel(df_n);
    nDelay_f=numel(df);
    nDelay_s=numel(ds);
    MaxDelay=max([dc df_n ds]);
    input_c=[];
    input_fn=[];
    input_f=[];
    input_s=[];
    input_ss=[];
    targets=[];
    % calculate delayed profiles for each input 
    for i=1:146
        N=size(Containerflow,2);
        Range=(MaxDelay+1):N;
        % prepare inputs based on delays
        in_c = zeros(nDelay_c,numel(Range));
        in_f=zeros(nDelay_f,numel(Range));
        in_s=zeros(nDelay_s,numel(Range));
        in_ss=zeros(nDelay_s,numel(Range));
        for k=1:nDelay_c
            d=dc(k);
            in_c(k,:)=Containerflow(:,Range-d,i);
        end
        input_c=[input_c in_c]; % container input
        
        
        for k=1:nDelay_fn
            d=df_n(k);
            in_fn(k,:)=nontruck_flow(node,Range-d,i);
        end
        input_fn=[input_fn in_fn]; % non truck flow input profile
        
        if node>1
            for k=1:nDelay_f
                d=df(k);
                in_f(k,:)=Predictedflow(1,Range-d,i);
            end
            input_f=[input_f in_f];  % predictions from previous nodes 
        end
        
        if ismember(ExpectedSpeed.index.All(i),ExpectedSpeed.index.saturdays)
            speed=ExpectedSpeed.Saturday;
        elseif ismember(ExpectedSpeed.index.All(i),ExpectedSpeed.index.sundays)
            speed=ExpectedSpeed.Sunday;
        elseif ismember(ExpectedSpeed.index.All(i),ExpectedSpeed.index.mondays)
            speed=ExpectedSpeed.Monday;
        elseif ismember(ExpectedSpeed.index.All(i),ExpectedSpeed.index.tuesdays)
            speed=ExpectedSpeed.Tuesday;
        elseif ismember(ExpectedSpeed.index.All(i),ExpectedSpeed.index.wednesdays)
            speed=ExpectedSpeed.Wednesday;
        elseif ismember(ExpectedSpeed.index.All(i),ExpectedSpeed.index.thursdays)
            speed=ExpectedSpeed.Thursday;
        elseif ismember(ExpectedSpeed.index.All(i),ExpectedSpeed.index.fridays)
            speed=ExpectedSpeed.Friday;
        end
        % take into acount the bounderies of the speed matrix and convolve 
        % speed matrix with both spetial and temporal delays
                 
            sp_delay=min(endnode-node,spetialdelay);
            for k=1:nDelay_s
                d=ds(k);
                if node<endnode
                    in_s(k,:)=mean(speed(node+1:node+sp_delay,Range-d));
                    in_ss(k,:)=mean(speedAll(node:node+sp_delay,Range-d,i));
                else
                    in_s(k,:)=mean(speed(node:node+sp_delay,Range-d));
                    in_ss(k,:)=mean(speedAll(node:node+sp_delay,Range-d,i));
                end
            end
        
        input_s=[input_s in_s]; % expected speed profile input
        input_ss=[input_ss in_ss]; % speed profile
        %prepare targets based on delays
        
        T(1,:)=flowAll(node,Range,i);
        T(2,:)=speedAll(node,Range,i);
        T(3,:)=VLH_T(node,Range,i)+VLH_P(node,Range,i);
        
        
        targets=[targets T];
    end
    % construct the whole input matrix 
    if node>1
        
        inputs=[input_ss;input_c;input_f;input_c];
        
    else
        inputs=[input_ss;input_c;input_fn;input_f;input_c];
    end
    %% Create a Fitting Network
    hiddenLayerSize = [7 6];
    TF={'logsig','logsig','purelin'};
    net = newff(inputs,targets,hiddenLayerSize,TF);
    % net = feedforwardnet(10);
    % net = train(net,inputs,targets);
    % check if any rwo is constant and remove them
    net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
    net.outputs{2}.processFcns = {'removeconstantrows','mapminmax'};
    
    % cross validation
    net.divideFcn = 'dividerand';  % Divide data randomly
    net.divideMode = 'sample';  % Divide up every sample
    net.divideParam.trainRatio = 70/100;
    net.divideParam.valRatio = 15/100;
    net.divideParam.testRatio = 15/100;
    
    net.trainFcn = 'trainlm';  % Levenberg-Marquardt
    
    % cost function
    net.performFcn = 'mse';  % Mean squared error
    
    % options
    net.trainParam.showWindow=false;
    net.trainParam.showCommandLine=false;
    net.trainParam.show=1;
    net.trainParam.epochs=100;
    net.trainParam.goal=1e-8;
    net.trainParam.max_fail=10;
    
    % Train the Network
    [net,tr] = train(net,inputs,targets);
    outputs = net(inputs);
    outputs(outputs<0)=0;
        %errors = gsubtract(targets,outputs);
        %performance = perform(net,targets,outputs);
        
        % Recalculate Training, Validation and Test Performance
        trainInd=tr.trainInd;
        trainInputs = inputs(:,trainInd);
        trainTargets = targets(:,trainInd);
        trainOutputs = outputs(:,trainInd);
        trainOutputs(trainOutputs<0)=0;
        trainErrors = trainTargets-trainOutputs;
        %trainPerformance = perform(net,trainTargets,trainOutputs);
        
        valInd=tr.valInd;
        valInputs = inputs(:,valInd);
        valTargets = targets(:,valInd);
        valOutputs = outputs(:,valInd);
        valOutputs(valOutputs<0)=0;
        %valErrors = valTargets-valOutputs;
        %valPerformance = perform(net,valTargets,valOutputs);
        
        testInd=tr.testInd;
        testInputs = inputs(:,testInd);
        testTargets = targets(:,testInd);
        testOutputs = outputs(:,testInd);
%         testError = testTargets-testOutputs;
        testOutputs(testOutputs<0)=0;
    
    % Test the Network
    
    outflow=reshape(outputs(1,:),[1,1440/agg-MaxDelay,146]);
    outspeed=reshape(outputs(2,:),[1,1440/agg-MaxDelay,146]);
    outPT=reshape(outputs(3,:),[1,1440/agg-MaxDelay,146]);
    output.flow=flowAll(node,:,:);
    output.speed=speedAll(node,:,:);
    output.PT=PT(node,:,:);
    output.flow(1,MaxDelay+1:end,:)=outflow;
    output.speed(1,MaxDelay+1:end,:)=outspeed;
    output.PT(1,MaxDelay+1:end,:)=outPT;
    
    
%      E = mean(trainErrors.^2);
     Model.net   = net;
     Model.train.Inputs=trainInputs;
     Model.train.Targets=trainTargets;
     Model.train.Outputs=trainOutputs;
     Model.val.Inputs =valInputs;
     Model.val.Targets =valTargets;
     Model.val.Outputs =valOutputs;
     Model.test.Inputs =testInputs;
     Model.test.Targets =testTargets;
     Model.test.Outputs =testOutputs;
     Model.inputs=inputs;
     Model.outputs=outputs;
     Model.targets=targets;
     Model.output=output;

end