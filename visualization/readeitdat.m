%bin file data structure
%1double+1float+1024float(EIT data)+1int+1int+30char+1int+52float
%8 + 4 + 1024*4 + 2 + 2 + 30 + 2 + 52*4
%each frame 4358 bytes, frame rate:50f/s
function [ eit_imgdat,GIval ] = readeitdat(eit_filname)
eitfid = fopen(eit_filname,'rb');
eit_imgdat = cell(0);
GIval = [];

curframe = 0;

while ~feof(eitfid)
    fseek(eitfid,curframe*4358,'bof');
    fseek(eitfid,12,'cof'); %offset:bytes, next byte is the wanted data
    curdat = fread(eitfid,1024,'float32');
    eit_imgdat(curframe+1) = {curdat};
    %img = imagesc(imrotate(reshape(curdat,32,32),90));       %rot90(matrix),
    %flipdim(img',1),fliplr                  colorbar
    curframe = curframe+1;
    GIval = [GIval sum(curdat)];
end

end