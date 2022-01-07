% intial ploting for data quality evaluation 
for i=1:20
    figure()
   imagesc(speedAll_A15(:,:,i));
    
end




%% 

% plot(models{90,1}.targets(2,:))
% hold on;
% plot(models{90,1}.outputs(2,:))
% plot(model{1,1}.targets(2,:),model{1,1}.outputs(2,:),'.')
% temp=[];
for i=1:13
    
s(i,:,:)=models_A16N{i,1}.output.speed;
f(i,:,:)=models_A16N{i,1}.output.flow;
end
figure(1)
h1=subplot(2,2,1);
imagesc(s(:,:,139));
h2=subplot(2,2,2);
imagesc(speedAll_A16N(:,:,139));
h3=subplot(2,2,3);
plot(f(:,:,139),s(:,:,139),'.')
h4=subplot(2,2,4);
plot(flowAll_A16N(:,:,139),speedAll_A16N(:,:,139),'.')


%% 
xrange=[-500 1000];
bin=20;
figure ()
subplot(4,4,1);
Gain.scenario_10(Gain.scenario_10(:,1)>-100&Gain.scenario_10(:,1)<0,1)=...
    -1.*Gain.scenario_10(Gain.scenario_10(:,1)>-100&Gain.scenario_10(:,1)<0,1);

[y,x]=hist(Gain.scenario_10(:,1),10);
bar(x,y)
xlim(xrange)
subplot(4,4,2);
[y,x]=hist(Gain.scenario_10(:,2),10);
bar(x,y)
xlim(xrange)
subplot(4,4,3);
[y,x]=hist(Gain.scenario_10(:,3),10);
bar(x,y)

xlim(xrange)
subplot(4,4,4);
[y,x]=hist(Gain.scenario_10(:,4),10);
bar(x,y)

xlim(xrange)
h9=subplot(4,4,5);
[y,x]=hist(Gain.scenario_20(:,1),bin);
bar(x,y)

xlim(xrange)
subplot(4,4,6);
[y,x]=hist(Gain.scenario_20(:,2),bin);
bar(x,y)

xlim(xrange)
subplot(4,4,7);
[y,x]=hist(Gain.scenario_20(:,3),bin);
bar(x,y)

xlim(xrange)
subplot(4,4,8);
[y,x]=hist(Gain.scenario_20(:,4),bin);
bar(x,y)
xlim(xrange)

h13=subplot(4,4,9);
[y,x]=hist(Gain.scenario_30(:,1),bin);
bar(x,y)

xlim(xrange)
subplot(4,4,10);
[y,x]=hist(Gain.scenario_30(:,2),bin);
bar(x,y)

xlim(xrange)

h15=subplot(4,4,11);
[y,x]=hist(Gain.scenario_30(:,3),bin);
bar(x,y)

xlim(xrange)

h16=subplot(4,4,12);
[y,x]=hist(Gain.scenario_30(:,4),bin);
bar(x,y)

xlim(xrange)

h5=subplot(4,4,13);
[y,x]=hist(Gain.scenario_40(:,1),bin);
bar(x,y)

xlim(xrange)

h5=subplot(4,4,14);
[y,x]=hist(Gain.scenario_40(:,2),bin);
bar(x,y)

xlim(xrange)

h5=subplot(4,4,15);
[y,x]=hist(Gain.scenario_40(:,3),bin);
bar(x,y)

xlim(xrange)

h5=subplot(4,4,16);
[y,x]=hist(Gain.scenario_40(:,4),bin);
bar(x,y)

xlim(xrange)

%% plot severe congested days

figure(); 
subplot (2,2,1);
imagesc(speedAll_A15(:,:,146))
subplot(2,2,3);
PT_A15(80,47,146)=.08;
PT_A15(PT_A15>1)=1;
stem(100.*PT_A15(80,:,146))
%  ylim([0 60])

subplot (2,2,2);
imagesc(speedAll_A15(:,:,5))
PT_A15(80,49,5)=.08
subplot(2,2,4);
stem(100.*PT_A15(80,:,5))
ylim([0 25]);
%% weekdays 
A=num2cell(Gain.scenario_10);
B=num2cell(Gain.scenario_20);
C=num2cell(Gain.scenario_30);
D=num2cell(Gain.scenario_40);
for i=1: 147 
   
    if ismember(ExpectedSpeed.index.All(i),ExpectedSpeed.index.saturdays)
            A{i,5}='Saturday';
            B{i,5}='Saturday';
            C{i,5}='Saturday';
            D{i,5}='Saturday';
        elseif ismember(ExpectedSpeed.index.All(i),ExpectedSpeed.index.sundays)
            A{i,5}='Sunday';
            B{i,5}='Sunday';
            C{i,5}='Sunday';
            D{i,5}='Sunday';
        elseif ismember(ExpectedSpeed.index.All(i),ExpectedSpeed.index.mondays)
            A{i,5}='Monday';
            B{i,5}='Monday';
            C{i,5}='Monday';
            D{i,5}='Monday';
        elseif ismember(ExpectedSpeed.index.All(i),ExpectedSpeed.index.tuesdays)
            A{i,5}='Tuesday';
            B{i,5}='Tuesday';
            C{i,5}='Tuesday';
            D{i,5}='Tuesday';
        elseif ismember(ExpectedSpeed.index.All(i),ExpectedSpeed.index.wednesdays)
            A{i,5}='Wednesday';
            B{i,5}='Wednesday';
            C{i,5}='Wednesday';
            D{i,5}='Wednesday';
        elseif ismember(ExpectedSpeed.index.All(i),ExpectedSpeed.index.thursdays)
            A{i,5}='Thursday';
            B{i,5}='Thursday';
            C{i,5}='Thursday';
            D{i,5}='Thursday';
        elseif ismember(ExpectedSpeed.index.All(i),ExpectedSpeed.index.fridays)
            A{i,5}='Friday';
            B{i,5}='Friday';
            C{i,5}='Friday';
            D{i,5}='Friday';
        end
    
    
    
    
end
%% plot comparison 
t(1,:)=sum(Gain.scenario_10,1);
t(2,:)=sum(Gain.scenario_20,1);
t(3,:)=sum(Gain.scenario_30,1);
t(4,:)=sum(Gain.scenario_40,1);

%% optimised 
temp(1,1)=sum(Gain.scenario_10(Gain.scenario_10(:,1)>0,1));
temp(1,2)=sum(Gain.scenario_10(Gain.scenario_10(:,2)>0,2));
temp(1,3)=sum(Gain.scenario_10(Gain.scenario_10(:,3)>0,3));
temp(1,4)=sum(Gain.scenario_10(Gain.scenario_10(:,4)>0,4));
temp(2,1)=sum(Gain.scenario_20(Gain.scenario_20(:,1)>0,1));
temp(2,2)=sum(Gain.scenario_20(Gain.scenario_20(:,2)>0,2));
temp(2,3)=sum(Gain.scenario_20(Gain.scenario_20(:,3)>0,3));
temp(2,4)=sum(Gain.scenario_20(Gain.scenario_20(:,4)>0,4));
temp(3,1)=sum(Gain.scenario_30(Gain.scenario_30(:,1)>0,1));
temp(3,2)=sum(Gain.scenario_30(Gain.scenario_30(:,2)>0,2));
temp(3,3)=sum(Gain.scenario_30(Gain.scenario_30(:,3)>0,3));
temp(3,4)=sum(Gain.scenario_30(Gain.scenario_30(:,4)>0,4));
temp(4,1)=sum(Gain.scenario_40(Gain.scenario_40(:,1)>0,1));
temp(4,2)=sum(Gain.scenario_40(Gain.scenario_40(:,2)>0,2));
temp(4,3)=sum(Gain.scenario_40(Gain.scenario_40(:,3)>0,3));
temp(4,4)=sum(Gain.scenario_40(Gain.scenario_40(:,4)>0,4));


%% plot for paper 
Gain_A15=load('Gain_A15.mat');
Gain_A16N=load('Gain_A16N.mat');
Gain_A16S=load('Gain_A16S.mat');
Gain_A4=load('Gain_A4.mat');
Gain_A29=load('Gain_A29.mat');

%%
a(1,1)=sum(Gain_A15.Gain.scenario_10(Gain_A15.Gain.scenario_10(:,4)>0,4),'omitnan');
a(1,2)=sum(Gain_A15.Gain.scenario_20(Gain_A15.Gain.scenario_20(:,4)>0,4),'omitnan');
a(1,3)=sum(Gain_A15.Gain.scenario_30(Gain_A15.Gain.scenario_30(:,4)>0,4),'omitnan');
a(1,4)=sum(Gain_A15.Gain.scenario_40(Gain_A15.Gain.scenario_40(:,4)>0,4),'omitnan');

a(2,1)=sum(Gain_A4.Gain.scenario_10(Gain_A4.Gain.scenario_10(:,4)>0,4),'omitnan');
a(2,2)=sum(Gain_A4.Gain.scenario_20(Gain_A4.Gain.scenario_20(:,4)>0,4),'omitnan');
a(2,3)=sum(Gain_A4.Gain.scenario_30(Gain_A4.Gain.scenario_30(:,4)>0,4),'omitnan');
a(2,4)=sum(Gain_A4.Gain.scenario_40(Gain_A4.Gain.scenario_40(:,4)>0,4),'omitnan');

a(3,1)=sum(Gain_A29.Gain.scenario_10(Gain_A29.Gain.scenario_10(:,4)>0,4),'omitnan');
a(3,2)=sum(Gain_A29.Gain.scenario_20(Gain_A29.Gain.scenario_20(:,4)>0,4),'omitnan');
a(3,3)=sum(Gain_A29.Gain.scenario_30(Gain_A29.Gain.scenario_30(:,4)>0,4),'omitnan');
a(3,4)=sum(Gain_A29.Gain.scenario_40(Gain_A29.Gain.scenario_40(:,4)>0,4),'omitnan');


a(4,1)=sum(Gain_A16N.Gain.scenario_10(Gain_A16N.Gain.scenario_10(:,4)>0,4),'omitnan');
a(4,2)=sum(Gain_A16N.Gain.scenario_20(Gain_A16N.Gain.scenario_20(:,4)>0,4),'omitnan');
a(4,3)=sum(Gain_A16N.Gain.scenario_30(Gain_A16N.Gain.scenario_30(:,4)>0,4),'omitnan');
a(4,4)=sum(Gain_A16N.Gain.scenario_40(Gain_A16N.Gain.scenario_40(:,4)>0,4),'omitnan');


a(5,1)=sum(Gain_A16S.Gain.scenario_10(Gain_A16S.Gain.scenario_10(:,4)>0,4),'omitnan');
a(5,2)=sum(Gain_A16S.Gain.scenario_20(Gain_A16S.Gain.scenario_20(:,4)>0,4),'omitnan');
a(5,3)=sum(Gain_A16S.Gain.scenario_30(Gain_A16S.Gain.scenario_30(:,4)>0,4),'omitnan');
a(5,4)=sum(Gain_A16S.Gain.scenario_40(Gain_A16S.Gain.scenario_40(:,4)>0,4),'omitnan');

%% 
sum(Gain_A15.Gain.scenario_10(Gain_A15.Gain.scenario_10(:,4)>0 & Gain_A4.Gain.scenario_10(:,4)>0 & Gain_A29.Gain.scenario_10(:,4)>0 & Gain_A16N.Gain.scenario_10(:,4)>0 & Gain_A16S.Gain.scenario_10(:,4)>0,4),'omitnan')

sum(Gain_A15.Gain.scenario_20(Gain_A15.Gain.scenario_20(:,4)>0 & Gain_A4.Gain.scenario_20(:,4)>0 & Gain_A29.Gain.scenario_20(:,4)>0 & Gain_A16N.Gain.scenario_20(:,4)>0 & Gain_A16S.Gain.scenario_20(:,4)>0,4),'omitnan')

sum(Gain_A15.Gain.scenario_30(Gain_A15.Gain.scenario_30(:,4)>0 & Gain_A4.Gain.scenario_30(:,4)>0 & Gain_A29.Gain.scenario_30(:,4)>0 & Gain_A16N.Gain.scenario_30(:,4)>0 & Gain_A16S.Gain.scenario_30(:,4)>0,4),'omitnan')

sum(Gain_A15.Gain.scenario_30(Gain_A15.Gain.scenario_30(:,4)>0 & Gain_A4.Gain.scenario_30(:,4)>0 & Gain_A29.Gain.scenario_40(:,4)>0 & Gain_A16N.Gain.scenario_40(:,4)>0 & Gain_A16S.Gain.scenario_40(:,4)>0,4),'omitnan')


%% 
sum(Gain.scenario_40(Gain_A15.Gain.scenario_40(:,4)>0,5),'omitnan')
sum(Gain.scenario_40(Gain_A4.Gain.scenario_40(:,4)>0,5),'omitnan')
sum(Gain.scenario_40(Gain_A29.Gain.scenario_40(:,4)>0,5),'omitnan')
sum(Gain.scenario_40(Gain_A16N.Gain.scenario_40(:,4)>0,5),'omitnan')
sum(Gain.scenario_40(Gain_A16S.Gain.scenario_40(:,4)>0,5),'omitnan')
%% calculate travel time improvment 
% 
% b(1,1)=mean(Gain.traveltime_10(:,1),'omitnan')*10;
% b(1,2)=mean(Gain.traveltime_20(:,1),'omitnan')*10;
% b(1,3)=mean(Gain.traveltime_30(:,1),'omitnan')*10;
% b(1,4)=mean(Gain.traveltime_40(:,1),'omitnan')*10;


b(1,1)=mean(Gain.traveltime_10(Gain.traveltime_10(:,3)>0,2),'omitnan')*10;
b(1,2)=mean(Gain.traveltime_20(Gain.traveltime_20(:,1)>0,2),'omitnan')*10;
b(1,3)=mean(Gain.traveltime_30(Gain.traveltime_30(:,2)>0,2),'omitnan')*10;
b(1,4)=mean(Gain.traveltime_40(Gain.traveltime_40(:,2)>0,2),'omitnan')*10;

%% plot All 
 
m=2;   % targtes 1-3 (1: flow, 2: speed, 3: truck percentage)
A15.t=models_A15{88,1}.test.Targets(m,:);
A15.y=models_A15{88,1}.test.Outputs(m,:);
A15.name='Test Data A15 Node 88';

A4.t=models_A4{4,1}.test.Targets(m,:);
A4.y=models_A4{4,1}.test.Outputs(m,:);
A4.name='Test Data A4 Node 94';

A29.t=models_A29{4,1}.test.Targets(m,:);
A29.y=models_A29{4,1}.test.Outputs(m,:);
A29.name='Test Data A29 Node 102';


A16N.t=models_A16N{4,1}.test.Targets(m,:);
A16N.y=models_A16N{4,1}.test.Outputs(m,:);
A16N.name='Test Data A16N Node 123';

A16S.t=models_A16S{8,1}.test.Targets(m,:);
A16S.y=models_A16S{8,1}.test.Outputs(m,:);
A16S.name='Test Data A16S Node 139';

plotAll(A15,A4,A29,A16N,A16S, m)