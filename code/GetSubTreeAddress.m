function adr = GetSubTreeAddress(Tree, id)
% adr = GetSubTreeAddress(Tree, id)
% construct string address for hierarhical cell-structured tree 
%
% Tree [strucutre] see ConstructTree
% id [int] Tree node number
%
% Example 1
% Tree = ConstructTree(???)
% adr = GetSubTreeAddress(Tree, 6)
%
% Example 2
% Tree5 = struct('id',5, 'of',[]);
% Tree4 = struct('id',4, 'of',[]);
% Tree3 = struct('id',3, 'of',[]);
% Tree2 = struct('id',2, 'of',[]);
% Tree2.of = {Tree3, Tree4};
% Tree1 = struct('id',1, 'of',[]);
% Tree1.of = {Tree2, Tree5};
% for id = 1:5
%     adr = GetSubTreeAddress(Tree1, id);
%     fprintf(1,'\nid=%d, adr=%s', id, adr);
% end
%
% http://strijov.com 09-04-09

adr = ConstructAddress(Tree, id, '');

% if adr is empty, return empty, otherwise return address 'Tree.of{1,2}.of{1,1}...
if ~isempty(adr) 
    adr = strcat('Tree',adr);
end
return

function adr = ConstructAddress(Tree, id, adr)
% recursive function, constructs address of hierarhical cell structure
%
% Tree has two obligatore fields:
% Tree.id [integer] id of the node
% Tree.of {Tree1,...,TreeeN} cell structure with Trees in the cells
%
% Example (could be rub from GetSubTreeAddress)
% Tree5 = struct('id',5, 'of',[]);
% Tree4 = struct('id',4, 'of',[]);
% Tree3 = struct('id',3, 'of',[]);
% Tree2 = struct('id',2, 'of',[]);
% Tree2.of = {Tree3, Tree4};
% Tree1 = struct('id',1, 'of',[]);
% Tree1.of = {Tree2, Tree5};
% for id = 1:5
%     adr = GetSubTreeAddress(Tree1, id);
%     %adr = ConstructAddress(Tree, id, '');
%     fprintf(1,'\nid=%d, adr=%s', id, adr);
% end
%
% http://strijov.com 09-04-09

    if Tree.id == id,        
        adr = ' ';
        return
    end
    % else
    for i = 1 : length(Tree.of)         
        adr = ConstructAddress(Tree.of{1,i}, id, adr);
        if ~isempty(adr)
            adr = strcat('.of{1,', num2str(i), '}', adr);
            break
        end
    end                  
return    