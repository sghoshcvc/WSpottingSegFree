function  feats  = Cal_feat_window( winIndx,ImageIntraw,ImageNorm)
%Calculate feature vector for the sliding windows 
%Input winInx eacsh row of winIndx is a sliding window of
%format(start_row,start_col,end_row,end_col)
%Imageintraw is a integral image of feature vectors for each point or block
%   

% checking boundary conditions
winIndx = [max(winIndx(:,1),1) max(winIndx(:,2),1) min(winIndx(:,3),size(ImageNorm,1)-1) min(winIndx(:,4),size(ImageNorm,2)-1)];
winIndx = [winIndx(:,1)+1,winIndx(:,2)+1,winIndx(:,3)+1,winIndx(:,4)+1];
%modAttr = cell(size(Imageintraw,1 )+1,size(Imageintraw,2) +1);
%ImageNormRaw = zeros(size(Imageintraw,1 )+1,size(Imageintraw,2) +1);
ndim = size(ImageIntraw,1);
%modAttr(1,:) = {zeros(ndim)};
%modAttr(:,1) = {zeros(ndim)};
%ImageNormRaw(1,:) = 0;
%ImageNormRaw(:,1) =0;
%[modAttr{2:end,2:end}] = Imageintraw{:};
%ImageNormRaw(2:end,2:end) = ImageNorm(:,:);
ind1 = sub2ind(size(ImageNorm),winIndx(:,3),winIndx(:,4));
ind2 = sub2ind(size(ImageNorm),winIndx(:,1)-1,winIndx(:,4));
ind3 = sub2ind(size(ImageNorm),winIndx(:,3),winIndx(:,2)-1);
ind4 = sub2ind(size(ImageNorm),winIndx(:,1)-1,winIndx(:,2)-1);
%  X11 = cell2mat(ImageIntraw(winIndx());
%     X22 =  cell2mat(ImageIntraw(j-1,k+slWindowWd-1));
%     X33 = cell2mat(ImageIntraw(j+slWindowHt-1,k-1));
%     X44 =  cell2mat(ImageIntraw(j-1,k-1));

feats = ImageIntraw(:,ind1)+ImageIntraw(:,ind4)-ImageIntraw(:,ind2)-ImageIntraw(:,ind3);
%Normalizing the feature vector 
%  N = sqrt(sum(feats.^2,1));
 % N =repmat(N,1,ndim);
 % feats = feats./N;
%  norm_l2 = power((ImageNormRaw(ind1)),2)+power((ImageNormRaw(ind2)),2)+power((ImageNormRaw(ind3)),2)+power((ImageNormRaw(ind4)),2);
%  
%  norm_l2 = norm_l2  +2 * ( sum((ImageIntraw(ind1) .* cell2mat(modAttr(ind4))),2)+ sum(cell2mat(modAttr(ind2)) .* cell2mat(modAttr(ind3)),2) ) ;
% norm_l2 = norm_l2 -2*( sum(cell2mat(modAttr(ind1)) .* cell2mat(modAttr(ind2)),2) + sum(cell2mat(modAttr(ind1)) .* cell2mat(modAttr(ind3)),2) + sum(cell2mat(modAttr(ind4)) .* cell2mat(modAttr(ind2)),2)+ sum(cell2mat(modAttr(ind4)) .* cell2mat(modAttr(ind3)),2) );
% norm_l2 = repmat(norm_l2,ndim);
% feats = feats./sqrt(norm_l2);
end

