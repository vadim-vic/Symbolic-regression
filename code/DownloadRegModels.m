function [Registry, models, wInits] = DownloadRegModels(RegistryFullFname, ModelsFullFname)
% [Registry, Population] = DownloadRegModels(RegistryFullFname, ModelsFullFname)
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

for i=1:length(models)
    wInits{i} = str2num(wInits{i});    
end
return