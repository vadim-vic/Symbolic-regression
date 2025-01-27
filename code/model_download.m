function [Registry, Population] = DownloadRegPop(RegistryFullFname, ModelsFullFname)
% [Registry, Population] = DownloadRegPop(RegistryFullFname, ModelsFullFname)
% 
% Registry [structure] with fields
% .func {[string]} function names
% .narg [vector of integers] number of arguments for each function
% .npar [vector of integers] number of parameters for each function
% .wInit {[1 x W(i)]} initial parameters for each function
% .wDom  {[W(i) x 2]} domain [min max] for the parameters for each function
%
% Population {Models} cell array of Models, see CreateEmptyModel
%
% http://strijov.com
% Strijov, 29-apr-08

% download Registry 
[   Registry.func,...
    Registry.narg,...
    Registry.npar,...
    Registry.wInit,...
    Registry.wDom] = ...
        textread(RegistryFullFname,'%s%d%d%s%s','commentstyle','matlab','delimiter',',');
    
for i=1:length(Registry.wInit)
    Registry.wInit{i} = str2num( Registry.wInit{i} );
    Registry.wDom{i}  = str2num( Registry.wDom{i} );
end

% download Models
[models, wInits] = textread(ModelsFullFname,'%s%s','commentstyle','matlab','delimiter',';');
nmodels = length(models)
for i=1:nmodels
    wInits{i} = str2num(wInits{i});    
end

% create Population
Population = cell(1,nmodels);
for i=1:nmodels
    Population{1,i} = CreateModel(models{i}, wInits{i}, Registry);
end
   



%     
% fprintf('currently in model_download \n');
%     registry = make_registry(registry_filename);
%     mdlpop = make_mdlpop(mdl_filename, registry);
% return

% 
% function registry = make_registry(registry_filename)
% [short, func, args, pars, b0s] = textread(registry_filename,'%s%s%d%d%s','commentstyle','matlab','delimiter',',');
% for i=1:length(func)
%     registry(i).func    = func{i};
%     registry(i).short   = short{i};
%     registry(i).fea     = args(i);
%     registry(i).par     = pars(i);
%     registry(i).b       = str2num(b0s{i});
% end
% return

% 
% function mdlpop = make_mdlpop(mdl_filename, registry)
% [mdllst, b0s] = textread(mdl_filename,'%s%s','commentstyle','matlab','delimiter',';'); % read the text file
% mdlpop = {};
% 
% for i=1:length(mdllst)
%     [mdl, parnum] = model_grabber(mdllst{i},registry);
%     b0 = []; 
%     if length(b0s)>=i, b0 = str2num(b0s{i}); end
%     if parnum ~= length(b0),
%         b0 = NaN*ones(1,parnum); 
%     end  % there is no parameters vector in aposteriory model or it is wrong
% 
% %    try 
%         net = func2mdl(mdl,b0);
%         %WARNING! Here func2model returns an error difficult to understand
%         % The message is: The syntacsys of model list MIGHT BE WRONG!
%         %    catch
% %        error(['the model ',mdl,' is incorrect']);
% %    end
% 
%     % look for parameters in the registry for each model component
%     for i = 1:length(net)
%         for j = 1:length(registry)          % search in the registry
%             if strcmp(net(i).func,registry(j).func) & ... % if there is such function 
%                             length(net(i).b) == length(registry(j).b) % and it contains something valuable
%                 net(i).b = registry(j).b;   % then we use the parameters in the model structure
%                 break
%             end
%         end            
%     end
%     % look for those model elements which have no parameters
%     for i = 1:length(net)
%         if ~isempty(net(i).b)
%         if isnan(net(i).b(1))                  % if there are no values in the vector
%             net(i).b = rand(size(net(i).b));   % the parameters are random (0,1)
%         end
%         end
%     end
%     % add the model into the population
%     mdlpop{length(mdlpop)+1} = net;
% end 
% return