function r = iscBehavior(subs, sub_var, data, varname, method)
% function used to calculate leave-one-out intersubject-correlation of
% behavior dataset (current version only works for intercultural project)
% Input:
%      subs: subject name list, should be a cell array
%      data: behavior data table, there shold always have a subject identification
%      variable which name as same as [sub_var]
%      sub_var: subject identification variable name
%      varname: variabel names used to calculate ISC, should be a cell
%      string. if use all variables in data, input 'all'
%      method: 'pcorr' or 'eudist'
% Output
%      r: ISC for each subjects

[a sub_select c] = intersect(data.(sub_var), subs);

if strcmp(varname,'all')
T = data(sub_select,:);
T.(sub_var) = [];
T = table2array(T);
else
T = table2array(data(sub_select,varname));  
end
    
sum_all = sum(T,1);
r = NaN(size(T,1),1);

for ii = 1:size(T,1)
    
    subj = T(ii,:);
    others = (sum_all - subj)/(size(T,1)-1);
    
    if strcmp(method,'pcorr')
    r(ii) = corr(subj',others'); 
    elseif strcmp(method,'spearman')
    r(ii) = corr(subj',others', 'Type', 'Spearman'); 
    elseif strcmp(method,'eudist')
        r(ii) = pdist2(subj,others);
    else
        error()
    end
end