function Model = UpdateTree(Model, options)
% Model = UpdateTree(Model)
% copies content of the model into the tree
%
% Model [strucute] see CreateEmptyModel
% options [string] 'all', 'parameters'
%
% Example
% str = 'f_2plus([],f_linear(w(1:2),f_gaussian(w(3:6),f_2divide([],x(:,1),f_sqrt(w(7:10),x(:,2))))),f_sin(w(11),x(:,2)))';
% Model = CreateEmptyModel();
% Model.Name =  str;
% Model.wInit = [111:-1:101];
% Model = UpdateTree(Model, 'all');
% Model2 = UpdateModel(Model);
% Model1.Name
% Model2.Name
% http://strijov.com
if nargin < 2, options = 'all'; end % reconstruct the Tree completely

if strcmp(options,'parameters')
    Tree = Model.Tree;        
else   
    Tree = CreateTree(Model.Name);
end

[Model.Tree, Model.idCount] = CopyModel2Tree(Tree, Model ,0);
return

function [Tree, id] = CopyModel2Tree(Tree, Model ,id)
% [Tree, id] = CopyModel2Tree(Tree, Model ,id)
% recursive copy parameters of the Model to the Tree 
%
% Model[structure] see CreateEmptyModel
% Tree [hierachical structure] see CreateEmptyTree
%
% Example (see example of UpdateModel)
% [Tree idCount] = CopyModel2Tree(Tree, Model ,0) 
% 
% http://strijov.com, 10-04-08

% get the information about the length of the parameters from the Tree.wInit
parnum = length(Tree.wInit);
if length(Model.wInit) < parnum, 
    error('Model initial parameters mismatch');
end

if parnum > 0 % there no parameters, saliences, domains,  etc.
    % move parameters from the Model to the node of the Tree
    Tree.wInit = Model.wInit(1:parnum); Model.wInit(1:parnum) = []; 
    % WARNING! below it is supposed that length of all the vectors are the same
    % of the vector is empty
    if length(Model.wFound) >= parnum
        Tree.wFound = Model.wFound(1:parnum); Model.wFound(1:parnum) = []; 
    end
    if size(Model.wDom,1)>= parnum
        Tree.wDom = Model.wDom(1:parnum); Model.wDom(1:parnum,:) = []; 
    end
    if length(Model.saliency) >= parnum
        Tree.saliency = Model.saliency(1:parnum); Model.saliency(1:parnum) = []; 
    end
    if ~isempty(Model.alpha)
        Tree.alpha= Model.alpha(1); Model.alpha(1) = []; 
    end
end

% fill the number of the node of the Tree
id = id+1;
Tree.id = id;

% make the next recursion call to fullfill the Tree
for i=1:length(Tree.of)    
    [Tree.of{1,i} id] = CopyModel2Tree(Tree.of{1,i}, Model ,id);
end

return


