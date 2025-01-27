function Population2TeX(Population,TeXfilename)
% Population2TeX(Population,TeXfilename)
% 
% \usepackage{ecltree}
% \drawwith{\dottedline{1}}
% \setlength{\GapDepth}{1mm}
% \setlength{\GapWidth}{2mm}
% then insert the tex string

strbeg = [  '\\documentclass[12pt]{article}\n', ...
            '\\usepackage{a4wide}\n', ...
            '\\usepackage[cp1251]{inputenc}\n',...
            '\\usepackage[russian]{babel}\n',...
            '\\usepackage{amsmath, amsfonts, amssymb, amsthm, amscd}\n',...
            '\\usepackage{graphicx, epsfig}\n',...
            '\\usepackage{epic}\n',...
            '\\usepackage{ecltree}\n',...
            '\\drawwith{\\dottedline{1}}\n',...
            '\\setlength{\\GapDepth}{4mm}\n',...
            '\\setlength{\\GapWidth}{8mm}\n',...
            '\n',...                      
            '\\begin{document}\n'];
strend =    '\\end{document}';

fid = fopen(TeXfilename,'w+');
fprintf(fid,strbeg);

for i = 1:length(Population)
    strTree = Tree2TeX(Population{1,i}.Tree,'');    
    strName = Population{1,i}.Name;
    %%% FIXIT, remove all '_' from the function names to safisfy TeX requirements 
    strTree = regexprep(strTree, '_', '');
    strName = regexprep(strName, '_', '');
    fprintf(fid,'\\hrule\n\n');
    fprintf(fid,'%s\n\n', strName);
    fprintf(fid,'%s\n\n', strTree);
end

fprintf(fid,strend);
fclose(fid);
return




    
    