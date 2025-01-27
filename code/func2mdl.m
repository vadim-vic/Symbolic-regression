function n = func2mdl(func,b)
%        n = func2mdl(func,b)
%
% Makes the network structure of the regression model.
% Accepts a string description of a regression model and return network
% structure net. The parameters vector b is also imbedded in the net.
% Here:
% func      string description of a regression model 
% b (1 x B) parameter vector 
% n         network structure
%
% SEE ALSO: mdl2func, model_grabber, model_releaser
%
% http://strijov.com
% Strijov, 29-apr-08

fprintf('currently in func2mdl \n');
n=[];
i=1;
% make the network structure of the regression model
n = f2t(func,n,i); 

% insert weights into the model
for i=1:length(n)
   n(i).b = eval(n(i).b);   
   n(i).flag = 1;  % DEFINE MUTATION STATE FLAGS
end
return

function n = f2t(func,n,i)

head = beforebrackets(func);
[body, bnum] =  break2args(insidebrackets(func));

n(i).ins = zeros(1,bnum-1);
n(i).func = head;
n(i).b = body{1};

for j = 2:bnum % first argument is parameters vector
    % if  ~strcmp(body{j},'x') % only for single-var regression!
    [isx, xnum] = xisinside(body{j});
    if ~isx     
        last = length(n);
        n(i).ins(j-1) = last + 1; 
        n = f2t(body{j},n,last+1);
    else
        n(i).ins(j-1) = - xnum;
    end
end
return

%==========================================================================
function [isx, xnum] = xisinside(str)  
    if strcmp(str(1:4),'x(:,') & strcmp(str(end),')')
        isx = 1;    % it is x
        xnum = str2num(str(5:end-1));        
    else
        isx = 0;    % it is not x, it's something another, I guess
        xnum = 0;
    end
return
%==========================================================================
function inside = insidebrackets(str)  
posob = findstr(str,'(');
poscb = findstr(str,')');
for i=1:length(poscb)
    idx = find(posob < poscb(i));      % how many open brackets for the i-th close bracket
    if length(idx) == i                % if the open brackets the same qty as the close then it found
        inside = str(posob(1)+1:poscb(i)-1);
    end
end
if ~exist('inside','var'), error('syntax error, bracket mismatch'); end
return
%==========================================================================
function before = beforebrackets(str)
pos = findstr(str,'(');
if isempty(pos)
    before = '';
else
    before = str(1:pos(1)-1);
end
return
%==========================================================================
function [args, argnum] = break2args(func)
OPEN = '(';
CLOSE = ')';
COMMA = ',';

ptr = 0;
args={};
argnum = 1;
ptrstart = 1;
while ptr<length(func)    
    ptr = ptr+1;
    switch func(ptr)
        case OPEN
            brcount = -1;
            for i = ptr+1:length(func)
                if func(i) == OPEN 
                    brcount = brcount -1;
                elseif func(i) == CLOSE 
                    brcount = brcount +1;
                end
                if brcount == 0
                    ptr = i;
                    break
                end
            end
            if brcount ~= 0, error('bracket syntax error, no close bracket'); end;
        case CLOSE
            error('bracket syntax error, extra close bracket');
        case COMMA
            ptrstop = ptr-1;
            if ptrstart>ptrstop, error('syntax error, double comma'); end
            args{argnum} = func(ptrstart:ptrstop);
            argnum = argnum + 1;
            ptrstart = ptr+1;
    end    
end
if ptrstart<=length(func), args{argnum} = func(ptrstart:length(func));  end
return