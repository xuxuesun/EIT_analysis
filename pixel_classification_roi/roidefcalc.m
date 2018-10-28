function [stdpar,slopepar,denpix,eiloc,denglobval] = roidefcalc( pixmat)
%function [stdpar,slopepar,denpix,eiloc,denglobval,contourline] = roidefcalc( pixmat)
%ROI definition based on two statistical parameters

stdpar = zeros(32);
slopepar = zeros(32);
tmpstd = [];
tmpslope = [];
denpix = zeros(size(pixmat));
fc = 2;
fs = 20;
[bfil1 afil1] = butter(4,2*fc/fs,'low'); %butterd for design
denglobval = zeros(1,size(pixmat,3));

%denoising, high frequency noise removal
for i=1:32
    for j=1:32
        pixarr = reshape(pixmat(i,j,:),1,[]);        
        densig = filter(bfil1,afil1,pixarr);
        denpix(i,j,:) = densig;
        
        denglobval = denglobval+densig;
    end
end

%end of inspiration in the global curve
difval = diff(denglobval);
tmplocind = find(difval(1:end-1)>0 & difval(2:end)<0)+1;
[tmpv tmpi] = max(denglobval(tmplocind));
eiloc = tmplocind(tmpi);
denglobval = denglobval./1024;

%SD and FC method
for i=1:32
    for j=1:32
        densig = reshape(denpix(i,j,:),1,[]);
        
        tmpstd = [tmpstd std(densig)];
        stdpar(i,j) = tmpstd(end);
        p = polyfit(denglobval,densig,1);
        tmpslope = [tmpslope p(1)];
        slopepar(i,j) = tmpslope(end);
    end
end

stdpar = stdpar./max(tmpstd);
slopepar =slopepar./max(tmpslope);

%perform gradient analysis of the frame at the end of inspiration
%caimg = reshape(pixmat(:,:,eiloc),32,32);
%save('test_eiframe.mat','caimg');
%maximum gradient occur at the intensity discontinuity
%gradient, imgradientxy, imgradient      directional
%[tmpgmag tmpgdir] = imgradient(im2bw(caimg));
%how to use magnitude??

%contour extraction based on others!!
%todo: manipulate contour matrix
%[cmatr chdle] =imcontour(caimg,3);
%sarr = contourdata(cmatr);
%xrang = 1:1:32;
%yrang = 1:1:32;
%incontmat = inpolygon(xrang,yrang,sarr(1).xdata,sarr(1).ydata);
%roipix_x = xrang(incontmat)
%roipix_y = yrang(incontmat);

end