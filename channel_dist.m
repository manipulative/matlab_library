function ch_dist=channel_dist(ch_MNI,ch_config)
% calculate distance of each channel pairs
% INPUT:
%    ch_MNI: MNI coordinates of each channel
%    ch_config: relation configuration of each channel pairs
% OUTPUT
%    ch_dist: distance of each channel pairs
% by Siyuan Zhou, Lulab, BNU

ch_num = size(ch_config, 1);
ch_dist = zeros(ch_num,10);

for ii = 1:ch_num
    ch_dist(ii,1) = pdist2(ch_MNI(ch_config(ii,1),:),ch_MNI(ch_config(ii,2),:),'euclidean');
     ch_dist(ii,[2 3 4]) = ch_MNI(ch_config(ii,1),:);
     ch_dist(ii,[5 6 7]) = ch_MNI(ch_config(ii,2),:);
     ch_dist(ii,8) = abs(ch_MNI(ch_config(ii,1),1) - ch_MNI(ch_config(ii,2),1));
     ch_dist(ii,9) = abs(ch_MNI(ch_config(ii,1),2) - ch_MNI(ch_config(ii,2),2));
     ch_dist(ii,10) = abs(ch_MNI(ch_config(ii,1),3) - ch_MNI(ch_config(ii,2),3));
end

end