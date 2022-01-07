function plotAll(A15,A4,A29,A16N,A16S, flag)
    %if flag~=3
        A15.y(A15.y<1 | isnan(A15.y))=1;
        A15.t(A15.t<1| isnan(A15.t))=1;
        A4.y(A4.y<1| isnan(A4.y))=1;
        A4.t(A4.t<1| isnan(A4.t))=1;
        A29.y(A29.y<1| isnan(A29.y))=1;
        A29.t(A29.t<1| isnan(A29.t))=1;
        A16N.y(A16N.y<1| isnan(A16N.y))=1;
        A16N.t(A16N.t<1| isnan(A16N.t))=1;
        A16S.y(A16S.y<1| isnan(A16S.y))=1;
        A16S.t(A16S.t<1| isnan(A16S.t))=1;

    %end
    figure(1); 
    h1=subplot(5,2,1); %Train
    plot(A15.t,A15.y,'k.');
    hold on;
    xmin=min(min(A15.t),min(A15.y));
    xmax=max(max(A15.t),max(A15.y));
    plot([0 xmax],[0 xmax],'b--','LineWidth',1);
    G = polyfit(A15.t,A15.y,1);
    yfit = G(1)*A15.t+G(2);
    plot(A15.t,yfit,'-','color',[0.9290 0.6940 0.1250],'LineWidth',2);
    [R P]=corr(A15.t',A15.y','rows','complete');
    title({A15.name,['R^2 = ' num2str(R) '   P-Value = ' num2str(P)],['Output~=' num2str(round(G(1),2)) ' * target +' num2str(round(G(2),2))]});
    xlabel('Observed volume');
    ylabel('Predicted volume' );
    xlim(h1,[xmin xmax]);
    ylim(h1,[xmin xmax])
    legend(' Data',' Y=T',' fit', 'location','northwest');
    hold off;
    
    h2=subplot(5,2,2); %Train
    plot(A15.y,'.-','color',[0.8 0 0],'LineWidth',1);
       
    hold on;
    plot(A15.t,'-','LineWidth',.1,'color',[0.1 0 1]);
%     xline(336,'--g','LineWidth',2);
%     xline(360,'--g','LineWidth',2);
    legend('Outputs','Targets','FontSize',9,'location','northeastoutside');
    title(A15.name);
    xlabel('Time of day in sample(every 5 min)','FontSize',10);
    ylabel('volume','FontSize',10);
    xlim(h2,[0 length(A15.t)]);
    hold off;
    
    
    
    
    h3=subplot(5,2,3); %Train
    plot(A4.t,A4.y,'k.');
    hold on;
    xmin=min(min(A4.t),min(A4.y));
    xmax=max(max(A4.t),max(A4.y));
    plot([0 xmax],[0 xmax],'b--','LineWidth',1);
    G = polyfit(A4.t,A4.y,1);
    yfit = G(1)*A4.t+G(2);
    plot(A4.t,yfit,'-','color',[0.9290 0.6940 0.1250],'LineWidth',2);
    [R P]=corr(A4.t',A4.y','rows','complete');
    title({A4.name,['R^2 = ' num2str(R) '   P-Value = ' num2str(P)],['Output~=' num2str(round(G(1),2)) ' * target +' num2str(round(G(2),2))]});
    xlabel('Obsereved volume');
    ylabel('Predicted volume' );
    xlim(h3,[xmin xmax]);
    ylim(h3,[xmin xmax])
    legend(' Data',' Y=T',' fit', 'location','northwest');
    hold off;
    
     h4=subplot(5,2,4); %Train
    plot(A4.y,'.-','color',[0.8 0 0],'LineWidth',1);
       
    hold on;
    plot(A4.t,'-','LineWidth',.1,'color',[0.1 0 1]);
%     xline(336,'--g','LineWidth',2);
%     xline(360,'--g','LineWidth',2);
    legend('Outputs','Targets','FontSize',9,'location','northeastoutside');
    title(A4.name);
    xlabel('Time of day in sample(every 5 min)','FontSize',10);
    ylabel('volume','FontSize',10);
    xlim(h4,[0 length(A4.t)]);
    hold off;
    
    
    h5=subplot(5,2,5); %Train
    plot(A29.t,A29.y,'k.');
    hold on;
    xmin=min(min(A29.t),min(A29.y));
    xmax=max(max(A29.t),max(A29.y));
    plot([0 xmax],[0 xmax],'b--','LineWidth',1);
    G = polyfit(A29.t,A29.y,1);
    yfit = G(1)*A29.t+G(2);
    plot(A29.t,yfit,'-','color',[0.9290 0.6940 0.1250],'LineWidth',2);
    [R P]=corr(A29.t',A29.y','rows','complete');
    title({A29.name,['R^2 = ' num2str(R) '   P-Value = ' num2str(P)],['Output~=' num2str(round(G(1),2)) ' * target +' num2str(round(G(2),2))]});
    xlabel('Observed volume');
    ylabel('Predicted volume' );
    xlim(h5,[xmin xmax]);
    ylim(h5,[xmin xmax])
    legend(' Data',' Y=T',' fit', 'location','northwest');
    hold off;
    
    h6=subplot(5,2,6); %Train
    plot(A29.y,'.-','color',[0.8 0 0],'LineWidth',1);
       
     hold on;
    plot(A29.t,'-','LineWidth',.1,'color',[0.1 0 1]);
%     xline(336,'--g','LineWidth',2);
%     xline(360,'--g','LineWidth',2);
    legend('Outputs','Targets','FontSize',9,'location','northeastoutside');
    title(A29.name);
    xlabel('Time of day in sample( every 5 min)','FontSize',10);
    ylabel('Volume','FontSize',10);
    xlim(h6,[0 length(A29.t)]);
    hold off;
    
    
    
    h7=subplot(5,2,7); %Train
    plot(A16N.t,A16N.y,'k.');
    hold on;
    xmin=min(min(A16N.t),min(A16N.y));
    xmax=max(max(A16N.t),max(A16N.y));
    plot([0 xmax],[0 xmax],'b--','LineWidth',1);
    G = polyfit(A16N.t,A16N.y,1);
    yfit = G(1)*A16N.t+G(2);
    plot(A16N.t,yfit,'-','color',[0.9290 0.6940 0.1250],'LineWidth',2);
    [R P]=corr(A16N.t',A16N.y','rows','complete');
    title({A16N.name,['R^2 = ' num2str(R) '   P-Value = ' num2str(P)],['Output~=' num2str(round(G(1),2)) ' * target +' num2str(round(G(2),2))]});
    xlabel('Observed volume');
    ylabel('Predicted volume' );
    xlim(h7,[xmin xmax]);
    ylim(h7,[xmin xmax])
    legend(' Data',' Y=T',' fit', 'location','northwest');
    hold off;
    
    h8=subplot(5,2,8); %Train
    plot(A16N.y,'.-','color',[0.8 0 0],'LineWidth',1);
       
     hold on;
    plot(A16N.t,'-','LineWidth',.1,'color',[0.1 0 1]);
%     xline(336,'--g','LineWidth',2);
%     xline(360,'--g','LineWidth',2);
    legend('Outputs','Targets','FontSize',9,'location','northeastoutside');
    title(A16N.name);
    xlabel('Time of day in sample(every 5 min)','FontSize',10);
    ylabel('Volume','FontSize',10);
    xlim(h8,[0 length(A16N.t)]);
    hold off;
    
    
    h9=subplot(5,2,9); %Train

    plot(A16S.t,A16S.y,'k.');
    hold on;
    xmin=min(min(A16S.t),min(A16S.y));
    xmax=max(max(A16S.t),max(A16S.y));
    plot([0 xmax],[0 xmax],'b--','LineWidth',1);
    G = polyfit(A16S.t,A16S.y,1);
    yfit = G(1)*A16S.t+G(2);
    plot(A16S.t,yfit,'-','color',[0.9290 0.6940 0.1250],'LineWidth',2);
    [R P]=corr(A16S.t',A16S.y','rows','complete');
    title({A16S.name,['R^2 = ' num2str(R) '   P-Value = ' num2str(P)],['Output~=' num2str(round(G(1),2)) ' * target +' num2str(round(G(2),2))]});
    xlabel('Observed volume');
    ylabel('Predicted volume' );
    xlim(h9,[xmin xmax]);
    ylim(h9,[xmin xmax])
    legend(' Data',' Y=T',' fit', 'location','northwest');
    hold off;

 h10=subplot(5,2,10); %Train
    plot(A16S.y,'.-','color',[0.8 0 0],'LineWidth',1);
       
     hold on;
    plot(A16S.t,'-','LineWidth',.1,'color',[0.1 0 1]);
%     xline(336,'--g','LineWidth',2);
%     xline(360,'--g','LineWidth',2);
    legend('Outputs','Targets','FontSize',9,'location','northeastoutside');
    title(A16S.name);
    xlabel('Time of day in sample( every 5 min)','FontSize',10);
    ylabel('Volume','FontSize',10);
    xlim(h10,[0 length(A16S.t)]);
    hold off;


end