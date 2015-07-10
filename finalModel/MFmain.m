%Brian Doolittle, Pratap Luitel
%Final Project for COSC 174, Dartmouth College
%3/15/2015
function [error,pred_y,correct_y] = MFmain(lambda1,lambda2,gamma,niter)
%This function loads the needed matrices, trains, tests and gives an RMSE
%error for the test. It assumes that the data matrices are already saved in
%the same location as the file is. 
%
%
%INPUT
% lambda1  : a scalar, hyperparameter 
% lambda2  : a scalar, hyperparameter
% gamma    : a scalar, hyperparameter
% niter    : a scalar, number of iterations for the ALS algorithm 
%
%OUTPUT
% error     : a scalar, The RMSE error on the test set
% pred_y    : [nTest x 1] predicted ratings for test set
% correct_y : [nTest x 1] actual ratings for the test set

%load the data    
UserProf = load('UserProf.mat');
ArtistProf = load('ArtistProf.mat');
M = load('M.mat');
Aidx = load('Aidx.mat');
Tidx = load('Tidx.mat');
Uidx = load('Uidx.mat');
test = load('test.mat');

UserProf = UserProf.UserProf;
ArtistProf = ArtistProf.ArtistProf;
M = M.M;
Aidx = Aidx.Aidx;
Tidx = Tidx.Tidx;
Uidx = Uidx.Uidx;
test = test.test(1:2000,:);


fprintf('loaded files \n')
%training
fprintf('Training.. \n')
    [Uinit,Tinit] = MFSVD_init(M,10);
    [T,U,Utrainidx,~,~,~] = MFtrain(M,UserProf,Uidx,Tidx,lambda1,lambda2,gamma,niter,'ProfInit');

%prediction
fprintf('Testing.. \n')
    [pred_y,~,~,~,~] = MFpredict(T,test,U,Tidx,Aidx,UserProf,ArtistProf,Utrainidx);
    
%error
    correct_y = test(:,4);
    error = rmse(pred_y,correct_y);
end
