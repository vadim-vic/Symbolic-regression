function result = main(PrjFname)
% The main function of the MVR 
%
% http://strijov.com

warning off
global PLTOPTSFIGNUM
PLTOPTSFIGNUM = 1;

THISFOLDER = fileparts(mfilename('fullpath'));
DATAFOLDER = fullfile(THISFOLDER,'data');
FUNCFOLDER = fullfile(THISFOLDER,'func');
CODEFOLDER = fullfile(THISFOLDER,'code');
REPORTFOLDER  = fullfile(THISFOLDER,'report');
if ~exist(REPORTFOLDER,'dir'), mkdir(REPORTFOLDER); end
addpath(FUNCFOLDER);
addpath(CODEFOLDER);

if nargin < 1, PrjFname = 'demo.prj.txt'; end
PrjFullFname = fullfile(DATAFOLDER, PrjFname);

% read the project file 
evalstr = textread(PrjFullFname,'%s','commentstyle','matlab','delimiter','%');
for i=1:length(evalstr)
    try 
        eval(evalstr{i});   
        fprintf(1,'%s\n',evalstr{i});
    catch
        fprintf(1,'\nError in the project file %s, line = %d, content = %s \n', PrjFname, i, evalstr{i});
    end
end 
if ~isfield(pltopts,'folder'), pltopts.folder = REPORTFOLDER; end
if isfield(pltopts,'fignum'), PLTOPTSFIGNUM = pltopts.fignum; end

DatFullFname = fullfile(DATAFOLDER, DataFile);
Data = dlmread(DatFullFname,DATASEPARATOR); % read the data
Y= Data(:,1);
X = Data(:,2:end);
%W = ones(length(Y),1);      % data impotance weights for weighted regression, not used for now

% get the registry (list of the models elements and the initial population of models 
RegistryFullFname = fullfile(DATAFOLDER, RegistryFile);
ModelsFullFname   = fullfile(DATAFOLDER, ModelsFile);
[Registry, models, wInits] = DownloadRegModels(RegistryFullFname, ModelsFullFname);

% to make continued computations and use results of the prevoius sessions
if strcmp(CONTINUED,'on')
    Population = load(fullfile(REPORTFOLDER, PopulationFile)); % The population is supposed to be tuned
    Population = Population.Population;                      % Restore initial structure
    MdlBase    = load(fullfile(REPORTFOLDER, ModelBaseFile));  % The file exists
    MdlBase    = MdlBase.MdlBase;                            % Restore initial structure  
else
    Population = CreatePopulation(Registry, models, wInits);
    %Population = InitFunctionPopulation(registry, mdlpop);  % create the population; obsolete 
    Population = RefreshTreeInfo(Population, Y, X, nlinopts, pltopts); % refresh parameters, function string, etc.
    MdlBase    = KeepModelsBase(Population, []);
end

% Make the TeX file to illustrate the initial Models
Population2TeX(Population, fullfile(REPORTFOLDER, 'ListOfInitialModels.tex'));

% the main iterations
for ii = 1:MAXCYCLECOUNT    
    NewPopulation = CrossingPopulation2(Population, MdlBase, CROSSINGAMOUNT, MAXNUMOFPARAMS, MAXNUMOFPRIMS);
    NewPopulation = MutationPopulation(NewPopulation, MdlBase, Registry, MUTATIONAMOUNT, MAXNUMOFPARAMS);    
    NewPopulation = RefreshTreeInfo(NewPopulation, Y, X, nlinopts, pltopts); % refresh parameters, function string, etc.
    MdlBase       = KeepModelsBase(NewPopulation, MdlBase);
    Population    = FindBestElemFromPopulation(Population, NewPopulation, BESTELEMAMOUNT);  
    %
    if Population{1,1}.errTest < THRESHOLDQUALITY
        break
    end      
    save(fullfile(REPORTFOLDER, PopulationFile), 'Population');
    save(fullfile(REPORTFOLDER, ModelBaseFile),  'MdlBase');    

    fprintf(1,'\n\n Generated: %d\n\n', length(MdlBase.errTest))
end



% print the result 
pltopts.display = 'on';
for i = 1:1 % length{Population} % - for all population
    Model = Population{1,i}
    h = plotstruct(Model.Handle, Model.wFound, X, Y, pltopts); % plot the models if 2d or 3d
    fprintf(1,'\nTest Err = %f, Model = %s\n', Model.errTest, Model.Name);
end
% Make the TeX file to illustrate the obtained Models
Population2TeX(Population, fullfile(REPORTFOLDER, 'ListOfObtainedModels.tex'));

% recover the initial state of the system
rmpath(FUNCFOLDER);
rmpath(CODEFOLDER);
warning on

return