%Brian Doolittel, Pratap Luitel
%Final Project for COSC 174, Dartmouth College
%3/15/2015

%This script initializes the matrix factorization model. It holds out random %10 
%of the training set for testing. It creates necessary matrices like M,A
%ArtistProf, UserProf, Aidx, Tidx, Uidx, etc. This should be run only if
%the training and testing set need to be reinitialized. 

fprintf('Initializing the matrix factorization model ...\n');

data_train = load('data_train.mat');
data_users = load('data_users.mat');
data_words = load('data_words.mat');

Xtrain = data_train.train;
user_profile = data_users.data_users;
words_profile = data_words.data_words;

[m,n] = size(Xtrain);

maxArtist = max(Xtrain(:,1));
maxTrack = max(Xtrain(:,2));
maxUser = max(Xtrain(:,3));

% creating a vector of indices of X
idxperm = 1:m;

iteration = 1;
N = 10;
        % looping through folds
        for j = 1

            tic;
            
            % creating fold from permuted data set    
            Xtest = idxperm([floor(m / N * j + 1) : floor(m / N * (j + 1))]);

            % creating the set of indices used for validation
            Xt = setdiff(idxperm,Xtest); 

            test = Xtrain(Xtest,:);
            train = Xtrain(Xt,:);
            
            [M,Uidx,Tidx,Aidx,A] = MFratings(train,maxArtist,maxTrack,maxUser);
            UserProf = MFusers(M,user_profile);
            
            [ArtistProf,WordProf,AUidx,UAidx] = MFartists(M,A,words_profile);
            
            save('UserProf','UserProf')
            save('ArtistProf','ArtistProf')
            save('M','M')
            save('A','A')
            save('Aidx','Aidx')
            save('Tidx','Tidx')
            save('Uidx','Uidx')
            save('AUidx','AUidx')
            save('UAidx','UAidx')
            save('test','test')
            save('train','train')
                
            fprintf('Finishing Initialization \n')

            toc;
        end


