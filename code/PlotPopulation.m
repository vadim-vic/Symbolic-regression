Population = load('options.pop.mat');
Population  = Population.Population;
Data = dlmread('options.dat.txt',',');
Y = Data(:,1);
X = Data(:, 2:end);

evalstr = textread('options.prj.txt','%s','commentstyle','matlab','delimiter','%');
for i=1:length(evalstr)
    try 
        eval(evalstr{i});    
        fprintf(1,'%s\n',evalstr{i});
    catch
        fprintf(1,'\nError in the project file %s, line = %d, content = %s \n', PrjFname, i, evalstr{i});
    end
end 
pltopts.display = 'on';
for i = 1:length(Population) % - for all population
    Model = Population{1,i}
    %h = plotstruct(Model.Handle, Model.wFound, X, Y, pltopts); % plot the models if 2d or 3d
    fprintf(1,'\nTest Err = %f, Model = %s\n', Model.errTest, Model.Name);
    %pause 
end
