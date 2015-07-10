%Brian Doolittle, Pratap Luitel
%Final Project for COSC 174, Dartmouth College
%3/15/2015
function [T,U,Utrainidx,Ttrainidx,rmse1,rmse2] = MFtrain(M,UserProf,Uidx,Tidx,lambda1,lambda2,gamma,niter,mode)
% This function uses matrix factorization to learn weights for users and tracks

% INPUT
% M        : [nUser x nTrack] user track rating matrix
% UserProf : [nUser x k] matrix containing information of users profile 
% Uidx{i}  : cell contains the track indices rated by user {i} 
% Tidx{i}  : cell contains the indices of users who have rated track {i}
% lambda1  : a scalar, hyperparameter 
% lambda2  : a scalar, hyperparameter
% gamma    : a scalar, hyperparameter
% niter    : a scalar, number of iterations for the ALS algorithm 
% mode     : string, 'svdInit' or 'profInit'

%
% OUTPUT
% T         : [nFeatures x nTracks] track latent feature matrix
% U         : [nUser x nFeatures] user latent feature matrix
% Utrainidx : matrix, contains index of users in train set
% Ttrainidx : matrix, contains indexo of tracks in train set
% rmse1     : RMSE of ALS algorithm
% rmse2     : RMSE of ALS algorithm 


tic;
[nUsers,nTracks] = size(M); 
[~,nFeatures] = size(UserProf);

if strcmp('ProfInit',mode)
    Tinit = ones(nFeatures,nTracks);
    Uinit = UserProf;
elseif strcmp('svdInit',mode)
    [Uinit,Tinit,~] = MFSVD_init(M,10);
    [~,l] = size(Uinit);
    nFeatures = l;
end

T = zeros(nFeatures ,nTracks);
U = zeros(nUsers, nFeatures);


Ttrainidx = [];
Utrainidx = [];


for iterUser = 1:nUsers
         
    if ~isempty(Uidx{iterUser})
        Utrainidx = cat(2,Utrainidx,iterUser);
    else
    end
       
end

for iterTrack = 1:nTracks
    
    if ~isempty(Tidx{iterTrack})
        Ttrainidx = cat(2,Ttrainidx,iterTrack);
    else
    end
end

iter = 0;
rmse1 = zeros(1,niter);
rmse2 = zeros(1,niter);


%gradient descent implementation
while (iter < niter)
lit_it = 1;
tic;
% looping through the rated tracks
%for j = 1:nFeatures
    for iterTrack = Ttrainidx
        if iter == 0
            % initializing T
            T(:,iterTrack) = Tinit(:,iterTrack);
        end

        % Looping through the users who rated the track
        for iterUser = Tidx{iterTrack}
        
            actualRating = M(iterUser,iterTrack); 
            %for each track a user has rated, 
            correct(lit_it) = actualRating;
            
            
            if iter == 0
                % initializing U with UserProfile
                userProfile = Uinit(iterUser,:);
                %userProfile = Uinit;
            else 
                userProfile = U(iterUser,:);
            end


            % making a prediction
            predictedRating = userProfile*T(:,iterTrack);
            
            pred1(lit_it) = max(0,min(predictedRating,100));
           
            
            diff = actualRating - predictedRating;
           
            
            %updating T
            T(:,iterTrack) = T(:,iterTrack)...
                                + gamma*(diff*userProfile' - lambda1*T(:,iterTrack));
                            
           

            % learning latent features for users
            predictedRating = userProfile*T(:,iterTrack);
            
            pred2(lit_it) = max(0,min(predictedRating,100));
            
           
            diff = actualRating - predictedRating;
            
            % updating U
            U(iterUser,:) = userProfile+gamma*(diff*T(:,iterTrack)' - lambda2*userProfile);
            
            lit_it = lit_it + 1;
        end
        
    end



%end
iter =  iter + 1;  
rmse1(iter) = rmse(pred1',correct');
rmse2(iter) = rmse(pred2',correct');
pred1 = 0;
pred2 = 0;
toc;
end
toc;

clf
figure(1)
plot([1:niter],rmse1,'bo')
hold on
plot([1:niter],rmse2,'rx')
hold off
end