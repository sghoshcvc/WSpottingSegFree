function [descrs_normalized,frames_normalized] = normalizeSift(opts,descrs,frames)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% -------------------------------------------------------------------------
descrs_normalized = descrs;

%xy = descrs_normalized(opts.SIFTDIM+1:end,:);
%descrs_normalized = descrs_normalized(1:opts.SIFTDIM,:);

% Remove empty ones
idx = find(sum(descrs_normalized)==0);
descrs_normalized(:,idx)=[];
if nargin < 3
    frames_normalized = [];
else
    frames_normalized = frames;
    frames_normalized(:,idx) = [];
end

% Square root:
descrs_normalized = sqrt(descrs_normalized);

% 1/4 norm
X = sum(descrs_normalized.*descrs_normalized).^-0.25;
descrs_normalized = bsxfun(@times, descrs_normalized,X);

%xy(:,idx) = [];
%descrs_normalized = [descrs_normalized; xy];

descrs_normalized(isnan(descrs_normalized))=0;
end


