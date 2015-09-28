function  compute_attribute_docs(opts)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%docs = dir([opts.pathDoc '*.jpg']);
%load([opts.pathDoc 'ICDAR03_testdata.mat']);
%load([opts.pathDoc 'ICDAR03_wordsGT.mat']);
PCA = readPCA(fullfile(opts.pathModel,'PCA.bin'));
GMM = readGMM(fullfile(opts.pathModel,'GMM.bin'));
attModels = readMat(fullfile(opts.pathModel,'attModels.bin'));
W = attModels(1:end-1,:);
doc = dir([opts.pathDoc '*.tif']);
% for i=1:length(test)
%    nameDoc =test(i).name;
%   
%    nameDoc =strrep(nameDoc(16:end),'/','_');
%    %nameDoc = nameDoc(idxs(1)+1:end);
%    %nameDoc =lower( nameDoc(1:end-4));
%    if isKey(classes, nameDoc(1:end-4))
%        test(i).idDoc = classes(nameDoc(1:end-4));
%                
%    end
% end
% imids =[test.idDoc];
% [imid_sorted,indx]=sort(imids);
% doc = [test(indx)];
%doc = {file.name};
   
   
for i=1:length(doc)
    im = imread([opts.pathDoc doc(i).name]);
    [Ht,Wd,~] = size(im);
    %ht_all(i) =Ht;
    %Wd_all(i)=Wd;
    numBlockY = ceil(Ht/opts.BlockSize);
        numBlockX = ceil(Wd/opts.BlockSize);
    bytesPerImage(i) = 12 + (numBlockX+1)*(numBlockY+1)*size(W,2)*4;% Two bytes for image header (rows, cols) plus one byte for feature dimension plus (numBlockX+1* NumBlockY+1) elements per dimension of attributes as 4 byte single floating point
    
    
   
end
 posAtI = 4 + length(bytesPerImage)* 8 + [ 0 cumsum(double(bytesPerImage))]; % Numer of images + lookup (8 byte integers) + accumulated sizes
    posAtI = int64(posAtI(1:end-1));
fileAttributes = fullfile(opts.pathModel,sprintf('fileAttributes.bin'));

    fid = fopen(fileAttributes, 'w');
    fwrite(fid, int32(length(bytesPerImage)), 'int32');
    fwrite(fid, posAtI, 'int64');
    fclose(fid);
for i=1:length(doc)
   tic ;
im = imread([opts.pathDoc doc(i).name]);
if ndims(im)>2
im = rgb2gray(im);
end
img2attr(opts,im,PCA,GMM,W);
t =toc;
fprintf('integral attribute for image %d calculated in time %.0f seconds\n',i,t);
end

end

