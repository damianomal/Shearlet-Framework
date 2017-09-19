function snr = SLcomputeSNR( X,Xnoisy )
%SLCOMPUTESNR Summary of this function goes here
%   Detailed explanation goes here
snr = 10*log10(sum(sum(sum(X.^2)))/sum(sum(sum((X-Xnoisy).^2))));
if isnan(snr)
    snr = Inf;
end
end

%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material
