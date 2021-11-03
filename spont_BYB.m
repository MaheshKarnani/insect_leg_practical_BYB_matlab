%open data
clear all
close all
filename='spont.wav'; %input the filename you recorded here
figure;



importdata(filename);
data=ans.data;
clear ans;
srate=10000; %sample rate 10kHz
data=data(1:floor(size(data,1)/srate)*srate,:); %cut to nearest full second
%plot
trace1=-data(:,1);%reverse polarity
trace2=-data(:,2);%reverse polarity
x=(1:size(data,1))/srate;
ax(1)=subplot(2,1,1),plot(x,trace1);
hold on;
ylabel('V,mV');
title(filename);
% plot(trace2-0.3);

%find peaks
trace=trace1;
clear locs
[~,locs]=findpeaks(trace,'MinPeakHeight',0.05,'MinPeakDistance',3);%change amplitude threshold here!
plot(x(locs),trace(locs),'rv');
ax(2)=subplot(2,1,2),histogram(x(locs),size(trace,1)/(1*srate));
ylabel('spike freq, Hz');
xlabel('time, s');
linkaxes(ax,'x');

mean_freq=size(locs,1)/max(x);


%average waveform
wave=[];
window=20;%how many samples either side of spike
for i=5:size(locs,1)-5
    wave(i,:)=trace([locs(i)-window:locs(i)+window]);
end
wave(1:4,:)=[];
wave_ave=mean(wave,1);
wave_std=std(wave,1);
figure;
plot(wave_ave,'LineWidth',3);hold on
errorbar(wave_ave,wave_std);
xlabel('time, samples 10kHz');
ylabel('V,mV');
title('average spike');

%amplitude distribution from last rec
amp=max(wave,[],2);
figure;
histogram(amp,20);
xlabel('spike amplitude, mV');
ylabel('count');
title('amplitude histogram');
