function vocab_new = shearlet_normalize_vocabulary( vocab )
%SHEARLET_NORMALIZE_VOCABULARY Summary of this function goes here
%   Detailed explanation goes here

vocab_new = vocab;

for i=1:size(vocab_new,1)
    row = vocab_new(i,:);
    mx = max(row(:));
    vocab_new(i,:) = row / mx;
end


end

