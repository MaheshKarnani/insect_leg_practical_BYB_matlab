%open data
clear all
close all
filenames=table(['short_.wav';'medium.wav';'long__.wav']);%input file names here
figure;
n_recordings=3;%input the number of recordings here
for i=1:n_recordings
temp=cellstr(table2cell(filenames(i,1)));
filename=temp{1, 1};
importdata(filename);
data=ans.data;
clear ans;
srate=10000; %sample rate 10kHz
data=data(1:floor(size(data,1)/srate)*srate,:); %cut to nearest full second
%plot
trace1=-data(:,1);%reverse polarity
% trace2=-data(:,2);%reverse polarity
x=(1:size(data,1))/srate;
ax(1)=subplot(2,n_recordings,i),plot(x,trace1);
hold on;
ylabel('V,mV');
title(filename);

%find peaks
trace=trace1;
clear locs
[~,locs]=findpeaks(trace,'MinPeakHeight',0.1,'MinPeakDistance',3);% change amplitude threshold here
plot(x(locs),trace(locs),'rv');
ax(2)=subplot(2,n_recordings,i+n_recordings),histogram(x(locs),[1:1:size(trace,1)/(1*srate)]);
ylabel('spike freq, Hz');
xlabel('time, s');
linkaxes(ax,'x');

rate(i).h=histcounts(x(locs),[1:1:size(trace,1)/(1*srate)]);
end

%% habituation index plot
clear x trace
figure;
x=[0.5,1,6]; %how many seconds after the peak did the stimulus last? (look at previous plot)
for i=1:size(rate,2)
    trace=rate(i).h;
    habi(i)=max(trace)/trace(find(trace==max(trace))+floor(x(i))); %habituation index 
end
plot(x,habi,'ko-','LineWidth',3);hold on;
title('spine habituation');
ylabel('habituation index');
xlabel('duration of stimulus, s');



