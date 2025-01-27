function Population = CreatePopulation(Registry, models, wInits)
% create population as a cell array of Models

nmodels = length(models);

if nargin<3, wInits = cell(size(models)); end
if nmodels ~= length(wInits), wInits = cell(size(models));  end

Population = cell(1,nmodels);
for i=1:nmodels
    Population{1,i} = CreateModel(models{i}, wInits{i}, Registry);
    fprintf(1,'\nCreated: %s', Population{1,i}.Name);
end
return
