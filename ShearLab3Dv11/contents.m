% Contents 
%
%
% 2D: With the methods in this folder, you can
%       - construct different 2D shearlet systems
%       - compute 2D shearlet transforms
%       - compute 2D shearlet reconstructions
%
% 3D: With the methods in this folder, you can
%       - construct different 3D shearlet systems
%       - compute 3D shearlet transforms
%       - compute 3D shearlet reconstructions
%
% Complex: With the methods in this folder, you can
%       - construct 2D complex shearlet system
%       - compute 2D complex shearlet transforms
%       - compute 2D complex shearlet reconstructions
%
% Data: This folder contains the images and videos used in the sample
% scripts.
%
% Examples: This folder contains several sample scripts that should give
% you a good understanding of how to use ShearLab 3D.
%
% Quick: This folder contains a simple method for doing the shearlet
% transform, hard thresholding and the reconstruction in just one step for
% 2D and 3D data.
%
% Util: This folder contains all methods used in ShearLab3D that are of
% little use on their own.
%
% The methods
%
% - dfilters 
% - dmaxflat
% - mctrans
% - modulate2
%
% were taken from the Nonsubsampled Contourlet Toolbox [1] which can be downloaded from
% http://www.mathworks.de/matlabcentral/fileexchange/10049-nonsubsampled-contourlet-toolbox.
%
% The methods
%
% - MakeONFilter
% - MirrorFilt
%
% were taken from WaveLab850 (http://www-stat.stanford.edu/~wavelab/).
%
%
% UtilCUDA: This folder contains one CUDA-Kernel needed for the construction of
% 3D shearlets.
%
%
% Changes in version 1.01
%
% - SLgetWedgeBandpassAndLowpassFilters2D: 2D directional filters don't
%   have to be equally sized anymore. 
%
% Changes in version 1.1
%
% - Fixed references to Nonsubsampled Contourlet Toolbox and WaveLab850
% - Replaced dyadup with SLupsample
% - Removed dependencies on Signal Processing Toolbox and Image Processing Toolbox 
% - Added Complex Shearlet Transform
% - Automatic reselection of filters if data is too small for specified shearlet system
%
%
%
% For more details, see: "ShearLab 3D: Faithful Digital Shearlet Transforms based on Compactly Supported Shearlets"
%
%
% [1] A. L. da Cunha, J. Zhou, M. N. Do, "The Nonsubsampled Contourlet Transform: Theory, Design, and Applications," IEEE Transactions on Image Processing, 2005.
%