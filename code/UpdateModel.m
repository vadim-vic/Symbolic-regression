function [NewModel] = UpdateModel(Model)
% [func_handle,b_init,func_name] = UpdateModel(Model)
% update Model fields from the Tree structure
% Model [structure] see CreateModel
%
% http://strijov.com
% Strijov, 08-may-08

NewModel = CreateEmptyModel(); % NewModel is a model with empty the Tree field

try
NewModel = CopyTree2Model(Model.Tree, NewModel, 1); % run in nodes recursively (to the left-bottom)
catch
    disp ok
end
% fill the rest of the fields in the MewModel

% 1) fill Tree node id 
[NewModel.Tree, NewModel.idCount] = RefreshNodeId(Model.Tree, 0);
% 2) fill the Handle
NewModel.Handle = eval(['@ (w,x) ' NewModel.Name ';']);

% WARNING! All the fields od Model, except the fields mentioned in these two
% functions will be lost!
return

function [NewModel, parnum] = CopyTree2Model(SubTree, NewModel ,parnum)
% [NewModel, parnum] = CopyTree2Model(SubTree, NewModel ,parnum)
% recursively copies the content of the Function Tree into fiels of the
% Model
% All the fields except the Model.Handle, Model.Tree and Model.idCount are
% fullfiled here.
%
% Model [structure] see CreateModel
% SubTree [structure] cee CreateTree
% 
% http://strijov.com
% Strijov, 08-may-08

NewModel.Name = strcat(NewModel.Name, SubTree.func);
if isempty(SubTree.of) % any terminal node        
    %~isempty(findstr(node.func,'x(:,')) % this is  x(i), terminal node        
    return
end

% represent each primitive as a part of a superposition func(b,x(:,i),x(:,j),...)   
if isempty(SubTree.wInit) % WARNING! 
    % Assume all the parameter vectors like wInit, wFound, sailency, has the same length 
    % and wDom has the same number of rows
    % empty values of the rest wXxx, and sailency are allowed 
    NewModel.Name = strcat(NewModel.Name, '([]'); % b = []; add the poen bracket and no parameters 
else
    if length(SubTree.wInit) == 1,                  % for the beauty, 'w(1)', not 'w(1:1)'
        parstr = strcat(num2str(parnum));        
    else                                            % the common procedure 'w(1:5)'
        parstr = strcat(num2str(parnum),':',num2str(parnum-1+length(SubTree.wInit)));
    end
    NewModel.Name = strcat(NewModel.Name, '(w(', parstr ,')');
    % func(b(parnum:parnum+num of parameters),...
    NewModel.wInit    = [NewModel.wInit,    SubTree.wInit]; 
    NewModel.wFound   = [NewModel.wFound,   SubTree.wFound]; 
    NewModel.wDom     = [NewModel.wDom,     SubTree.wDom]; 
    NewModel.saliency = [NewModel.saliency, SubTree.saliency]; 
    NewModel.alpha    = [NewModel.alpha,    SubTree.alpha]; 

    parnum = parnum + length(SubTree.wInit);
end    

for ii=1:length(SubTree.of)
    NewModel.Name = strcat(NewModel.Name, ','); % func1(b(...),func2(...),func3(...)  etc. recursively
    [NewModel, parnum] = CopyTree2Model(SubTree.of{1,ii}, NewModel, parnum);
end
NewModel.Name = strcat(NewModel.Name, ')'); % close the bracket at the end of the substring
return

function [SubTree, id] = RefreshNodeId(SubTree, id)
% [Tree, id] = RefreshIndexes(Tree, id)
% enumerates the nodes of the Function Tree recursively
%
% Tree [structure] see CreateTree
%
% http://strijov.com
% Strijov, 08-may-08
    id = id + 1;
    SubTree.id = id;
    for i = 1:length(SubTree.of)
        [SubTree.of{1,i}, id] = RefreshNodeId(SubTree.of{1,i}, id);
    end
return