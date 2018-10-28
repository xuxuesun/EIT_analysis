clc;
clear all;
load 'expdat/0227/testcardimg_exp_bao02_2.mat';
load 'expdat/0227/testventimg_exp_bao02_2.mat';
load '../0227exp/origpixdat_exp_bao02_2.mat';


%display at specific point
figure(1);
cur_carddat = cardimgdat{258};
cur_ventdat = ventimgdat{258};
cur_eitdat = origimgdat{258};
subplot(1,3,1);
imgorig = image(cur_eitdat);
axis image;
caxis([0 32]);
set(gca,'Fontsize',20,'XTick',[0 8 16 24 32],'XTickLabel',{'0','8','16','24','32'},'YTick',[0 8 16 24 32],'YTickLabel',{'0','8','16','24','32'});
colormap jet
colorbar
freezeColors
subplot(1,3,2);
imgvent = image(imrotate(cur_ventdat,90));
axis image;
caxis([0 32]);
set(gca,'Fontsize',20,'XTick',[0 8 16 24 32],'XTickLabel',{'0','8','16','24','32'},'YTick',[0 8 16 24 32],'YTickLabel',{'0','8','16','24','32'});
colormap jet
colorbar
freezeColors
subplot(1,3,3);
[b clims tmpmap] = real2rgb(imrotate(cur_carddat,90), 'cool');
imgdat1  = cmapping(imrotate(cur_carddat,90),'br','direct');
image(imgdat1);
colormap hsv
colorbar
axis image;
caxis([0 32]);
set(gca,'Fontsize',20,'XTick',[0 8 16 24 32],'XTickLabel',{'0','8','16','24','32'},'YTick',[0 8 16 24 32],'YTickLabel',{'0','8','16','24','32'});
freezeColors

figure(2);
cur_carddat = cardimgdat{295};
cur_ventdat = ventimgdat{295};
cur_eitdat = origimgdat{295};
subplot(1,3,1);
imgorig = image(cur_eitdat);
axis image;
colormap jet
colorbar
caxis([0 32]);
set(gca,'Fontsize',20,'XTick',[0 8 16 24 32],'XTickLabel',{'0','8','16','24','32'},'YTick',[0 8 16 24 32],'YTickLabel',{'0','8','16','24','32'});
freezeColors;
subplot(1,3,2);
imgvent = image(imrotate(cur_ventdat,90));
axis image;
caxis([0 32]);
colormap jet
colorbar
set(gca,'Fontsize',20,'XTick',[0 8 16 24 32],'XTickLabel',{'0','8','16','24','32'},'YTick',[0 8 16 24 32],'YTickLabel',{'0','8','16','24','32'});
freezeColors;
subplot(1,3,3);
[b clims tmpmap] = real2rgb(imrotate(cur_carddat,90), 'cool');
imgdat1  = cmapping(imrotate(cur_carddat,90),'br','direct');
image(imgdat1);
axis image;
caxis([0 32]);
colorbar
set(gca,'Fontsize',20,'XTick',[0 8 16 24 32],'XTickLabel',{'0','8','16','24','32'},'YTick',[0 8 16 24 32],'YTickLabel',{'0','8','16','24','32'});
freezeColors;

figure(3);
cur_carddat = cardimgdat{590};
cur_ventdat = ventimgdat{590};
cur_eitdat = origimgdat{590};
subplot(1,3,1);
imgorig = image(cur_eitdat);
axis image;
colormap jet
colorbar
caxis([0 32]);
set(gca,'Fontsize',20,'XTick',[0 8 16 24 32],'XTickLabel',{'0','8','16','24','32'},'YTick',[0 8 16 24 32],'YTickLabel',{'0','8','16','24','32'});
freezeColors;
subplot(1,3,2);
imgvent = image(imrotate(cur_ventdat,90));
axis image;
colormap jet
colorbar
caxis([0 32]);
set(gca,'Fontsize',20,'XTick',[0 8 16 24 32],'XTickLabel',{'0','8','16','24','32'},'YTick',[0 8 16 24 32],'YTickLabel',{'0','8','16','24','32'});
freezeColors;
subplot(1,3,3);
[b clims tmpmap] = real2rgb(imrotate(cur_carddat,90), 'cool');
imgdat1  = cmapping(imrotate(cur_carddat,90),'br','direct');
image(imgdat1);
axis image;
colorbar
caxis([0 32]);
set(gca,'Fontsize',20,'XTick',[0 8 16 24 32],'XTickLabel',{'0','8','16','24','32'},'YTick',[0 8 16 24 32],'YTickLabel',{'0','8','16','24','32'});

numframes = size(cardimgdat,2);
eitvid = VideoWriter('testeit_exp_liu02.avi');
eitvid.Quality = 100;
eitvid.FrameRate = 20;
open(eitvid);

for i=1:numframes
    cur_carddat = cardimgdat{i};
    cur_ventdat = ventimgdat{i};
    cur_eitdat = origimgdat{i};
    
    subplot(1,3,1);
    imgorig = image(cur_eitdat);
    axis image;
    caxis([0 32]);
    freezeColors;
    
    subplot(1,3,2);
    imgvent = image(imrotate(cur_ventdat,90));
    axis image;
    caxis([0 32]);
    freezeColors;
    
	%adjust the display scale!!!
	subplot(1,3,3);     
	[b clims tmpmap] = real2rgb(imrotate(cur_carddat,90), 'cool');
	imgdat1  = cmapping(imrotate(cur_carddat,90),'br','direct');
	imshow(imgdat1);
	axis image;
	caxis(clims);
	freezeColors;
    
    writeVideo(eitvid,getframe(gcf));
    clf;
end
close(eitvid);