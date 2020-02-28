function RunModel(UserData)
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
%
% -------------------------------------------------------------------------
% INPUT DATA
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

%% INPUT DATA
try
    %% Loas Data Model
    UserData = LoadData_Model(UserData);
    
    %% SCENARIOS
    % Scenarios by Demand
    Scenario         = cell2mat(UserData.Scenarios(:,2));
    StatusScenario   = cell2mat(UserData.Scenarios(:,3));
    
    DateInit    = UserData.Scenarios(:,4);
    DateEnd     = UserData.Scenarios(:,5);

    %% Save Data
    NameBasin       = cell(1,length(UserData.ArcID) + 1);
    NameBasin{1}    = 'Date_Matlab';

    for k = 2:length(UserData.ArcID) + 1
        NameBasin{k} = ['Basin_',num2str(UserData.ArcID(k - 1))];
    end

    for Sce = 1:length(Scenario)
        
        if ~StatusScenario(Sce)
            continue
        end
        
        %% Date        
        [~, id]         = ismember( Scenario(Sce), Scenario);
        Date1           = datetime(['01-',DateInit{id},' 00:00:00'],'InputFormat','dd-MM-yyyy HH:mm:ss');
        Date2           = datetime(['01-',DateEnd{id},' 00:00:00'],'InputFormat','dd-MM-yyyy HH:mm:ss');
        UserData.Date   = (Date1:calmonths:Date2)';
        
        UserData        = LoadData_Climate_Demand(UserData, Scenario(Sce));
        
        %% RUN MODEL
        UserData.PoPis = ones(length(UserData.a), 1);
        [UserData.VAc,...
         UserData.Esc,...
         UserData.ETR,...
         UserData.StatesMT,...
         UserData.StatesMF] = HMO(  UserData.Date,...
                                    UserData.P,...
                                    UserData.ETP,...
                                    UserData.DemandSup,...
                                    UserData.DemandSub,...
                                    UserData.Returns,...
                                    UserData.BasinArea,...
                                    UserData.FloodArea,... 
                                    UserData.ArcID,...
                                    UserData.Arc_InitNode,...
                                    UserData.Arc_EndNode,...
                                    UserData.ArcID_Downstream,...
                                    UserData.a,...
                                    UserData.b,...
                                    UserData.c,...
                                    UserData.d,...
                                    UserData.Tpr,...
                                    UserData.Trp,...
                                    UserData.Q_Umb,...
                                    UserData.V_Umb,...
                                    UserData.IDExtAgri,...
                                    UserData.IDExtDom,...
                                    UserData.IDExtLiv,... 
                                    UserData.IDExtHy,... 
                                    UserData.IDExtMin,...
                                    UserData.IDRetAgri,...
                                    UserData.IDRetDom,...
                                    UserData.IDRetLiv,...
                                    UserData.IDRetHy,...
                                    UserData.IDRetMin,...
                                    UserData.ParamExtSup,...
                                    UserData.Sw,...
                                    UserData.Sg,...
                                    UserData.Vh,...
                                    UserData.IDAq,...
                                    UserData.PoPis,...
                                    UserData.Mode);

        %% Results
%         if UserData.NumberSceCal == Scenario(Sce)
%             Qref = reshape(UserData.VAc(:,1,:),length(UserData.ArcID), length(UserData.Date))';
%         end
% 
%         if UserData.NumberSceCal == Scenario(Sce)
%             VariablesResults(Scenario(Sce), UserData, Qref)
%         else
%             VariablesResults(Scenario(Sce), UserData)
%         end

        %% Results 
        VariablesResults(Scenario(Sce), UserData)
        
    end
    

    %% Operation Completed
    [Icon,~] = imread('Completed.jpg'); 
    msgbox('Operation Completed','Success','custom',Icon);

catch ME
   errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
        ME.stack(1).name, ME.stack(1).line, ME.message);
    errordlg( errorMessage )
    return
end
