function [eitimg eitgi] = geneitmat(filenam,genfile)
load(filenam);

eitdat = ImpImgData;
framenum = size(eitdat,2);

eitimg = cell(0);
eitgi = [];

for i=1:framenum
   eitimg(i) = {eitdat(:,i)};
   eitgi = [eitgi sum(eitdat(:,i))];
end

%save(genfile,'eitimg');
end