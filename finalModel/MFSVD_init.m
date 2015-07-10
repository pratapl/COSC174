function [Uinit,Tinit,error] = MFSVD_init(M,numLatent)

% Input 
% M             Matrix of track ratings
% numLatent     The number of latent features to be used in the model

% Output
% Uinit    [nUsers,numLatent] initialized user latent features
% Tinit    [numLatent,nTracks] initialized track latent features

[U,S,T] = svd(M,'econ');

Uinit = U(:,2:numLatent);
Tinit = S(2:numLatent,2:numLatent)*T(:,2:numLatent)';

Mapx = Uinit*Tinit;

error = rmse(M(:),Mapx(:));



end