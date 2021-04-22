 function tempFilesList=fileScanner_win(matchStr,pathName)
% To read all files contain match strings in a folder and its subfolders. Then put their
% names and pathes into a table
% Input:matchStr,path
% Output:filesInfo (table)
% Updated: 2021/4/22

p=genpath(pathName);
length_p = size(p,2);
path = {};
temp = [];
tempFilesList=[];

% save subfiles' name to variable: path
for i = 1:length_p 
    if p(i) ~= ';'
        temp = [temp p(i)];
    else 
        temp = [temp '\'];
        path = [path ; temp];
        temp = [];
    end
end 

%swich among each subfile and read texts
for i=1:numel(path)
    currentName=cell2mat(path(i));
    cd(currentName)
    traverseName=['*' matchStr '*']; %change the path name to only read files with .filestype
    FileList=dir(traverseName);
    
    if numel(FileList)==0 
        continue
    else
        tempFilesList=[tempFilesList;FileList]; 
        
    end
end
%output
cd(pathName); 

if size(tempFilesList,1) == 0
    disp('no results org')
else
tempFilesList = struct2table(tempFilesList);
end
