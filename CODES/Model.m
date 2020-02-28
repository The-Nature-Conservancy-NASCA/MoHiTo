function varargout = Model(varargin)
% MODEL MATLAB code for Model.fig
%      MODEL, by itself, creates a new MODEL or raises the existing
%      singleton*.
%
%      H = MODEL returns the handle to a new MODEL or the handle to
%      the existing singleton*.
%
%      MODEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODEL.M with the given input arguments.
%
%      MODEL('Property','Value',...) creates a new MODEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Model_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Model_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Model

% Last Modified by GUIDE v2.5 14-Feb-2019 16:38:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Model_OpeningFcn, ...
                   'gui_OutputFcn',  @Model_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Model is made visible.
function Model_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

%% Warning off
warning off

%% Color white Figure 
set(handles.figure1,'Color',[1 1 1])

%% Logos 
% % Logo de TNC
% axes(handles.Icons_TNC)
% Logo = imread('Logo_TNC.png');
% image(Logo);
% axis off
%  
% % Logo de SNAPP
% axes(handles.Icons_SNAPP)
% Logo = imread('Logo_SNAPP.jpg');
% image(Logo);
% axis off

% This is the a Hydrological Models designed for Orinoquia region in the 
% framework the SNAPP project
% Logo Model
axes(handles.Icons_Models)
Logo = imread('Logos.png');
image(Logo);
axis off

% Update handles structure
guidata(hObject, handles);

%% Outputs
function varargout = Model_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


%% New Project
function FlashNew_ClickedCallback(hObject, eventdata, handles)

global UserData

UserData    = struct;
Tmp         = uigetdir;
DirModel    = pwd;

if Tmp ~= 0 
    UserData.PathProject        = Tmp;
    UserData.Parallel           = false;
    UserData.Verbose            = false;
    UserData.CoresNumber        = 4;
    UserData.DemandVar          = {'Agricultural','Domestic','Livestock','Hydrocarbons','Mining'};
    UserData.ClimateVar         = {'Pcp','T','ETP'};
    UserData.NameProject        = 'Dummy_Model';
    UserData.ModeModel          = 1;
    UserData.Cal_ETP            = 1;
    UserData.Scenarios          = {'Scenario-1',1,true,'01-1985','12-2013'};
    UserData.NumberSceCal       = 1; 
    UserData.DateNaN            = datetime('01-01-1000 00:00:00','InputFormat','dd-MM-yyyy HH:mm:ss');    
    UserData.TypeFile_Pcp       = 1;
    UserData.NameFile_Pcp       = 'Precipitation.xlsx';
    UserData.TypeFile_T         = 1;
    UserData.NameFile_T         = 'Temperature.xlsx';
    UserData.TypeFile_ETP       = 1;
    UserData.NameFile_ETP       = 'Evapotranspiration.xlsx';
    UserData.NameFile_Q         = 'Hydrological.xlsx';
    UserData.NameFile_HUA       = 'HUA.shp';
    UserData.NameFile_DEM       = 'DEM.tif';
    UserData.NamesFileDm_Agri   = cell(1,2);
    UserData.NamesFileDm_Dom    = cell(1,2);
    UserData.NamesFileDm_Liv    = cell(1,2);
    UserData.NamesFileDm_Hy     = cell(1,2);
    UserData.NamesFileDm_Min    = cell(1,2);
    UserData.NameFileDm_Sub     = 'DmSub.xlsx';
    UserData.Mode               = 1;
    UserData.Inc_Agri           = false;
    UserData.Inc_Dom            = false;
    UserData.Inc_Liv            = false;
    UserData.Inc_Hy             = false;
    UserData.Inc_Min            = false;
    UserData.Inc_Sub            = false;
    UserData.Inc_R_Q            = true;
    UserData.Inc_R_P            = true;
    UserData.Inc_R_Esc          = true;
    UserData.Inc_R_ETP          = true;
    UserData.Inc_R_ETR          = true;
    UserData.Inc_R_Sw           = true;
    UserData.Inc_R_Sg           = true;
    UserData.Inc_R_Y            = true;
    UserData.Inc_R_Ro           = true;
    UserData.Inc_R_Rg           = true;
    UserData.Inc_R_Qg           = true;
    UserData.Inc_R_Ql           = true;
    UserData.Inc_R_Rl           = true;
    UserData.Inc_R_Vh           = true;
    UserData.Inc_R_Agri_Dm      = true;
    UserData.Inc_R_Dom_Dm       = true;
    UserData.Inc_R_Liv_Dm       = true;
    UserData.Inc_R_Hy_Dm        = true;
    UserData.Inc_R_Min_Dm       = true;
    UserData.Inc_R_Agri_R       = true;
    UserData.Inc_R_Dom_R        = true;
    UserData.Inc_R_Liv_R        = true;
    UserData.Inc_R_Hy_R         = true;
    UserData.Inc_R_Min_R        = true;
    UserData.Inc_R_Index        = true;
    UserData.Inc_R_TS           = true;
    UserData.Inc_R_Box          = true;
    UserData.Inc_R_Fur          = true;
    UserData.Inc_R_DC           = true;
    UserData.Inc_R_MMM          = true;   
    
    
    %% Create Folders 
    mkdir(fullfile(UserData.PathProject,'FIGURES'))
    mkdir(fullfile(UserData.PathProject,'RESULTS'))
    mkdir(fullfile(UserData.PathProject,'DATA'))
    mkdir(fullfile(UserData.PathProject,'DATA','ExcelFormat'))
    mkdir(fullfile(UserData.PathProject,'DATA','Climate'))
    mkdir(fullfile(UserData.PathProject,'DATA','Climate','Precipitation'))
    mkdir(fullfile(UserData.PathProject,'DATA','Climate','Temperature'))
    mkdir(fullfile(UserData.PathProject,'DATA','Climate','Evapotranspiration'))
    mkdir(fullfile(UserData.PathProject,'DATA','Hydrological'))
    mkdir(fullfile(UserData.PathProject,'DATA','Parameters'))
    mkdir(fullfile(UserData.PathProject,'DATA','Demand'))
    mkdir(fullfile(UserData.PathProject,'DATA','Demand','Mining'))
    mkdir(fullfile(UserData.PathProject,'DATA','Demand','Livestock'))
    mkdir(fullfile(UserData.PathProject,'DATA','Demand','Hydrocarbons'))
    mkdir(fullfile(UserData.PathProject,'DATA','Demand','Domestic'))
    mkdir(fullfile(UserData.PathProject,'DATA','Demand','Agricultural'))
    mkdir(fullfile(UserData.PathProject,'DATA','Demand','Underground'))
    mkdir(fullfile(UserData.PathProject,'DATA','Geographic'))
    mkdir(fullfile(UserData.PathProject,'DATA','Geographic','DEM'))
    mkdir(fullfile(UserData.PathProject,'DATA','Geographic','HUA'))
    mkdir(fullfile(UserData.PathProject,'DATA','Geographic','SU'))
    mkdir(fullfile(UserData.PathProject,'DATA','Geographic','SUD'))
    mkdir(fullfile(UserData.PathProject,'DATA','Geographic','OTHERS'))    
    mkdir(fullfile(UserData.PathProject,'DATA','ExcelFormat')) 
    
    % Copy Format Excel in Project
    PathFormat  = ['copy "',fullfile(DirModel,'Format-Climate.xlsx'),'" "',fullfile(UserData.PathProject,'DATA','ExcelFormat','Format-Climate.xlsx'),'"'];
    PathFormat1 = ['copy "',fullfile(DirModel,'Format-Demand.xlsx'),'" "',fullfile(UserData.PathProject,'DATA','ExcelFormat','Format-Demand.xlsx'),'"'];
    PathFormat2 = ['copy "',fullfile(DirModel,'Format-Hydrological.xlsx'),'" "',fullfile(UserData.PathProject,'DATA','ExcelFormat','Format-Hydrological.xlsx'),'"'];
    PathFormat3 = ['copy "',fullfile(DirModel,'Parameters.xlsx'),'" "',fullfile(UserData.PathProject,'DATA','ExcelFormat','Parameters.xlsx'),'"'];
    PathFormat4 = ['copy "',fullfile(DirModel,'Configure.xlsx'),'" "',fullfile(UserData.PathProject,'DATA','ExcelFormat','Configure.xlsx'),'"'];
    
    system(PathFormat)
    system(PathFormat1)
    system(PathFormat2)
    system(PathFormat3)
    system(PathFormat4)
    
    %% Configure
    UserData                = ConfigPath(UserData);
end


%% OPEN PROJECT
function FlashOpen_ClickedCallback(hObject, eventdata, handles)

global UserData

[FileName,PathName] = uigetfile('*.mat');
if PathName ~= 0
    Tmp                  = load(fullfile(PathName,FileName));
    UserData             = Tmp.UserData;
    UserData.PathProject = PathName;
    UserData             = ConfigPath(UserData);
end


%% SAVE PROJECT
function FlashSave_ClickedCallback(hObject, eventdata, handles)

global UserData

if ~isempty(UserData)
    uisave('UserData',fullfile(UserData.PathProject, UserData.NameProject))
else
    errordlg('There is no record of any project','!! Error !!')
end


%% RUN MODEL
function FlashRunModel_ClickedCallback(hObject, eventdata, handles)

global UserData

if ~isempty(UserData) && (UserData.ModeModel == 2)
    [UserData, StatusRun]   = ListResults(UserData);
    if StatusRun
        RunModel(UserData);
    end
else
    errordlg('There is no record of any project or the model is not in sumulation mode','!! Error !!')
end


%% Calibration Model
function Flash_Calibration_ClickedCallback(hObject, eventdata, handles)

global UserData

%% PARALLEL POOL ON CLUSTER
if UserData.Parallel
    ProgressBar     = waitbar(0, 'Configure Parallel Pool...');
    wbch            = allchild(ProgressBar);
    jp              = wbch(1).JavaPeer;
    jp.setIndeterminate(1)
    
    try
       myCluster                = parcluster('local');
       myCluster.NumWorkers     = UserData.CoresNumber;
       saveProfile(myCluster);
       parpool;
    catch
    end
    close(ProgressBar)
else
    poolobj = gcp('nocreate');
    delete(poolobj);
end

if ~isempty(UserData) && (UserData.ModeModel == 1)
    Calibration_Validation(UserData);
else
    errordlg('There is no record of any project or the model is not in calibration mode','!! Error !!')
end


%% Demand Processing All
function MenuProDemandAll_Callback(hObject, eventdata, handles)

global UserData

if ~isempty(UserData)
    UserData.DemandVar      = {'Agricultural','Domestic','Livestock','Hydrocarbons','Mining'};
    UserData.NameDemandVar  = {'Agri','Dom','Liv','Hy','Min'};
    Demand(UserData)
else
    errordlg('There is no record of any project','!! Error !!')
end

%% Agricultural Demand Processing
function MenuPro_Agri_Callback(hObject, eventdata, handles)

global UserData

if ~isempty(UserData)
    UserData.DemandVar      = {'Agricultural'};
    UserData.NameDemandVar  = {'Agri'};
    Demand(UserData)
    UserData.DemandVar      = {'Agricultural','Domestic','Livestock','Hydrocarbons','Mining'};
    UserData.NameDemandVar  = {'Agri','Dom','Liv','Hy','Min'};
else
    errordlg('There is no record of any project','!! Error !!')
end


%% Domestic Demand Processing
function MenuPro_Dom_Callback(hObject, eventdata, handles)

global UserData

if ~isempty(UserData)
    UserData.DemandVar      = {'Domestic'};
    UserData.NameDemandVar  = {'Dom'};
    Demand(UserData)
    UserData.DemandVar      = {'Agricultural','Domestic','Livestock','Hydrocarbons','Mining'};
    UserData.NameDemandVar  = {'Agri','Dom','Liv','Hy','Min'};
else
    errordlg('There is no record of any project','!! Error !!')
end


%% Livestock Demand Processing
function MenuPro_Liv_Callback(hObject, eventdata, handles)

global UserData

if ~isempty(UserData)
    UserData.DemandVar      = {'Livestock'};
    UserData.NameDemandVar  = {'Liv'};
    Demand(UserData)
    UserData.DemandVar      = {'Agricultural','Domestic','Livestock','Hydrocarbons','Mining'};
    UserData.NameDemandVar  = {'Agri','Dom','Liv','Hy','Min'};
else
    errordlg('There is no record of any project','!! Error !!')
end


%% Hydrocarbons Demand Processing
function MenuPro_Hy_Callback(hObject, eventdata, handles)

global UserData

if ~isempty(UserData)
    UserData.DemandVar      = {'Hydrocarbons'};
    UserData.NameDemandVar  = {'Hy'};
    Demand(UserData)
    UserData.DemandVar      = {'Agricultural','Domestic','Livestock','Hydrocarbons','Mining'};
    UserData.NameDemandVar  = {'Agri','Dom','Liv','Hy','Min'};
else
    errordlg('There is no record of any project','!! Error !!')
end


%% Mining Demand Processing
function MenuPro_Min_Callback(hObject, eventdata, handles)

global UserData

if ~isempty(UserData)
    UserData.DemandVar      = {'Mining'};
    UserData.NameDemandVar  = {'Min'};
    Demand(UserData)
    UserData.DemandVar      = {'Agricultural','Domestic','Livestock','Hydrocarbons','Mining'};
    UserData.NameDemandVar  = {'Agri','Dom','Liv','Hy','Min'};
else
    errordlg('There is no record of any project','!! Error !!')
end


%% Climate Processing All
function MenuProClimateAll_Callback(hObject, eventdata, handles)

global UserData

if ~isempty(UserData)
    % Precipitation
    if UserData.TypeFile_Pcp == 1
        Climate_Precipitation_Points(UserData)
    elseif UserData.TypeFile_Pcp == 2
        Climate_Precipitation_Time(UserData)
    end

    % Evapotranspiration
    if UserData.Cal_ETP == 1
        % False
        UserData.Mode = 3;
    else
        % True
        UserData.Mode = 2;
    end

    if eval(['UserData.TypeFile_',UserData.ClimateVar{UserData.Mode}]) == 1
        Climate_Evapotranspitation_Points(UserData)
    elseif eval(['UserData.TypeFile_',UserData.ClimateVar{UserData.Mode}]) == 2
        Climate_Evapotranspitation_Time(UserData)
    end

else
    errordlg('There is no record of any project','!! Error !!')
end


%% Precipitation Processing
function MenuPro_P_Callback(hObject, eventdata, handles)

global UserData

if ~isempty(UserData)
    if UserData.TypeFile_Pcp == 1
        Climate_Precipitation_Points(UserData)
    elseif UserData.TypeFile_Pcp == 2
        Climate_Precipitation_Time(UserData)
    end
else
    errordlg('There is no record of any project','!! Error !!')
end


%% Temperature and Evapotranspiration Processing
function MenuPro_T_ETP_Callback(hObject, eventdata, handles)

global UserData

if ~isempty(UserData)
    % Evapotranspiration
    if UserData.Cal_ETP == 1
        % False
        UserData.Mode = 3;
    else
        % True
        UserData.Mode = 2;
    end

    if eval(['UserData.TypeFile_',UserData.ClimateVar{UserData.Mode}]) == 1
        Climate_Evapotranspitation_Points(UserData)
    elseif eval(['UserData.TypeFile_',UserData.ClimateVar{UserData.Mode}]) == 2
        Climate_Evapotranspitation_Time(UserData)
    end

else
    errordlg('There is no record of any project','!! Error !!')
end


%% Edit Menu
function FlashEdit_ClickedCallback(hObject, eventdata, handles)

global UserData

if ~isempty(UserData)
    UserData = ConfigPath(UserData);
    save(fullfile(UserData.PathProject, UserData.NameProject),'UserData')
else
    errordlg('There is no record of any project','!! Error !!')
end

%% Help
function FlashHelp_ClickedCallback(hObject, eventdata, handles)

%% MENU PROCESSING
function MenuProcessing_Callback(hObject, eventdata, handles)
function MenuProClimate_Callback(hObject, eventdata, handles)
function MenuProDemand_Callback(hObject, eventdata, handles)
function figure1_SizeChangedFcn(hObject, eventdata, handles)
