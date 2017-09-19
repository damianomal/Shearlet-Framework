function [mat, norm_mat] =  shearlet_compare_vocabulary( vocab_1, vocab_2, show, normalize)
%SHEARLET_COMPARE_VOCABULARY Summary of this function goes here
%   Detailed explanation goes here

% close all;

if(nargin < 3)
    show = true;
end

if(nargin < 4)
    normalize = true;
end

v1 = vocab_1;
v2 = vocab_2;

if(normalize)
    v1 = shearlet_normalize_vocabulary(v1);
    v2 = shearlet_normalize_vocabulary(v2);
end

% MAGNIFYING = 100;
% v1 = v1 * MAGNIFYING;
% v2 = v2 * MAGNIFYING;


mat = zeros(size(vocab_1,1), size(vocab_2,1));

for i=1:size(v1,1)
    for j=1:size(v2,1)
        mat(i,j) = sqrt(sum( (v1(i,:)-v2(j,:)).^2 ));
        %         mat(i,j) = xcorr(v1(i,:),v2(j,:), 0, 'coeff');
    end
end

norm_mat = (max(mat(:)) - mat) ./ max(mat(:));

if(show)
    
    figure('Name', 'Similarity Matrix', 'Position', [25 -13 681 372]);
    imshow(norm_mat, [], 'InitialMagnification', 1000);
    
    colorbar;
    
    [~, mi] = max(norm_mat,[],2);
    
    hold on;
    plot(mi, 1:size(v1,1), 'ro');
    hold off;
    
    % ticks = cell(1,size(v1,1));
    
    % for i=1:size(v1,1)
    %    ticks{i} = num2str(mx(i));
    % end
    
    % yticklabels(ticks);
    
    set(gcf, 'Position', [25 -13 681 372]);
    
    fHvoc1 = figure('Name', 'Vocabulary 1', 'Position', [20 347 1112 642]);
    fHvoc2 = figure('Name', 'Vocabulary 2', 'Position', [798 55 1113 644]);
    
    rows = 2;
    cols = 3;
    dim = rows*cols;
    
    incr1 = 0;
    incr2 = 0;
    redraw = true;
    
    looping = true;
    
    while looping
        
        if(redraw)
            
            figure(fHvoc1);
            
            for i=1:dim
                subplot(rows,cols,i);
                shearlet_show_descriptor(v1(i+incr1,:), i+incr1, false);
            end
            
            figure(fHvoc2);
            
            for i=1:dim
                subplot(rows,cols,i);
                shearlet_show_descriptor(v2(i+incr2,:), i+incr2, false);
            end
            
            redraw = false;
        end
        
        pause(0.5)
        current_key = uint8(get(gcf,'CurrentCharacter'));
        
        if(~isempty(current_key))
            
            if(gcf == fHvoc1)
                switch current_key
                    case 28
                        incr1 = incr1 - 6;
                        if(incr1 < 0)
                            incr1 = 0;
                        end
                        redraw = true;
                    case 29
                        incr1 = incr1 + 6;
                        if(incr1 > size(v1,1) - 6)
                            incr1 = size(v1,1) - 6;
                        end
                        redraw = true;
                    case 'q'
                        looping = false;
                end
            elseif (gcf == fHvoc2)
                switch current_key
                    case 28
                        incr2 = incr2 - 6;
                        if(incr2 < 0)
                            incr2 = 0;
                        end
                        redraw = true;
                    case 29
                        incr2 = incr2 + 6;
                        if(incr2 > size(v2,1) - 6)
                            incr2 = size(v2,1) - 6;
                        end
                        redraw = true;
                    case 'q'
                        looping = false;
                end
            end
            
            set(gcf,'currentch',char(1))
            
        end
        
    end
end


end

