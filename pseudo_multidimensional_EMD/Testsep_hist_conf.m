%conference illustration generation
clc;
clear all;

%please specify the name of ROI file and the file name of two components
load '0227exp/roipixdat_exp_bao02_2.mat';
ventimgnam = 'disp/expdat/0227/testventimg_exp_bao02_2_v2.mat';
cardimgnam = 'disp/expdat/0227/testcardimg_exp_bao02_2_v2.mat';

ventimgdat = cell(0);
cardimgdat = cell(0);
ventpix = cell(0);
cardpix = cell(0);

for i=1:length(pixcell)   
    pixsig1 = cell2mat(pixcell(i)); 
    pixsig = pixsig1(4:end);
    pixattr = pixsig1(3);

    if pixattr == 1
        [ecurmode curiter] = eemd(pixsig,0.7,15,5000);
    elseif pixattr == -1 
        ecurmode = emd(pixsig,'INTERP','spline','MAXMODES',5);
    else
        [ecurmode curiter] = eemd(pixsig,0.5,15,5000);
    end
    
    %combination strategy based on histogram of IF
    ventcomp = zeros(size(ecurmode(1,:)));
    cardcomp = zeros(size(ecurmode(1,:)));
    sampfreq = 20;
    %instantaneous frequency distribution analysis
    for k=1:size(ecurmode,1)
       curimf = ecurmode(k,:);
       htval = hilbert(curimf);
       cur_inst_freq = rifndq(curimf,2*pi/sampfreq);
       inst_amp = abs(htval);
	   
       minif = min(cur_inst_freq);
       maxif = max(cur_inst_freq);
       ifdev = std(cur_inst_freq);
       ifvar = var(cur_inst_freq);       
       [pifval pifloc] = findpeaks(curimf);
       
       if maxif > 0 & length(pifloc)>2
           interest_freq = [0 0.1 0.5 0.7 2 5];
           cnt = histc(cur_inst_freq, interest_freq);
           [tmpmaxval tmpmaxind] = max(cnt);
           maxfreqrag = interest_freq(tmpmaxind); %range lower bound
           %disparity between buckets of interested
           disp23 = abs(cnt(3)-cnt(2));
           disp34 = abs(cnt(4)-cnt(3));
           difthred = length(curimf)/3;
           zthred = length(curimf)/10;
           if maxfreqrag == 0.1 & disp23 > difthred & cnt(4) < zthred
               ventcomp = ventcomp+curimf;
           elseif maxfreqrag==0.7 & disp34 > difthred & cnt(2) < zthred
               cardcomp = cardcomp+curimf;
           end
       else
           ventcomp = ventcomp+curimf;
       end
    end
    ventpix(i) = {[pixsig1(1) pixsig1(2) ventcomp]};
    cardpix(i) = {[pixsig1(1) pixsig1(2) cardcomp]};
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