function VariablesResults(Sce,UserData, varargin)
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
%                              INPUT DATA 
% -------------------------------------------------------------------------
%   
%   Sce         [double]   : scenario Number
%   UserData    [Struct]   : Data Struct 

%% ADD VALUE TO SHAUserData.PEFILE HUA
% Progress
ProgressBar     = waitbar(0, 'Export Data ...');

warning off
if nargin > 2, Qref = varargin{1}; Inc_Index = 1; else, Inc_Index = 0; end

mkdir(fullfile(UserData.PathProject,'RESULTS','Models'))
mkdir(fullfile(UserData.PathProject,'RESULTS','Models',['Scenario-', num2str(Sce)]))

Months          = {'ENE','FEB','MAR','ABR','MAY','JUN','JUL','AGO','SEP','OCT','NOV','DEC','YEAR'};

try
    %% Format file
    CodeBasin       = UserData.ArcID;
    Date            = datenum(UserData.Date);

    M               = month(UserData.Date);

    NameBasin       = cell(1,length(CodeBasin) + 1);
    NameBasin{1}    = 'Date_Matlab';
    for k = 2:length(CodeBasin) + 1
        NameBasin{k} = ['Basin_',num2str(CodeBasin(k - 1))];
    end

    NameDate    = cell(1,length(Date));
    for k = 1:length(Date)
        NameDate{k} = datestr(Date(k),'dd-mm-yyyy');
    end

    UserData.PosiVAc         = []; 
    UserData.PosiSta         = []; 
    Co                  = 1;
    ResultsMMM          = NaN(length(CodeBasin),1);
    NameMMM             = {'Code'};

    %% Streamflow
    if UserData.Inc_R_Q         == 1
        Results = reshape(UserData.VAc(:,1,:), length(CodeBasin), length(Date));

        for i = 1:12
            ResultsMMM(:,Co) = nanmean(Results(:,M == i),2);
            NameMMM{Co+1} = ['Q_',Months{i}];
            Co = Co + 1; 
        end

        ResultsMMM(:,Co)    = nanmean(Results,2);
        NameMMM{Co+1}         = 'Q_Year';
        Co = Co + 1;

        Results = array2table([Date Results'],'VariableNames',NameBasin,'RowNames',NameDate);

        writetable(Results,...
            fullfile(UserData.PathProject,'RESULTS','Models',['Scenario-', num2str(Sce)],'Q.csv'), 'WriteRowNames',true) 
    end 
    
    % ---------------------
    % Progress
    waitbar(1/15)
    
    %% Runoff - Streamflow
    if UserData.Inc_R_Q         == 1
        Results = reshape(UserData.VAc(:,end,:), length(CodeBasin), length(Date));

        for i = 1:12
            ResultsMMM(:,Co) = nanmean(Results(:,M == i),2);
            NameMMM{Co+1} = ['Q_R_',Months{i}];
            Co = Co + 1; 
        end

        ResultsMMM(:,Co)    = nanmean(Results,2);
        NameMMM{Co+1}         = 'Q_R_Year';
        Co = Co + 1;

        Results = array2table([Date Results'],'VariableNames',NameBasin,'RowNames',NameDate);

        writetable(Results,...
            fullfile(UserData.PathProject,'RESULTS','Models',['Scenario-', num2str(Sce)],'Q_R.csv'), 'WriteRowNames',true) 
    end 
    
    % ---------------------
    % Progress
    waitbar(2/15)
   
    %% Demand or Returns
    Name    = {'Dm','R'};
    Name1   = {'Agri_','Dom_','Liv_','Hy_','Min_'};

    for j = 1:length(Name)
        Cu      = 1;
        for k = 1:length(Name1)

            if eval(['UserData.Inc_R_',Name1{k},Name{j}])
                Results = UserData.DemandSup(:,:,Cu)';
                for i = 1:12
                    ResultsMMM(:,Co)    = mean(Results(:,M == i),2,'omitnan');
                    NameMMM{Co+1}       = [Name1{k},Name{j},'_',Months{i}];
                    Co = Co + 1; 
                end

                ResultsMMM(:,Co)    = sum(Results,2,'omitnan');
                NameMMM{Co+1}       = [Name1{k},Name{j},'_Year'];
                Co = Co + 1;
            end 
            Cu = Cu + 1;
        end
    end
    
    % ---------------------
    % Progress
    waitbar(3/15)
    
    %% Runoff
    if UserData.Inc_R_Esc   
        for i = 1:12
            ResultsMMM(:,Co)    = mean(UserData.Esc(M == i,:)',2,'omitnan');
            NameMMM{Co+1}       = ['Esc_',Months{i}];
            Co = Co + 1; 
        end

        ResultsMMM(:,Co)        = sum(UserData.Esc',2,'omitnan');
        NameMMM{Co+1}           = 'Esc_Year';
        Co = Co + 1;

        Results = array2table([Date UserData.Esc],'VariableNames',NameBasin,'RowNames',NameDate);

        writetable(Results,...
            fullfile(UserData.PathProject,'RESULTS','Models',['Scenario-', num2str(Sce)],'Esc.csv'), 'WriteRowNames',true) 
    end

    % ---------------------
    % Progress
    waitbar(4/15)
    
    %%  UserData.PreciPitation
    if UserData.Inc_R_P     
        for i = 1:12
            ResultsMMM(:,Co)    = mean(UserData.P(M == i,:)',2,'omitnan');
            NameMMM{Co+1}       = ['P_',Months{i}];
            Co = Co + 1; 
        end

        ResultsMMM(:,Co)        = sum(UserData.P',2,'omitnan');
        NameMMM{Co+1}           = 'P_Year';
        Co = Co + 1;

    end 
    
    % ---------------------
    % Progress
    waitbar(5/15)
    
    %% UserData.Potential EvaPotransPiration
    if UserData.Inc_R_ETP   
        for i = 1:12
            ResultsMMM(:,Co)    = mean(UserData.ETP(M == i,:)',2,'omitnan');
            NameMMM{Co+1}       = ['ETP_',Months{i}];
            Co = Co + 1; 
        end

        ResultsMMM(:,Co)        = sum(UserData.ETP',2,'omitnan');
        NameMMM{Co+1}           = 'ETP_Year';
        Co = Co + 1;
    end 
    
    % ---------------------
    % Progress
    waitbar(6/15)
    
    %% Actual EvaUserData.PotransUserData.Piration
    if UserData.Inc_R_ETR  
        for i = 1:12
            ResultsMMM(:,Co)    = mean(UserData.ETR(M == i,:)',2,'omitnan');
            NameMMM{Co+1}       = ['ETR_',Months{i}];
            Co = Co + 1; 
        end

        ResultsMMM(:,Co)        = sum(UserData.ETR',2,'omitnan');
        NameMMM{Co+1}           = 'ETR_Year';
        Co = Co + 1;

        Results = array2table([Date UserData.ETR],'VariableNames',NameBasin,'RowNames',NameDate);

        writetable(Results,...
            fullfile(UserData.PathProject,'RESULTS','Models',['Scenario-', num2str(Sce)],'ETR.csv'), 'WriteRowNames',true) 
    end 
    
    % ---------------------
    % Progress
    waitbar(7/15)
    
    %% States Variables Thomas Model
    Name = {'Sw','Sg','Y','Ro','Rg','Qg'};
    for j = 1:length(Name)
        if eval(['UserData.Inc_R_',Name{j}])
            Results = UserData.StatesMT(:,:,j);

            for i = 1:12
                ResultsMMM(:,Co)    = mean(Results(M == i,:)',2,'omitnan');
                NameMMM{Co+1}       = [Name{j},'_',Months{i}];
                Co = Co + 1; 
            end

            ResultsMMM(:,Co)        = sum(Results',2,'omitnan');
            NameMMM{Co+1}           = [Name{j},'_Year'];
            Co = Co + 1;

            Results = array2table([Date Results],'VariableNames',NameBasin,'RowNames',NameDate);

            writetable(Results,...
                fullfile(UserData.PathProject,'RESULTS','Models',['Scenario-', num2str(Sce)],[Name{j},'.csv']), 'WriteRowNames',true)
        end
    end
    
    % ---------------------
    % Progress
    waitbar(8/15)
    
    %% States Variables FloodUserData.Plains Model
    Name = {'Vh','Ql','Rl'};
    for j = 1:length(Name)
        if eval(['UserData.Inc_R_',Name{j}]) 
            Results = UserData.StatesMF(:,:,1);

            for i = 1:12
                ResultsMMM(:,Co)    = mean(Results(M == i,:)',2,'omitnan');
                NameMMM{Co+1}       = [Name{j},'_',Months{i}];
                Co = Co + 1; 
            end

            ResultsMMM(:,Co)        = sum(Results',2,'omitnan');
            NameMMM{Co+1}           = [Name{j},'_Year'];
            Co = Co + 1;

            TmUserData.P         = zeros(length(Date),length(CodeBasin));
            TmUserData.P(:,:)   = Results;
            Results     = array2table([Date TmUserData.P],'VariableNames',NameBasin,'RowNames',NameDate);

            writetable(Results,...
                fullfile(UserData.PathProject,'RESULTS','Models',['Scenario-', num2str(Sce)],[Name{j},'.csv']), 'WriteRowNames',true)
        end
    end
    
    % ---------------------
    % Progress
    waitbar(9/15)
    
    %% Save Summary
    NameBasin       = cell(1,length(CodeBasin));
    for k = 1:length(CodeBasin)
        NameBasin{k} = ['Basin_',num2str(CodeBasin(k))];
    end

    Results     = array2table([CodeBasin ResultsMMM],'VariableNames',NameMMM,'RowNames',NameBasin);

    writetable(Results,...
        fullfile(UserData.PathProject,'RESULTS','Models',['Scenario-', num2str(Sce)],'Summary.csv'), 'WriteRowNames',true)


    NameBasin       = cell(1,length(CodeBasin));
    for k = 1:length(CodeBasin)
        NameBasin{k} = ['Basin_',num2str(CodeBasin(k))];
    end
    
    %% Index
    if UserData.Inc_R_Index 
        Results     = reshape(UserData.VAc(:,1,:), length(CodeBasin), length(Date))';

        if length(UserData.Date) > 24
            Index       = Q95(UserData.Date, Results);
            NameCol     = {'ArcID', 'ENE','FEB','MAR','ABR','MAY','JUN','JUL','AGO','SEP','OCT','NOV','DEC','YEAR'};
            Results1    = array2table([CodeBasin Index],'VariableNames',NameCol,'RowNames',NameBasin);

            writetable(Results1,...
            fullfile(UserData.PathProject,'RESULTS','Models',['Scenario-', num2str(Sce)],'Q95.csv'), 'WriteRowNames',true)
        end
    end
    
   
    if UserData.Inc_R_Index  && (Sce ~= UserData.NumberSceCal)
        if Inc_Index == 1
            mkdir( fullfile(UserData.PathProject,'FIGURES','Index') )
            mkdir( fullfile(UserData.PathProject,'FIGURES','Index',['Scenario-', num2str(Sce)]) )

            Results = reshape(UserData.VAc(:,1,:), length(CodeBasin), length(Date))';

            if length(UserData.Date) > 24
                Index    = IndexQ95(Qref,Results);
                NameCol  = {'ArcID','Q5', 'Q10', 'Q25', 'Q75', 'Q99'};
                Results1 = array2table([CodeBasin Index],'VariableNames',NameCol,'RowNames',NameBasin);

                writetable(Results1,...
                fullfile(UserData.PathProject,'RESULTS','Models',['Scenario-', num2str(Sce)],'Index.csv'), 'WriteRowNames',true)
            end
        end
    end
    
    % ---------------------
    % Progress
    waitbar(10/15)
    
    %% Plot TimeSeries
    if UserData.Inc_R_TS 
        if ~isempty(UserData.Interest_Points_Code)
            mkdir( fullfile(UserData.PathProject,'FIGURES','TimeSeries') )
            mkdir( fullfile(UserData.PathProject,'FIGURES','TimeSeries',['Scenario-', num2str(Sce)]) )
            Results = reshape(UserData.VAc(:,1,:), length(CodeBasin), length(Date))';
            [~,Poi] = ismember(UserData.Interest_Points_Code, CodeBasin);
            Data    = Results(:,Poi);
            TyUserData.PeVar = 0;

            for i = 1:length(UserData.Interest_Points_Code)
                Num = num2str(UserData.Interest_Points_Code(i));
                FigPlot = PlotTimeSeries(Date, Data(:,i), TyUserData.PeVar);
                saveas(FigPlot, fullfile(UserData.PathProject,'FIGURES','TimeSeries',['Scenario-', num2str(Sce)],[Num,'.jpg']) )
            end
        end
    end
    
    % ---------------------
    % Progress
    waitbar(11/15)
    
    %% Plot Boxplot
    if UserData.Inc_R_Box 
        if ~isempty(UserData.Interest_Points_Code)
            mkdir( fullfile(UserData.PathProject,'FIGURES','Boxplots') )
            mkdir( fullfile(UserData.PathProject,'FIGURES','Boxplots',['Scenario-', num2str(Sce)]) )
            Results = reshape(UserData.VAc(:,1,:), length(CodeBasin), length(Date))';
            [~,Poi] = ismember(UserData.Interest_Points_Code, CodeBasin);
            Data    = Results(:,Poi);
            TyUserData.PeDate = 0;

            if length(UserData.Date) > 24
                for i = 1:length(UserData.Interest_Points_Code)
                    Num = num2str(UserData.Interest_Points_Code(i));
                    FigPlot = PlotBoxplot(UserData.Date, Data(:,i), TyUserData.PeVar, TyUserData.PeDate);
                    saveas(FigPlot, fullfile(UserData.PathProject,'FIGURES','Boxplots',['Scenario-', num2str(Sce)],[Num,'.jpg']) )
                end
            end
        end
    end
    
    % ---------------------
    % Progress
    waitbar(12/15)
    
    %% Plot Fourier
    if UserData.Inc_R_Fur 
        if ~isempty(UserData.Interest_Points_Code)
            mkdir( fullfile(UserData.PathProject,'FIGURES','Periodogram') )
            mkdir( fullfile(UserData.PathProject,'FIGURES','Periodogram',['Scenario-', num2str(Sce)]) )
            Results = reshape(UserData.VAc(:,1,:), length(CodeBasin), length(Date))';
            [~,Poi] = ismember(UserData.Interest_Points_Code, CodeBasin);
            Data    = Results(:,Poi);

            for i = 1:length(UserData.Interest_Points_Code)
                Num = num2str(UserData.Interest_Points_Code(i));
                FigPlot = PlotPeriodogram(Date, Data(:,i));
                saveas(FigPlot, fullfile(UserData.PathProject,'FIGURES','Periodogram',['Scenario-', num2str(Sce)],[Num,'.jpg']) )
            end
        end
    end
    
    % ---------------------
    % Progress
    waitbar(13/15)
    
    %% Plot Duration Curve
    if UserData.Inc_R_DC
        if ~isempty(UserData.Interest_Points_Code)
            mkdir( fullfile(UserData.PathProject,'FIGURES','DurationCurve') )
            mkdir( fullfile(UserData.PathProject,'FIGURES','DurationCurve',['Scenario-', num2str(Sce)]) )
            Results = reshape(UserData.VAc(:,1,:), length(CodeBasin), length(Date))';
            [~,Poi] = ismember(UserData.Interest_Points_Code, CodeBasin);
            Data    = Results(:,Poi);

            for i = 1:length(UserData.Interest_Points_Code)
                Num = num2str(UserData.Interest_Points_Code(i));
                FigPlot = PlotDurationCurve(Data(:,i));
                saveas(FigPlot, fullfile(UserData.PathProject,'FIGURES','DurationCurve',['Scenario-', num2str(Sce)],[Num,'.jpg']) )
            end
        end

    end
    
    % ---------------------
    % Progress
    waitbar(14/15)
    
    %% Plot Average Time Series
    if UserData.Inc_R_MMM 
        if ~isempty(UserData.Interest_Points_Code)
            mkdir( fullfile(UserData.PathProject,'FIGURES','Monthly_Multiyear_Averages') )
            mkdir( fullfile(UserData.PathProject,'FIGURES','Monthly_Multiyear_Averages',['Scenario-', num2str(Sce)]) )
            Results = reshape(UserData.VAc(:,1,:), length(CodeBasin), length(Date))';
            [~,Poi] = ismember(UserData.Interest_Points_Code, CodeBasin);
            Data    = Results(:,Poi);
            TyUserData.PeVar = 0;

            if length(UserData.Date) > 24
                for i = 1:length(UserData.Interest_Points_Code)
                    Num = num2str(UserData.Interest_Points_Code(i));
                    FigPlot = PlotClimateMMM(UserData.Date, Data(:,i), TyUserData.PeVar);
                    saveas(FigPlot, fullfile(UserData.PathProject,'FIGURES','Monthly_Multiyear_Averages',['Scenario-', num2str(Sce)],[Num,'.jpg']) )
                end
            end
        end
    end
    
    % ---------------------
    % Progress
    waitbar(15/15)
    
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
    errordlg( errorMessage )
    return
end
