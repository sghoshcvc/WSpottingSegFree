function [ feat,featDim,numBlockX,numBlockY ] = readDescriptor( fid,toc,i )
%SAVEIMAGES Summary of this function goes here
%   Detailed explanation goes here

fseek(fid, toc(i), 'bof');
numBlockX=fread(fid, 1, 'int32');
numBlockY=fread(fid, 1,'int32');
featDim = fread(fid, 1,'int32');
feat = fread(fid,[featDim,numBlockY*numBlockX],'single');

%image = fread(fid, [D,N], '*uint8');
%fwrite(fid, int32(numBlockX+1),'int32');
 %       fwrite(fid, int32(numBlockY+1), 'int32');
  %      fwrite(fid, int32(size(W,2)), 'int32')
       % fwrite(fid,single(fv_Rep),'single');

end


