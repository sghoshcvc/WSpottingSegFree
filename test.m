addpath('util');
addpath('util/io');
%% load parameters
pathModels = 'modelGW/';
load([pathModels 'opts.mat']);
data = load_dataset(opts);
%used for dividing into train andd test
data = prepare_data_learning(opts,data);

PCA = readPCA(fullfile(pathModels,'PCA.bin'));
GMM = readGMM(fullfile(pathModels,'GMM.bin'));
attModels = readMat(fullfile(pathModels,'attModels.bin'));
W = attModels(1:end-1,:);

fileAttRepresTe = [pathModels 'attRepresTe.bin'];
fileAttributes = [pathModels 'fileAttributes.bin'];
%if  ~exist(fileAttRepresTe)
    opts.BlockSize =16;
%else
attReprTe = readMat(fileAttRepresTe);
%end
data.attReprTe = single(attReprTe);
%data.phocsTe = single(data.phocsTe);
data.wordClsTe = single(data.wordClsTe);
embeddingFile =fullfile(pathModels,'CCA.bin');
embedding = readCCA(embeddingFile);
   %embedding = embedding.cca;
    attReprTeQuery = bsxfun(@rdivide, attReprTe,sqrt(sum(attReprTe.*attReprTe)));
        attReprTeQuery(isnan(attReprTeQuery)) = 0;
    
        attReprTeQuery =  bsxfun(@minus, attReprTeQuery,embedding.matts);
    
    % Embed  test
        attReprTeQuery = embedding.Wx(:,1:embedding.K)' * attReprTeQuery; 
        %featQuery =  bsxfun(@minus, attRepr,embedding.mphocs);

im = imread('/home/sgnosh/watts/datasets/GW/images/2700270.tif');
im = im(155:253,100:271);
im = im2single(im);

img2attr(opts, im,PCA,GMM,W );







        
        