%open data
clear all
close all
filenames=table(['000.wav';'090.wav';'180.wav';'270.wav']); %input the filenames you recorded here
figure;
n_recordings=4;%input the number of recordings here
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
[~,locs]=findpeaks(trace,'MinPeakHeight',0.1,'MinPeakDistance',3); % change amplitude threshold here
plot(x(locs),trace(locs),'rv');
ax(2)=subplot(2,n_recordings,i+n_recordings),histogram(x(locs),size(trace,1)/(1*srate));
ylabel('spike freq, Hz');
xlabel('time, s');
linkaxes(ax,'x');

mean_freq(i)=size(locs,1)/max(x);
end

%Deflection angle / firing rate plot
clear x
figure;
x=deg2rad([0,90,180,270]); % input the deflection angles you chose here
polarplot(x([1:end 1]),mean_freq([1:end 1]),'ko-','LineWidth',3);hold on;
title('spine angle tuning');
rmax = max(mean_freq);
text(rmax/2, 0, 'spike freq, Hz', 'horiz', 'center', 'vert', 'top', 'rotation', 80);
text(pi/4, rmax*1.2, 'deflection angle, degrees', 'horiz', 'center', 'rotation', -45);



