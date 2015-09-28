addpath('util');
addpath('util/io');
%% load parameters
pathModels = 'modelGW/';
load([pathModels 'opts.mat']);
data = load_dataset(opts);
relDoc = getRelDocs(data);
%used for dividing into train andd test
data = prepare_data_learning(opts,data);
%% read data Queries
%fileFeatures = [pathModels 'attRepresTe.bin'];
 if ~exist('features','var');
        features = readMat([pathModels 'featureTe.bin']);
 end
 attModels = readMat([pathModels 'attModels.bin']);
 W = attModels(1:end-1,:);
 attReprTeQuery = W' * features; %W'*feats_te;
fileAttributes = [pathModels 'fileAttributes.bin'];
%if  ~exist(fileAttRepresTe)
    BlockSize =16;
    overlap = 0.5;
%else
%attReprTe = readMat(fileAttRepresTe);
%end
%data.attReprTeQuery = single(attReprTe);
%data.phocsTe = single(data.phocsTe);
%data.wordClsTe = single(data.wordClsTe);
embeddingFile =fullfile(pathModels,'CCA.bin');
embedding = readCCA(embeddingFile);
   %embedding = embedding.cca;
    attReprTeQuery = bsxfun(@rdivide, attReprTeQuery,sqrt(sum(attReprTeQuery.*attReprTeQuery)));
        attReprTeQuery(isnan(attReprTeQuery)) = 0;
    
        attReprTeQuery =  bsxfun(@minus, attReprTeQuery,embedding.matts);    
    % Embed  test
        attReprTeQuery = embedding.Wx(:,1:embedding.K)' * attReprTeQuery; 
        %featQuery =  bsxfun(@minus, attRepr,embedding.mphocs);
        attReprTeQuery = bsxfun(@rdivide, attReprTeQuery,sqrt(sum(attReprTeQuery.*attReprTeQuery)));
        attReprTeQuery(isnan(attReprTeQuery)) = 0;
        numBlockX = ceil([data.words.W]/BlockSize);
        numBlockY = ceil([data.words.H]/BlockSize);
        matts = embedding.matts;
        Wx = embedding.Wx(:,1:embedding.K)';
        %Wx(:,1:K)
        %K = embedding.K;
        locW = [data.words(:).loc];
        locW = reshape(locW',4,[])';
        classQuery = [data.words(:).class];
   tic;
for i=1:lengtha(data.words)
    
        tocontent = readDescriptorToc(fileAttributes);
        resS =[];
        resLoc=[];
        result =[];
        overlapRes =[];
        areaP = numBlockX(i) *numBlockY(i) *256;
       % classQuery = data.words(i).class;
       % relDocQuery = relDoc{i,:};
    parfor page =1:length(tocontent)
        %page
        %relDocSingle = relDocQuery(page);
    %% read Integral attributes for each page
        fid = fopen(fileAttributes, 'r');
        [featDoc,dim,wd,ht] =readDescriptor(fid,tocontent,page);
        fclose(fid);
             
    %% generate candidate windows
        [winSeg,locSeg] =genWindows(1,1,ht,wd,numBlockY(i),numBlockX(i),16);
        %if ~isempty(attrMat)
            attrNorm = zeros(ht,wd,'single');%[];%readAttributes( fidNorm,attrToc,indx );
        
%% compute score 
            feats =Cal_feat_window(winSeg,featDoc,attrNorm);
       % end
             %loc = []
        % evaluate get a 604 dim descriptor for each
        
        attRepr = bsxfun(@rdivide, feats,sqrt(sum(feats.*feats)));
        attRepr(isnan(attRepr)) = 0;
    
        attRepr =  bsxfun(@minus, attRepr,matts);
    
    % Embed  test
        attRepr = Wx * attRepr;
    
    % L2 normalize (critical)
        attRepr = (bsxfun(@rdivide, attRepr, sqrt(sum(attRepr.*attRepr))));
        relLoc = locW(relDoc{classQuery(i),page},:);
        relLoc = reshape(relLoc',4,[])';
       
         s = attReprTeQuery(:,i)'*attRepr;
    [s2,I2] = sort(s);
    %loc = 
    I2 = I2(end-2000:end);
    
    pick = nms_C(int32(I2)',int32(locSeg)',0.3);
    resS = [resS ;s(pick)'];
    resLoc = [resLoc; [locSeg(pick,:) repmat(page,length(pick),1)]];
    if ~isempty(relLoc)
        [tempRes, tempOv] =evalRel(locSeg(pick,:),relLoc,areaP,overlap);
        result = [result ;tempRes];
        overlapRes =[overlapRes;tempOv];
            
    else
        result =[result; zeros(length(pick),1)];
        overlapRes =[overlapRes; zeros(length(pick),1)];
    end
    end
    %% 
    %toc;
    [fScore{i},fIndex] = sort(resS,'descend');
    fresult{i} = [result(fIndex) overlapRes(fIndex)];
    fresLoc{i} = resLoc(fIndex,:);
    map(i)=compute_mAP(result(fIndex),length([relDoc{classQuery(i),:}]));
    
    fprintf('mAP for word %d %f\n',i,map(i));
    
    %resLoc =
end
toc;
 

