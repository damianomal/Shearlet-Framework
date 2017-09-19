function [TOTALCOST, cost_matrix, ASSIGN] =  shearlet_compare_vocabulary_munkres( vocab_1, vocab_2, normalize, show)
%SHEARLET_COMPARE_VOCABULARY_MUNKRES Summary of this function goes here
%   Detailed explanation goes here

% close all;

if(nargin < 4)
    show = true;
end

if(normalize)
    vocab_1 = shearlet_normalize_vocabulary(vocab_1);
    vocab_2 = shearlet_normalize_vocabulary(vocab_2);
end

[~, cost_matrix] =  shearlet_compare_vocabulary(vocab_1, vocab_2, false, normalize);

% cost_matrix = 1 - cost_matrix;
cost_matrix = max(cost_matrix(:)) - cost_matrix;

[ASSIGN, TOTALCOST] = munkres(cost_matrix);

% ASSIGN
n_el = (size(vocab_1,1));

mmat = cost_matrix';
% COSTS = mmat(12*[0:11] + ASSIGN);
COSTS = mmat(n_el*[0:(n_el-1)] + ASSIGN);

[~, idx] = sort(COSTS, 'ascend');

cost_matrix = cost_matrix(idx, ASSIGN(idx));

name_1 = inputname(1);
name_2 = inputname(2);

mkdir(['Results/' name_1 '_vs_' name_2]);
 
fHandles = cell(1,4);
cur_fig = 1;

if(show)
    
    fHandles{cur_fig} = figure('Position', [181 227 1696 767]);
    
    index = 1;
    
    vocab_1 = vocab_1(idx,:);
    vocab_2 = vocab_2(ASSIGN(idx),:);
    
    %     vocab_1 = vocab_1(idx,:);
    %     vocab_2 = vocab_2(idx,:);
    
    BIGMAT = [vocab_1 vocab_2 COSTS'];
    
    [sorted_matrix, I] = sortrows(BIGMAT, 3);
    
    vocab_1 = sorted_matrix(:, 1:121);
    vocab_2 = sorted_matrix(:, 122:242);
    
    for i=1:numel(ASSIGN)
        
        subplot(2,4,index);
        % shearlet_show_descriptor(vocab_1(i,:), i, false);
%         shearlet_show_descriptor(vocab_1(i,:), idx(I(i)), false);
        shearlet_show_descriptor(vocab_1(i,:), -1, false);
        set(gca,'zticklabel',[])

        subplot(2,4,4+index);
        % shearlet_show_descriptor(vocab_2(ASSIGN(i),:), ASSIGN(i), false);
%         shearlet_show_descriptor(vocab_2(i,:), ASSIGN(idx(I(i))), false);
        shearlet_show_descriptor(vocab_2(i,:), -1, false);
        set(gca,'zticklabel',[])

        index = index + 1;
        
        if(index > 4 && i < numel(ASSIGN))
            index = 1;
            cur_fig = cur_fig + 1;
            fHandles{cur_fig} = figure('Position', [181 227 1696 767]);
        end
        
    end
    
    cur_fig = cur_fig + 1;
    fHandles{cur_fig} = figure; imshow(1-cost_matrix, [0 1], 'InitialMagnification', 2000);
    
    colormap default
    colorbar

end

% COST = trace(cost_matrix);

end

