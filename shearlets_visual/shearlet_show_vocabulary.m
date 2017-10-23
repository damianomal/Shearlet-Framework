function [ output_args ] = shearlet_show_vocabulary( dictionary, rows, cols)
%SHEARLET_SHOW_VOCABULARY Summary of this function goes here
%   Detailed explanation goes here

if(nargin < 3)
    rows = 2;
    cols = 3; 
end

dim = size(dictionary,1);

if(dim > rows*cols)
    dim = rows*cols;
end

incr = 0;
redraw = true;
show_bar = false;

if(size(dictionary,2) < 50)
   show_bar = true; 
end

%  figure('Name','Centroids Vocabulary', 'Position', [726 554 560 420]);
 figure('Name','Centroids Vocabulary', 'Position', [305 95 1612 898]);

 cluster_map = shearlet_init_cluster_map;
 
 while true
    
    if(redraw)
        for i=1:dim
            
            subplot(rows,cols,i);
            
            if(show_bar)
                bar(dictionary(i+incr,:));
            else
                shearlet_show_descriptor(dictionary(i+incr,:), i+incr, false);
            end
            
            title(['Cluster #' int2str(i+incr)]);
        end
        
        redraw = false;
    end
    
    pause(0.5)
    current_key = uint8(get(gcf,'CurrentCharacter'));
    
    if(~isempty(current_key))
        switch current_key
            case 28
                incr = incr - 6;
                if(incr < 0)
                    incr = 0;
                end
                redraw = true;
            case 29
                incr = incr + 6;
                if(incr > size(dictionary,1) - 6)
                    incr = size(dictionary,1) - 6;
                end
                redraw = true;
                
        end
        
        set(gcf,'currentch',char(1))
        
    end
    
end

end

