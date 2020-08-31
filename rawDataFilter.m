function rawDataFilter(dataName,dataType,lower,upper,domain)
% Use RawDataFilter to check the quality of the Raw fNIRS data
% Just input fs, nch, lower and upper, rawDataFilter will generate the plot
%==========================================================================
% dataName -> the name of the raw data in the workspace. It must be a struct
% and it should include information of fs and nch
% dataName.signal -> the data in the current struct
% name -> the name of the current data, used to generate the title of plot
% fs -> Sampling frequency          (necessary)
% nch -> Number of Channels         (necessary)
% lower -> lower limit of frequency band
% upper -> upper limit of frequency band
% domain -> show plot in time-domain or frequency-domain. input 'time' or
% 'frequency'
%
% by Siyuan Zhou

temp=['dataName.' dataType];
dataName.signal=eval(temp);
fs=dataName.fs;
nch=size(dataName.signal,2);
% lower=0.01;
% upper=1;

sizeOfA=size(dataName.signal);  
countOfRow=sizeOfA(1); % 矩阵有多少行,生成图片用
N = countOfRow;
n = 0:N -1;
t = (n/fs)'; % 通过fs求得每一个采样点的时间点
rowOfSubplot=ceil(nch/5); % 子图行数


 
 for i = 1:nch
%% Fast Fourier Transformation & Bandpass
Y=fft(dataName.signal(:,i));       %FT变换                                                              
mag2=abs(Y/t);                         %FT变换之后的振幅
mag1=mag2(1:t/2+1);
mag1(2:end-1)=2*mag1(2:end-1);
f=fs*(0:(t/2))/t;                            %频率序列  

%passband
highPass=2*(lower)/fs;
lowPass=2*(upper)/fs;
[b,a]=butter(3,[highPass,lowPass]);
Data_Filter=filter(b,a,dataName.signal(:,i));

%% generate post-filtered plots
h2(i)=subplot(rowOfSubplot,5,i);

if strcmp(domain,'time')
    plot(dataName.signal(:,i),'Color',[33/255 150/255 243/255])
    hold on
    axis([0,N,-0.1,0.1])
    set(gca,'xtick',[],'xticklabel',[])
    plot(Data_Filter,'Color',[244/255 67/255 54/255]);
elseif strcmp(domain,'frequency')
    semilogx(f(find(f>=0.01,1)-1:find(f>=1,1)+1),mag1(find(f>=0.01,1)-1:find(f>=1,1)+1),'Color',[244/255 67/255 54/255]); % 仅保留4hz以下数据
    axis([0,1,0,0.05])
    set(gca,'xtick',[0 0.01 0.025 0.05 0.075 0.1 0.25 0.5 0.75 1],'xticklabel',[0 0.01 0.025 0.05 0.075 0.1 0.25 0.5 0.75 1],'ytick',[],'yticklabel',[])
end

a=exist('dataName.subject');
if a
    if i==1
        title(dataName.name);
    end
end


ylabel(i,'rotation',0);
hold off
 end
 
 



