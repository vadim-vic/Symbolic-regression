function NewPopulation = CrossingPopulation(Population, MdlBase, CROSSINGAMOUNT, MAXNUMOFPARAMS, MAXNUMOFPRIMS)
% NewPopulation = CrossingPopulation(Population, crossingamount, y, x)
%
% http://strijov.com

%fprintf('currently in CrossingPopulation \n');
PopSize = length(Population);

NewPopulation = {};

Tree  = Population{1,1}.Tree;

for dummy = 1:CROSSINGAMOUNT
    
    % choose 2 models from the population
    idx = floor(rand()*PopSize+1);
    Model1 = Population{1,idx};
    
    idx = floor(rand()*PopSize+1);
    Model2 = Population{1,idx};
    
    % choose subtrees
    id = floor(rand()*Model1.idCount + 1);        
    adr1 = GetSubTreeAddress(Model1.Tree, id);     
    SubTree1 = eval(['Model1.',  adr1]);

    id = floor(rand()*Model2.idCount + 1);        
    adr2 = GetSubTreeAddress(Model2.Tree, id);         
    SubTree2 = eval(['Model2.',  adr2]);
    
    % exchange subtrees -> crossover
    eval(strcat('Model1.', adr1, ' = ', 'SubTree2', ';'));
    eval(strcat('Model2.', adr2, ' = ', 'SubTree1', ';'));

    % recover model structure from obtained tree
    [Model1] = UpdateModel(Model1);
    [Model2] = UpdateModel(Model2);
    
    % check is there such model in the generated models base
    % append the new models to the new population
    % if they are not in the list of the generated functions  
    
    if length(Model1.wInit) <= MAXNUMOFPARAMS && Model1.idCount <= MAXNUMOFPRIMS
        if isempty( strmatch(Model1.Name, MdlBase.Name, 'exact') ),
          NewPopulation{1,end+1} = Model1;
        end
    end
    
    if length(Model2.wInit) <= MAXNUMOFPARAMS && Model2.idCount <= MAXNUMOFPRIMS
        if isempty( strmatch(Model2.Name, MdlBase.Name, 'exact') ),
          NewPopulation{1,end+1} = Model2;
        end
    end   
end    

if isempty(NewPopulation)
    disp('WARNING! There were no new Models append to the population');
end
    
return

