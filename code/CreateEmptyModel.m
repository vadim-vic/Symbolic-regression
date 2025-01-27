function Model = CreateEmptyModel()
% Model = CreateModel()
% create model of the predefined structure
% look the structure description below
%
% Example
% Modell = CreateModel()
%
% http://strijov.com
% Strijov, 08-may-08

Model = struct(...
'Name',     [],  ...% string, Function description for text and database presentation
'errTrain', Inf, ...% scalar, Error value for the taining data set
'errTest',  Inf, ...% scalar, Error value for the test data set
'Tree',     [],  ...% structure, see below
'Handle',   [],  ...% function, Matlab model representation for usage
'wInit',    [],  ...% row-vector, Inital parameters of the model
'wFound',   [],  ...% row-vector, Tuned parameters of the model
'wDom',     [],  ...% matrix [min max ;] domain for each parameter
'saliency', [],  ...% row-wector, Saliency of the error function for each parameters
'alpha',    [],  ...% scalar,     Hyperparameter, convolution of the saliency vector
'idCount',  0    ...% scalar,  Number of the primitives in the model 
);

% WARNING! errTrain and errTest must be +Inf or real positive scalar.
% all the rest values must be reset to +Inf immediately after the
% optimization