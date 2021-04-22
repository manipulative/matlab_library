function total_data = genTotalData(data_name_list, data_type)
% Input list of dataname(cell form), then generate a3 3-dimension tensor of data; the
% last dimension is the list dimension. Currently only support 2-D data
%    Args:data_name_list: the list of filenames
%         data_type: Basiclly, data are stored in struct form, so you need
%         to identity the type name of data; if data are stored in matrix
%         form, input "0"    

total_data = [];
for ii = 1:size(data_name_list)

    temp_data_struct = load(data_name_list{ii});
        
    if data_type ==0
    total_data(:,:,ii) = [total_data,temp_data_struct];
    else 
        eval(['temp_data = temp_data_struct.' data_type ';'])
        total_data(:,:,ii) = temp_data;
    end
    
end
