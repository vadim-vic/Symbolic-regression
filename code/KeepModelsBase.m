function MdlBase = KeepModelsBase(Population, MdlBase)
% MdlBase = KeepModelsBase(Population)
%
% Get the new population and append to the existed database of the models
% KeepModelsBase(Population, []); creates a new MdlBase
%
% Population [structure] see InitFunctionPopulation
% MdlBase [structure]
% MdlBase.Name      {cell array of strings}, each cell is the function name
% MdlBase.wFound   {cell arrat of vectors}, each cell is the parameter vector 
% MdlBase.errTrain  [vector] each value is the correspomding quality function
% MdlBase.errTest   [vector] each value is the correspomding quality function
% 
% Example
%
% See also
%
% http://strijov.com
% Strijov, 07-may-08

if isempty(MdlBase)
    MdlBase.Name = {};
    MdlBase.wFound = {};
    MdlBase.errTest  = [];
    MdlBase.errTrain = [];    
end

for i = 1:length(Population)
    MdlBase.Name{end+1}     = Population{1,i}.Name;    
    MdlBase.wFound{end+1}   = Population{1,i}.wFound;
    MdlBase.errTest(end+1) = Population{1,i}.errTest;   
    MdlBase.errTrain(end+1) = Population{1,i}.errTrain;       
end
return