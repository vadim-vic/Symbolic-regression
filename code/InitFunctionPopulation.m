function Population = InitFunctionPopulation(Registry, mdlpop)
% FunctionPopulation = InitFunctionPopulation(Registry, mdlpop)
% generaten initial population from the mdlpop structure using registry
%  
% Regsitry   see mvrStructures.m
% Population {cell of Models } CreateModel.m
% mdlpop     must be replaced
%
% Example:
% mdl1 = 'sin(x1)'
% TODO make the example
%
% http://strijov.com
% Eliseev, 14-dec-07
% Strijov, 29-apr-08

fprintf('currently in InitFunctionPopulation \n');
%FunctionPopulation = cell(size(mdlpop));
sizePop = length(mdlpop);
%tmp(sizePop) = struct('Quality', Inf, 'FunctionTree', [], 'FunctionHandle', [], 'b_init', [], 'b_found', [], 'LeavesCount', 0, 'FunctionName', []);
%tmp(:,:)          = struct('Quality', Inf, 'FunctionTree', [], 'FunctionHandle', [], 'b_init', [], 'b_found', [], 'LeavesCount', 0, 'FunctionName', []);
%tmp(sizePop) = struct('errTrain', Inf, 'errTest', Inf, 'Tree', [], 'Handle', [], 'wInit', [], 'wFound', [], 'dom', [], 'idCount', 0, 'Name', []);
tmp(sizePop) = CreateModel();

Population = num2cell(tmp);
clear tmp

for i = 1:sizePop
    [Population{1,i}.Tree, Population{1,i}.idCount] = ...
        AddNewItem(mdlpop,i,1,0,Registry,0); % convert source data into the normal tree
end
return

% This finction must be replaced by text conversion function
function [population,idCurrent] = AddNewItem(mdlpop,f1,f2,var,registry, idCurrent) % recursive addition of the tree branchers
% var = 0 iff non-terminal function, var = i iff  x_i is added   
% f1 function number
% f2 operator number
    if var ~=0 % terminal node 
        idCurrent = idCurrent + 1;
        %population = struct('func',strcat('x(:,',num2str(var),')'),'arguments',[],'param',[],'LeaveNumber', idCurrent);
        population = struct(...   
        'func',     strcat('x(:,',num2str(var),')'), ...%  string,     Name of a primitive function
        'of',       [], ...% Tree(s),    Recursive-called structured        
        'wInit',    [], ...% row-wector, Initial parameters of the primitive 
        'wFound',   [], ...% rowm-wector, Tuned parameters of the primitive 
        'wDom',      [], ...% [min max],  Domain of the primitive
        'saliency', [], ...% row-wector, Saliency of the error function for each parameters
        'alpha',    [], ...% scalar,     Hyperparameter, convolution of the saliency vector
        'id',       idCurrent ...% integer,    Node number of the tree
        );
        return        
    end% if for the terminal node
    
    idCurrent = idCurrent + 1;
    %population = struct('func',[],'arguments',[],'param',[], 'LeaveNumber', idCurrent);
    population = struct(...   
        'func',     [], ...%  string,     Name of a primitive function
        'of',       [], ...% Tree(s),    Recursive-called structured
        'wInit',    [], ...% row-wector, Initial parameters of the primitive 
        'wFound',   [], ...% rowm-wector, Tuned parameters of the primitive 
        'wDom',     [], ...% [min max],  Domain of the primitive
        'saliency', [], ...% row-wector, Saliency of the error function for each parameters
        'alpha',    [], ...% scalar,     Hyperparameter, convolution of the saliency vector
        'id',       idCurrent ...% integer,    Node number of the tree
        );
    population.func  = mdlpop{1,f1}(1,f2).func;
    population.wInit = mdlpop{1,f1}(1,f2).b;
    for ii = 1:length(registry) % find the function in the registry and get the param number
        if strcmp(population.func, registry(1,ii).func)
            if registry(1,ii).par ~= length(population.wInit)
                population.wInit = registry(1,ii).b;
                p1 = length(population.param)+1;
                p2 = registry(1,ii).par;
                population.wInit(1,p1:p2) = rand(1,p2-p1+1);
            end
            break
        end
    end    
    ins = mdlpop{1,f1}(1,f2).ins;
    if ~isempty(ins) % for each tree add the corresponding subtree recursively 
        population.of = cell(1,length(ins));
        for ii = 1:length(ins)
            if ins(ii)<0
                [population.of{1,ii}, idCurrent] = AddNewItem([],0,0,-ins(ii),registry,idCurrent);
                continue
            end
            [population.of{1,ii}, idCurrent] = AddNewItem(mdlpop,f1,ins(ii),0,registry,idCurrent);
        end
    end
return
