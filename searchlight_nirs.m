function X = searchlight_nirs(id, distance_rank, ch_co)
% Inputing channel's id, coordinates and distance rank(1,2,3), calculates the
% nearest channle set for each channel within limited distance.
% ch_co should be a matriax which first column is channel's id, second and
% thrid columns are 2-D coordinates of each channel, and the last column is
% the id of channel-sets it belongs to.
% rank1 = 0.707*unit; rank2 = 1*unit; rank3 = 1.414*unit;


id_set = ch_co(id,4);

target_co = ch_co(id,[2 3]);
ch_co(id,:) = [];
set_co = ch_co((ch_co(:,4)==id_set),:);

id = set_co(:,1);
D = pdist2(target_co, set_co(:,[2 3]))';

set_dist = [id D];

switch distance_rank
    case 1
        r = sqrt(2)/2;
    case 2
        r = 1;
    case 3
        r = sqrt(2);
    otherwise
        error
end

unit = 2;
X = set_dist((set_dist(:,2)/unit <= r),1)


end




