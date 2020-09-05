 function tempFilesList=fileScanner(filesType,pathName)
% To read all same type files in a folder and its subfolders. Then put their
% names and pathes into a table
% Input:filestype,path
% Output:filesInfo (table)

p=genpath(pathName);
length_p = size(p,2);
path = {};
temp = [];
tempFilesList=[];
filesTypeName=['*.' filesType];

% save subfiles' name to variable: path
for i = 1:length_p %寻找分割符';'，一旦找到，则将路径temp写入path数组中
    if p(i) ~= ';'
        temp = [temp p(i)];
    else 
        temp = [temp '\']; %在路径的最后加入 '\'
        path = [path ; temp];
        temp = [];
    end
end 

%swich among each subfile and read texts
for i=1:numel(path)
    currentName=cell2mat(path(i));
    cd(currentName)
    traverseName=[currentName filesTypeName]; %change the path name to only read files with .filestype
    FileList=dir(traverseName);
    
    if numel(FileList)==0 %判断该文件夹下是否有指定类型文件
        continue
    else
        tempFilesList=[tempFilesList;FileList]; %提取文件名称和路径,并保存在一个struct里
        
    end
end
%output
cd(pathName); %返回初始目录

tempFilesList = struct2table(tempFilesList);
%filesInfo=struct('name',tempFilesNameList,'path',tempFilesPathList);