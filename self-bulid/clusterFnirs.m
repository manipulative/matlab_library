function result = clusterFnirs(data, map, z_flag)
% Input:
%      data: fnirs data in a ch x time (or ch x subject) matrix form
%       map: cluster map for channels in a cell form
%    zscore: 0 - no, 1 - yes
% Output:
%      result: clustered fnirs data in a cluster x time (or cluster x subject) matrix form
% By Siyuan Zhou, Lulab. 2020/2/18

nclst = length(map);

nch = size(data,1);
nt = size(data,2);
result = nan(nclst,nt);

for ii = 1:nclst
    
    if z_flag == 0
    result(ii,:) = mean(data(map{ii},:),1);
    elseif z_flag ==1
        result(ii,:) = mean(zscore(data(map{ii},:),[],2),1);
    end
end
    
    