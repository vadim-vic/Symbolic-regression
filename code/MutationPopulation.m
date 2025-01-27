function Population = MutationPopulation(Population, MdlBase, Registry, MUTATIONAMOUNT, MAXNUMOFPARAMS)
% Population = MutationPopulation(Population, MdlBase, registry, mutationamount)
%
% http://strijov.com
% Eliseev, 14-dec-07
% Strijov, 29-apr-08

%global DEBAGINFOSAVE
if isempty(Population), return; end

% WARNING temporary TmpMdlBase for the items from Crossing 
% need fo avoid; that will bring errors 
TmpMdlBase = KeepModelsBase(Population, []);

%fprintf('currently in MutationPopulation \n');
PopSize = length(Population); % keep length of the population to compare the growth

for dummy = 1:MUTATIONAMOUNT    
    % choose a model for the modification
    idx = floor(rand()*PopSize+1);    
    Model = Population{1,idx};

    % find the node for the modification    
    id = floor(rand()*Model.idCount + 1);
    adr = strcat( 'Model.', GetSubTreeAddress(Model.Tree, id) );
    
    % how many arguments has the function?
    narg = eval( strcat('length(', adr, '.of);') );    
    idx2chg = find(Registry.narg == narg);
    
    % WARNING! 'x(:,1)' never changed for 'x(:,2)' since they are not in the Registry 
    if ~isempty(idx2chg) 
        idx = randperm(length(idx2chg));        
        idx2chg = idx2chg(idx(1));
        eval( strcat( adr, '.func = Registry.func{idx2chg};' ) );
        eval( strcat( adr, '.wDom = [',  num2str(Registry.wDom{idx2chg}), '];' ) );
        if length(Registry.wInit{idx2chg}) == Registry.npar(idx2chg)
            eval( strcat(adr, '.wInit = [', num2str(Registry.wInit{idx2chg}), '];' ) );
        else
            eval( strcat(adr, '.wInit = [', num2str(zeros(1,Registry.npar(idx2chg))),'];') );
        end
        % update if modification is ok 
        Model = UpdateModel(Model);
        % check if there is new model
        if length(Model.wInit) <= MAXNUMOFPARAMS
            if isempty( strmatch(Model.Name, MdlBase.Name, 'exact') )   && ...
                  isempty( strmatch(Model.Name, TmpMdlBase.Name, 'exact') ),      
              Population{1,end+1} = Model;      
            end                   
        end
    end    
end
   
if PopSize  == length(Population)
    disp('WARNING! There were no new Models append to the population');
end
return