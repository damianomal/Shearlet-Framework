

INDM = zeros(15,15);

INDM(8,8)=1;

ind = 1;

vars = [0 1; 1 0; 0 -1; -1 0; 0 1];

for step=1:7
    
    i = 8-step;
    j = 8;
    
    var_ind = 1;
    
    for var_ind =1:4
        
        while(INDM(i+vars(var_ind+1,1), j + vars(var_ind+1,2)) ~= 0)
            
            
            ind = ind + 1;
            
            INDM(i,j) = ind;
            
            i = i + vars(var_ind,1);
            j = j + vars(var_ind,2);
            
        end
        
        
    end
    
    while(step > 1 && INDM(i,j) == 0)
                
        ind = ind + 1;
        INDM(i,j) = ind;
        j = j +1;
        
    end
    
end

res_v = zeros(15*15,1);

for i=1:15*15
    
    [r,c] = find(INDM == i);
       
    res_v(i) = sub2ind([15 15], r, c);
    
end


