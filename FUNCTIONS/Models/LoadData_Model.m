function UserData = LoadData_Model(UserData)
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

    % -------------------------------------------------------------------------
    % Load HUA
    % -------------------------------------------------------------------------
    ProgressBar     = waitbar(0, 'Load HUA ...');
    try
        [~, CodeBasin] = shaperead( fullfile(UserData.PathProject,'DATA','Geographic','HUA',UserData.NameFile_HUA) );

        if isfield(CodeBasin,'Code') 
            CodeBasin = [CodeBasin.Code]';
        else
            close(ProgressBar);
            errordlg('There is no attribute called "Code" in the Shapefile of UAH','!! Error !!')
            return
        end

    catch
        close(ProgressBar);
        errordlg(['The Shapefile "',UserData.NameFile_HUA,'" not found'],'!! Error !!')
        return
    end
    waitbar(1)
    close(ProgressBar)

    % -------------------------------------------------------------------------
    % Parameter  Model
    % -------------------------------------------------------------------------
    ProgressBar     = waitbar(0, 'Load Parameters Model ...');
    % Load Parameters Model
    try
        Tmp = dlmread( fullfile(UserData.PathProject,'DATA','Parameters','Parameters.csv'), ',',1,0);
        [~, Poo]  = sort(Tmp(:,1));    
        Tmp       = Tmp(Poo,:);
    catch
        close(ProgressBar)
        errordlg('The Parameters.csv not found','!! Error !!')    
        return
    end

    waitbar(0.3)

    % Check Codes 
    [id, ~] = ismember(CodeBasin, Tmp(:,1));
    if sum(id) ~= length(CodeBasin)
        close(ProgressBar)
        errordlg('There is a discrepancy between the codes of the Parameters.csv and the HUA shapefile','!! Error !!')    
        return
    end

    [id, ~] = ismember(Tmp(:,1),CodeBasin);
    if sum(id) ~= length(Tmp(:,1))
        close(ProgressBar)
        errordlg('There is a discrepancy between the codes of the Parameters.csv and the HUA shapefile','!! Error !!')  
        return
    end

    waitbar(0.6)

    UserData.ArcID          = Tmp(:,1);
    UserData.BasinArea      = Tmp(:,2);
    UserData.FloodArea      = Tmp(:,2).*Tmp(:,3); % Perc to m2
    UserData.TypeBasinCal   = Tmp(:,4);
    UserData.IDAq           = Tmp(:,5);
    UserData.Arc_InitNode   = Tmp(:,6);
    UserData.Arc_EndNode    = Tmp(:,7);
    UserData.Sw             = Tmp(:,8);
    UserData.Sg             = Tmp(:,9);
    UserData.Vh             = Tmp(:,10);
    UserData.a              = Tmp(:,11);
    UserData.b              = Tmp(:,12);
    UserData.c              = Tmp(:,13);
    UserData.d              = Tmp(:,14);
    UserData.ParamExtSup    = Tmp(:,15);
    UserData.Trp            = Tmp(:,16);
    UserData.Tpr            = Tmp(:,17);
    UserData.Q_Umb          = Tmp(:,18);
    UserData.V_Umb          = Tmp(:,19);
    UserData.IDExtAgri      = Tmp(:,20);
    UserData.IDExtDom       = Tmp(:,21);
    UserData.IDExtLiv       = Tmp(:,22); 
    UserData.IDExtHy        = Tmp(:,23); 
    UserData.IDExtMin       = Tmp(:,24);
    UserData.IDRetAgri      = Tmp(:,25);
    UserData.IDRetDom       = Tmp(:,26);
    UserData.IDRetLiv       = Tmp(:,27);
    UserData.IDRetHy        = Tmp(:,28);
    UserData.IDRetMin       = Tmp(:,29);

    waitbar(1)
    close(ProgressBar)

    % -------------------------------------------------------------------------
    % River Downstream
    % -------------------------------------------------------------------------
    ProgressBar     = waitbar(0, 'Load River mouth and Interes Points ...');
    try
        Tmp = xlsread( fullfile(UserData.PathProject,'DATA','Parameters','Configure.xlsx'), 'RiverMouth');
    catch
        close(ProgressBar)
        errordlg('The Configure.xlsx not found','!! Error !!')
        return
    end

    if ~isempty(Tmp)
        [id, ~] = ismember(Tmp, UserData.ArcID);
        if sum(id) == length(id)
            UserData.ArcID_Downstream   = Tmp;
        else
            close(ProgressBar)
            errordlg('There is one or several river mouth codes that are not consistent with the HUAs','!! Error !!')
            return
        end
    else
        close(ProgressBar)
        errordlg('River mouth codes not found','!! Error !!')
        return
    end

    waitbar(0.5)

    % -------------------------------------------------------------------------
    % Interes Points
    % -------------------------------------------------------------------------
    try
        [Tmp, Tmp1] = xlsread( fullfile(UserData.PathProject,'DATA','Parameters','Configure.xlsx'), 'Interest_Points');  
    catch
        close(ProgressBar)
        errordlg(['The Excel "',UserData.DataParams,'" not found'],'!! Error !!')
        return
    end

    Tmp = Tmp(isnan(Tmp) == 0);
    if ~isempty(Tmp)
        [id, ~] = ismember(Tmp, UserData.ArcID);
        if sum(id) == length(id)
            UserData.Interest_Points_Code = Tmp;
            UserData.Interest_Points_Name = Tmp1(2:length(Tmp)+1);

        else
            close(ProgressBar)
            errordlg('There is one or several interest points codes that are not consistent with the HUAs','!! Error !!')
            return
        end
    else
        UserData.Interest_Points_Code = [];
    end

    waitbar(1)
    close(ProgressBar)
    
catch ME
    errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
        ME.stack(1).name, ME.stack(1).line, ME.message);
    errordlg( errorMessage )
    return
end
        