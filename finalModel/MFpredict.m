%Brian Doolittle, Pratap Luitel
%Final Project for COSC 174, Dartmouth College
%3/15/2015
function [pred_y,coldStart_idx,newUser_idx,newTrack_idx,warmStart_idx] =...
        MFpredict(T,Xtest,U,Tidx,Aidx,UserProf,ArtistProf,Utrainidx)
%This function predicts rating for new set of users. 
%
% INPUT 
% T         :[k,n]  k feature weights for each track
% Xtest     :examples to be predicted 
% U         :[nUser x nFeatures] user latent feature matrix
% Tidx{i}   :cell contains the indices of users who have rated track {i}
% Aidx{i}   :cell contains the indices of tracks composed by artist {i}
% UserProf  :[m,k] m user profiles with k features each
% ArtistProf: matrix, artist profiles from average user description
% Utrainidx : matrix, contains index of users in train set

% OUTPUT
% pred_y        :predicted track rating of user
% coldStart_idx :cold start index
% newUser_idx   :new user index
% newTrack_idx  :new track index
% warmStart_idx :warm start index

[m,n] = size(Xtest);
pred_y = zeros(m,1);

% user track combo to predict

predU = Xtest(:,3);
predT = Xtest(:,2);
predA = Xtest(:,1);

[nUser,nFeatures] = size(U);
[~,nTracks] = size(T);

coldStart_idx = 0;
newUser_idx = 0;
newTrack_idx = 0;
warmStart_idx = 0;


count = 0;
cold_it = 1;
new_track_it = 1;
new_user_it = 1;
warm_it = 1;
% for each example in Xtest
fprintf('in MFpredict now.. \n');
for i = 1:m
    i
    % Findig User, Track, and Artist id's
    uidx = predU(i)+1;
    tidx = predT(i)+1;
    aidx = predA(i)+1;

    % Cold start case logic
    if U(uidx,:)*U(uidx,:)' == 0
        
        %unknown user, unknown track
        if T(:,tidx)'*T(:,tidx) == 0
            coldStart_idx(cold_it) = i;
            cold_it = cold_it + 1;
            %fprintf('U,T = 0, calling find_usertrack_latent \n');
            Ul = MFfind_user_latent(uidx,Tidx{tidx},U,UserProf,'correlatedUser',Utrainidx);
            Tl = MFfind_track_latent(aidx, T,ArtistProf,Aidx);
        
        %unknown user, known track    
        else
            newUser_idx(new_user_it) = i;
            new_user_it = new_user_it + 1;
            %fprintf('U =0, T ~= 0, calling find_user_latent \n');
            Ul = MFfind_user_latent(uidx,Tidx{tidx},U,UserProf,'correlatedUser',Utrainidx);                
            Tl = T(:,tidx);
        end
    
    else   
        %known user, unknown track
        if T(:,tidx)'*T(:,tidx) == 0
            newTrack_idx(new_track_it) = i;
            new_track_it = new_track_it + 1;
            %fprintf('U ~= 0, T = 0, calling find_track_latent \n');
            Tl = MFfind_track_latent(aidx,T,ArtistProf,Aidx);
            Ul = U(uidx,:);
            
        %known user, known track
        else
            warmStart_idx(warm_it) = i;
            warm_it = warm_it + 1;
            %fprintf('Known U, known T, calculating the rating \n');
            Tl = T(:,tidx);
            Ul = U(uidx,:);
        end
    end
    

    % making prediction
    pred_y(i) = Ul*Tl;
 
    % Limiting values to 0 to 100
    if pred_y(i) < 0
        pred_y(i) = 0;
    elseif pred_y(i) > 100
        pred_y(i) = 100;

    end
   
end




end