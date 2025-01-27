function Population = RefreshTreeInfo(Population, y, x, nlinopt, pltopts)
% Population = RefreshTreeInfo(Population, y, x)
% Refresh parameters, string function etc.
%
% http://strijov.com
% Eliseev, 14-dec-07
% Strijov, 29-apr-08

% FIXIT debug version
nlinopt.FunValCheck = 'off'; % Check for invalid values, such as NaN or Inf, from  the objective function [ 'off' | 'on' (default) ].
%fprintf('currently in RefreshTreeInfo \n');

for funct = 1:length(Population)
   crashflag = 0;
   Model = Population{1,funct}; % WARNING the model must be updated!
   Model = UpdateModel(Population{1,funct}); % WARNING Not shure it is needed here, better in Cross and Mutation as a part of the Model Modffication    
   fprintf(1, '\nTune: %s', Model.Name);
   Model.wFound = [];
    if ~isempty(Model.wInit)    
        %    weights=ones(size(PopulationElem.b_init));
        %    PopulationElem.b_found = nlinfit5(x,y,PopulationElem.FunctionHandle,...
        %            PopulationElem.b_found,weights,PopulationElem.b_init,statset('Display','off')); % tune parameters
       try
          [Model.wFound, r, J] = nlinfit(x,y,Model.Handle, Model.wInit, nlinopt); % find parameters           
       catch
          disp('nlinfit failed')
       end
   end
   if ~isempty(Model.wFound)    
       Model.wInit = Model.wFound;    %%%%% !!! WARNING !!! %%%%
       r(isnan(r)) = [];      
       if any(isinf(r)) || ~all(isreal(r))  % WARNING! fix it by Domain analysis
                                            % error('not all the residuals are real');
           Model.errTrain = Inf;
       else
           Model.errTrain = (r'*r)/length(r);
           Model.errTest = Model.errTrain; % duplicate the error, now there is no cross-validation procedure
           J(isnan(J(:,1)),:)=[];
           Hss = diag(inv(J'*J));
           Hss = Hss(:)';
           Model.saliency = (Model.wFound .^2 ) ./ (2 * Hss);           
           Model = UpdateTree(Model);      % return the tuned model back to population    
           Model.alpha = Saliency2Alpha(Model.Tree);
           Population{1,funct} = Model; % save back only if the tining was successfull 
           plotstruct(Model.Handle, Model.wFound, x, y, pltopts);           
       end
       fprintf(1, '\nTestError: %f', Model.errTest);        
   end
end
return