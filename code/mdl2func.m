function [func,b] = mdl2func(n)

fprintf('currently in mdl2func \n');
%        [func,b] = mdl2func(n)
%
% Converts the network structure into a regression model string
% and extracts the parameters vector.
% Here:
% func      string description of a regression model 
% b (1 x B) parameter vector 
% n         network structure
%
% SEE ALSO: func2mdl, model_grabber, model_releaser
%
%------------------------------------------
% 19-Apr-05, Vadim Strijov, strijov@ccas.ru

for i=1:length(n) % align the parameters vecotr, a little patch
    [a,b]=size(n(i).b);    
    if a > b, n(i).b = n(i).b'; end
end

         [func, bbeg, b] = getfunc('', n, 1, 1, []);

function [s, bbeg, beta] = getfunc(s, n, nnum, bbeg, beta)
    
    % i.e. the next nested argument is x
    if nnum < 0,  s = ['x(:,',num2str(-nnum),')']; return; end    % the leaf of the tree is x    
    
    % NOW IT HAVE NO SENSE 
    if nnum == 0, s = '[]'; return; end   % the leaf of the tree is empty set;
    
    % begin of the new composition function entrance 
	s1 = sprintf('%s',n(nnum).func);
    % the first argument of any function is parameter vector
	bfin = -1 + bbeg + length(n(nnum).b);

    s2 = sprintf('b(%1.f:%1.f)',bbeg, bfin);
    if bfin<bbeg, s2 = '[]'; end % if there are no parameters
    
    % the second argument is first nested function 
	bbeg = bfin+1;
	beta = [beta n(nnum).b];

    % the third argument is first nested function 
    % only two functions are allowed at the same nested level
    s3 = ''; 
    for numero = n(nnum).ins,
        [s, bbeg, beta] = getfunc(s, n, numero, bbeg, beta);
        s3 = sprintf('%s,%s',s3,s);          
    end;
    
    % collect all together, i.e. function name, parameters, the nested funcs and args
	s = sprintf('%s(%s%s)',s1, s2, s3);
return
    