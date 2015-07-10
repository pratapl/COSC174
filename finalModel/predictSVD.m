function pred_y = predictSVD(Uinit,Tinit,test)


[m,n] = size(test);

pred_y = zeros(m,1);

for i = 1:m
    uidx = test(i,3) + 1;
    tidx = test(i,2) + 1;
    
    pred_y(i) = Uinit(uidx,:)*Tinit(:,tidx);
    
    pred_y(i) = min(100,max(pred_y(i),0));
   
end
end