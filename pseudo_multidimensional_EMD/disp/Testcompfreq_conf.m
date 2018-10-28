%display the frequency content of separated components
clc;
clear all;
%please specify the original data file and the files of two extracted components
load '../0227exp/origpixdat_exp_bao02_2.mat';
load 'expdat/0227/testcardimg_exp_bao02_2_v2.mat';
load 'expdat/0227/testventimg_exp_bao02_2_v2.mat';

samp_freq = 20;
cardgi = [];
origgi = [];
ventgi = [];
for k=1:868    
    curimg = imrotate(cardimgdat{k},90);
    curcard = curimg(23,23);
    cardgi = [cardgi curcard];
    curimg = origimgdat{k};
    curorig = curimg(23,23);
    origgi = [origgi curorig];
    curimg = imrotate(ventimgdat{k},90);
    curvent = curimg(23,23);
    ventgi = [ventgi curvent];
end

subplot(3,2,1);
timespan = 1/samp_freq:1/samp_freq:length(origgi)/20;
plot(timespan, origgi);
set(gca,'Xlim',[0 40],'Ylim',[0 60],'Fontsize',20);
xlabel('Time(second)','Fontsize',20);
ylabel('Amplitude','Fontsize',20);
title('(a) Original Signal','Fontsize',20);
nfft= 2^nextpow2(length(origgi));
freqsig=fft(origgi,nfft)/length(origgi);
ff1=samp_freq/2*linspace(0,1,nfft/2+1);
freqv=2*abs(freqsig(1:nfft/2+1)); 
subplot(3,2,2);
plot(ff1,freqv,'k');
set(gca,'XLim',[0.1 2],'Ylim',[0 8.5],'Fontsize',20);
xlabel('Frequency','Fontsize',20);
ylabel('Magnitude','Fontsize',20);
title('(b) Frequency Contents of Original Signal','Fontsize',20);
subplot(3,2,3);
plot(timespan, cardgi);
set(gca,'Xlim',[0 40],'Ylim',[-3 3.5],'Fontsize',20);   %bao02
xlabel('Time(second)','Fontsize',20);
ylabel('Amplitude','Fontsize',20);
title('(c) Cardiac Activity','Fontsize',20);
nfft= 2^nextpow2(length(cardgi));
freqsig=fft(cardgi,nfft)/length(cardgi);
ff1=samp_freq/2*linspace(0,1,nfft/2+1);
freqv=2*abs(freqsig(1:nfft/2+1)); 
subplot(3,2,4);
plot(ff1,freqv,'k');
set(gca,'Xlim',[0 5],'Ylim',[0 0.5],'Fontsize',20);
xlabel('Frequency','Fontsize',20);
ylabel('Magnitude','Fontsize',20);
title('(d) Frequency Contents of Cardiac Activity','Fontsize',20);
subplot(3,2,5);
plot(timespan,ventgi);
set(gca,'Xlim',[0 40],'Ylim',[-2 60], 'Fontsize',20);   %bao02
xlabel('Time(second)','Fontsize',20);
ylabel('Amplitude','Fontsize',20);
title('(e) Ventilation Component','Fontsize',20);
nfft = 2^nextpow2(length(ventgi));
freqsig = fft(ventgi,nfft)/length(ventgi);
ff1 = samp_freq/2*linspace(0,1,nfft/2+1);
freqv = 2*abs(freqsig(1:nfft/2+1));
subplot(3,2,6);
plot(ff1,freqv,'k');
set(gca,'Xlim',[0.1 2],'Ylim',[0 8],'Fontsize',20);
xlabel('Frequency','Fontsize',20);
ylabel('Magnitude','Fontsize',20);
title('(f) Frequency Contents of Ventilation','Fontsize',20);