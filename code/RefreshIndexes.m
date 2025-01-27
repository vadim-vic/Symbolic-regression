function [Tree, index] = RefreshIndexes(Tree, index)
% [Tree, index] = RefreshIndexes(Tree, index)
% enumerates the nodes of the Function Tree recursively
%
% http://strijov.com
% Eliseev, 14-dec-07
% Strijov, 04-may-08

    index = index + 1;
    Tree.LeaveNumber = index;
    for argum = 1:length(Tree.arguments)
        [Tree.arguments{1,argum}, index] = RefreshIndexes(Tree.arguments{1,argum}, index);
    end
return