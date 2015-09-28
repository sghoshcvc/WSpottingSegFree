function [winIndx,loc] = genWindows(start_row,start_col,end_row,end_col,slWindowHt,slWindowWd,BlockSize)
%This function generate all possible sliding windows :
%input BB (dimension of the boundix box where sliding window will be
%performed)
%BB(:) = [start-row,start-col,end-row,end-col]
%     for entire matrix(image)
%     make BB =[1,1,height,width]
%      slWindowHt,slWindowWd respectively height and width of sliding
%      window
    %output (start_row,Start_col,End_row,End_col) of sliding window
    BB= [start_row,start_col,end_row,end_col];
sl_h = BB(3)-slWindowHt+1;
sl_w = BB(4)-slWindowWd+1;
rowStart = sort(repmat([BB(1):sl_h]',(sl_w-BB(2)+1),1));
colStart = repmat([BB(2):sl_w]',(sl_h-BB(1)+1),1);
slwindowRep = repmat([slWindowHt,slWindowWd],(sl_h-BB(1)+1)*(sl_w-BB(2)+1),1);
% added +1 to each point to make the calculation easy
winIndx = [rowStart,colStart,slwindowRep(:,1)+rowStart-1,slwindowRep(:,2)+colStart-1];
loc = [(winIndx(:,2)-1)*BlockSize+1,(winIndx(:,1)-1)*BlockSize+1,winIndx(:,4)*BlockSize,winIndx(:,3)*BlockSize];

