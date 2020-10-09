function pairs = combPair(vec1,vec2,varargin)
% combPair function generates all possible combinations of input vectors.
% Args:
%       vec1 or vec2: you can input either one or two vectors which you
%       want to combine togather. If you input one vector, the function
%       will generate all possible combinations of elements in vector. If
%       you input two vectors, the functuion will generate all possible
%       combinations between elements in two vectors.
% by Siyuan Zhou
if nargin>1
    pairs = [repelem(vec1(:), numel(vec2)) ...
            repmat(vec2(:), numel(vec1), 1)];
else
    pairs = nchoosek(vec1,2);
end

end