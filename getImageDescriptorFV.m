
function attRepr = getImageDescriptorFV(GMM, PCA, descrs,WP)

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% -------------------------------------------------------------------------

% Project into PCA space
%[x_descr,y_descr] = size(descrs);
%[x_wp,y_wp] = size(WP);
%fv = zeros(x_wp,y_descr);
%fprintf('x_size %d,y_size %d\n',x_descr,y_descr);
%fprintf('numpointts %d,dimension %d',y_descr,x_wp);
%xy = descrs(opts.SIFTDIM+1:end,:);
%descrs=bsxfun(@minus, descrs(1:opts.SIFTDIM,:), PCA.mean); if isempty(sifts4Block)
% descrs = descrs{:};
% PCA = PCA{:};
% GMM = GMM{:};
% WP = WP{:};
if isempty(descrs)
    attRepr = zeros(size(WP,1),1,'double');
else
    
    descrs=bsxfun(@minus, descrs, PCA.mean);
    descrs=PCA.eigvec'*descrs;
    
    % [x_descr,y_descr] = size(descrs);
    % fprintf('x_size %d,y_size %d\n',x_descr,y_descr);
    %
    %
    % %descrs = [descrs; xy];
    % [x_descr,y_descr] = size(descrs);
    % fprintf('x_size %d,y_size %d\n',x_descr,y_descr);
    
    % Extracts FV representation using the GMM
    %for i=1:y_descr
    fisher_vector =  vl_fisher(descrs, GMM.mu, GMM.sigma, GMM.we,'Improved');
    
    attRepr = WP*fisher_vector;
    %attRepr = fisher_vector;
end
%tmp = matx*attReprTe;
%attReprTe_emb = 1/sqrt(emb.M) * [ cos(tmp); sin(tmp)];
%attReprTe_emb=bsxfun(@minus, attReprTe_emb, emb.matts);
%attReprTe_emb = emb.Wx(:,1:emb.K)' * attReprTe_emb;
%attReprTe_emb = (bsxfun(@rdivide, attReprTe_emb, sqrt(sum(attReprTe_emb.*attReprTe_emb))));
%fv = fv/1.0e+30;
%[x_fv,y_fv] = size(fv);
%fprintf('x_size %d,y_size %d %d\n',x_fv,y_fv,i);
%end
%[x_fv,y_fv] = size(fv);
%fprintf('x_size %d,y_size %d\n',x_fv,y_fv);
attRepr = single(attRepr);
end


