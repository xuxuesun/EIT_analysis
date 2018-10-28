%conference illustration for imf display: fig3
%overlapping region pixel temporal curve IMF+freq plot
clc;
clear all;

load '0227exp/roipixdat_exp_bao01.mat';

olind = 362;
olpixsig1 = cell2mat(pixcell(olind));
olpixsig = olpixsig1(4:1000);

[ecurmode curiter] = eemd(olpixsig,0.7,15,5000);
f2 = figure(1);
subaxis(7,2,1,'Spacing',0.05,'SpacingHoriz',0, 'Padding', 0.01, 'Margin', 0.03,'MarginLeft',0.01,'MarginRight',0.01);
plot(olpixsig);
set(gca,'FontSize',12);
hlx=[120 120 260 260];
hly=[0 5 5 0];
hlreg = patch(hlx,hly,'r');
set(hlreg,'FaceAlpha',0.2,'LineStyle','none');
title('Original Signal');
axis tight;
subaxis(7,2,2,'Spacing',0.05,'SpacingHoriz',0, 'Padding', 0.01, 'Margin', 0.03,'MarginRight',0);
plot(olpixsig(120:260));
set(gca,'FontSize',12);
title('Highlighted Segment');
axis tight;
for k=1:6
    subaxis(7,2,k*2+1,'Spacing',0.05,'SpacingHoriz',0, 'Padding', 0.01, 'Margin', 0.03,'MarginLeft',0.01,'MarginRight',0.01);
    plot(ecurmode(k,:));
    set(gca,'FontSize',12);
    title(strcat('IMF',num2str(k)));
    axis tight;
    samp_freq = 20;
    nfft= 2^nextpow2(length(ecurmode(k,:)));
    freqsig=fft(ecurmode(k,:),nfft)/length(ecurmode(k,:));
    ff1=samp_freq/2*linspace(0,1,nfft/2+1);
    freqv=2*abs(freqsig(1:nfft/2+1)); 
    subaxis(7,2,k*2+2,'Spacing',0.05,'SpacingHoriz',0, 'Padding', 0.01, 'Margin', 0.03,'MarginRight',0);
    plot(ff1,freqv,'k');
    set(gca,'FontSize',12);
    title(strcat('Frequency analysis of IMF',num2str(k)));
    axis tight;
end