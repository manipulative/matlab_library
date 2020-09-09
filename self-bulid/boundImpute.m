function new_data=boundImpute(old_data,lost_position,n)
% Input: 
%       old_data:data which lost some points in margin
%       lost_position: 'start' or 'end'
%       n : how many points need to be imputated
% Output:
%       new_data = imputated data

old_length=size(old_data,1);
old_num=size(old_data,2);
new_length=old_length+n;
new_data=zeros(new_length,old_num);

if strcmp(lost_position,'end')
    mean_lost=mean(old_data(old_length-n+1:old_length,:),1);std_lost=std(old_data(old_length-n+1:old_length,:),1);
    new_data(1:new_length-n,:)=old_data;
    for ii=1:n
        new_data(old_length+ii,:)=normrnd(mean_lost,std_lost,[1 old_num]);
    end

elseif strcmp(lost_position,'start')
    mean_lost=mean(old_data(1:n,:),1);std_lost=std(old_data(1:n,:),1);
    % new_data(1:n,:)=normrnd(mean_lost,std_lost,[1 n]);
    new_data(n+1:end,:)=old_data;
    for ii=1:n
        new_data(ii,:)=normrnd(mean_lost,std_lost,[1 old_num]);
    end
    
else
    error('unexpected input')
end
end