function alpha = Saliency2Alpha(Tree)
% alpha = Saliency2Alpha(Tree)
% run across the Tree compute alpha and store it 
%
% Tree  [structure] see CreateEmptyTree; fields required 
% .of   [Tree cell array]
% .saliency [row vector]
% .alpha    [scalar]  .alpha = max(saliency)
%
% alpha  [row vector] of collects alpha scalars
%
% Example
%
%
% 

%Tree.saliency
alpha = max(Tree.saliency);
Tree.alpha = alpha;
for i=1:length(Tree.of)
    alpha = [alpha Saliency2Alpha(Tree.of{1,i})];
end
return