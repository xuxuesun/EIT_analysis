%conference illustration generation
clc;
clear all;

%please specify the loaded ROI file and the file name of two components
load '0227exp/roipixdat_exp_bao02_2.mat';
ventimgnam = 'disp/expdat/0227/testventimg_exp_bao02_2.mat';
cardimgnam = 'disp/expdat/0227/testcardimg_exp_bao02_2.mat';

ventimgdat = cell(0);
cardimgdat = cell(0);
ventpix = cell(0);
cardpix = cell(0);

for i=1:length(pixcell)   
    pixsig1 = cell2mat(pixcell(i)); 
    pixsig = pixsig1(4:end);
    pixattr = pixsig1(3);

    if pixattr == 1
        [ecurmode curiter] = eemd(pixsig,0.2,15,5000);
        ventpix(i) = {[pixsig1(1) pixsig1(2) sum(ecurmode(4:end,:),1)]};
        cardpix(i) = {[pixsig1(1) pixsig1(2) ecurmode(3,:)]};
    elseif pixattr == -1 
        ecurmode = emd(pixsig,'INTERP','spline','MAXMODES',5);
        cardpix(i) = {[pixsig1(1) pixsig1(2) ecurmode(1,:)]};
        ventpix(i) = {[pixsig1(1) pixsig1(2) sum(ecurmode(2:end,:),1)]};
    else
        [ecurmode curiter] = eemd(pixsig,0.1,15,5000);
       %specific scales selection with manual analysis
       ventpix(i) = {[pixsig1(1) pixsig1(2) sum(ecurmode(4:end,:),1)]};
       cardpix(i) = {[pixsig1(1) pixsig1(2) ecurmode(3,:)]};        
    end
end

framenum = length(cell2mat(pixcell(1)))-3;

load '0227exp/origpixdat_exp_bao02_2.mat';
for i=1:framenum
   tmpimgmat = reshape(cell2mat(origimgdat(i)),32,32);
   %ventmat = tmpimgmat;
   ventmat = zeros(32);
   for j=1:length(ventpix)
       tmpdat = cell2mat(ventpix(j));
       tmppix = tmpdat(3:end);
       ventmat(tmpdat(1),33-tmpdat(2)) = tmppix(i);
   end

   %cardmat = tmpimgmat;
   cardmat = zeros(32);
   for j=1:length(cardpix)
      tmpdat = cell2mat(cardpix(j));
      tmppix  = tmpdat(3:end);
      cardmat(tmpdat(1),33-tmpdat(2)) = tmppix(i);
   end
   [tmpindx tmpindy] = ind2sub(size(cardmat),find(cardmat==0));
   bgval = min(min(cardmat));
   for k=1:length(tmpindx)
       cardmat(tmpindx(k),tmpindy(k)) = bgval;
   end
   
   ventimgdat(i) = {ventmat};
   cardimgdat(i) = {cardmat};
end

save(ventimgnam,'ventimgdat');
save(cardimgnam,'cardimgdat');