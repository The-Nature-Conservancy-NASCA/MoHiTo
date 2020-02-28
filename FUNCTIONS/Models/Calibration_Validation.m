function Calibration_Validation(UserData)
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
    %% Load Data 
    UserData = LoadData_Model(UserData);
    UserData = LoadData_Climate_Demand(UserData, UserData.NumberSceCal);
    UserData = LoadData_Calibration_Validation(UserData, UserData.NumberSceCal);
    
    %% CALIBRACION
    % Id Basin by Arcid Downstream
    NumberCat   = unique(UserData.CatGauges);

    SummaryCal  = [];

    Answer      = questdlg('Calibration Method', 'Calibration Model',...
                'Total','Sequential','');
    if isempty(Answer)
        [Icon,~] = imread('Completed.jpg'); 
        msgbox('Operation Completed','Success','custom',Icon);
        return
    end
    
    % Handle response
    switch Answer
        case 'Total'
            ControlCal = 0;
        case 'Sequential'
            ControlCal = 1;
    end
    
    if ControlCal == 0
        Answer      = questdlg('Calibration Method', 'Calibration Model',...
                    'Load Parameters','Calibration','');

        if isempty(Answer)
            [Icon,~] = imread('Completed.jpg'); 
            msgbox('Operation Completed','Success','custom',Icon);
            return
        end

        % Handle response
        switch Answer
            case 'Load Parameters'
                ResumeCal = 1;
            case 'Calibration'
                ResumeCal = 0;
        end  
    end
    
    TextResults = sprintf([ '------------------------------------------------------------------------------------------ \n\r',...
                            '                                         Calibration \n\r',...
                            '------------------------------------------------------------------------------------------']);
    PrintResults(TextResults,0, UserData.PathProject)
    
    %% Order
    PoPo    = zeros(length(UserData.ArcID),1); 
    PoPoID  = zeros(length(UserData.ArcID),1);
    for i = 1:length(NumberCat)

        if i > 1
            TmpTxT = '\n\r------------------------------------------------------------------------------------------';
            TextResults = sprintf([TextResults, TmpTxT]);
            PrintResults(TextResults,0, UserData.PathProject)
        end
        
        %% Gauges by Order
        id = find(UserData.CatGauges == NumberCat(i) );

        SummaryCal_i    = NaN(length(id), 22);

        for j = 1:length(id)            
            
             if ControlCal == 1
                Answer      = questdlg('Calibration HAU', 'Calibration Model',...
                    ['Station => ', num2str(UserData.CodeGauges(id(j)))],'Total','');

                if isempty(Answer)
                    [Icon,~] = imread('Completed.jpg'); 
                    msgbox('Operation Completed','Success','custom',Icon);
                    return
                end

                % Handle response
                switch Answer
                    case ['Station => ', num2str(UserData.CodeGauges(id(j)))]
                        ControlCal = 1;
                    case 'Total'
                        ControlCal = 0;
                end

                Answer      = questdlg('Calibration Method', 'Calibration Model',...
                    'Load Parameters', 'Calibration','');

                if isempty(Answer)
                    [Icon,~] = imread('Completed.jpg'); 
                    msgbox('Operation Completed','Success','custom',Icon);
                    return
                end

                % Handle response
                switch Answer
                    case 'Load Parameters'
                        ResumeCal = 1;
                    case 'Calibration'
                        ResumeCal = 0;
                end

             end
            
            % time 
            tic
            UserData.DownGauges     = UserData.ArIDGauges(id(j));
            
            %% Get Position Basin Calibration
            PoPo_i = zeros(length(UserData.ArcID),1); 
            [PoPo, PoPo_i] = GetNetwork(  UserData.ArcID,...
                                  UserData.Arc_InitNode,...
                                  UserData.Arc_EndNode,...
                                  UserData.ArIDGauges(id(j)),...
                                  PoPo, PoPo_i);
            
            PoPoID          = (PoPoID + PoPo);
            UserData.IDPoPo = (PoPoID  == 1);
            UserData.PoPo   = logical(PoPo_i);  
            UserData.PoPis  = PoPoID;
            
            %% Planicies   
            if sum(UserData.FloodArea( UserData.IDPoPo)) > 0 
                UserData.PnoP = true;
            else
                UserData.PnoP = false;
            end
            
            % Date calibration 
            ID_Po1 = find(UserData.Date == UserData.DateCal_Init(id(j)));
            ID_Po2 = find(UserData.Date == UserData.DateCal_End(id(j)));
            
            if isempty(ID_Po1) || isempty(ID_Po2)
                close(ProgressBar)
                errordlg('The calibration and analysis period dates are inconsistent','!! Error !!')
                return
            end
            
            UserData.ID_Po1 = ID_Po1;
            UserData.ID_Po2 = ID_Po2;

            % streamflow calibration
            UserData.Qobs = UserData.RawQobs(ID_Po1:ID_Po2,id(j));

            SummaryCal_i(j,1) = UserData.CodeGauges(id(j));

            % Disp Results
            TmpTxT = sprintf(['\n\r[Order = ',num2str(i),' - Control = ',num2str(j), ']  Gauges = ',num2str(UserData.CodeGauges(id(j))),'-',num2str(UserData.ArIDGauges(id(j)))]);
            TextResults = sprintf([TextResults,TmpTxT]);
            
            PrintResults(TextResults,0,UserData.PathProject)

            if ResumeCal == 1
                
                Param = dlmread( fullfile(UserData.PathProject, 'RESULTS','Parameters_Model','Parameters',...
                        [num2str(UserData.CodeGauges(id(j))),'-',num2str(UserData.DownGauges),'.csv']), ',',1,0);
                                
            else
                if UserData.PnoP
                    [Param, Bestf, ~, allEvals] = sce('Function_Obj',UserData.pop_ini,...
                                                            [UserData.a_min, UserData.b_min, UserData.c_min, UserData.d_min, UserData.Q_Umb_min, ...
                                                            UserData.V_Umb_min, UserData.Tpr_min,UserData.Trp_min, UserData.ExtSup_min],...
                                                            [UserData.a_max, UserData.b_max, UserData.c_max, UserData.d_max, UserData.Q_Umb_max,...
                                                            UserData.V_Umb_max ,UserData.Tpr_max ,UserData.Trp_max ,UserData.ExtSup_max],...
                                                            UserData.ncomp, UserData);
                else
                    [Param, Bestf, ~, allEvals] = sce('Function_Obj',UserData.pop_ini,...
                                                            [UserData.a_min, UserData.b_min, UserData.c_min, UserData.d_min, UserData.ExtSup_min],...
                                                            [UserData.a_max, UserData.b_max, UserData.c_max, UserData.d_max, UserData.ExtSup_max],...
                                                            UserData.ncomp, UserData);                                                        
                    Param = [Param(1:4),0,0,0,0,Param(5)];
                    Tmp = allEvals(:,5:6);
                    allEvals(:,7:10) = 0;
                    allEvals(:,5:6) = 0;
                    allEvals(:,9:10) = Tmp;
                end

            end
                        
            %% Save Best Parameters
            if ResumeCal == 0
                % Update Parameters table
                NameParams = 'a (Ad),b (mm),c (Ad),d (Ad), Trp (Porc),Tpr (Porc),Q_Umb (mm), V_Umb (mm), Sup (Porc)\n';

                fileID = fopen( fullfile(UserData.PathProject, 'RESULTS','Parameters_Model','Parameters',...
                                [num2str(UserData.CodeGauges(id(j))),'-',num2str(UserData.DownGauges),'.csv']),'w');
                Format = '%f,%f,%f,%f,%f,%f,%f,%f,%f';
                fprintf(fileID,NameParams);
                fprintf(fileID,Format,Param);
                fclose(fileID);

                %% Save All Evalution 
                % Update Parameters table
                NameParams = 'a (Ad),b (mm),c (Ad),d (Ad), Trp (Porc),Tpr (Porc),Q_Umb (mm), V_Umb (mm), Sup (Porc), 1 - Nash\n';

                fileID = fopen( fullfile(UserData.PathProject, 'RESULTS','Parameters_Model','AllEvals',...
                                [num2str(UserData.CodeGauges(id(j))),'-',num2str(UserData.DownGauges),'.csv']),'w');
                Format = '%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n';
                fprintf(fileID,NameParams);
                fprintf(fileID,Format,allEvals');
                fclose(fileID);
            end

            %% Parameter Asignation 
            IDPoPo_tmp = UserData.IDPoPo;
            IDPoPo_tmp(isnan(UserData.a) == 0) = 0;
            UserData.a(IDPoPo_tmp)              = Param(1);

            IDPoPo_tmp = UserData.IDPoPo;
            IDPoPo_tmp(isnan(UserData.b) == 0) = 0;
            UserData.b(IDPoPo_tmp)              = Param(2);

            IDPoPo_tmp = UserData.IDPoPo;
            IDPoPo_tmp(isnan(UserData.c) == 0) = 0;
            UserData.c(IDPoPo_tmp)              = Param(3);

            IDPoPo_tmp = UserData.IDPoPo;
            IDPoPo_tmp(isnan(UserData.d) == 0) = 0;
            UserData.d(IDPoPo_tmp)              = Param(4);
                        
            IDPoPo_tmp = UserData.IDPoPo;
            IDPoPo_tmp(isnan(UserData.Q_Umb) == 0) = 0;
            UserData.Q_Umb(IDPoPo_tmp)          = Param(5);

            IDPoPo_tmp = UserData.IDPoPo;
            IDPoPo_tmp(isnan(UserData.V_Umb) == 0) = 0;
            UserData.V_Umb(IDPoPo_tmp)          = Param(6);

            IDPoPo_tmp = UserData.IDPoPo;
            IDPoPo_tmp(isnan(UserData.Tpr) == 0) = 0;
            UserData.Tpr(IDPoPo_tmp)            = Param(7);

            IDPoPo_tmp = UserData.IDPoPo;
            IDPoPo_tmp(isnan(UserData.Trp) == 0) = 0;
            UserData.Trp(IDPoPo_tmp)            = Param(8);

            IDPoPo_tmp = UserData.IDPoPo;
            IDPoPo_tmp(isnan(UserData.ParamExtSup) == 0) = 0;
            UserData.ParamExtSup(IDPoPo_tmp)    = Param(9);
            
            if UserData.PnoP
                %% Correct Flood Plains 
                Tmp     = find(UserData.PoPo);
                JoJa    = UserData.FloodArea(Tmp) == 0;
                Tmp1    = Tmp(JoJa);
                UserData.Q_Umb(Tmp1) = 0; 
                UserData.V_Umb(Tmp1) = 0; 
                UserData.Tpr(Tmp1)   = 0; 
                UserData.Trp(Tmp1)   = 0;
            end
            
            UserData.GaugesStreamFlowQ   = UserData.CodeGauges(id(j));
            
            % Plot Calibration Series
            [Fig, SummaryCal_i(j,2:end), ResultsModel] = Plot_Eval_Model( UserData);
            
            saveas(Fig, fullfile(UserData.PathProject, 'FIGURES','Calibration',...
                [num2str(UserData.CodeGauges(id(j))),'-',num2str(UserData.DownGauges),'.jpg']))
            
            clearvars Fig           

            Nash = SummaryCal_i(j,2);
            
            if Nash < 0.4
                TmpTxT = sprintf([' ==>  #  Nash = ', num2str(Nash,'%0.3f'),'  Time = ',num2str(toc,'%0.1f'),' Seg']);
                TextResults = sprintf([TextResults,TmpTxT]);
                
                PrintResults(TextResults,0,UserData.PathProject)
            else
                TmpTxT = sprintf([' ==>     Nash = ', num2str(Nash,'%0.3f'),'  Time = ',num2str(toc,'%0.1f'),' Seg']);
                TextResults = sprintf([TextResults,TmpTxT]);
                
                PrintResults(TextResults,0,UserData.PathProject)
            end

        end
        SummaryCal = [SummaryCal; SummaryCal_i];
        
    end
        
    %% Save Calibration Metric
    NameParamsR = 'Code Gauges,Nash,AME,PDIFF,MAE,MSE,RMSE,R4MS4E,RAE,PEP,MARE,MRE,MSRE,RVE,R,CE,PBE,AARE,TS1,TS25,TS50,TS100\n';

    fileID = fopen( fullfile(UserData.PathProject, 'RESULTS','Parameters_Model','Calibration_Metric.csv'),'w');
    Format = '%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n';
    fprintf(fileID,NameParamsR);
    fprintf(fileID,Format,SummaryCal');
    fclose(fileID);
    
    %% Parameters Assignation 
    JoJaJo = find(isnan(UserData.a));
    CBNC = unique(UserData.TypeBasinCal(JoJaJo));
    if sum(CBNC) > 0
        for i = 1:length(CBNC)
            id = UserData.TypeBasinCal(JoJaJo) == CBNC(i);

            UserData.a(JoJaJo(id))      = UserData.a(UserData.ArcID == CBNC(i) );
            UserData.b(JoJaJo(id))      = UserData.b(UserData.ArcID== CBNC(i) );
            UserData.c(JoJaJo(id))      = UserData.c(UserData.ArcID== CBNC(i) );
            UserData.d(JoJaJo(id))      = UserData.d(UserData.ArcID== CBNC(i) );    
            UserData.Q_Umb(JoJaJo(id))  = UserData.Q_Umb(UserData.ArcID== CBNC(i) );
            UserData.V_Umb(JoJaJo(id))  = UserData.V_Umb(UserData.ArcID== CBNC(i) );
            UserData.Tpr(JoJaJo(id))    = UserData.Tpr(UserData.ArcID== CBNC(i) );
            UserData.Trp(JoJaJo(id))    = UserData.Trp(UserData.ArcID== CBNC(i) );
            UserData.ParamExtSup(JoJaJo(id)) = UserData.d(UserData.ArcID== CBNC(i) );
        end
    end
    
    %% Check Floodplains
    Tmp1 = UserData.FloodArea == 0;
    UserData.Q_Umb(Tmp1) = 0; 
    UserData.V_Umb(Tmp1) = 0; 
    UserData.Tpr(Tmp1)   = 0; 
    UserData.Trp(Tmp1)   = 0;
                
    % Update Parameters table
    NameParamsR = ['Code,Basin Area (m2),Flooplains Area (Porc),Type,Aquifer Code,From Node,',...
                    'To Node,Sw (mm),Sg (mm),Vh (mm),a (Ad),b (mm),c (Ad),d (Ad),Sup (Porc),',...
                    'Trp (Porc),Tpr (Porc),Q_Umb (mm),V_Umb (mm),ID_Dm_Agri,ID_Dm_Dom,ID_Dm_Liv,',...
                    'ID_Dm_Hy,ID_Dm_Min,ID_Re_Agri,ID_Re_Dom,ID_Re_Liv,ID_Re_Hy,ID_Re_Min\n'];

    ResultsParamTota = [UserData.ArcID,...
                        UserData.BasinArea,...
                        UserData.FloodArea./UserData.BasinArea,...
                        UserData.TypeBasinCal,...
                        UserData.IDAq,...
                        UserData.Arc_InitNode,...
                        UserData.Arc_EndNode,...
                        UserData.Sw,...
                        UserData.Sg,...
                        UserData.Vh,...
                        UserData.a,...
                        UserData.b,...
                        UserData.c,...
                        UserData.d,...
                        UserData.ParamExtSup,...
                        UserData.Trp,...
                        UserData.Tpr,...
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
                        UserData.IDRetMin];

    fileID = fopen( fullfile(UserData.PathProject,'RESULTS','Parameters_Model','Parameters.csv') ,'w');
    Format = '%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n';
    fprintf(fileID,NameParamsR);
    fprintf(fileID,Format,ResultsParamTota');
    fclose(fileID);

    %% VALIDATION
    % Id Basin by Arcid Downstream
    PoPo        = zeros(length(UserData.ArcID),1); 
    PoPoID      = PoPo;
    NumberCat   = unique(UserData.CatGauges);

    SummaryVal  = [];
    
    TmpTxT = sprintf(['\n\r \n\r \n\r \n\r ------------------------------------------------------------------------------------------ \n\r',...
                            '                                    Results Validation \n\r',...
                            '------------------------------------------------------------------------------------------']);
    TextResults = sprintf([ TextResults,TmpTxT]);
    
    PrintResults(TextResults,0,UserData.PathProject)

    for i = 1:length(NumberCat)

        id = find(UserData.CatGauges == NumberCat(i) );
        SummaryVal_i  = NaN(length(id), 22);

        for j = 1:length(id)

            UserData.DownGauges     = UserData.ArIDGauges(id(j));

            %% Get Position Basin
            PoPo_i = zeros(length(UserData.ArcID),1); 
            [PoPo, PoPo_i] = GetNetwork(  UserData.ArcID,...
                                  UserData.Arc_InitNode,...
                                  UserData.Arc_EndNode,...
                                  UserData.ArIDGauges(id(j)),...
                                  PoPo, PoPo_i);
            
            PoPoID          = (PoPoID + PoPo);
            UserData.IDPoPo = (PoPoID  == 1);
            UserData.PoPo   = logical(PoPo_i);  
            UserData.PoPis  = PoPoID;
            
            %% Planicies   
            if sum(UserData.FloodArea( UserData.IDPoPo)) > 0 
                UserData.PnoP = true;
            else
                UserData.PnoP = false;
            end

            % Check Validation 
            if UserData.DateVal_Init(id(j)) == UserData.DateNaN
                continue
            end

            % Date calibration 
            ID_Po1 = find(UserData.Date == UserData.DateVal_Init(id(j)));
            ID_Po2 = find(UserData.Date == UserData.DateVal_End(id(j)));
            
            if isempty(ID_Po1) || isempty(ID_Po2)
                close(ProgressBar)
                errordlg('The validation and analysis period dates are inconsistent','!! Error !!')
                return
            end

            UserData.ID_Po1 = ID_Po1;
            UserData.ID_Po2 = ID_Po2;
            
            % streamflow calibration
            UserData.Qobs = UserData.RawQobs(ID_Po1:ID_Po2,id(j));

            SummaryVal_i(j,1) = UserData.CodeGauges(id(j));

            %% Plot Validation
            [Fig, SummaryVal_i(j,2:end), ~] = Plot_Eval_Model(UserData);

            saveas(Fig, fullfile(UserData.PathProject, 'FIGURES','Validation',...
                [num2str(UserData.CodeGauges(id(j))),'-',num2str(UserData.DownGauges),'.jpg']))

            clearvars Fig

            Nash = SummaryVal_i(j,2);
            if Nash < 0.4
                TmpTxT = sprintf(['\n\r[Order = ',num2str(i),' - Control = ',num2str(j), ']  Gauges = ',num2str(UserData.ArIDGauges(id(j))),...
                    ' ==>  #  Nash = ', num2str(Nash,'%0.3f'),'  Time = ',num2str(toc,'%0.1f'),' Seg']);
                TextResults = sprintf([TextResults,TmpTxT]);
                
                PrintResults(TextResults,0,UserData.PathProject)
            else
                TmpTxT = sprintf(['\n\r[Order = ',num2str(i),' - Control = ',num2str(j), ']  Gauges = ',num2str(UserData.ArIDGauges(id(j))),...
                    ' ==>     Nash = ', num2str(Nash,'%0.3f'),'  Time = ',num2str(toc,'%0.1f'),' Seg']);
                TextResults = sprintf([TextResults,TmpTxT]);
                
                PrintResults(TextResults,0,UserData.PathProject)
            end

        end
        ik = isnan(SummaryVal_i(:,1)) == 0;
        SummaryVal_i = SummaryVal_i(ik,:);
        SummaryVal   = [SummaryVal; SummaryVal_i];
        
    end
    
    %% Save Validation Metric
    NameParamsR = 'Code Gauges,Nash,AME,PDIFF,MAE,MSE,RMSE,R4MS4E,RAE,PEP,MARE,MRE,MSRE,RVE,R,CE,PBE,AARE,TS1,TS25,TS50,TS100\n';

    fileID = fopen( fullfile(UserData.PathProject, 'RESULTS','Parameters_Model','Validation_Metric.csv'),'w');
    Format = '%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n';
    fprintf(fileID,NameParamsR);
    fprintf(fileID,Format,SummaryVal');
    fclose(fileID);
    
    %% Operation Completed
    [Icon,~] = imread('Completed.jpg'); 
    msgbox('Operation Completed','Success','custom',Icon);

catch ME
    errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
        ME.stack(1).name, ME.stack(1).line, ME.message);
    errordlg( errorMessage )
    return
end