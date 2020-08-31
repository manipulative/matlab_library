function wss=hieWss(rawData)
% wss=hieWss(HieData) is a function to calculate the WSS(within cluster sum of square)
% of hierarchical cluster analysis.
% 
% wss: the sum of within-cluster sum of square. By calculating squared
% Euclidean distance of each within cluster member and cluster centroid.
% 
% rawData: the row should be features and the column should be cases. The
% cluster analysis is conducted at feature wise.
% 
% Cluster Analysis parameters: Distance: Euclidean; Linkage: Ward.
%
% Siyuan Zhou, LuLab, 2019/4/11

% clustering
hieDist=pdist(rawData','euclidean');
hieLink=linkage(hieDist,'ward');

for ii=2:size(rawData,2)

hieCluster=cluster(hieLink,'maxclust',ii);

% calculate WSS
func=@(x) sum(pdist2(x',mean(x,2)','squaredeuclidean'));
wss(ii) = sum(splitapply(func,rawData,hieCluster'));
end
