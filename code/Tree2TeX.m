function str = Tree2TeX(Tree, str)
% str = Tree2TeX(Tree, str)
% creates TeX tree from the Tree structure
%
% str [string] TeX string for output, '' for input
% Tree [structure] see CreateEmptyTree
%
% Example
% func = 'plus(mult(log(x1),sin(x2)),cos(x1))' 
% % WARNING! the string must satirfy MVR rules for regression models
% Tree = CreateTree(func)
% str = Tree2TeX(Tree,'')
%
% Usage: 
% TeX file must contain the following header:
% \documentclass[12pt]{article}
% \usepackage[cp1251]{inputenc}
% \usepackage{epic}
% \usepackage{ecltree}
% \drawwith{\dottedline{1}}
% \setlength{\GapDepth}{4mm}
% \setlength{\GapWidth}{8mm}
% \begin{document}
% %%%-your string
% \end{document}
%
% http://strijov.com

if ~isempty(Tree.of)
    str = strcat(str, '\begin{bundle}{', Tree.func, '}');
    for i = 1:length(Tree.of)    
        str = strcat(str, '\chunk{');
        str = Tree2TeX(Tree.of{1,i}, str);
        str = strcat(str, '}');
    end
    str = strcat(str,'\end{bundle}');
else
    str = strcat(str,Tree.func);
end
return