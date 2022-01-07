%% Network wide flow and speed prediction for TSO (time shift operation)
%this app is designed for short term prediction of multi-class traffic astates (speed, flow for trucks and passengers) 
%code by: Ali Nadi
clear;clc;close all; 
 %% Read Data
 % running this chunck of code will all the data necessary for this app.
 % all files are in matrix format containing data colleced from portbase
 % dataset and loop detectors for the first 6 months of the year 2017.
 % the Cflow file contains 181 rows (representing days e.g. the first row
 % is the first of January) and 1440 columns each represents a specific
 % time of day in minutes. truck data for each motorway is a matrix of i*j
 % where i is a hectometer and j is time of the day in minutes for all 181
 % days as a series. the hectometer location is also loaded for each
 % motorway to keep track of the locations. the data collected for all
 % vehicles include speed and flow matrixs in form of m*n*d where m is 
 % hectometers, n is time of the day in minutes and d is number of days 
 % (181 days in the provided example). it also retrive the hectometers' 
 % locations and the dates for which the data is collected. the data
 % collection scripts are also included in 'data collection folder'. please
 % note that the speed profiles are recustructed passing through ASM filters.  
  
    % container data
    load('data collection\Cflow.mat');              %  portbased data container demand 
    % truck data
    load('data collection\TruckFlow_A15.mat');      % Truck flow on A15
    load('data collection\TruckHectos_A15.mat');    % Hectormeter location on A15
    load('data collection\TruckFlow_A4.mat');       % Truck flow on A4
    load('data collection\TruckHectos_A4.mat');     % Hectormeter location on A4
    load('data collection\TruckFlow_A29.mat');      % Truck flow on A29
    load('data collection\TruckHectos_A29.mat');    % Hectormeter location on A29
    load('data collection\TruckFlow_A16N.mat');     % Truck flow on A16 North
    load('data collection\TruckHectos_A16N.mat');   % Hectormeter location on A16 North
    load('data collection\TruckFlow_A16S.mat');     % Truck flow on A16 South
    load('data collection\TruckHectos_A16S.mat');   % Hectormeter location on A16 South
    % load speed and flow for all five links 
    load('data collection\Data_2017_Jan_to_June_ASM.mat'); % All vehicles data on A15
    load('data collection\Data_2017_A4_asm.mat');          % All Vehicles data on A4
    load('data collection\Data_2017_A29_asm.mat');         % All Vehicles data on A4
    load('data collection\Data_2017_A16N_asm.mat');        % All Vehicles data on A4
    load('data collection\Data_2017_A16S_asm.mat');        % All Vehicles data on A4

    
%%   Prepare data
%the function Prepare data gets the data needed and generates
%VLH_T_motowayname : vehicle loss hours for trucks 
%VLH_P_motorwayname : vehicle loss hours for passengers
%ExpectedSpeed_motorwayname : historically expected speed 
%Containerflow : the flow of containier at port 
%speedAll_motorwayname : speed profile of all vehicles 
%flowAll_motorwayname : flow of all vehicles 
%nontruck_flow_motorwayname : non truck flow 
%PT_motorwayname : perentage of trucks at each time stamp 

agg=15; % time resolution ( aggregation level ) 
link="A15"; % link name 
[VLH_T_A15,VLH_P_A15,ExpectedSpeed_A15, Containerflow, speedAll_A15, flowAll_A15, nontruck_flow_A15,PT_A15]=PrepareData(Cflow,flow,hectos_asm,speed,TflowA15,TruckHectos_A15,agg,link);
% correct the flow units bade on aggregation level 
flowAll_A15=flowAll_A15./(60/agg);
nontruck_flow_A15=nontruck_flow_A15./(60/agg);
%%
agg=5;
link="A4";
[VLH_T_A4,VLH_P_A4,ExpectedSpeed_A4, Containerflow_A4, speedAll_A4, flowAll_A4, nontruck_flow_A4,PT_A4]=PrepareData(Cflow,flow_A4,Hectos_A4,speed_A4,TflowA4,TruckHectos_A4,agg,link);
% clear dates hectos_asm TruckHectos flow speed Tflow Cflow TFlow
flowAll_A4=flowAll_A4./(60/agg);
nontruck_flow_A4=nontruck_flow_A4./(60/agg);
VLH_P_A4=flip(VLH_P_A4,1);
VLH_T_A4=flip(VLH_T_A4,1);
flowAll_A4=flip(flowAll_A4,1);
speedAll_A4=flip(speedAll_A4,1);
PT_A4=flip(PT_A4,1);
nontruck_flow_A4=flip(nontruck_flow_A4,1);
ExpectedSpeed_A4=flip(ExpectedSpeed_A4,1);

%%
agg=5;
link="A29";
[VLH_T_A29,VLH_P_A29,ExpectedSpeed_A29, Containerflow_A29, speedAll_A29, flowAll_A29, nontruck_flow_A29,PT_A29]=PrepareData(Cflow,flow_A29,Hectos_A29,speed_A29,TflowA29,TruckHectos_A29,agg,link);
% clear dates hectos_asm TruckHectos flow speed Tflow Cflow TFlow
flowAll_A29=flowAll_A29./(60/agg);
nontruck_flow_A29=nontruck_flow_A29./(60/agg);
%%
agg=10;
link="A16N";
[VLH_T_A16N,VLH_P_A16N,ExpectedSpeed_A16N, Containerflow_A16N, speedAll_A16N, flowAll_A16N, nontruck_flow_A16N,PT_A16N]=PrepareData(Cflow,flow_A16N,Hectos_A16N,speed_A16N,TflowA16N,TruckHectos_A16N,agg,link);
% clear dates hectos_asm TruckHectos flow speed Tflow Cflow TFlow
flowAll_A16N=flowAll_A16N./(60/agg);
nontruck_flow_A16N=nontruck_flow_A16N./(60/agg);
VLH_P_A16N=flip(VLH_P_A16N,1);
VLH_T_A16N=flip(VLH_T_A16N,1);
flowAll_A16N=flip(flowAll_A16N,1);
speedAll_A16N=flip(speedAll_A16N,1);
PT_A16N=flip(PT_A16N,1);
nontruck_flow_A16N=flip(nontruck_flow_A16N,1);
ExpectedSpeed_A16N=flip(ExpectedSpeed_A16N,1);
%%
agg=5;
link="A16S";
[VLH_T_A16S,VLH_P_A16S,ExpectedSpeed_A16S, Containerflow_A16S, speedAll_A16S, flowAll_A16S, nontruck_flow_A16S,PT_A16S]=PrepareData(Cflow,flow_A16S,Hectos_A16S,speed_A16S,TflowA16S,TruckHectos_A16S,agg,link);
% clear dates hectos_asm TruckHectos flow speed Tflow Cflow TFlow
flowAll_A16S=flowAll_A16S./(60/agg);
nontruck_flow_A16S=nontruck_flow_A16S./(60/agg);

%% train model Batch 1 : A15
link='A15'; 
% the training process is decomposed into different batches each for a link
%this batch is for A15.
disp('Trainin A15');
model=0; %Intialize the model for each node on a selected motorway we train a model base on trained models on connected motoways. since there is no road connected to node 1 on A15 from other mtorways this is considered as zero 
Nnodes=90; % number of nodes on the motorway 
%E=zeros(Nnodes,1); % models' error ( this is be used for tuning the spetial and temporal delays. however now is dective because the optimized is decoupled from the model trainig phase
models_A15=cell(Nnodes,1);
    for i=1:Nnodes
        tic;
        [models_A15{i,1}]=TrainModels(VLH_P_A15,VLH_T_A15,agg,models_A15,model,flowAll_A15,speedAll_A15,PT_A15,Containerflow,nontruck_flow_A15,ExpectedSpeed_A15,i,link);
        toc;
        disp(['Node: ' int2str(i)]);
    end

%% train model Batch 2 : A4
link='A4'; 
disp('Trainin A4');
Nnodes=8;
%E=zeros(Nnodes,1);
models_A4=cell(Nnodes,1);
    for i=1:Nnodes
        tic;
        [models_A4{i,1}]=TrainModels(VLH_P_A4,VLH_T_A4,agg,models_A4,models_A15,flowAll_A4,speedAll_A4,PT_A4,Containerflow_A4,nontruck_flow_A4,ExpectedSpeed_A4,i,link);
        toc;
        disp(['Node: ' int2str(i)]);
    end
    
    
    %% train model Batch 3 : A29
link='A29';
disp('Trainin A29');
% model_A15=load('model3(best).mat');
Nnodes=20;
E=zeros(Nnodes,1);
models_A29=cell(Nnodes,1);
    for i=1:Nnodes
        tic;
        [models_A29{i,1}]=TrainModels(VLH_P_A29,VLH_T_A29,agg,models_A29,models_A15,flowAll_A29,speedAll_A29,PT_A29,Containerflow_A29,nontruck_flow_A29,ExpectedSpeed_A29,i,link);
        toc;
        disp(['Node: ' int2str(i)]);
    end
    
 %% train model Batch 4 : A16N

link='A16N';
disp('Trainin A16 North');

% model_A15=load('model3(best).mat');
Nnodes=13;
E=zeros(Nnodes,1);
models_A16N=cell(Nnodes,1);
    for i=1:Nnodes
        tic;
        [models_A16N{i,1}]=TrainModels(VLH_P_A16N,VLH_T_A16N,agg,models_A16N,models_A15,flowAll_A16N,speedAll_A16N,PT_A16N,Containerflow_A16N,nontruck_flow_A16N,ExpectedSpeed_A16N,i,link);
        toc;
        disp(['Node: ' int2str(i)]);
    end

     %% train model Batch 5 : A16S

link='A16S';
disp('Trainin A16 South');
% model_A15=load('model3(best).mat');
Nnodes=35;
E=zeros(Nnodes,1);
models_A16S=cell(Nnodes,1);
    for i=1:Nnodes
        tic;
        [models_A16S{i,1}]=TrainModels(VLH_P_A16S,VLH_T_A16S,agg,models_A16S,models_A15,flowAll_A16S,speedAll_A16S,PT_A16S,Containerflow_A16S,nontruck_flow_A16S,ExpectedSpeed_A16S,i,link);
        toc;
        disp(['Node: ' int2str(i)]);
    end
    
%% node specific plot the results 
% Select one of the corridors bellow for visualization of the results  
models=models_A15;
%models=models_A4;
%models=models_A29;
%models=models_A16N;
%models=models_A15S;
% choose which location on the selected corridor you would like to visulize
n=80;   % enter a number between [1-90] for A15,  [1-8] for A4, node [1-20] for A29, [1-13] for A16S, and [1-35] for A16S
m=3;   % what kind of traffic state predictions would you like to visulize? select 1-3 (1: flow, 2: speed, 3: vehicle loss hours)

All.t=models{n,1}.targets(m,:);
All.y=models{n,1}.outputs(m,:);
All.name='All Data';

Test.t=models{n,1}.test.Targets(m,:);
Test.y=models{n,1}.test.Outputs(m,:);
Test.name='Test Data';

Val.t=models{n,1}.val.Targets(m,:);
Val.y=models{n,1}.val.Outputs(m,:);
Val.name='Validation Data';

Train.t=models{n,1}.train.Targets(m,:);
Train.y=models{n,1}.train.Outputs(m,:);
Train.name='Train Data';

PlotResults2(Train,Test,Val,All,m);

%% change container flow and Create scenarios
k=[2 4 8 12];   % time shift 
l=[0.1 0.2 0.3 0.4];  % percentage of shift 
models=models_A15;
link='A15';
Nnodes=90;
tt=zeros(146,3);
for n=k
    for m=l
containers=Containerflow;
con=Containerflow;
counter=zeros(1,96,146);

% calculate shifted container profile 
for i=1:146
%     counter(1,15*60/agg-n:18*60/agg-n,i)=(m).*con(:,15*60/agg:18*60/agg,i);
    containers(1,15*60/agg-n:18*60/agg-n,i)=con(:,15*60/agg-n:18*60/agg-n,i)+(m).*con(:,15*60/agg:18*60/agg,i);
    containers(1,15*60/agg:18*60/agg,i)=(1-m).*con(:,15*60/agg:18*60/agg,i);
    
end

% for i=1:146
%     counter(1,15*60/agg-n:18*60/agg-n,i)=(m).*con(:,15*60/agg:18*60/agg,i);
%     containers(1,15*60/agg-n:18*60/agg-n,i)=con(:,15*60/agg-n:18*60/agg-n,i)+(m).*con(:,15*60/agg:18*60/agg,i);
%     containers(1,15*60/agg:18*60/agg,i)=(1-m).*con(:,15*60/agg:18*60/agg,i);
%     
% end
% predict traffic based on shifted profile 
out=cell(Nnodes,1);
    for i=1:Nnodes
        out{i,1}= TestModel(agg,models_A15,models_A15,flowAll_A15,speedAll_A15,VLH_T_A15+VLH_P_A15,containers,nontruck_flow_A15,ExpectedSpeed_A15,i,link);
    end
    
%     ntf=nontruck_flow;
% 
%     for i=1:147
%     ntf(:,15*60/agg-n:18*60/agg-n,i)=nontruck_flow(:,15*60/agg-n:18*60/agg-n,i)+(m).*nontruck_flow(:,15*60/agg:18*60/agg,i);
%     ntf(:,15*60/agg:18*60/agg,i)=(1-m).*nontruck_flow(:,15*60/agg:18*60/agg,i);
%     
%     end
%     out=cell(Nnodes,1);
%     for i=1:Nnodes
%         out{i,1}= TestModel(agg,models,flowAll,speedAll,PT,Containerflow,ntf,ExpectedSpeed,i);
%     end

    for i=1: Nnodes
    scenario.Speed(i,:,:)=out{i,1}.speed(1,:,:);
    scenario.Flow(i,:,:)=out{i,1}.flow(1,:,:);
    scenario.PT(i,:,:)=out{i,1}.PT(1,:,:);
    scenario.PT(i,:,:)=out{i,1}.flow(1,:,:);

    Base.Speed(i,:,:)=models{i,1}.output.speed(1,:,:);
    Base.Flow(i,:,:)=models{i,1}.output.flow(1,:,:);
    Base.PT(i,:,:)=models{i,1}.output.PT(1,:,:);
%     Base.Speed(i,:,:)=speedAll(1,:,:);
%     Base.Flow(i,:,:)=flowAll(1,:,:);
%     Base.PT(i,:,:)=PT(1,:,:);
    end
    % calculate vehicle loss hour 
    VLH_Base=zeros(146,1);
    VLH_scenario=zeros(146,1);
    for i=1:146
            VLH_scenario(i,1)=sum(scenario.PT(:,:,i),'all');
            VLH_Base(i,:)=sum(Base.PT(:,:,i),'all');
% %         VLH_scenario(i,1)=Loss_hour_computation(Base.Flow(:,:,i),Base.Speed(:,:,i));
% %         VLH_Base(i,1)=Loss_hour_computation(scenario.Flow(:,:,i),scenario.Speed(:,:,i));
             C(i,:)=sum(counter(:,:,i),'all');
%             if n==8
%                 TT_scenario= Traveltime(scenario.Speed(:,:,i));
%                 TT_Base= Traveltime(Base.Speed(:,:,i));
%                 gain=100*(TT_scenario(2,:)-TT_Base(2,:))./(TT_Base(2,:))*10;
%                 tt(i,1)=mean(gain(12*60:15*60));
%                 tt(i,2)=mean(gain(15*60+1:18*60));
%                 tt(i,3)=mean(gain(18*60+1:20*60));
%             end
    end   
    % calculate gain obtained from shifted container pickups 
    if m==0.1
        if n==2
            Gain.scenario_10(:,1)=VLH_Base-VLH_scenario;
        elseif n==4
            Gain.scenario_10(:,2)=VLH_Base-VLH_scenario;
        elseif n==8
            Gain.scenario_10(:,3)=VLH_Base-VLH_scenario;
            Gain.traveltime_10=tt;
        elseif n==12
            Gain.scenario_10(:,4)=VLH_Base-VLH_scenario;
        end
         Gain.scenario_10(:,5)=C;
    elseif m==0.2
            if n==2
            Gain.scenario_20(:,1)=VLH_Base-VLH_scenario;
            elseif n==4
                Gain.scenario_20(:,2)=VLH_Base-VLH_scenario;
            elseif n==8
                Gain.scenario_20(:,3)=VLH_Base-VLH_scenario;
                Gain.traveltime_20=tt;
            elseif n==12
            Gain.scenario_20(:,4)=VLH_Base-VLH_scenario;
            end
              Gain.scenario_20(:,5)=C;

    elseif m==0.3
        if n==2
            Gain.scenario_30(:,1)=VLH_Base-VLH_scenario;
        elseif n==4
            Gain.scenario_30(:,2)=VLH_Base-VLH_scenario;
        elseif n==8
            Gain.scenario_30(:,3)=VLH_Base-VLH_scenario;
            Gain.traveltime_30=tt;
        elseif n==12
            Gain.scenario_30(:,4)=VLH_Base-VLH_scenario;
        end
         Gain.scenario_30(:,5)=C;

    elseif m==0.4
        if n==2
            Gain.scenario_40(:,1)=VLH_Base-VLH_scenario;
        elseif n==4
            Gain.scenario_40(:,2)=VLH_Base-VLH_scenario;
        elseif n==8
            Gain.scenario_40(:,3)=VLH_Base-VLH_scenario;
            Gain.traveltime_40=tt;
        elseif n==12
            Gain.scenario_40(:,4)=VLH_Base-VLH_scenario;
        end
         Gain.scenario_40(:,5)=C;

    end
        
    end
end
    

%% trajectory method travel time 

TT_scenario= Traveltime(scenario.Speed(:,:,42)); % calculate travel time 
TT_Base= Traveltime(Base.Speed(:,:,42)); % calculate travel time from base case 
gain=100*(TT_scenario(2,:)-TT_Base(2,:))./(TT_Base(2,:)); % calculae gain 