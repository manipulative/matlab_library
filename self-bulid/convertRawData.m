function outFile=convertRawData(filePath, channelNum, subject)
%% Describe
% A function convert Shimadzu-NIRS data .txt file into struct
% Input: *.txt from NIRS equipment
% Output: struct
% origin
% originate:Yihuan Jiang; edited:Siyuan Zhou
%% read data from .txt
disp(['convert the data of ',subject])
tic

% read data information
path_file_n = filePath;
N = channelNum;

% initial data matrix in order to save time
nirs_data.oxyData = zeros(200000,N);
nirs_data.dxyData = zeros(200000,N);
nirs_data.tHbData = zeros(200000,N);
nirs_data.mark=zeros(20000,1);

% open nirs data
fid = fopen(path_file_n);

while 1
    tline = fgetl(fid);                       % read each line of txt
    nindex = find(tline == ',');
    tline(nindex) = ' ';                      % replace "," with " "
    [token, remain] = strtok(tline);          % to read element before each space
    
    % read timestamp, the 2th line
    if strncmp(tline, 'Measured Date',13) == 1
         [token remain] = strtok(remain);
         nirs_data.timestamp = remain;
    end
    
    % read rawname, the 4th line
    if strncmp(tline, 'Name',4) == 1
         [token remain] = strtok(remain);
         nirs_data.rawname = token;
    end
    
    % read data layout, the 16th line
    if strncmp(tline, 'Filename',8) == 1
        nirs_data.layout = remain;
    end
    
    % read data time range, the 32th line
    if strncmp(tline, 'Time Range',10) == 1
        % due to time range is the 3rd element in this line, there needs to reply 3 times
        [token remain] = strtok(remain);
        [token remain] = strtok(remain);
        [token remain] = strtok(remain);
    end
    
    % read nirs-data, from the 35th line
    if strcmp(token, 'Time(sec)') == 1
        index = 1;                                  % the order of rows of nirs-data
        while 1
            tline2 = fgetl(fid);                    % go to 36th line, read data
            if ischar(tline2) == 0, break, end,     % if tline is character, stop repeat
            newlabel = strrep(tline2, 'Z', '');   % transform mark from char to num
            nindex = find(newlabel == ',');
            newlabel = str2num(newlabel);
            
            nirs_data.oxyData(index, :) = newlabel(1,5:3:end-2);
            nirs_data.dxyData(index, :) = newlabel(1,6:3:end-1);
            nirs_data.tHbData(index, :) = newlabel(1,7:3:end);
            nirs_data.mark(index,1)=newlabel(1,4);
            time(index,1) = newlabel(1,1);
            
            % generate mark onset
            vector_onset(index, 1) = newlabel(1,2);
            
            index = index + 1;
        end
        break
    end
end

fclose(fid);

%% write data into .mat

fs = 1./(mean(diff(time)));                  % frequency
nirs_data.fs = fs;

nirs_data.nch = size(nirs_data.oxyData,2);   % number of channels

nirs_data.oxyData = nirs_data.oxyData(1:index-1,:);
nirs_data.dxyData = nirs_data.dxyData(1:index-1,:);
nirs_data.tHbData = nirs_data.tHbData(1:index-1,:);
nirs_data.mark=nirs_data.mark(1:index-1,:);

% generate mark series
count = nirs_data.mark;
for i = 1:max(count)
    index= min(find(count==i));
    mark_onset(i) = index;
end
if ~exist('mark_onset') % for data without mark
    mark_onset=[];
end

nirs_data.T = 1/nirs_data.fs;
nirs_data.subject = subject;
nirs_data.mark_onset =mark_onset;

%% save
outFile=nirs_data;
toc
end
