function I = localMax(sig)

% function I = localMax(sig)
% function outputs local maxima of a time series

if size(sig,1) == 1
    sig = sig';
end


A = diff(sign(diff([0;sig;0])));

I = find(A == -2);