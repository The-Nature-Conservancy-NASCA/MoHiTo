function Climate_Precipitation_Time(UserData)
% -------------------------------------------------------------------------
% Matlab Version - R2018b 
% -------------------------------------------------------------------------
%                              BASE DATA 
% -------------------------------------------------------------------------
% The Nature Conservancy - TNC
% 
% Project     : Landscape planning for agro-industrial expansion in a large, 
%               well-preserved savanna: how to plan multifunctional 
%               landscapes at scale for nature and people in the Orinoquia 
%               region, Colombia
% 
% Team        : Tomas Walschburger 
%               Science Sr Advisor NASCA
%               twalschburger@tnc.org
% 
%               Carlos Andr�s Rog�liz 
%               Specialist in Integrated Analysis of Water Systems NASCA
%               carlos.rogeliz@tnc.org
%               
%               Jonathan Nogales Pimentel
%               Hydrology Specialist
%               jonathan.nogales@tnc.org
% 
% Author      : Jonathan Nogales Pimentel
% Email       : jonathannogales02@gmail.com
% Date        : November, 2017
% 
% -------------------------------------------------------------------------
% This program is free software: you can redistribute it and/or modify it 
% under the terms of the GNU General Public License as published by the 
% Free Software Foundation, either version 3 of the License, or option) any 
% later version. This program is distributed in the hope that it will be 
% useful, but WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
% ee the GNU General Public License for more details. You should have 
% received a copy of the GNU General Public License along with this program
% If not, see http://www.gnu.org/licenses/.
% -------------------------------------------------------------------------


%% Folder Resulst
warning off
mkdir(fullfile(UserData.PathProject,'RESULTS','P'))

%% PARALLEL POOL ON CLUSTER
if UserData.Parallel
    try
       myCluster                = parcluster('local');
       myCluster.NumWorkers     = UserData.CoresNumber;
       saveProfile(myCluster);
       parpool;
    catch
    end
end


try
    %% Data Type - Points        
    % Progres Process
    % --------------
    ProgressBar     = waitbar(0,'Processing Precipitation - Please wait...');

    % Scenarios by Demand
    Tmp         = cell2mat(UserData.Scenarios(:,2));
    Tmp1        = cell2mat(UserData.Scenarios(:,3));
    DateInit    = UserData.Scenarios(:,4);
    DateEnd     = UserData.Scenarios(:,5);
    Scenarios   = Tmp(Tmp1==1);
    DateInit    = DateInit(Tmp1==1);
    DateEnd     = DateEnd(Tmp1==1);

    Cont = 1;

    for i = 1:length(Scenarios)
        % Load Data
        try
            [Data, DateTmp] = xlsread( fullfile(UserData.PathProject,'DATA','Climate','Precipitation', UserData.NameFile_Pcp),...
                ['Scenario-',num2str(Scenarios(i))]);
        catch
            close(ProgressBar)
            errordlg(['The File "',UserData.NameFile_Pcp,'" not found'],'!! Error !!')
            return
        end

        CodeBasin   = Data(1,:)';
        Values      = Data(2:end,:);
        DateTmp     = DateTmp(2:length(Values(:,1))+1,1);

        % Check Date 
        % -------------------
        Date1       = datetime(['01-',DateInit{i},' 00:00:00'],'InputFormat','dd-MM-yyyy HH:mm:ss');
        Date2       = datetime(['01-',DateEnd{i},' 00:00:00'],'InputFormat','dd-MM-yyyy HH:mm:ss');
        DateModel   = (Date1:calmonths:Date2)'; 

        for w = 1:length(DateTmp)
            DateTmp{w} = ['01-',DateTmp{w},' 00:00:00'];        
        end

        try
            Date = datetime(DateTmp,'InputFormat','dd-MM-yyyy HH:mm:ss');
        catch
            errordlg('The date has not been entered in the correct format.','!! Error !!')
            return
        end

        [id,PosiDate] = ismember(DateModel, Date);
        if sum(id) ~= length(DateModel)
            errordlg('The dates of the file are not in the defined ranges','!! Error !!')
        end

        tmp = diff(PosiDate);
        if sum(tmp ~= 1)>0
            errordlg('The dates of the file are not organized chronologically','!! Error !!')
        end

        Date        = datenum(DateModel);   
        Values      = Values(PosiDate,:);

        %% NaN
        Months = month(datetime(Date,'ConvertFrom', 'datenum'));

        for k = 1:length(Values(1,:))
            Posi = find(isnan(Values(:,k)) == 1);

            for j = 1:length(Posi)
                m = Months(Posi(j));
                Values(Posi(j),k) = mean(Values(m:12:length(Values(:,1)),k),'omitnan');
            end

        end
        
        %% Check NAN
        if sum( isnan(reshape(Values,[],1)) ) > 0
            warndlg(['The processing has been carried out successfully,'...
                    'however, the supplied ',ClimateVar{UserData.Mode},...
                    ' data of the scenario',num2str(Scenarios(i)),' have inconsistencies, given ',...
                    'that the results obtained contain NaN. Please review the ',...
                    'data provided or complete the results; of not causing',...
                    ' problems in the model.'],'Warning');
        end
        
        %% Save Data Table
        NameBasin       = cell(1,length(CodeBasin));
        NameBasin{1}    = ['Basin_',num2str(CodeBasin(1))];
        for k = 2:length(CodeBasin)
            NameBasin{k} = ['Basin_',num2str(CodeBasin(k))];
        end

        NameDate    = cell(1,length(Date));
        for k = 1:length(Date)
            NameDate{k} = datestr(Date(k),'dd-mm-yyyy');
        end

        writetable(array2table(Values,'VariableNames',NameBasin,'RowNames',NameDate),...
            fullfile(UserData.PathProject,'RESULTS','P',['Pcp_Scenario-',num2str(i),'.csv']), 'WriteRowNames',true)

        % Progres Process
        % ----------------
        waitbar(Cont / length(Scenarios))
        Cont = Cont + 1;

    end

    % Progres Process
    % --------------
    close(ProgressBar);
    % --------------

    %% Operation Completed
    [Icon,~] = imread('Completed.jpg'); 
    msgbox('Operation Completed','Success','custom',Icon);
catch ME
   errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
        ME.stack(1).name, ME.stack(1).line, ME.message);
    close(ProgressBar);
    errordlg( errorMessage )
    return
end