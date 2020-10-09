function rawDataFilter(dataName,fs,lower,upper,domain)
% Use RawDataFilter to check the quality of the Raw fNIRS data
% Just input fs, lower band and upper band, rawDataFilter will generate the plot
%==========================================================================
% dataName -> the data in the current struct
% fs -> Sampling frequency          (necessary)
% nch -> Number of Channels         (necessary)
% lower -> lower limit of frequency band
% upper -> upper limit of frequency band
% domain -> show plot in time-domain or frequency-domain. input 'time' or
% 'frequency'
%
% by Siyuan Zhou

nch=size(dataName,2);


sizeOfA=size(dataName);  
countOfRow=sizeOfA(1); % the numbers of channels
N = countOfRow;
n = 0:N -1;
t = (n/fs)'; % the time length of signal
rowOfSubplot=ceil(nch/5); % the 


 
 for i = 1:nch
%% Fast Fourier Transformation & Bandpass
Y=fft(dataName(:,i));       %FT变换                                                              
mag2=abs(Y/t);                         %FT变换之后的振幅
mag1=mag2(1:t/2+1);
mag1(2:end-1)=2*mag1(2:end-1);
f=fs*(0:(t/2))/t;                            %频率序列  

%passband
highPass=2*(lower)/fs;
lowPass=2*(upper)/fs;
[b,a]=butter(3,[highPass,lowPass]);
Data_Filtered=filter(b,a,dataName(:,i));

%% generate post-filtered plots
h2(i)=subplot(rowOfSubplot,5,i);

if strcmp(domain,'time')
    plot(dataName(:,i),'Color',[33/255 150/255 243/255])
    hold on
    axis([0,N,-0.1,0.1])
    set(gca,'xtick',[],'xticklabel',[])
    plot(Data_Filtered,'Color',[244/255 67/255 54/255]);
elseif strcmp(domain,'frequency')
    semilogx(f(find(f>=0.01,1)-1:find(f>=1,1)+1),mag1(find(f>=0.01,1)-1:find(f>=1,1)+1),'Color',[244/255 67/255 54/255]); % 仅保留4hz以下数据
    axis([0,1,0,0.05])
    set(gca,'xtick',[0 0.01 0.025 0.05 0.075 0.1 0.25 0.5 0.75 1],'xticklabel',[0 0.01 0.025 0.05 0.075 0.1 0.25 0.5 0.75 1],'ytick',[],'yticklabel',[])
end


ylabel(i,'rotation',0);
hold off
 end
 
 



