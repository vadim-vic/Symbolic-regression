function [model_output, parcounter] = model_grabber(model_input, registry)
%        [model_output, parcounter] = model_grabber(model_input, registry_filename) 
%
% The initial models can be created as text strings.
% A model is an arbitrary superposition of the list functions.
% For example if there are function a,b and c have single argument 
% the a superposition can be a(b(c(a))). If some functions, 
% i.e. 2d and 2f have two arguments, then a superposition can be 
% 2d(a,2f(b,c)). These two examples are easy to be shown as trees.
% The careful brackets alignment is obvious. 
% This function accept a string, put into the string necessary elements,
% such as parameters of functions, etc. 
% The mandatory elements in input models are:
% 1) names of the functions must be in the list of the function  ...,
% 2) brackets and commas are in the proper places,
% 3) each terminal function must contain a name of input variable 'x' or
%    constant, i.e. a(x2), 2f(x1,x2), 2d(x1,5.4).
% WARNING! This function does not verify whether the model syntacsis is
% correct or not.
% HERE:
% parcounter - overall number of parameters in the model
% registry_filename - name of the file which sprcifies the model elements
%
% EXAMPLES:
% model_input  = '2plus(sin(x1),gaussian(x1))';
% model_output =  'f_2plus([],f_sin(b(1:4),x(:,1),f_gaussian(b(5:8),x(:,1))';
%
% model_input  = '2plus(2plus(2plus(gaussian(x1),gaussian(x1)),gaussian(x1)),x1)';
% %f_2plus([],f_2plus([],f_2plus([],f_gaussian(b(1:4),x(:,1)),f_gaussian(b(5:8),x(:,1))),...
%                                                   f_gaussian(b(9:12),x(:,1))),x(:,1)) 
%
% SEE ALSO: model_releaser, func2mdl, mdl2func
%
% http://strijov.com
% Strijov, 29-apr-08
fprintf('currently in model_grabber \n');

tin  = model_input;             % short the name
pos1 = findstr(tin,'(');        % find all the entrances of the open brackets
pos2 = findstr(tin,')');        % find all the entrances of the close brackets
pos3 = findstr(tin,',');        % find all the entrances of the commas
pos = sort([pos1, pos2, pos3]); % order the cut positions
beg = 1;
parcounter = 0;
for i = 1:length(pos)
    fin = pos(i)-1;
    sub1 = tin(beg:fin);        % it is name of a model function
    parnum = findfunc(sub1, registry);    % get the number of parameters in the function
    
    if parnum > -1              % no such function in the registry
        if parnum == 0          % function has no parameters
            insert = '([],';    
        elseif parnum == 1      % function has one parameter
            insert = ['(b(',num2str(parcounter + 1),'),']; 
        else                    % function has several parameters
            insert =  ['(b(',num2str(parcounter + 1),':',num2str(parcounter + parnum),'),'];
        end
        parcounter = parcounter + parnum; % number of parameter in the parametric vector
                                % gather the string
        tout = [tin(1:beg-1), 'f_', sub1, insert, tin(fin+2:end)];
                                % correct the cut positions in the new string
        pos = pos + 1 + length(insert);
        tin = tout;             % go on with the conversion
    else
        insert = 0;
    end   
    beg = pos(i)+1;
end    

pos = findstr(tin,',x');        % find all the x's in the string
beg = 1;
for i = length(pos):-1:1
    first = tin(1:pos(i)-1);      % the first part, before the ',x'
    closebr1 = findstr(tin(pos(i)+1:end),')'); % find the close brackets of x or commas 
    closebr2 = findstr(tin(pos(i)+1:end),','); 
    closebr  = min([closebr1, closebr2]);
    digit    = tin(pos(i)+2:pos(i)+closebr-1); % order number of x
    last     = tin(pos(i)+closebr:end);        % the string remainder 
    tin = [first, ',x(:,',digit,')',last];     % gather the new string
end 
model_output = tin;
return 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function parnum = findfunc(sub1,registry)
parnum  = -1;
for i = 1:length(registry)
    if strcmp(['f_',sub1], registry(i).func)
        parnum = registry(i).par;
        break
    end
end
return
