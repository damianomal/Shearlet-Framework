function subsystem = SLgetSubsystem3D(shearletSystem,subsystemIdxs)
%SLgetSubsystem3D Compute subset of an existing 3D shearlet system.
%
%Usage:
%
% subsystem = SLgetSubsystem3D(shearletSystem)
%
%Input:
%
% shearletSystem: A shearlet system, generated by SLgetShearletSystem3D.
%  subsystemIdxs: A Nx4 array of shearlet indexes, specifying the desired
%                 subset of shearlets. 
%
%Output:
%
%             subsystem: A structure containing the specified subsystem of shearletSystem.
%            .shearlets: A XxYxZxN array of N 3D shearlets in the frequency domain where X, Y and Z   
%                        denote the size of each shearlet. To get the i-th shearlet in the 
%                        time domain, use fftshift(ifftn(ifftshift(subsystem.shearlets(:,:,:,i)))). 
%                        Each Shearlet is centered at floor([X Y Z]/2) + 1.
%                 .size: The size of each shearlet in the system.
%          .shearLevels: The respective input argument is stored here.
%                 .full: The respective input argument is stored here.
%           .nShearlets: Number of shearlets in the
%                        shearletSystem.shearlets array. This number
%                        also describes the redundancy of the system.
%        .shearletdIdxs: A Nx4 array, specifying each shearlet in the system
%                        in the format [cone scale shearing1 shearing2] where N
%                        denotes the number of shearlets. The lowpass shearlet is 
%                        indexed by [0 0 0].
%     .dualFrameWeights: A XxYxZ array containing the absolute and squared sum over all shearlets
%                        stored in shearletSystem.shearlets. These weights
%                        are needed to compute the dual shearlets during reconstruction.
%                   RMS: A 1xnShearlets array containing the root mean
%                        squares (L2-norm divided by sqrt(X*Y*Z)) of all shearlets stored in
%                        shearletSystem.shearlets. These values can be used to normalize 
%                        shearlet coefficients to make them comparable.
%
%Example 1:
%
% %Subsystem consisting only of the first scale of a 2-scaled shearlet system
% shearletSystem = SLgetShearletSystem3D(0,64,64,64,2,[1 1],0,modulate2(dfilters('cd','d'),'c'));
% subIdxs = SLgetShearletIdxs3D(shearletSystem.shearLevels,shearletSystem.full,'scales',1);
% subsystem = SLgetSubsystem3D(shearletSystem,subIdxs);
%
%Example 2:
%
% %Subsystem consisting only of of all shearlets sheared once (type 1) on the first pyramid. 
% shearletSystem = SLgetShearletSystem3D(0,64,64,64,2,[1 1],1,modulate2(dfilters('cd','d'),'c'));
% subIdxs = SLgetShearletIdxs3D(shearletSystem.shearLevels,shearletSystem.full,'pyramids',1,'shearings1',1);
% subsystem = SLgetSubsystem3D(shearletSystem,subIdxs);
%
%See also: SLgetShearletSystem3D, SLgetShearletIdxs3D

    %% check input arguments
    if nargin < 1
        error('Too few input arguments!');
    end;
    
    help = ismember(shearletSystem.shearletIdxs,subsystemIdxs,'rows');    
    subsystem = struct('shearlets',shearletSystem.shearlets(:,:,:,help),'size',shearletSystem.size,'shearLevels',shearletSystem.shearLevels,'full',shearletSystem.full,'nShearlets',sum(help),'shearletIdxs',shearletSystem.shearletIdxs(help,:),'dualFrameWeights',shearletSystem.dualFrameWeights,'RMS',shearletSystem.RMS(help),'useGPU',shearletSystem.useGPU);
end

%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material