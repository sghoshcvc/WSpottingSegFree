function out = integralImageCell(a,numrow,numcol)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%a = a{:};
a = reshape(a,numrow,numcol);
%pad up with initial zero row column %
a = integralImage(a);
out = reshape(a,1,[]);

end

