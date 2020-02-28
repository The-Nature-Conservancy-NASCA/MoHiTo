function UserData = LoadData_Calibration_Validation(UserData, Sce)
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

    %% Crate Folder 
    mkdir(fullfile(UserData.PathProject, 'FIGURES','Calibration'))
    mkdir(fullfile(UserData.PathProject, 'FIGURES','Validation'))
    mkdir(fullfile(UserData.PathProject, 'RESULTS','Parameters_Model'))
    mkdir(fullfile(UserData.PathProject, 'RESULTS','Parameters_Model','Parameters'))
    mkdir(fullfile(UserData.PathProject, 'RESULTS','Parameters_Model','AllEvals'))
    
    %% SCENARIOS
    % Scenarios by Demand
    Tmp         = cell2mat(UserData.Scenarios(:,2));    
    DateInit    = UserData.Scenarios(:,4);
    DateEnd     = UserData.Scenarios(:,5);
    
    [~, id]         = ismember( Sce, Tmp);
    Date1           = datetime(['01-',DateInit{id},' 00:00:00'],'InputFormat','dd-MM-yyyy HH:mm:ss');
    Date2           = datetime(['01-',DateEnd{id},' 00:00:00'],'InputFormat','dd-MM-yyyy HH:mm:ss');
    UserData.Date   = (Date1:calmonths:Date2)';

    %% INPUT DATA
    % -------------------------------------------------------------------------
    % SCE main configuration
    % -------------------------------------------------------------------------
    ProgressBar     = waitbar(0, 'Load Parameters of the Shuffled Complex Evolution ...');
    try
        Tmp = xlsread( fullfile(UserData.PathProject,'DATA','Parameters','Configure.xlsx'), 'Params_SCE');
    catch
        close(ProgressBar)
        errordlg('The Configure.xlsx not found or there are erroneous values in the Params_SCE sheet','!! Error !!')
        return
    end

    if sum(isnan(Tmp)) > 0
        close(ProgressBar)
        errordlg('There are erroneous values in the Params_SCE sheet of the Configure.xlsx file','!! Error !!')  
        return
    end

    waitbar(0.5)

    % parallel version: false or 0, true or otherwise
    if UserData.Parallel
        UserData.parRuns    = 1; %true;
    else
        UserData.parRuns    = 0; %true;
    end
    % Define pop_ini to force initial evaluation of this population. Values
    % must be in real limits, otherwise pop_ini must be empty
    UserData.pop_ini        = [];
    % Maximum number of experiments or evaluations
    UserData.maxIter        = Tmp(1); 
    % ncomp: number of complexes (sub-pop.)- between 2 and 20
    UserData.ncomp          = Tmp(2);
    % Months no incluide in the calibration and validation
    UserData.nt             = 5;

    waitbar(1)
    close(ProgressBar)

    % -------------------------------------------------------------------------
    % Limit Parameters
    % -------------------------------------------------------------------------
    ProgressBar     = waitbar(0, 'Load Parameters of the Shuffled Complex Evolution ...');
    try
        Tmp = xlsread( fullfile(UserData.PathProject,'DATA','Parameters','Configure.xlsx'), 'RangeParams');
    catch
        close(ProgressBar)
        errordlg('The Configure.xlsx not found or there are erroneous values in the RangeParams sheet','!! Error !!')
        return
    end

    if sum(isnan(Tmp),2) > 0
        close(ProgressBar)
        errordlg('There are erroneous values in the RangeParams sheet of the Configure.xlsx file','!! Error !!')  
        return
    end

    waitbar(0.5)

    UserData.a_min       = Tmp(1,1);     UserData.a_max       = Tmp(1,2);
    UserData.b_min       = Tmp(2,1);     UserData.b_max       = Tmp(2,2);
    UserData.c_min       = Tmp(3,1);     UserData.c_max       = Tmp(3,2);
    UserData.d_min       = Tmp(4,1);     UserData.d_max       = Tmp(4,2);
    UserData.Q_Umb_min   = Tmp(5,1);     UserData.Q_Umb_max   = Tmp(5,2);
    UserData.V_Umb_min   = Tmp(6,1);     UserData.V_Umb_max   = Tmp(6,2);
    UserData.Trp_min     = Tmp(7,1);     UserData.Trp_max     = Tmp(7,2);
    UserData.Tpr_min     = Tmp(8,1);     UserData.Tpr_max     = Tmp(8,2);
    UserData.ExtSup_min  = Tmp(9,1);     UserData.ExtSup_max  = Tmp(9,2);

    waitbar(1)
    close(ProgressBar)

    % -------------------------------------------------------------------------
    % Calibration Streamflow
    % -------------------------------------------------------------------------
    ProgressBar     = waitbar(0, 'Load Date by Calibration and Validation ...');
    try
        [Tmp, TmpDate] = xlsread( fullfile(UserData.PathProject,'DATA','Parameters','Configure.xlsx'), 'Calibration_Validation');
    catch
        close(ProgressBar)
        errordlg('The Excel Configure.csv not found','!! Error !!')
        return
    end

    UserData.CodeGauges = Tmp(:,1);
    UserData.ArIDGauges = Tmp(:,2);
    UserData.CatGauges  = Tmp(:,3);

    TmpDate = TmpDate(3:(length(UserData.CodeGauges) + 2),4:7);

    UserData.DateCal_Init = datetime;
    UserData.DateCal_End  = datetime;
    for dt = 1:length(UserData.CodeGauges)
        try
            Tmp = datetime(['01-',TmpDate{dt,1},' 00:00:00'],'InputFormat','dd-MM-yyyy HH:mm:ss');
            if Tmp > UserData.Date(1)
                UserData.DateCal_Init(dt)    = Tmp;
            else
                UserData.DateCal_Init(dt)    = UserData.Date(1);
            end

            Tmp = datetime(['01-',TmpDate{dt,2},' 00:00:00'],'InputFormat','dd-MM-yyyy HH:mm:ss');
            if Tmp > UserData.Date(end)
                UserData.DateCal_End(dt)     = UserData.Date(end);
            else
                UserData.DateCal_End(dt)     = Tmp;
            end

        catch
            close(ProgressBar)
            errordlg('The date has not been entered in the correct format. See Configure.xlsx file - Calibration_Validation sheet','!! Error !!')
            return
        end
        waitbar( dt/ (2*length(UserData.CodeGauges)))
    end

    UserData.DateVal_Init = datetime;
    UserData.DateVal_End  = datetime;

    for dt = 1:length(UserData.CodeGauges)
        if ~strcmp(TmpDate{dt,3},'NaN')
            try            
                Tmp = datetime(['01-',TmpDate{dt,3},' 00:00:00'],'InputFormat','dd-MM-yyyy HH:mm:ss');
                if Tmp > UserData.Date(1)
                    UserData.DateVal_Init(dt)    = Tmp;
                else
                    UserData.DateVal_Init(dt)    = UserData.Date(1);
                end

                Tmp = datetime(['01-',TmpDate{dt,4},' 00:00:00'],'InputFormat','dd-MM-yyyy HH:mm:ss');
                if Tmp > UserData.Date(end)
                    UserData.DateVal_End(dt)     = UserData.Date(end);
                else
                    UserData.DateVal_End(dt)     = Tmp;
                end
            catch
                close(ProgressBar)
                errordlg('The date has not been entered in the correct format. See Configure.xlsx file- Calibration_Validation sheet','!! Error !!')
                return
            end
        else
            UserData.DateVal_Init(dt)    = UserData.DateNaN;
            UserData.DateVal_End(dt)     = UserData.DateNaN;
        end
        waitbar( (dt + length(UserData.CodeGauges)/ (2*length(UserData.CodeGauges))))
    end

    waitbar(1)
    close(ProgressBar)

    % -------------------------------------------------------------------------
    % LOAD STRAMFLOW DATA
    % -------------------------------------------------------------------------
    ProgressBar     = waitbar(0, 'Load Hydrological Data by Calibration and Validation ...');
    % Load Data
    try
        [Data, DateTmp] = xlsread( fullfile(UserData.PathProject,'DATA','Hydrological',UserData.NameFile_Q),...
            'Calibration');
    catch
        close(ProgressBar)
        errordlg(['The File "',UserData.NameFile_Q,'" not found'],'!! Error !!')
        return
    end

    CodeGaugesQ = Data(1,:)';
    Values      = Data(2:end,:);
    DateTmp     = DateTmp(2:length(Values(:,1))+1,1);

    % Check Codes 
    [id, pp] = ismember(UserData.CodeGauges, CodeGaugesQ);
    if sum(id) ~= length(UserData.CodeGauges)
        close(ProgressBar)
        errordlg(['There is a discrepancy between the codes of the streamflow gauges of the ',...
                   UserData.NameFile_Q,' file and the Configure.xlsx file - Calibration_Validation sheet' ],'!! Error !!')    
        return
    end

    Values = Values(:,pp);

    waitbar(0.5)

    % Check Date 
    % -------------------
    for w = 1:length(DateTmp)
        DateTmp{w} = ['01-',DateTmp{w},' 00:00:00'];        
    end

    try
        Date = datetime(DateTmp,'InputFormat','dd-MM-yyyy HH:mm:ss');
    catch
        close(ProgressBar)
        errordlg([  'The date has not been entered in the correct format.',...
                    'See ', UserData.NameFile_Q, ' file.'],'!! Error !!')
        return
    end

    [id,PosiDate] = ismember(UserData.Date, Date);
    if sum(id) ~= length(UserData.Date)
        close(ProgressBar)
        errordlg('The dates of the ',UserData.NameFile_Q,' file are not in the defined ranges in the Configure.xlsx file - Calibration_Validation sheet','!! Error !!')
        return
    end

    tmp = diff(PosiDate);
    if sum(tmp ~= 1)>0
        close(ProgressBar)
        errordlg('The dates of the ',UserData.NameFile_Q,' file are not organized chronologically','!! Error !!')
        return
    end

    UserData.RawQobs      = Values(PosiDate,:);

    waitbar(1)
    close(ProgressBar)
    
catch ME
    errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
        ME.stack(1).name, ME.stack(1).line, ME.message);
    errordlg( errorMessage )
    return
end
        