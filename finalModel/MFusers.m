%Brian Doolittle, Pratap Luitel
%Final Project for COSC 174, Dartmouth College
%3/15/2015
function UserProf = MFusers(M,data_users)
    %INPUT
    % M : [nUsers x nTracks] matrix of users ratings
    % data_users : matrix, contains users profile information
    %
    %OUTPUT
    % UserProf : matrix of user profiles

    num_user = size(M,1);
    [m,n] = size(data_users);
    UserProf = zeros(num_user,n-1);


    for i = 1:m
       uidx = data_users(i,1) + 1;
       UserProf(uidx,:) = data_users(i,2:n);
    end

    % finding users who did not fill in survey and giving them average
    coldidx = find(sum(abs(UserProf),2) == 0);

    avgU = sum(abs(UserProf))/m;

    for i = coldidx'
        UserProf(i,:) = avgU; 
    end


end