%Brian Doolittle, Pratap Luitel
%Final Project for COSC 174, Dartmouth College
%3/15/2015
function latentFeatures_track = MFfind_track_latent(artistIdx,T,ArtistProf,Aidx)
%This function returns laten features of a track for an artist  
% INPUTS:
% artistIdx  : a scalar, index of the artist 
% T          : [nFeatures x nTracks], latent features of tracks
% ArtistProf : [nArtists x nColumn] averaged users description of all artists
% Aidx       : a cell, Aidx{i} contains a matrix with index of tracks by artist i

% OUTPUT:
% latentFeatures_track: [nFeatures x 1], latent feature for the new track

    % matrix containing index for tracks by same artist
    artistTracks = Aidx{artistIdx};

    %if the artist has other known tracks
    %the latent features is the average of those tracks
    if ~isempty(artistTracks)
        Tset = T(:,artistTracks);
        latentFeatures_track = sum(Tset,2)/size(Tset,2);
    
    %if the artist is new, the latent features is the average of latent
    %features of tracks by a similar artist. The similar artist is found by
    %comparing the artist profile which is derived from words.csv. 
    else
        artist_profile = ArtistProf(artistIdx,:);
        artist_profile = artist_profile/norm(artist_profile);
        
        %find index of artists that have been rated by users
        rowCounter = 1;
        for i = 1:length(Aidx)
            if (~ isempty(Aidx{i}))
                artist_neighbor_idx(rowCounter,1) = i;
                rowCounter = rowCounter + 1;
            end
        end
        
        artist_neighbor = ArtistProf(artist_neighbor_idx,:);
        %a column, each element is the magnitude of corresponding row in
        %artist_neighbor
        normFactor = sqrt(sum(artist_neighbor.^2,2));
        %magnitude matrix of the same size as artist_neighbor
        normFactor = repmat(normFactor,[1,size(artist_neighbor,2)]);
        
        %check if there are any zero vectors
        zeroVectorIdx = find(sum(normFactor,2)== 0);
        if isempty(zeroVectorIdx)
            %normalize artist_neighbor
            artist_neighbor = artist_neighbor./normFactor;
        else
            fprintf('one or more neighbors of artist %d is empty /n',artistIdx);
        end
        [~,similarArtistIdx] = max(artist_neighbor*artist_profile');
        latentArtistIdx = artist_neighbor_idx(similarArtistIdx);
        
        %songs composed by the latentArtistIdx
        trackIdx = Aidx{latentArtistIdx};
        if ~ isempty(trackIdx)
            %average of the latent features of the tracks by the artist
            latentFeatures_track = mean(T(:,trackIdx),2);
        else
            fprintf('estimated artist %d doesnt have any tracks /n ',latentArtistIdx);
            latentFeatures_track = (1/91)*ones(91,1);
        end
    end
end