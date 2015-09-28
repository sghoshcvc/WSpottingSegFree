function [featSize,numBlockX,numBlockY,fv_Rep] = img2attr(opts, im,PCA,GMM,W )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
%if ~isdeployed()
% addpath('util');
% addpath('util/io');
% end
% 
if ~exist('util/vlfeat-0.9.18/toolbox/mex','dir')
    if isunix
        cd 'util/vlfeat-0.9.18/';
        mexloc = fullfile(matlabroot,'bin/mex');
        % This is necessary to include support to OpenMP in Mavericks+XCode5
        % gcc4.2 can be installed from MacPorts
        %if strcmpi(computer,'MACI64')
        %   system(sprintf('make MEX=%s CC=/opt/local/bin/gcc-apple-4.2',mexloc));
        %else
        system(sprintf('make MEX=%s',mexloc));
        %end
        cd ../..;
    else
        run('util/vlfeat-0.9.18/toolbox/vl_compile');
    end
end


run('util/vlfeat-0.9.18/toolbox/vl_setup')
% pathModel = 'model';


%load(fullfile(pathModel,'opts.mat'));
pathModels = 'modelGW/';

[Ht,Wd] = size(im);
im = im2single(im);
        
        %bytesPerImage = 12 + (numBlockX+1)*(numBlockY+1)*size(W,2)*4;% Two bytes for image header (rows, cols) plus one byte for feature dimension plus (numBlockX+1* NumBlockY+1) elements per dimension of attributes as 4 byte single floating point
    
    
    %posAtI = 4 + length(bytesPerImage)* 8 + [ 0 cumsum(double(bytesPerImage))]; % Numer of images + lookup (8 byte integers) + accumulated sizes
   % posAtI = int64(posAtI(1:end-1));
    fileAttributes = fullfile(pathModels,sprintf('fileAttributes.bin'));

    fid = fopen(fileAttributes, 'a');
    %fwrite(fid, int32(length(bytesPerImage)), 'int32');
    %fwrite(fid, posAtI, 'int64');
    
     [frames, descrs] = vl_phow(im, opts.phowOpts{:}) ;
        descrs = descrs / 255;
        
        [descrs,frames] = normalizeSift(opts,descrs,frames);
        %fv_full = getImageDescriptorFV(GMM, PCA, descrs,W');
        numPoints= size(descrs,2);
        % feats = zeros(opts.FVdim,y_descr,'single');
        % group sifts according to block
        numBlockY = ceil(Ht/opts.BlockSize);
        numBlockX = ceil(Wd/opts.BlockSize);
        Blocks = cell(numBlockY,numBlockX);
        %Blockseach = cell(numBlockX,numBlockY);
       % ImageIntNorm = zeros(numBlockX,numBlockY);
        for j=1:numPoints
            Y = ceil(frames(1,j)/opts.BlockSize);
            X = ceil(frames(2,j)/opts.BlockSize);
            % fprintf('X =%d,Y= %d\n',X,Y);
            P = cell2mat(Blocks(X,Y));
            Blocks(X,Y) = {cat(2,P,descrs(:,j))};
        end
        %Blocks = reshape(Blocks,1,numBlockX*numBlockY);
        %Blocks_all = Blocks;
        %creating the arguments to call cellfun
        GMM_Rep =repmat({GMM},numBlockY,numBlockX);
        PCA_Rep = repmat({PCA},numBlockY,numBlockX);
        W_Rep = repmat({W'},numBlockY,numBlockX);
        fv = @getImageDescriptorFV;
        fv_Rep = cellfun(fv,GMM_Rep,PCA_Rep,Blocks,W_Rep,'uniformOutput', false);
        fv_Rep = reshape(fv_Rep,1,[]);
        fv_Rep = cell2mat(fv_Rep);
        fv_Rep = mat2cell(fv_Rep,ones(1,size(fv_Rep,1)));
        numBlockXRep = repmat({numBlockX},size(fv_Rep,1),1);
        numBlockYRep = repmat({numBlockY},size(fv_Rep,1),1);
        intImage = @integralImageCell;
        fv_Rep = cellfun(intImage,fv_Rep,numBlockYRep,numBlockXRep,'uniformOutput', false);
        fv_Rep = cell2mat(fv_Rep);
        fwrite(fid, int32(numBlockX+1),'int32');
        fwrite(fid, int32(numBlockY+1), 'int32');
        fwrite(fid, int32(size(W,2)), 'int32');
        fwrite(fid,single(fv_Rep),'single');
        featSize = int32(size(W,2));
        fclose(fid);

end

