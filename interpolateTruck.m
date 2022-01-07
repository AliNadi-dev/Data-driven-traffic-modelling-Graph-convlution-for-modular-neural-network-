function H= interpolateTruck(m,I)
    q.truck=nan(271,size(m,2));
%     matchingIndex=[3;8;9;14;32;35;38;41;47;50;57;58;66;74;77;79;83;87;90;91;97;118;133;135];
%     matchingIndex=matchingIndex-2;
    q.truck(I',:)=m;
    q.truck=round(fillmissing(q.truck,'linear',1));
    H=q.truck;
end