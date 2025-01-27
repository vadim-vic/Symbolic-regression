function Tree = CreateTree(str)
% Tree = CreateTree(str)
% creates Tree with the fileds Tree.func and Tree.of
% The rest of the fields are optional 
% 
% Tree [structure] see CreateNode
% str  [string] function description, i.e. 'foo(w(1:3), foo(...), ..., foo(..., x(:,1))'
%
% Example
% str = 'f_2plus([],f_linear(w(1:2),f_gaussian(w(3:6),f_2divide([],x(:,1),f_sqrt(w(7:10),x(:,2))))),f_sin(w(11),x(:,2)))';
% str = 'f_2plus(f_linear(f_gaussian(f_2divide(x(:,1),f_sqrt(x(:,2))))),f_sin(x(:,2)))';
% str = 'f_2plus(f_linear(f_gaussian(f_2divide(x1,f_sqrt(x2)))),f_sin(x2))';
% str = 'x(:,2)';
% Tree = CreateTree(str)
%
% http:/strijov.com 10-05-08

% no spaces in the string permitted; it removes all spaces from the str
str = regexprep(str, '\s+', ''); % this is needed for testing only, 

% constants for regular expression analysis
term  = '(?<term>^x\(:,\d+\))';  % terminal nodes: 'x(:,1)'     DEBUG prev. ver. '(?<term>\<x\(:,\d+\)\>)'
short = '(?<short>^x\d+)';       % terminal nodes in short notation: 'x1' -> 'x(:,1)' DEBUG prev.ver. '(?<short>\<x\d+\>)'
param = '(?<param>w\(\d+:\d+\),|w\(\d+\),|\[\],|)'; % parameters: '[]' or 'w(1)' or 'w(12:14)' or nothing ''
foo   = '(?<func>^\w+\()';      % function header, i.e. 'sin('
rest  = '(?<rest>.+)';          % all the rest
clos = '(?<close>\)$)';         % function close bracket
expr = strcat(short, '|',term, '|', foo, param, rest, clos);
                                % the terminal node or the function 
% reminder '\w+' means at least one simbol from [0-9_A-Za-z] while 
% \s* means there could be empty string of separators i.e. spaces

% create current node of the Tree 
Tree = CreateEmptyTree();

% parce the string 
%[tok mat names idx] = regexp(str, expr, 'tokens', 'match', 'names') % for debugging
[names, mat] = regexp(str, expr, 'names','match'); % for release
if ~strcmp(mat{1},str) % check 
    error(sprintf('\n%s: %s\n', 'abnormal expression', str));
end
% below will be used: func, term, short, rest ans param
% omitted: clos
if ~isempty(names.func)
    Tree.func = names.func(1:end-1); % func name without '('
    n = GetParametersLength(names.param);
    if n > 0
        Tree.wInit = [1:n]; % dummy parameters
    end    
else
    if ~isempty(names.term)             % treminal node discovered
        Tree.func = names.term;         % keep it        
    elseif ~isempty(names.short)        % terminal node in short notation -> regular notation            
        Tree.func = strcat('x(:,', names.short(2:end), ')'); % 2:end means without leading x        
    else                                % one of the 3 possibilities: function, terminal, short terminal 
        error(sprintf('\n%s: %s\n', 'abnormal expression', str));
    end
end
 
% break the string into separate functions
funcs = Str2Funcs(names.rest);
% for each function of this level of hierachy
for i = 1:length(funcs)
    Tree.of{1,i} = CreateTree(funcs{1,i});
end
return

function funcs = Str2Funcs(str)
% breaks string into several functions of upper hierarchy
% str [string]
% funcs {str array}
% str must have no spaces, and 
% functions must be separated by comma
%
% Example
% str = 'f_linear(w(1:2),f_gaussian(w(3:6),f_2divide([],x(:,1),f_sqrt(w(7:10),x(:,2))))),f_sin(w(11),x(:,2))';
% funcs = Str2Funcs(str);
% funcs{:}
% 
% http://strijov.com

if isempty(str), funcs = []; return; end % there is nothing to break apart

idx_op = regexp(str, '('); % find open parenthesis
idx_cl = regexp(str, ')'); % find close parenthesis
op = +1 * ones(size(idx_op)); % create tokens
cl = -1 * ones(size(idx_cl)); 
[idx, tmp] = sort([idx_op , idx_cl]); % join indexes
opcl = [op, cl];                      % join parenthesis tokens
opcl = opcl(tmp);

% check if the parenthesis at least in pairs
if length(op)~=length(cl), error(sprintf('\n%s: %s\n', 'parentheses mismatch:', str)); end

% find all commas =  possible function separators
% a comma is a separator of the sum of the brackets before it = 0
str = strcat(str, ',');             % post the terminal comma
sepidx = findstr(str, ',');

% find the places start-end of the functions
cut =[0];
for i=sepidx %length(opcl)
    opclidx = find (idx < i);       % find indexes of the parantheses before the comma    
    if sum(opcl(opclidx)) == 0,     % for corresponded pair of parentheses the sum of them equals 0
        cut(end+1) = i;             % mark this place
    end
end

% store the functions into cell array
funcs = {};
for i = 2: length(cut)
    funcs{end+1} = str(cut(i-1)+1:cut(i)-1); % +1 ans -1 this eats the comma separator
end
return    

function n = GetParametersLength(str)
% n = GetParametersLength(str))
%
% str [string] of 3 types 'w(1:2)', 'w(3), '[]'
% n [integer] number of items 
% WARNING! 'w(1:2)', not 'w(2:1)'
%
% Example
% GetParametersLength('w(12:17)')
% GetParametersLength('w(44)')
% GetParametersLength('[]')
% 
% http://strijov.com

if isempty(str), n=0; return; end % parameters could be omitted in the short notation 

%              first case             second case           third case   
expr = '(?<two>^w\(\d+:\d+\),$)|(?<one>^w\(\d+\),$)|(?<zero>^\[\],$)';
names = regexp(str, expr, 'names');

% three variants or error message
if ~isempty(names.two)
    str(strfind(str,':')) = '-';    % in the first case replace ':' by '-', remove 'w' and ','
    n = 1 - eval(str(2:end-1));% and evaluate the expression
    return
end
if ~isempty(names.one),  n = 1; return; end
if ~isempty(names.zero), n = 0; return; end
% get back and error report
str(strfind(str,'-')) = ':';
error(sprintf('\n%s: %s\n', 'misspelling of the parameters', str)); 
return