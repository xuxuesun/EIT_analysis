clc;
clear all;
%[eitimg eitgi] = readeitdat('ts_guertel_M_konf_A_01_01.bin');
%customized parameters
%origfile = '0116exp/ab_xy_01_eiu_Img.mat';
%origfile='0227exp/Baoshuai/ab_xy_19_eiu_Img.mat';
origfile='0227exp/Lin_Liu/ab_xy_07_eiu_Img.mat';
genfile = 'testeit_exp07.mat';
gen_movfile = 'testeit_exp07.avi';
[eitimg eitgi] = geneitmat(origfile,genfile);
numframes = size(eitimg,2);

eitvid = VideoWriter(gen_movfile);
eitvid.Quality = 100;
eitvid.FrameRate = 20;
%eitvid.FrameRate = 50;
open(eitvid);
gival = [];

for i=1:numframes
    cureitdat = eitimg{i};
   img = image(reshape(cureitdat',32,32)); 
    
    gival = [gival sum(cureitdat)];
    writeVideo(eitvid,getframe(gcf));
end

close(eitvid);

timespan = 1/20:1/20:numframes/20;
plot(timespan,gival);hold on;
%highlight apnea period
%apneax1 = [165 165 176.3 176.3];
%apneay1 = [0 40000 40000 0];
%apneapos1 = patch(apneax1,apneay1,'r');
%set(apneapos1,'FaceAlpha',0.2,'LineStyle','none');
xlabel('Time(seconds)','FontSize',14);
ylabel('Amplitude','FontSize',14);
title('Apnea Involved Global Impedance Changes','FontSize',20);