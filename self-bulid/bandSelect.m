function T_selected = bandSelect(pmap, threshold_peak, threshold_bound)
% Dependency: findContineElement
% Input: pmap: the p-value(or t, F-value) map
%        threshold_peak: the threshold of the peak point
%        threshold_bound: the threshold to determine adjacent points around
%        peak point
% Output: T_selected: first column is channel pair ID, second column is fs
% band
% By Siyuan Zhou,2020/10
% Bug Fix: 2021/3

[t2_pos1,t2_pos2]=find(pmap<=threshold_peak);
source_x = t2_pos2;
source_y = t2_pos1;
selected = {};
value = {};

for ii = 1:size(source_x)
    
    pos0 = source_y(ii);
    raw = pmap(:,source_x(ii));
    select_chwise = findContinueElement(raw, pos0, threshold_bound);
    selected{ii}=select_chwise;
    value{ii} = raw(select_chwise);
end

T = table(source_x,selected',value','VariableNames',{'ch' 'fs' 'value'});

% convert fs and value to string to remove duplicated data
tempT = T(:,{'ch','fs'});
tempT.fs = cellfun(@num2str,T.fs,'UniformOutput',false);
[B, ci]=unique(tempT(:,[1 2]));

T_selected= T(ci,:);

    function continual_set = findContinueElement(raw, pos0, threshold)
        % find continual elements in a vector based on a certain threshold
        %   Input: raw: the vector to find continual elements
        %          pos0: the start position
        %          threshold: to determine whether an element belongs to the continual vector
        %   Output: continual_set: the positions of continual elements
        % By Siyuan Zhou, 2020/10
        
        pos = pos0;
        idx = 1;
        pos_idx = [];
        
        while(pos >0 & pos<=numel(raw) & raw(pos)<threshold)
            pos_idx(idx) = pos;
            pos = pos +1;
            idx = idx+1;
        end
        pos = pos0 - 1;
        
        while(pos >0 & pos<=numel(raw) & raw(pos)<threshold)
            pos_idx(idx) = pos;
            pos = pos -1;
            idx = idx+1;
        end
        
        continual_set = sort(pos_idx);
    end
end