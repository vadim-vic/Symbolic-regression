function Population = FindBestElemFromPopulation(Population, NewPopulation, BESTELEMAMOUNT)
% Population = FindBestElemFromPopulation(Population, BESTELEMAMOUNT)
% sort the population, the error increases, keep BESTELEMAMOUNT the best
%
% http://strijov.com
% Eliseev, 14-dec-07
% Strijov, 29-apr-08

%fprintf('currently in FindBestElemFromPopulation \n');

for ii = 1:length(NewPopulation)
    Population{end+1} = NewPopulation{1,ii};
end

PopulationQualityArray = zeros(1,length(Population));

for ii = 1:length(Population)
    PopulationQualityArray(ii) = Population{1,ii}.errTest;
end

[tmp,index] = sort(PopulationQualityArray);
NewPopulation = cell(1,min(BESTELEMAMOUNT,length(Population)));

for ii = 1:length(NewPopulation)
    NewPopulation{1,ii} = Population{1,index(ii)};
end

Population = NewPopulation;