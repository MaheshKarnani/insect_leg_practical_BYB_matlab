%open data
clear all
close all
filenames=table(['00.wav';'45.wav';'90.wav']); %input the filenames you recorded here
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
trace2=-data(:,2);%reverse polarity
x=(1:size(data,1))/srate;
ax(1)=subplot(2,n_recordings,i),plot(x,trace1);
hold on;
ylabel('V,mV');
title(filename);

%find peaks
trace=trace1;
clear locs
[~,locs]=findpeaks(trace,'MinPeakHeight',0.05,'MinPeakDistance',3);%change amplitude threshold here!
plot(x(locs),trace(locs),'rv');
ax(2)=subplot(2,n_recordings,i+n_recordings),histogram(x(locs),size(trace,1)/(1*srate));
ylabel('spike freq, Hz');
xlabel('time, s');
linkaxes(ax,'x');

mean_freq(i)=size(locs,1)/max(x);
end

%average waveform from last rec
wave=[];
window=20;%how many samples either side of spike
for i=5:size(locs,1)-5
    wave(i,:)=trace([locs(i)-window:locs(i)+window]);
end

%Joint angle / firing rate plot
clear x
figure;
x=[0,45,90]; %input the joint angles you recorded here in degrees
plot(x,mean_freq,'ko-','LineWidth',3);
xlabel('joint angle, degrees');
ylabel('spike freq, Hz');
title('joint angle encoding');



