function [ logFile ] = saveEventsFile(input, expParameters, logFile, varargin)

if nargin<3 || isempty(logFile)
    logFile = struct();
end
    
switch input
    
    case 'open'

        logFile = struct();

        % Initialize txt logfiles and empty fields for the standard BIDS
        % event file
        logFile.eventLogFile = fopen(...
            fullfile(expParameters.outputDir, expParameters.modality, expParameters.fileName.events), ...
            'w');
        
        % print the basic BIDS columns
        fprintf(logFile.eventLogFile, '%s\t%s\t%s\t', 'onset', 'trial_type', 'duration');
        
        % print any extra column specified by the user
        % also prepare an empty field in the structure to collect data
        % for those
        for iExtraColumn = 1:numel(varargin)
            fprintf(logFile.eventLogFile,'%s\t', lower(varargin{iExtraColumn}));
        end
        
        % next line so we start printing at the right place
        fprintf(logFile.eventLogFile, '\n');
        
        
    case 'save'
        
        % appends to the logfile all the data stored in the structure 
        % first with the standard BIDS data and then any extra things
        for iEvent = 1:size(logFile.onset,1)

            fprintf(logFile.eventLogFile,'%f\t%s\t%f\t',...
                logFile.onset{iEvent,1}, ...
                logFile.trial_type{iEvent,1}, ...
                logFile.duration{iEvent,1});
            
            for iExtraColumn = 1:numel(varargin)

                % if the field we are looking for does not exist or is empty in the
                % input logFile structure we will write a NaN otherwise we
                % write its content
                
                if ~isfield(logFile, lower(varargin{iExtraColumn}))
                    data = [];
                else
                    data = getfield(logFile, lower(varargin{iExtraColumn}));
                    data = data{iEvent};
                end
                
                if isempty(data)
                    data = NaN;
                end
                     
                if ischar(data)
                    fprintf(logFile.eventLogFile, '%s\t', data);
                else
                    fprintf(logFile.eventLogFile, '%f\t', data);
                end
                
            end
            
            fprintf(logFile.eventLogFile, '\n');
        end
        
    case 'close'
        
        % close txt log file
        fclose(logFile.eventLogFile);
        
end