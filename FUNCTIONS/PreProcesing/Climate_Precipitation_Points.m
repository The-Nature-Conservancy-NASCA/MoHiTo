function Climate_Precipitation_Points(UserData)
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
if UserData.Parallel == 1
    try
       myCluster                = parcluster('local');
       myCluster.NumWorkers     = UserData.CoresNumber;
       saveProfile(myCluster);
       parpool;
    catch
    end
end

try
    %% Load ShapeFile HUA
    try
        [Basin, CodeBasin]      = shaperead(fullfile(UserData.PathProject,'DATA','Geographic','HUA',UserData.NameFile_HUA));
        XBasin                  = {Basin.X}';
        YBasin                  = {Basin.Y}';
        BoundingBox             = {Basin.BoundingBox}';

        clearvars Basin

        if isfield(CodeBasin,'Code') 
            CodeBasin_Tmp = [CodeBasin.Code];
        else
            errordlg(['There is no attribute called "Code" in the Shapefile "',UserData.NameFile_HUA,'"'], '!! Error !!')
            return
        end

        [CodeBasin,PosiBasin]   = sort(CodeBasin_Tmp);
        CodeBasin               = CodeBasin';
        XBasin                  = XBasin(PosiBasin');
        YBasin                  = YBasin(PosiBasin');
        BoundingBox             = BoundingBox(PosiBasin');

        clearvars CodeBasin_Tmp
    catch
        errordlg(['The Shapefile "',UserData.NameFile_HUA,'" not found'],'!! Error !!')
        return
    end
    
    % -------------------------------------------------------------------------
    % Parameter  Model
    % -------------------------------------------------------------------------
    ProgressBar     = waitbar(0, 'Load Parameters Model ...');
    % Load Parameters Model
    try
        Tmp = dlmread( fullfile(UserData.PathProject,'DATA','Parameters','Parameters.csv'), ',',1,0);
        [~, Poo]    = sort(Tmp(:,1));    
        Tmp         = Tmp(Poo,:);
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
    ArcID          = Tmp(:,1);
    BasinArea      = Tmp(:,2);    
    
    waitbar(1)
    close(ProgressBar)
    
    %% Lineal Equation 
    Top_Min = 3;
    Top_Max = round(sqrt(max(BasinArea)/(250*250)),0) + 2;
    
    Params  = polyfit([ min(BasinArea)  max(BasinArea)], [Top_Min Top_Max],1);
        
    %% Data Type - Points        
    % Progres Process
    % --------------
    ProgressBar     = waitbar(0,'Processing Precipitation - Please wait...');

    Cont = 1;

    % Scenarios by Demand
    Tmp         = cell2mat(UserData.Scenarios(:,2));
    Tmp1        = cell2mat(UserData.Scenarios(:,3));
    DateInit    = UserData.Scenarios(:,4);
    DateEnd     = UserData.Scenarios(:,5);
    Scenarios   = Tmp(Tmp1==1);
    DateInit    = DateInit(Tmp1==1);
    DateEnd     = DateEnd(Tmp1==1);

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

        % Load Data
        try
            Tmp     = xlsread( fullfile(UserData.PathProject,'DATA','Parameters','Configure.xlsx'), 'Gauges_Catalog');
            Catalog = Tmp(:,[1 4 5 6 ]); 
        catch
            close(ProgressBar)
            errordlg(['The File "',UserData.GaugesCatalog,'" not found'],'!! Error !!')
            return
        end

        CodeGauges  = Data(1,:)';
        Data        = Data(2:end,:);
        DateTmp     = DateTmp(2:length(Data(:,1))+1,1);
        [~, posi]   = ismember(CodeGauges, Catalog(:,1));

        XCatalog    = Catalog(posi,2);
        YCatalog    = Catalog(posi,3);

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
        Data        = Data(PosiDate,:);
        Values      = NaN(length(Date),length(CodeBasin));

        %% PRECIPITATION
        Xp = cell(length(CodeBasin),1);
        Yp = cell(length(CodeBasin),1);

        if UserData.Parallel
            parfor k = 1:length(CodeBasin) 
                ExtentBasin = BoundingBox{k};
                x           = linspace(ExtentBasin(1,1), ExtentBasin(2,1),polyval(Params, BasinArea(k)));
                y           = linspace(ExtentBasin(2,2), ExtentBasin(1,2),polyval(Params, BasinArea(k)));
                [x, y]      = meshgrid(x, y);
                x           = reshape(x,[],1);
                y           = reshape(y,[],1);
                id          = inpolygon(x, y, XBasin{k}, YBasin{k});

                Xp{k}       = x(id);
                Yp{k}       = y(id);

            end
        else 
            for k = 1:length(CodeBasin) 
                ExtentBasin = BoundingBox{k};
                x           = linspace(ExtentBasin(1,1), ExtentBasin(2,1),polyval(Params, BasinArea(k)));
                y           = linspace(ExtentBasin(2,2), ExtentBasin(1,2),polyval(Params, BasinArea(k)));
                [x, y]      = meshgrid(x, y);
                x           = reshape(x,[],1);
                y           = reshape(y,[],1);
                id          = inpolygon(x, y, XBasin{k}, YBasin{k});

                Xp{k}       = x(id);
                Yp{k}       = y(id);

            end
        end

        clearvars x y id

        if UserData.Parallel
            for w = 1:length(Data(:,1))

                vstruct = SemivariogramSetting(XCatalog, YCatalog, Data(w,:)');
                DataTmp = Data(w,:)';

                parfor k = 1:length(CodeBasin) 
                    Values(w,k) = nanmean(PrecipitationFields(XCatalog, YCatalog, DataTmp, Xp{k}, Yp{k}, vstruct));
                end

                % Progres Process
                % --------------
                waitbar(Cont / ((length(Data(:,1)) * length(Scenarios))))
                Cont = Cont + 1;
            end
        else
            for w = 1:length(Data(:,1))

                vstruct = SemivariogramSetting(XCatalog, YCatalog, Data(w,:)');
                DataTmp = Data(w,:)';

                for k = 1:length(CodeBasin) 
                    Values(w,k) = nanmean(PrecipitationFields(XCatalog, YCatalog, DataTmp, Xp{k}, Yp{k}, vstruct));
                end

                % Progres Process
                % --------------
                waitbar(Cont / ((length(Data(:,1)) * length(Scenarios))))
                Cont = Cont + 1;
            end
        end

        % ---------------------------------------------------------
        % Filter
        % ---------------------------------------------------------
        NumYear = length(unique(year(datetime(Date,'ConvertFrom','datenum'))));
        DataTmp = NaN((NumYear*12),1);
        nm      = length(Date);
        DDate   = datetime(Date,'ConvertFrom','datenum');
        nn      = month(DDate(1));

        for k = 1:length(CodeBasin)
            DataTmp(nn:(nm + nn - 1)) = Values(:,k);

            Tmp = reshape(DataTmp,12,[])';

            for f = 1:12
                RI = quantile(Tmp(:,f),0.75) - quantile(Tmp(:,f),0.25);
                id = Tmp(:,f) > (quantile(Tmp(:,f),0.75) + (1.5*RI));

                Tmp(id,f) = NaN;
                if sum(id) ~= 0
                    Tmp(id,f) = unique(max(Tmp(:,f)));
                end

                id = Tmp(:,f) < (quantile(Tmp(:,f),0.25) - (1.5*RI));

                Tmp(id,f) = NaN;
                if sum(id) ~= 0
                    Tmp(id,f) = unique(min(Tmp(:,f)));
                end

            end
            Yupi = reshape(Tmp',[],1);
            Values(:,k) = Yupi(1:length(Date));
        end

        
        %% Check NAN
        if sum( isnan(reshape(Values,[],1)) ) > 0
            warndlg(['The processing has been carried out successfully,'...
                    'however, the supplied ',...
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