function [shearlets,RMS,dualFrameWeights] = SLgetShearlets3D(preparedFilters,shearletIdxs)
%SLgetShearlets3D Compute 3D shearlets in the frequency domain.
%
%Usage: 
%
% [shearlets, RMS, dualFrameWeights] = SLgetShearlets3D(preparedFilters)
% [shearlets, RMS, dualFrameWeights] = SLgetShearlets3D(preparedFilters, shearletIdxs)
%
%Input:
% 
% preparedFilters: A structure containing filters that can be used to compute 3D shearlets.
%                  Such filters can be generated with SLprepareFilters3D.
%   shearletdIdxs: A Nx4 array, specifying each shearlet that is to be
%                  computed in the format [cone scale shearing1 shearing2] where N
%                  denotes the number of shearlets. The three pyramids are
%                  indexed by 1, 2 and 3. Note that the values for scale and shearings are limited by 
%                  the precomputed filters. The lowpass shearlet is indexed by 
%                  [0 0 0 0]. If no shearlet indexes are specified, SLgetShearlets3D 
%                  returns a standard shearlet system based on the precomputed filters.
%                  Such a standard index set can also be obtained by
%                  calling SLgetShearletIdxs3D.
%
%Output:
%
%         shearlets: A XxYxZxN array of N 3D shearlets in the frequency domain where X, Y and Z   
%                    denote the size of each shearlet.
%               RMS: A 1xnShearlets array containing the root mean
%                    squares (L2-norm divided by sqrt(X*Y*Z)) of all shearlets stored in
%                    shearlets. These values can be used to normalize 
%                    shearlet coefficients to make them comparable.
%  dualFrameWeights: A XxYxZ matrix containing the absolute and squared sum over all shearlets
%                    stored in shearlets. These weights are needed to compute the dual shearlets during reconstruction.
%
%Description:
%
% The 2D shearlets in preparedFilters are used to compute
% shearlets on different scales and of different shearings, as specified by
% the shearletIdxs array. Shearlets are computed in the frequency domain.
% To get the i-th shearlet in the time domain, use
% fftshift(ifftn(ifftshift(shearlets(:,:,:,i)))).
%
% Each Shearlet is centered at floor([X Y Z]/2) + 1.
%
%Example 1:
% 
% %compute the lowpass shearlet
% preparedFilters = SLprepareFilters3D(128,128,128,2);
% lowpassShearlet = SLgetShearlets3D(preparedFilters,[0 0 0 0]);
% lowpassShearletTimeDomain = fftshift(ifftn(ifftshift(lowpassShearlet)));
%
%Example 2:
%
% %compute a standard shearlet system of one scale
% preparedFilters = SLprepareFilters3D(128,128,128,1);
% shearlets = SLgetShearlets3D(preparedFilters);
%
%Example 3:
%
% %compute a full shearlet system of one scale
% preparedFilters = SLprepareFilters3D(128,128,128,1);
% shearlets = SLgetShearlets3D(preparedFilters,SLgetShearletIdxs3D(preparedFilters.shearLevels,1));
%
%See also: SLprepareFilters3D, SLgetShearletIdxs3D, SLsheardec3D,
%          SLshearrec3D


%% check input arguments
    if nargin < 1
        error('Too few input arguments!');
    end;
    if nargin < 2
        shearletIdxs = SLgetShearletIdxs3D(preparedFilters.shearLevels);
    end;
    ndim1 = preparedFilters.size(1);
    ndim2 = preparedFilters.size(2);
    ndim3 = preparedFilters.size(3);
    
    nShearlets = size(shearletIdxs,1);

    useGPU = preparedFilters.useGPU;
    if useGPU
        if verLessThan('distcomp','6.1')
            shearlets = complex(parallel.gpu.GPUArray.zeros(ndim1, ndim2, ndim3, nShearlets));
            shearletAbsSqrd = parallel.gpu.GPUArray.zeros(ndim1,ndim2,ndim3);
            if nargout > 1
                RMS = parallel.gpu.GPUArray.zeros(1,nShearlets);
                if nargout > 2
                    dualFrameWeights = parallel.gpu.GPUArray.zeros(ndim1,ndim2,ndim3);
                end
            end
        else
            shearlets = complex(gpuArray.zeros(ndim1, ndim2, ndim3, nShearlets));
            shearletAbsSqrd = gpuArray.zeros(ndim1,ndim2,ndim3);
            if nargout > 1
                RMS = gpuArray.zeros(1,nShearlets);
                if nargout > 2
                    dualFrameWeights = gpuArray.zeros(ndim1,ndim2,ndim3);
                end
            end
        end
                
        kGetShearlet3D =  parallel.gpu.CUDAKernel('SLgetShearlet3DCUDA.ptx','SLgetShearlet3DCUDA.cu');
        kGetShearlet3D.GridSize = [ndim1 ndim2];
        kGetShearlet3D.ThreadBlockSize = [ndim3 1 1];
    else
        shearletAbsSqrd = zeros(ndim1,ndim2,ndim3);
        shearlets = complex(zeros(ndim1, ndim2, ndim3, nShearlets));        
        if nargout > 1
            RMS = zeros(1,nShearlets);
            if nargout > 2
                dualFrameWeights = zeros(ndim1,ndim2,ndim3);
            end
        end
    end
    for j = 1:nShearlets
        pyramid = shearletIdxs(j,1);
        scale = shearletIdxs(j,2);
        shearing1 = shearletIdxs(j,3);
        shearing2 = shearletIdxs(j,4);
        
        if pyramid == 0 
            if useGPU
                [shearlets(:,:,:,j), shearletAbsSqrd] = feval(kGetShearlet3D,shearlets(:,:,:,j),shearletAbsSqrd,pyramid,preparedFilters.d1d2(:,:,end),preparedFilters.d3d2(:,:,end));
            else
                shearlet1 = preparedFilters.d1d2(:,:,end);
                shearlet2 = preparedFilters.d3d2(:,:,end);            
                for k = 1:ndim2
                    shearlets(:,k,:,j) = shearlet1(:,k)*permute(shearlet2(:,k),[2 1]);
                end
            end
        elseif pyramid == 1
            if useGPU
                [shearlets(:,:,:,j), shearletAbsSqrd] = feval(kGetShearlet3D,shearlets(:,:,:,j),shearletAbsSqrd,pyramid,preparedFilters.d1d2(:,:,SLgetShearletPosFromIdxs(preparedFilters.shearLevels,1,scale,shearing1)),preparedFilters.d3d2(:,:,SLgetShearletPosFromIdxs(preparedFilters.shearLevels,1,scale,shearing2)));
            else
                shearlet1 = preparedFilters.d1d2(:,:,SLgetShearletPosFromIdxs(preparedFilters.shearLevels,1,scale,shearing1));
                shearlet2 = preparedFilters.d3d2(:,:,SLgetShearletPosFromIdxs(preparedFilters.shearLevels,1,scale,shearing2));

                for k = 1:ndim2
                    shearlets(:,k,:,j) = shearlet1(:,k)*permute(shearlet2(:,k),[2 1]);
                end
            end
        elseif pyramid == 2
            if useGPU
                [shearlets(:,:,:,j), shearletAbsSqrd] = feval(kGetShearlet3D,shearlets(:,:,:,j),shearletAbsSqrd,pyramid,preparedFilters.d1d3(:,:,SLgetShearletPosFromIdxs(preparedFilters.shearLevels,1,scale,shearing1)),preparedFilters.d3d2(:,:,SLgetShearletPosFromIdxs(preparedFilters.shearLevels,2,scale,shearing2)));
            else
                shearlet1 = preparedFilters.d1d3(:,:,SLgetShearletPosFromIdxs(preparedFilters.shearLevels,1,scale,shearing1));
                shearlet2 = preparedFilters.d3d2(:,:,SLgetShearletPosFromIdxs(preparedFilters.shearLevels,2,scale,shearing2));
                for k = 1:ndim3
                    shearlets(:,:,k,j) = shearlet1(:,k)*shearlet2(k,:);
                end
            end
        else
            if useGPU
                [shearlets(:,:,:,j), shearletAbsSqrd] = feval(kGetShearlet3D,shearlets(:,:,:,j),shearletAbsSqrd,pyramid,preparedFilters.d1d2(:,:,SLgetShearletPosFromIdxs(preparedFilters.shearLevels,2,scale,shearing1)),preparedFilters.d1d3(:,:,SLgetShearletPosFromIdxs(preparedFilters.shearLevels,2,scale,shearing2)));
            else
                shearlet1 = preparedFilters.d1d2(:,:,SLgetShearletPosFromIdxs(preparedFilters.shearLevels,2,scale,shearing1));
                shearlet2 = preparedFilters.d1d3(:,:,SLgetShearletPosFromIdxs(preparedFilters.shearLevels,2,scale,shearing2));           

                for k = 1:ndim1
                    shearlets(k,:,:,j) = permute(shearlet1(k,:),[2 1])*shearlet2(k,:);
                end
            end
        end
        if nargout > 1
            if useGPU == 0
                shearletAbsSqrd = abs(shearlets(:,:,:,j)).^2;
            end           
            RMS(j) = sqrt(sum(shearletAbsSqrd(:))/(ndim1*ndim2*ndim3));
            if nargout > 2
                dualFrameWeights = dualFrameWeights + shearletAbsSqrd;
            end
        end
    end
end

    
function pos = SLgetShearletPosFromIdxs(shearLevels,cone,scale,shearing)
    pos = 1+sum(2.^(shearLevels+1) + 1)*(cone-1) + shearing + 2^shearLevels(scale);
    if scale > 1        
        pos = pos + sum(2.^(shearLevels(1:(scale-1))+1)+1);
    end;
end
%
%  Copyright (c) 2014. Rafael Reisenhofer
%
%  Part of ShearLab3D v1.1
%  Built Mon, 10/11/2014
%  This is Copyrighted Material

