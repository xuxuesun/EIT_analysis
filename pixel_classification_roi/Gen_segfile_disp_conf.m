%generate segmentation result (binary) for global contour detection
%generate ventilation region segmentation result (binary)
%generate cardiac region detection result (binary)
%pixel classification based on set operation 
%save the classification result into file
clc;
clear all;
load 'exp/0227data/testeit_exp_bao05.mat';       %please specify the name of original data with full location

datmat1 = cell2mat(eitimg);
datmat = reshape(datmat1,32,32,size(datmat1,2));

pixcell = cell(0);
roipix_cnt = 0;
origimgdat = cell(0);
globval = sum(datmat1,1);

for k=1:size(datmat,3)
    origimgdat(k) = {datmat(:,:,k)};
end

%cardiac region segmentation based on change detection
%apnea period or 15samples window around end of expiration
apneadur = 380:1:665; %bao05
[stdval,slopeval,denpval,tmploc,dengval] = roidefcalc(datmat);

%change detection, unify all change region
unicreg = zeros(32,32);
for k=2:length(apneadur)
    framediff = datmat(:,:,apneadur(k))-datmat(:,:,apneadur(k-1));
    tmpind = find((im2bw(framediff)+unicreg)~=0);
    if ~isempty(tmpind)
            for k=1:length(tmpind)
                [tmpindx,tmpindy] = ind2sub(size(unicreg),tmpind(k));
                unicreg(tmpindx,tmpindy) = 1;
            end
    end
end

cdcontour = unicreg;

%ventilation dominated region segmentation
eiframe = datmat(:,:,tmploc);
seg = chenvese(eiframe,'small',800,0.1,'chan')
hold off;

if seg(1,1)~=0
    vdcontour = ~seg;
else
    vdcontour = seg;
end

globcontour = zeros(32,32);
tmpunionind = union(find(vdcontour==1),find(cdcontour==1));
for k=1:length(tmpunionind)
    [tmpindx,tmpindy] = ind2sub(size(cdcontour),tmpunionind(k));
    globcontour(tmpindx,tmpindy) = 1;
end
globcontour = imfill(globcontour);

tmpintsectind = intersect(find(vdcontour==1),find(cdcontour==1));
cdregion = cdcontour;
vdregion = vdcontour;
for k=1:length(tmpintsectind)
    [tmpindx,tmpindy] = ind2sub(size(cdcontour),tmpintsectind(k));
    cdregion(tmpindx,tmpindy) = 0;
    vdregion(tmpindx,tmpindy) = 0;
end

tmpglobind = find(globcontour==1);
tmpolind = union(tmpintsectind,setdiff(tmpglobind,tmpunionind));
olregion = zeros(32,32);
for k=1:length(tmpolind)
    [tmpindx,tmpindy] = ind2sub(size(cdcontour),tmpolind(k));
    olregion(tmpindx,tmpindy) = 1;
end

%generate classified pixel roi file, please specify the file name
filnam = 'exp/0227exp/roipixdat_exp_bao05_2.mat';
filnam2 = 'exp/0227exp/origpixdat_exp_bao05_2.mat';

for k=1:length(tmpglobind)
   [tmpindx,tmpindy] = ind2sub(size(cdcontour),tmpglobind(k));
   densig = reshape(denpval(tmpindx,tmpindy,:),1,[]);
   if cdregion(tmpindx,tmpindy)==1
       pixcell(roipix_cnt+1) = {[tmpindy tmpindx -1 densig]};
   elseif vdregion(tmpindx,tmpindy)==1
       pixcell(roipix_cnt+1) = {[tmpindy tmpindx 1 densig]};
   else
       pixcell(roipix_cnt+1) = {[tmpindy tmpindx 0 densig]};
   end
   roipix_cnt = roipix_cnt+1;
end

figure(3);
h = image(eiframe);
hold on;
set(gcf, 'color', 'w');
set(gcf, 'InvertHardCopy', 'off');
for i=1:32
    for j=1:32
        h1 = scatter(i,j,'s','MarkerFaceColor','none','MarkerEdgeColor','k','LineWidth',2); 
    end
end
for k=1:length(pixcell)
   pixinter = pixcell{k};
   if pixinter(3)==1
       h2 = scatter(pixinter(1),pixinter(2),'s','MarkerFaceColor','none','MarkerEdgeColor','b','LineWidth',2); 
   elseif pixinter(3)==0
       h3 = scatter(pixinter(1),pixinter(2),'s','MarkerFaceColor','none','MarkerEdgeColor','m','LineWidth',2); 
   else
       h4 = scatter(pixinter(1),pixinter(2),'s','MarkerFaceColor','none','MarkerEdgeColor','r','LineWidth',2); 
   end
end

ventindx = 6;
ventindy = 21;
cardindx = 19;
cardindy = 12;
olindx = 14;
olindy = 29;

%scatter(ventindy,ventindx,'filled','wO');
%scatter(olindy,olindx,'filled','wO');
%scatter(cardindy,cardindx,'filled','wO');
[nx1 ny1] = ds2nfu(ventindx,ventindy+2);
[nx2 ny2] = ds2nfu(ventindx+3,ventindy+2);
annotation('textarrow',[nx2 nx1],[ny2 ny1],'String','Pixel1','Color','y','FontSize',12,'TextColor','y','FontWeight','bold','LineWidth',1);
[nx3 ny3] = ds2nfu(olindx,olindy);
[nx4 ny4] = ds2nfu(olindx,olindy-4);
annotation('textarrow',[nx3 nx4],[ny3 ny4],'String','Pixel2','Color','y','FontSize',12,'TextColor','y','FontWeight','bold','LineWidth',1);
[nx5 ny5] = ds2nfu(cardindx-1,33-cardindy-4);
[nx6 ny6] = ds2nfu(cardindx-1,33-cardindy-1);
annotation('textarrow',[nx5 nx6],[ny5 ny6],'String','Pixel3','Color','y','FontSize',12,'TextColor','y','FontWeight','bold','LineWidth',1);

hold off;

save(filnam2,'origimgdat');
save(filnam,'pixcell');