function [ hist ] = hvalue( hry )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
global aa;
aa = 0;
% if a ~= 0
    for i = 1:13
    if hry{1,i}>aa
    aa = hry{1,i};
    end
    end
    
% end
hist=aa;
end

