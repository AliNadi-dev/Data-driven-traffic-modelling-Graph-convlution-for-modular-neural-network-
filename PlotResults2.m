function PlotResults2(Train,Test,Val,All,flag)
    %% fit
    if flag~=3
    Train.y(Train.y<1)=1;
    Train.t(Train.t<1)=1;
    Val.y(Val.y<1)=1;
    Val.t(Val.t<1)=1;
    Test.y(Test.y<1)=1;
    Test.t(Test.t<1)=1;
    All.y(All.y<1)=1;
    All.t(All.t<1)=1;
    end
    figure(1); 
    
    % t and y
    h1=subplot(4,1,1);% Train
    
    plot(Train.y,'.-','color',[0.8 0 0],'LineWidth',1);
       
    hold on;
    plot(Train.t,'-','LineWidth',.1,'color',[0.1, 0, 1]);
%     xline(1534,'--g','LineWidth',2);
%     xline(1677,'--g','LineWidth',2);
    legend('Outputs','Targets','FontSize',9,'location','northeastoutside');
    title(Train.name);
    xlabel('Samples','FontSize',10);
    ylabel('flow','FontSize',10);
    xlim(h1,[0 length(Train.t)]);
    hold off;
    
    h2=subplot(4,1,3);% Test
    plot(Test.y,'.-','color',[0.8 0 0],'LineWidth',1);
       
    hold on;
    plot(Test.t,'-','LineWidth',.1,'color',[0.1 0 1]);
%     xline(336,'--g','LineWidth',2);
%     xline(360,'--g','LineWidth',2);
    legend('Outputs','Targets','FontSize',9,'location','northeastoutside');
    title(Test.name);
    xlabel('Samples','FontSize',10);
    ylabel('flow','FontSize',10);
    xlim(h2,[0 length(Test.t)]);
    hold off;
    
    h3=subplot(4,1,2);% Val
    plot(Val.y,'.-','color',[0.8 0 0],'LineWidth',1);
       
    hold on;
    plot(Val.t,'-','LineWidth',.1,'color',[0.1 0 1]);
%     xline(340,'--g','LineWidth',2);
%     xline(369,'--g','LineWidth',2);
    legend('Outputs','Targets','FontSize',9,'location','northeastoutside');
    title(Val.name);
    xlabel('Samples','FontSize',10);
    ylabel('flow','FontSize',10);
    xlim(h3,[0 length(Val.t)]);
    hold off;
    
    h4=subplot(4,1,4); % All
    plot(All.y,'.-','color',[0.8 0 0],'LineWidth',1);
       
    hold on;
    plot(All.t,'-','LineWidth',.1,'color',[0.1 0 1]);
%     xline(2160,'--g','LineWidth',2);
%     xline(2414,'--g','LineWidth',2);
    legend('Outputs','Targets','FontSize',9,'location','northeastoutside');
    title(All.name);
    xlabel('Samples','FontSize',10);
    ylabel('flow','FontSize',10);
    xlim(h4,[0 length(All.t)]);
    hold off;
    
        %% corr plot
    figure (2)
    % Correlation Plot
    h5=subplot(2,2,1); %Train
    plot(Train.t,Train.y,'k.');
    hold on;
    xmin=min(min(Train.t),min(Train.y));
    xmax=max(max(Train.t),max(Train.y));
    plot([0 xmax],[0 xmax],'b--','LineWidth',1);
    G = polyfit(Train.t,Train.y,1);
    yfit = G(1)*Train.t+G(2);
    plot(Train.t,yfit,'-','color',[0.9290 0.6940 0.1250],'LineWidth',2);
    [R P]=corr(Train.t',Train.y','rows','complete');
    title({Train.name,['R^2 = ' num2str(R) '   P-Value = ' num2str(P)],['Output~=' num2str(round(G(1),2)) ' * target +' num2str(round(G(2),2))]});
    xlabel('Actual Losses');
    ylabel('Predicted Losses' );
    xlim(h5,[xmin xmax]);
    ylim(h5,[xmin xmax])
    legend(' Data',' Y=T',' fit', 'location','northwest');
    hold off;
   
    % Correlation Plot
    h6=subplot(2,2,2); %Val
    plot(Val.t,Val.y,'k.');
    hold on;
    xmin=min(min(Val.t),min(Val.y));
    xmax=max(max(Val.t),max(Val.y));
    plot([0 xmax],[0 xmax],'b--','LineWidth',1);
    G = polyfit(Val.t,Val.y,1);
    yfit = G(1)*Val.t+G(2);
    plot(Val.t,yfit,'-','color',[[0, 0.75, 0.75]],'LineWidth',2);
    [R P]=corr(Val.t',Val.y','rows','complete');
    title({Val.name,['R^2 = ' num2str(R) '   P-Value = ' num2str(P)],['Output~=' num2str(round(G(1),2)) ' * target +' num2str(round(G(2),2))]});
    xlabel('Actual Losses');
    ylabel('Predicted Losses' );
    xlim(h6,[xmin xmax]);
    ylim(h6,[xmin xmax])
    legend(' Data',' Y=T',' fit', 'location','northwest');
    hold off;

    % Correlation Plot
    h7=subplot(2,2,3); %Test
    plot(Test.t,Test.y,'k.');
    hold on;
    xmin=min(min(Test.t),min(Test.y));
    xmax=max(max(Test.t),max(Test.y));
    plot([0 xmax],[0 xmax],'b--','LineWidth',1);
    G = polyfit(Test.t,Test.y,1);
    yfit = G(1)*Test.t+G(2);
    plot(Test.t,yfit,'-','color',[0.6350, 0.0780, 0.1840],'LineWidth',2);
    [R P]=corr(Test.t',Test.y','rows','complete');
    title({Test.name,['R^2 = ' num2str(R) '   P-Value = ' num2str(P)],['Output~=' num2str(round(G(1),2)) ' * target +' num2str(round(G(2),2))]});
    xlabel('Actual Losses');
    ylabel('Predicted Losses' );
    xlim(h7,[xmin xmax]);
    ylim(h7,[xmin xmax])
    legend(' Data',' Y=T',' fit', 'location','northwest');
    hold off;

  
    % Correlation Plot
    h8=subplot(2,2,4); %ALL
    plot(All.t,All.y,'k.');
    hold on;
    xmin=min(min(All.t),min(All.y));
    xmax=max(max(All.t),max(All.y));
    plot([0 xmax],[0 xmax],'b--','LineWidth',1);
    G = polyfit(All.t,All.y,1);
    yfit = G(1)*All.t+G(2);
    plot(All.t,yfit,'-','color',[0, 0.9, 0],'LineWidth',2);
    [R P]=corr(All.t',All.y','rows','complete');
    title({All.name,['R^2 = ' num2str(R) '   P-Value = ' num2str(P)],['Output~=' num2str(round(G(1),2)) ' * target +' num2str(round(G(2),2))]});
    xlabel('Actual Losses');
    ylabel('Predicted Losses' );
    xlim(h8,[xmin xmax]);
    ylim(h8,[xmin xmax])
    legend(' Data',' Y=T',' fit', 'location','northwest');
    hold off;

    
    
    %% Residuals 
    Test.y(Test.y<1)=1;
    Test.t(Test.t<1)=1;
    w=5;
    figure (3)
    h9=subplot(4,1,1); % Train
    e=Train.t-Train.y;
    plot(e,'b');
    
    MSE=mean(e.^2,'omitnan');
    MAE=mean(abs(e));
    MAPE=mean(abs(e./Train.t));
    APE=abs(e./Train.t);
    PAPE=numel(APE(APE<w))/numel(e);
    RMSE=sqrt(MSE);
    title({Train.name,[ 'MSE = ' num2str(MSE) ',  RMSE=' num2str(RMSE) ',  MAE = ' num2str(MAE) ',  MAPE = ' num2str(MAPE) ',  PAPE = ' num2str(PAPE)]});
    xlim(h9,[0,length(e)]);
    xlabel('Hour','FontSize',10);
    ylabel('Residuals','FontSize',10);
%     hold on ;
%     xline(1534,'--g','LineWidth',2);
%     xline(1677,'--g','LineWidth',2);
%     legend('Error', 'x=1534','x=1677','location','northeastoutside');
%     hold off;
    
    h10=subplot(4,1,2); % Val
    e=Val.t-Val.y;
    plot(e,'b');
    
    MSE=mean(e.^2,'omitnan');
    MAE=mean(abs(e));
    MAPE=mean(abs(e./Val.t));
    APE=abs(e./Val.t);
    PAPE=numel(APE(APE<w))/numel(e);
    RMSE=sqrt(MSE);
    title({Val.name,[ 'MSE = ' num2str(MSE) ',  RMSE=' num2str(RMSE) ',  MAE = ' num2str(MAE) ',  MAPE = ' num2str(MAPE) ',  PAPE = ' num2str(PAPE)]});
    xlim(h10,[0,length(e)]);
    xlabel('Hour','FontSize',10);
    ylabel('Residuals','FontSize',10);
%     hold on ;
%     xline(340,'--g','LineWidth',2);
%     xline(369,'--g','LineWidth',2);
%     legend('Error', 'x=340','x=369','location','northeastoutside');
%     hold off;
    
    h11=subplot(4,1,3); % Test
    e=Test.t-Test.y;
    plot(e,'b');
    
    MSE=mean(e.^2,'omitnan');
    MAE=mean(abs(e),'omitnan');
    MAPE=mean(abs(e./Test.t),'omitnan');
    APE=abs(e./Test.t);
    PAPE=numel(APE(APE<w))/numel(e);
    RMSE=sqrt(MSE);
    title({Test.name,[ 'MSE = ' num2str(MSE) ',  RMSE=' num2str(RMSE) ',  MAE = ' num2str(MAE) ',  MAPE = ' num2str(MAPE) ',  PAPE = ' num2str(PAPE)]});
    xlim(h11,[0,length(e)]);
    xlabel('Hour','FontSize',10);
    ylabel('Residuals','FontSize',10);
%     hold on ;
%     xline(336,'--g','LineWidth',2);
%     xline(360,'--g','LineWidth',2);
%     legend('Error', 'x=336','x=360','location','northeastoutside');
%     hold off;
    
    h12=subplot(4,1,4); % All
    e=All.t-All.y;
    plot(e,'b');
    
    MSE=mean(e.^2,'omitnan');
    MAE=mean(abs(e));
    MAPE=mean(abs(e./All.t));
    APE=abs(e./All.t);
    PAPE=numel(APE(APE<w))/numel(e);
    RMSE=sqrt(MSE);
    title({All.name,[ 'MSE = ' num2str(MSE) ',  RMSE=' num2str(RMSE) ',  MAE = ' num2str(MAE) ',  MAPE = ' num2str(MAPE) ',  PAPE = ' num2str(PAPE)]});
    xlim(h12,[0,length(e)]);
    xlabel('Hour','FontSize',10);
    ylabel('Residuals','FontSize',10);
%     hold on ;
%     xline(2160,'--g','LineWidth',2);
%     xline(2414,'--g','LineWidth',2);
%     legend('Error', 'x=2160','x=2496','location','northeastoutside');
%     hold off;
    %% Error distribution
    figure (4)
    eTrain=Train.t-Train.y;
    eVal=Val.t-Val.y;
    eTest=Test.t-Test.y;
    eAll=All.t-All.y;
   % ALL
    [~,edges] = histcounts(eAll);
    [N1,~] = histcounts(eAll,edges);
    ctrs = (edges(1:end-1)+edges(2:end))/2; % Calculate the bin centers
    bar(ctrs, N1',1,'stacked','FaceAlpha',0.9,'FaceColor',[0, 0.4470, 0.7410]);
    xticks auto % Use automatic ticks
    eMeanAll=mean(eAll,'omitnan');
    eStdAll=std(eAll,'omitnan');
    hold on;
    % Train
    [N1,~] = histcounts(eTrain,edges);
    ctrs = (edges(1:end-1)+edges(2:end))/2; % Calculate the bin centers
    bar(ctrs,N1',1,'FaceAlpha',0.9,'FaceColor','y');
    eMeanTrain=mean(eTrain,'omitnan');
    eStdTrain=std(eTrain,'omitnan');
    % Val
    [N1,~] = histcounts(eVal,edges);
    ctrs = (edges(1:end-1)+edges(2:end))/2; % Calculate the bin centers
    bar(ctrs, N1',1,'stacked','FaceAlpha',0.9,'FaceColor',[0.8500, 0.3250, 0.0980]	);
    xticks auto % Use automatic ticks
    eMeanVal=mean(eVal,'omitnan');
    eStdVal=std(eVal,'omitnan');
        % Test
    [N1,~] = histcounts(eTest,edges);
    ctrs = (edges(1:end-1)+edges(2:end))/2; % Calculate the bin centers
    bar(ctrs, N1',1,'stacked','FaceAlpha',0.9,'FaceColor',[0, 0.75, 0.75]);
    xticks auto % Use automatic ticks
    eMeanTest=mean(eTest,'omitnan');
    eStdTest=std(eTest,'omitnan');
    legend(['All Data : ' '\mu = ' num2str(eMeanAll) ', \sigma = ' num2str(eStdAll)],...
        ['Train Data : ' '\mu = ' num2str(eMeanTrain) ', \sigma = ' num2str(eStdTrain)],...
        ['Validation Data : ' '\mu = ' num2str(eMeanVal) ', \sigma = ' num2str(eStdVal)],...
        ['Test Data : ' '\mu = ' num2str(eMeanTest) ', \sigma = ' num2str(eStdTest)],'location','northwest');
    title('Error histogram');
    hold off;

end