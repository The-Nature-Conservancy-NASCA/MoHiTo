function UserData = LoadData_Climate_Demand(UserData, Sce)
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
%                               DESCRIPTION 
% -------------------------------------------------------------------------
% 
% This function perform the calibration and validation of the ABDC-FP-D 
% Model through of the Shuffled complex evolution
% 
% -------------------------------------------------------------------------
%                               INPUT DATA
% -------------------------------------------------------------------------
% UserData [Struct]
%   .ArcID               [Cat,1]         = ID of each section of the network                     [Ad]
%   .Arc_InitNode        [Cat,1]         = Initial node of each section of the network           [Ad]
%   .Arc_EndNode         [Cat,1]         = End node of each section of the network               [Ad]
%   .ArcID_Downstream    [1,1]           = ID of the end node of accumulation                    [Ad]
%   .AccumVar            [Cat,Var]       = Variable to accumulate                                
%   .AccumStatus         [Cat,Var]       = Status of the accumulation variable == AccumVar       
%   .ArcIDFlood          [CatFlood,1]    = ID of the section of the network with floodplain      [Ad]
%   .FloodArea           [CatFlood,1]    = Floodplain Area                                       [m^2]
%   .IDExtAgri           [Cat,1]         = ID of the HUA where to extraction Agricultural Demand [Ad]
%   .IDExtDom            [Cat,1]         = ID of the HUA where to extraction Domestic Demand     [Ad]
%   .IDExtLiv            [Cat,1]         = ID of the HUA where to extraction Livestock Demand    [Ad]
%   .IDExtMin            [Cat,1]         = ID of the HUA where to extraction Mining Demand       [Ad]
%   .IDExtHy             [Cat,1]         = ID of the HUA where to extraction Hydrocarbons Demand [Ad]
%   .IDRetDom            [Cat,1]         = ID of the HUA where to return Domestic Demand         [Ad]
%   .IDRetLiv            [Cat,1]         = ID of the HUA where to return Livestock Demand        [Ad]
%   .IDRetMin            [Cat,1]         = ID of the HUA where to return Mining Demand           [Ad]
%   .IDRetHy             [Cat,1]         = ID of the HUA where to return Hydrocarbons Demand     [Ad]
%   .P                   [Cat,1]         = Precipitation                                         [mm]
%   .ETP                 [Cat,1]         = Actual Evapotrasnpiration                             [mm]
%   .Vh                  [CatFlood,1]    = Volume of the floodplain Initial                      [mm]
%   .Ql                  [CatFlood,1]    = Lateral flow between river and floodplain             [mm]
%   .Rl                  [CatFlood,1]    = Return flow from floodplain to river                  [mm]
%   .Trp                 [CatFlood,1]    = Percentage lateral flow between river and floodplain  [dimensionless]
%   .Tpr                 [CatFlood,1]    = Percentage return flow from floodplain to river       [dimensionless]
%   .Q_Umb               [CatFlood,1]    = Threshold lateral flow between river and floodplain   [mm]
%   .V_Umb               [CatFlood,1]    = Threshold return flow from floodplain to river        [mm]
%   .a                   [Cat,1]         = Soil Retention Capacity                               [dimensionless]
%   .b                   [Cat,1]         = Maximum Capacity of Soil Storage                      [dimensionless]
%   .Y                   [Cat,1]         = Evapotranspiration Potential                          [mm]
%   .PoPo                [Cat,1]         = ID of the HUA to calibrate                            [Ad]
%   .PoPoFlood           [Cat,1]         = ID of the HUA to calibrate with floodplains           [Ad]
%   .ArcID_Downstream2   [1,1]           = ID of the end node of accumulation                    [Ad]
%

try
    %% Initial Weitbar
    warning off
    
    %% SCENARIOS
    % Scenarios by Demand
    Tmp         = cell2mat(UserData.Scenarios(:,2));
    
    DateInit    = UserData.Scenarios(:,4);
    DateEnd     = UserData.Scenarios(:,5);
    
    [~, id]         = ismember( Sce, Tmp);
    Date1           = datetime(['01-',DateInit{id},' 00:00:00'],'InputFormat','dd-MM-yyyy HH:mm:ss');
    Date2           = datetime(['01-',DateEnd{id},' 00:00:00'],'InputFormat','dd-MM-yyyy HH:mm:ss');
    UserData.Date   = (Date1:calmonths:Date2)';
    
    %% LOAD CLIMATE DATA
    % -------------------------------------------------------------------------
    % Precipitation 
    % -------------------------------------------------------------------------
    ProgressBar     = waitbar(0, 'Load Precipitation Data  ...');
    try
        Tmp     = readtable(fullfile(UserData.PathProject,'RESULTS','P',['Pcp_Scenario-',num2str(Sce),'.csv']),'ReadRowNames',true);
        DateTmp = Tmp.Row;
        Tmp     = table2array(Tmp);    

        Date_test       = datetime(DateTmp,'InputFormat','dd-MM-yyyy');
        [id,PosiDate]   = ismember(UserData.Date,Date_test);
        if sum(id) ~= length(UserData.Date)
            close(ProgressBar)
            errordlg([  'The dates of the Pcp_Scenario-',num2str(Sce),'.csv file are not in the defined ranges '...
                        'in the Configure.xlsx file - Calibration_Validation sheet'],'!! Error !!')
            return
        end

        UserData.P = Tmp(PosiDate,:);
    catch
        close(ProgressBar)
        errordlg('The Pcp_Scenario-',num2str(Sce),'.csv Not Found','!! Error !!')
        return
    end
    waitbar(1)
    close(ProgressBar)

    % -------------------------------------------------------------------------
    % Evapotranspiration
    % -------------------------------------------------------------------------
    ProgressBar     = waitbar(0, 'Load Evapotranspiration Data  ...');
    try
        Tmp     = readtable(fullfile(UserData.PathProject,'RESULTS','ETP',['ETP_Scenario-',num2str(Sce),'.csv']),'ReadRowNames',true);
        DateTmp = Tmp.Row;
        Tmp     = table2array(Tmp);

        Date_test     = datetime(DateTmp,'InputFormat','dd-MM-yyyy');

        [id,PosiDate] = ismember(UserData.Date,Date_test);
        if sum(id) ~= length(UserData.Date)
            close(ProgressBar)
            errordlg([  'The dates of the ETP_Scenario-',num2str(Sce),'.csv file are not in the defined ranges '...
                        'in the Configure.xlsx file - Calibration_Validation sheet'],'!! Error !!')
            return
        end

        UserData.ETP = Tmp(PosiDate,:);
    catch
        close(ProgressBar)
        errordlg('The ETP_Scenario-',num2str(Sce),'.csv Not Found','!! Error !!')
        return
    end
    waitbar(1)
    close(ProgressBar)

    %% LOAD DEMAND DATA  
    ProgressBar     = waitbar(0, 'Load Demand and Return Data  ...');
    % TOTAL SURFACE DEMAND
    UserData.DemandVar  = {'Agricultural','Domestic','Livestock','Hydrocarbons','Mining'};
    UserData.DemandSup  = zeros(length(UserData.Date), length(UserData.ArcID),length(UserData.DemandVar));
    UserData.Returns    = zeros(length(UserData.Date), length(UserData.ArcID),length(UserData.DemandVar));

    NameDemandVar = {'Agri','Dom','Liv','Hy','Min'};
    NameDm = {'UserData.DemandSup', 'UserData.Returns'};    
    for dr = 1:2
        for VarD = 1:length(UserData.DemandVar)
            if eval(['UserData.Inc_',NameDemandVar{VarD}]) == 1
                DeRe = {'Demand','Return'};
                try
                    Tmp     = readtable(fullfile(UserData.PathProject,'RESULTS','Demand',UserData.DemandVar{VarD},['Scenario-',num2str(Sce)],['Total_',DeRe{dr},'.csv']),'ReadRowNames',true);
                    DateTmp = Tmp.Row;
                    
                    Tmp     = table2array(Tmp);
                    Tmp(isnan(Tmp)) = 0;

                    Date_test     = datetime(DateTmp,'InputFormat','dd-MM-yyyy');

                    % Check Date
                    [id,PosiDate] = ismember(UserData.Date,Date_test);
                    if sum(id) ~= length(UserData.Date)
                        close(ProgressBar)
                        errordlg(['The dates of the Total_Demand.csv file - ',UserData.DemandVar{VarD},'Demand are not in the defined ranges'],'!! Error !!')
                        return
                    end

                    % value Demand
                    eval([NameDm{dr},'(:,:,',num2str(VarD),') = Tmp(PosiDate,:);']);
                catch
                    close(ProgressBar)
                    errordlg(['Total_',DeRe{dr},'.csv of ',UserData.DemandVar{VarD},'Demand Not Found'],'!! Error !!')
                    return
                end
            end

            waitbar((VarD*dr)/11)
        end
    end

    % TOTAL UNDERGROUND DEMANDA
    if UserData.Inc_Sub == 1
         % Load Data
        try
            [Data, DateTmp] = xlsread( fullfile(UserData.PathProject,'DATA','Demand','Underground-Demand',UserData.NameFileDm_Sub ),...
                ['Scenario-',num2str(Sce)]);
        catch
            close(ProgressBar)
            errordlg(['The File "',UserData.NameFileDm_Sub,'" not found'],'!! Error !!')
            return
        end

        CodeSub             = Data(1,:)';
        UserData.DemandSub  = Data(2:end,:);

        % Check Codes 
        [id, ~] = ismember(UserData.ArcID, CodeSub);
        if sum(id) ~= length(UserData.ArcID)
            close(ProgressBar)
            errordlg('There is a discrepancy between the codes of the Parameters.csv and the HUA shapefile','!! Error !!')    
            return
        end

        [id, ~] = ismember(CodeSub,UserData.ArcID);
        if sum(id) ~= length(CodeSub)
            close(ProgressBar)
            errordlg('There is a discrepancy between the codes of the Parameters.csv and the HUA shapefile','!! Error !!')  
            return
        end

        % Check Date 
        % -------------------   
        DateTmp             = DateTmp(2:length(UserData.DemandSub(:,1))+1,1);
        for w = 1:length(DateTmp)
            DateTmp{w} = ['01-',DateTmp{w},' 00:00:00'];        
        end

        try
            Date = datetime(DateTmp,'InputFormat','dd-MM-yyyy HH:mm:ss');
        catch
            close(ProgressBar)
            errordlg(['The date has not been entered in the correct format. See ',UserData.NameFileDm_Sub,' file'],'!! Error !!')
            return
        end

        [id,PosiDate] = ismember(UserData.Date, Date);
        if sum(id) ~= length(UserData.Date)
            close(ProgressBar)
            errordlg(['The dates of the ',UserData.NameFileDm_Sub,' file are not in the defined ranges'],'!! Error !!')
            return
        end

        tmp = diff(PosiDate);
        if sum(tmp ~= 1)>0
            close(ProgressBar)
            errordlg(['The dates of the ',UserData.NameFileDm_Sub,' file are not organized chronologically'],'!! Error !!')
            return
        end
        UserData.DemandSub  = UserData.DemandSub(PosiDate,:);
    else
        UserData.DemandSub  = zeros(length(UserData.Date), length(UserData.ArcID));
    end
    
    %% Save UserData    
    waitbar(1)
    close(ProgressBar)
    
catch ME
    errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
        ME.stack(1).name, ME.stack(1).line, ME.message);
    errordlg( errorMessage )
    return
end
        