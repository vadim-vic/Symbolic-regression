function idx = Roulette(errs)
% idx = Roulette(errs)
% select an element proportional to its relative rand if ell errors are the
% same or Inf return a randem model
%
% errs [1,M] errors, (the little the better) could be only positive or +Inf
% no Nan, etc. allowed
% idx  [idx scalar] number of the selected model
%
% Example
% choises = zeros(1,100);
% errs = [100 98 75 74 80 Inf 120];
% for i=1:100
%   idx = Roulette(errs);
%   choises(1,i) = idx;
% end
% hist(choises);
% idx = Roulette([Inf Inf Inf Inf])
% ind = Roulette([3 3 3 3])
% ind = Roulette([2 2 2 3])

Scores = errs;
n = length(errs);
% idxInf selects the worse models
idxInf = find(isinf(Scores));
if n == length(idxInf) % all scores are Inf
     idx = floor(rand()*n+1);    
    return; 
end
% normalize the errors, convert to scores
Scores(idxInf) = NaN;
const = max(Scores) - min(Scores);
if const == 0 % all scores are the same    
     idx = floor(rand()*n+1);    
    return; 
end    
Scores = 1 - (Scores - min(Scores)) / const;
% no chances to choose the worth model after the normalisation; assume the
% woth score equals the scores of the model one better than the worth
Scores(find(Scores == 0)) = Inf; 
[tmp idxMin] = min(Scores);
% 
if isempty(idxMin),
end 
% else
Scores(isinf(Scores)) = Scores(idxMin(1)); 
% no chances to coose a model with err = Inf
Scores(idxInf) = 0;
% make a segment for each model score
ScoreSegs= [0];
for i = 1:length(errs)
    ScoreSegs(end+1) = ScoreSegs(end) + Scores(i);        
end
% normalize the scores to 1
ScoreSegs = ScoreSegs / ScoreSegs(end);
randnum = rand;
idx = find(ScoreSegs <= randnum);
idx = max(idx);
return