function Model = CreateModel(model, wInit, Registry)
% Model = CreateModel(model, wInit, Registry)
% creates Model from model desccription, parameters and Registry structure
%
% model [string] model description foo(bar(...),... ,foo(...))
% functions foo and bar must be described in the Registry and stored in the folder 'func'
% wInit [1 x W] vector of parameters
% Registry [structure] see PopulationDownload
% Model [structure] see CreateEmptyModel
%
% Example 
% [Models, Registry] = DownloalModelsAndRegistry()
%
%
% http://strijov.com
Tree = CreateTree(model);
Model = CreateEmptyModel();
Model.Tree = CopyRegistry2Tree(Tree, Registry, 0);
Model = UpdateModel(Model);

if length(Model.wInit) == length(wInit),    
    if any(Model.wInit ~= wInit),
        fptintf(1,'\n%s: %s'\n,'parameters of the initial model used:', model); 
        Model.wInit = wInit;
    end
elseif ~isempty(wInit)    
    error(sprintf('\n%s: %s\n','check parameters of the initial model', model)); 
end

return


function [Tree, id] = CopyRegistry2Tree(Tree, Registry, id)
% [Tree, id] = CopyRegistry2Tree(Tree, Registry, id)
% copy content of the Registry into corresponding nodes of the Tree
%
% Tree [structure] see CreateEmptyTree
% Registry [structure] see PopulationDownload
% id [integer] number of the current node of the Tree
%
% http://strijov.com

% find the function if the Registry
idx = strmatch(Tree.func, Registry.func, 'exact'); 
if length(idx)==1, 
    % fill the parameters; the parameters wFound, saliency, alpha are to be filled later
    % parameters wInit is optional in the Registry 
    if ~isempty(Registry.wInit{idx}) && length(Registry.wInit{idx}) == Registry.npar(idx)
        Tree.wInit = Registry.wInit{idx};
    else % trust the number of parameters, npar; it is obligatory
        Tree.wInit = zeros(1,Registry.npar(idx));
    end                
    Tree.wDom  = Registry.wDom{idx};
elseif ~strcmp(Tree.func(1:4),'x(:,')   % if yes, this is a treminal node                 
        error(sprintf('\n%s: %s\n','registry, check the function', Tree.func));   
end
% if length 

% fill number of the current node
id = id+1;
Tree.id = id; 

% fill the next branch
for i = 1:length(Tree.of)
    [Tree.of{1,i}, id] = CopyRegistry2Tree(Tree.of{1,i}, Registry, id);
end
return
