%Brian Doolittel, Pratap Luitel
%Final Project for COSC 174, Dartmouth College
%3/15/2015

%This script partitions the train data based on time and creates and saves
%M,WordProf,UserProf,ArtistProf, test set, training set, and other
%important variables. This should should only be run to change the train
%and test sets. 

data_train = load('data_train.mat');
data_users = load('data_users.mat');
data_words = load('data_words.mat');


Xtrain = data_train.train;
user_profile = data_users.data_users;
words_profile = data_words.data_words;

%ratings in time period 1-18 and the rest
idx_T1 = find(Xtrain(:,5)<= 18);
idx_T2 = find(Xtrain(:,5) > 18);

%training set
train = Xtrain(idx_T1,:);
%test set
test = Xtrain(idx_T2,:);

% finding maximum values of Xtrain
maxArtist = max(Xtrain(:,1));
maxTrack = max(Xtrain(:,2));
maxUser = max(Xtrain(:,3));

fprintf('finding M \n')
% creating M matrix with Xtrain filled in and dimensions MaxUser+1 x
% MaxTrack+1
[M,Uidx,Tidx,Aidx,A] = MFratings(train,maxArtist,maxTrack,maxUser);
%function [T,U] = MFtrain_latent(M,lambda,gamma,latent)
%function pred_y = MFpredict_latent(T,Xtest,U)

fprintf('finding UserProf \n')
% making matrix of user profiles
UserProf = MFusers(M,user_profile);

fprintf('finding ArtistProf \n')
[ArtistProf, WordProf,AUidx,UAidx] = MFartists(M,A,words_profile);
%train the model on ratings for first 12 months
%[T,U] = MFtrain_latent(M,0.01,0.01,150);

save('WordProf','WordProf')
save('ArtistProf','ArtistProf')
save('UserProf','UserProf')
save('M','M')
save('A','A')
save('Aidx','Aidx')
save('Tidx','Tidx')
save('Uidx','Uidx')
save('AUidx','AUidx')
save('UAidx','UAidx')
save('test','test')
save('train','train')

fprintf('saved files')




