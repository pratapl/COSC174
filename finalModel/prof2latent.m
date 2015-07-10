function [profMap,pred_U,error] = prof2latent(U,Utrainidx,UserProf,gamma,niter)
[nUsers,nLatent] =  size(U);
numEx = length(Utrainidx);
UserProf = cat(2,UserProf,ones(nUsers,1));
profMap = zeros(nLatent + 1,nLatent);
iter = 1;
while iter <= niter
    tic;
    %for i = 1:nLatent
        for user = Utrainidx
           for j = 1:nLatent + 1
               pred = UserProf(user,:)*profMap(:,:);
               y = U(user,:);
               profMap(j,:) = profMap(j,:) - gamma*(pred - y)*UserProf(user,j);
           end
        end
    %end
    toc;

iter = iter + 1;

end

size(profMap)
pred_U = UserProf(Utrainidx,:)*profMap;
size(pred_U)
correct_U = U(Utrainidx,:);
size(correct_U)

err_sum = 0;
%for i = 1:numEx
    error = sum((pred_U - correct_U).^2)/numEx;
    
    %err_sum = err_sum + err;
    
    
%end

%error = err_sum/numEx;

end