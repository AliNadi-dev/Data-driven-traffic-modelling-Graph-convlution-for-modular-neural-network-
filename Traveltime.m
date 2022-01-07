function [TT]= Traveltime(speed)
              x=0:0.6:54;
              x=x(1:end-1)*1000;
              [~, TT] = rl_trajectory(0,0.277778*speed,x,60,60*15);
              TT(2,:)=TT(2,:)./60;
            


end