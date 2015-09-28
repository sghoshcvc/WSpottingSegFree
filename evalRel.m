function [result,overlap] = evalRel(resLoc,relDoc,areaP,ov)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%if ~isempty(relDoc)
result = zeros(length(resLoc),1);

    relBoxes = [relDoc(:,1) relDoc(:,3) relDoc(:,2)-relDoc(:,1)+1 relDoc(:,4)-relDoc(:,3)+1];
        predBoxes = [resLoc(:,1) resLoc(:,2) resLoc(:,3)-resLoc(:,1)+1 resLoc(:,4)-resLoc(:,2)+1];
    
        intArea = rectint(single(predBoxes), single(relBoxes));
    
        %areaP = model.newH * model.newW;
        areaGt = relBoxes(:,3).*relBoxes(:,4);
    
        denom = bsxfun(@minus, single(areaP+areaGt'), intArea);
        overlap = intArea./denom;
    
        [y,x] = find(overlap >= ov);
        [U, PosY, PosX] = unique(x,'first');
        result(y(PosY))=1;
        overlap = max(overlap,[],2);


end

