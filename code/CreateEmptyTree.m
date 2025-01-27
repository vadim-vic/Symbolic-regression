function Tree = CreateEmptyTree()
% Tree = CreateEmptyTree()
% creates empty Tree 
%
% Tree        hierarchicl structure, each node has following fields
%
% http://strijov.com

Tree = struct(...    
    'func',     [], ...% string,     Name of a primitive function
    'of',       [], ...% Tree(s),    Recursive-called structured
    'wInit',    [], ...% row-wector, Initial parameters of the primitive 
    'wFound',   [], ...% row-wector, Tuned parameters of the primitive 
    'wDom',     [], ...% matrix [min, max ; ...] domain for each parameter of the primitive
    'saliency', [], ...% row-wector, Saliency of the error function for each parameters
    'alpha',    [], ...% scalar,     Hyperparameter, convolution of the saliency vector
    'id',       []  ...% integer     Node number in the tree
);
return