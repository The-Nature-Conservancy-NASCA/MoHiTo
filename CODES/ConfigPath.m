function varargout = ConfigPath(varargin)
% CONFIGPATH MATLAB code for ConfigPath.fig
%      CONFIGPATH, by itself, creates a new CONFIGPATH or raises the existing
%      singleton*.
%
%      H = CONFIGPATH returns the handle to a new CONFIGPATH or the handle to
%      the existing singleton*.
%
%      CONFIGPATH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONFIGPATH.M with the given input arguments.
%
%      CONFIGPATH('Property','Value',...) creates a new CONFIGPATH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ConfigPath_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ConfigPath_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ConfigPath

% Last Modified by GUIDE v2.5 21-May-2019 09:27:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ConfigPath_OpeningFcn, ...
                   'gui_OutputFcn',  @ConfigPath_OutputFcn, ...
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


function ConfigPath_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

%% Warning off
warning off

%% Color white Figure 
set(handles.figure1,'Color',[1 1 1])

% Logo de TNC
axes(handles.axes1)
Logo = imread('Logo_TNC.png');
image(Logo);
axis off

% Update handles structure
guidata(hObject, handles);

global UserData

if nargin > 3
    
    UserData = varargin{1};

    % Name Project
    set(handles.NameProject,'String',UserData.NameProject)
    % Cores
    set(handles.NCores,'Value',UserData.CoresNumber/2)
    % Parallel
    if UserData.Parallel
        set(handles.ParPool,'Value',1)
    else
        set(handles.ParPool,'Value',2)
    end
    % Name File HUA
    set(handles.File_HUA,'String', UserData.NameFile_HUA)
    % Name File DEM
    set(handles.File_DEM,'String', UserData.NameFile_DEM)
    % Name File Precipitation 
    set(handles.File_P,'String', UserData.NameFile_Pcp)
    % Name File Underground Demand 
    set(handles.File_DmSub,'String', UserData.NameFileDm_Sub)
    % Name File Streamflow
    set(handles.File_Q,'String', UserData.NameFile_Q)
    % Mode Model 
    set(handles.ModeModel,'Value',UserData.ModeModel)     
    % Etimate Evapotranspiration
    set(handles.Cal_ETP,'Value',UserData.Cal_ETP)
    % Type File Precipitation 
    set(handles.TypeFile_P,'Value',UserData.TypeFile_Pcp)

    if UserData.Cal_ETP == 1
        % Type File Evapotranspiration 
        set(handles.TypeFile_ETP,'Value',UserData.TypeFile_ETP)
        % Name File Evapotranspiration 
        set(handles.File_ETP,'String', UserData.NameFile_ETP);
    else
        % Type File Temperature
        set(handles.TypeFile_T,'Value',UserData.TypeFile_T)
        % Name File Temperature
        set(handles.File_T,'String', UserData.NameFile_T);
    end

    % Inc of Agricultural Demand
    set(handles.Agri_checkbox,'Value',UserData.Inc_Agri)
    % Inc of Domestic Demand
    set(handles.Dom_checkbox,'Value',UserData.Inc_Dom)
    % Inc of Livestock Demand
    set(handles.Liv_checkbox,'Value',UserData.Inc_Liv)
    % Inc of Hydrocarbons Demand
    set(handles.Hy_checkbox,'Value',UserData.Inc_Hy)
    % Inc of Mining Demand
    set(handles.Min_checkbox,'Value',UserData.Inc_Min)
    % Inc of underground Demand
    set(handles.Sub_checkbox,'Value',UserData.Inc_Sub)
    
    % -----------------------------------------------------------------
    % Check block
    % -----------------------------------------------------------------
    % Modo simulation or Calibration
    value = get(handles.ModeModel,'value');
    if value == 2
        set(handles.File_Q,'Enable','off')
    else
        set(handles.File_Q,'Enable','on')
    end

    % Estimation evapotranpitation 
    value = get(handles.Cal_ETP,'value');
    if value == 1
        set(handles.File_T,'Enable','off')
        set(handles.TypeFile_T,'Enable','off')
        set(handles.File_ETP,'Enable','on')
        set(handles.TypeFile_ETP,'Enable','on')
    else
        set(handles.File_T,'Enable','on')
        set(handles.TypeFile_T,'Enable','on')
        set(handles.File_ETP,'Enable','off')
        set(handles.TypeFile_ETP,'Enable','off')
    end
    
    value  = get(handles.Cal_ETP,'Value');
    value2 = get(handles.TypeFile_T,'Value');
    value3 = get(handles.TypeFile_ETP,'Value');

    if value == 1
        if value3  == 1
            set(handles.File_DEM,'Enable','on')
        else
            set(handles.File_DEM,'Enable','off')
        end
    else
        if value2  == 1
            set(handles.File_DEM,'Enable','on')
        else
            set(handles.File_DEM,'Enable','off')
        end
    end

    % Underground demamd
    value = get(handles.Sub_checkbox,'Value');

    if value == 0
        set(handles.File_DmSub,'Enable','off')
    else
        set(handles.File_DmSub,'Enable','on')
    end

end


%% Outputs
function varargout = ConfigPath_OutputFcn(hObject, eventdata, handles) 

uiwait(gcf)
global UserData
varargout{1} = UserData;


%% Mode Model
function ModeModel_Callback(hObject, eventdata, handles)

value = get(handles.ModeModel,'value');
if value == 2
    set(handles.File_Q,'Enable','off')
else
    set(handles.File_Q,'Enable','on')
end

global UserData
% Model Mode
Va = get(handles.ModeModel,'Value');
UserData.ModeModel = Va;

function ModeModel_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Cal ETP
function Cal_ETP_Callback(hObject, eventdata, handles)

value = get(handles.Cal_ETP,'value');
if value == 1
    set(handles.File_T,'Enable','off')
    set(handles.TypeFile_T,'Enable','off')
    set(handles.File_ETP,'Enable','on')
    set(handles.TypeFile_ETP,'Enable','on')
else
    set(handles.File_T,'Enable','on')
    set(handles.TypeFile_T,'Enable','on')
    set(handles.File_ETP,'Enable','off')
    set(handles.TypeFile_ETP,'Enable','off')
end

value2 = get(handles.TypeFile_T,'Value');
value3 = get(handles.TypeFile_ETP,'Value');

if value == 1
    if value3  == 1
        set(handles.File_DEM,'Enable','on')
    else
        set(handles.File_DEM,'Enable','off')
    end
else
    if value2  == 1
        set(handles.File_DEM,'Enable','on')
    else
        set(handles.File_DEM,'Enable','off')
    end
end

global UserData

% Calculation of Evapotranspiration
UserData.Cal_ETP  = value;

if value == 1
    Va = get(handles.TypeFile_ETP,'Value');
    UserData.TypeFile_ETP = Va;
    UserData.NameFile_ETP = get(handles.File_ETP,'String');    
else
    Va = get(handles.TypeFile_T,'Value');
    UserData.TypeFile_T = Va;
    UserData.NameFile_T = get(handles.File_T,'String');   
end

function Cal_ETP_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Type File Temperature
function TypeFile_T_Callback(hObject, eventdata, handles)

global UserData

Va  = get(handles.TypeFile_T,'Value');
UserData.TypeFile_T    = Va;

function TypeFile_T_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Save Data
function Save_Callback(hObject, eventdata, handles)

global UserData

save(fullfile(UserData.PathProject,[UserData.NameProject,'.mat']), 'UserData')
close(gcf)


%% Cancel
function Cancel_Callback(hObject, eventdata, handles)
close(gcf)


%% Load Agricultural Demand Data
function LoadData_Agri_Callback(hObject, eventdata, handles)

global UserData 

Tmp = get(handles.Agri_checkbox,'Value');

if Tmp == 1
    Data = TableDemand(UserData.PathProject,1,UserData.NamesFileDm_Agri);
    UserData.NamesFileDm_Agri = Data;

else
    errordlg('Estimate Agricultural Demand - False!!','!! Error !!')
end


%% Load Domestic Demand Data
function LoadData_Dom_Callback(hObject, eventdata, handles)

global UserData 

Tmp = get(handles.Dom_checkbox,'Value');

if Tmp == 1
    Data = TableDemand(UserData.PathProject,2,UserData.NamesFileDm_Dom);
    UserData.NamesFileDm_Dom = Data;

else
    errordlg('Estimate Agricultural Demand - False!!','!! Error !!')
end


%% Load Livestock Demand Data
function LoadData_Liv_Callback(hObject, eventdata, handles)

global UserData

Tmp = get(handles.Liv_checkbox,'Value');

if Tmp == 1
    Data = TableDemand(UserData.PathProject,3,UserData.NamesFileDm_Liv);
    UserData.NamesFileDm_Liv = Data;

else
    errordlg('Estimate Agricultural Demand - False!!','!! Error !!')
end


%% Load Hydrocarbons Demand Data
function LoadData_Hy_Callback(hObject, eventdata, handles)

global UserData

Tmp = get(handles.Hy_checkbox,'Value');

if Tmp == 1
    Data = TableDemand(UserData.PathProject,4,UserData.NamesFileDm_Hy);
    UserData.NamesFileDm_Hy = Data;

else
    errordlg('Estimate Agricultural Demand - False!!','!! Error !!')
end


%% Load Mining Demand Data
function LoadData_Min_Callback(hObject, eventdata, handles)

global UserData

Tmp = get(handles.Min_checkbox,'Value');

if Tmp == 1
    Data = TableDemand(UserData.PathProject,5,UserData.NamesFileDm_Min);
    UserData.NamesFileDm_Min = Data;

else
    errordlg('Estimate Agricultural Demand - False!!','!! Error !!')
end

%% Name Project
function NameProject_Callback(hObject, eventdata, handles)

global UserData

% Name Project
UserData.NameProject = get(handles.NameProject,'String');

function NameProject_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Type File Precipitation 
function TypeFile_P_Callback(hObject, eventdata, handles)

global UserData

value = get(handles.TypeFile_P,'Value');

UserData.TypeFile_Pcp      = value;

function TypeFile_P_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Scenarios
function ScenariosRun_Callback(hObject, eventdata, handles)

global UserData

if isfield(UserData,'Scenarios')
    Data    = {};
    [DataTmp, Tmp]= TableScenarios(UserData.Scenarios, num2str(UserData.NumberSceCal));
    for i = 1:length(DataTmp(:,1))
        for j = 1:length(DataTmp(1,:))
            T = DataTmp{i,j};
            if ~isempty(T)
                Data{i,j} = T;
            end
        end
    end
    UserData.Scenarios  = Data;
    UserData.NumberSceCal     = str2num(Tmp);
else
    Data    = {};
    [DataTmp, Tmp] = TableScenarios;
    for i = 1:length(DataTmp(:,1))
        for j = 1:length(DataTmp(1,:))
            T = DataTmp{i,j};
            if ~isempty(T)
                Data{i,j} = T;
            end
        end
    end
    UserData.Scenarios  = Data;
    UserData.NumberSceCal     = str2num(Tmp);
end


%% Check Agricultural Demand Data 
function Agri_checkbox_Callback(hObject, eventdata, handles)

global UserData

Va = get(handles.Agri_checkbox,'Value');
UserData.Inc_Agri           = Va;


%% Check Domestic Demand Data
function Dom_checkbox_Callback(hObject, eventdata, handles)

global UserData

Va = get(handles.Dom_checkbox,'Value');
UserData.Inc_Dom = Va;


%% Check Livestock Demand Data
function Liv_checkbox_Callback(hObject, eventdata, handles)

global UserData

Va = get(handles.Liv_checkbox,'Value');
UserData.Inc_Liv = Va;


%% Check Hydrocarbons Demand Data
function Hy_checkbox_Callback(hObject, eventdata, handles)

global UserData

Va = get(handles.Hy_checkbox,'Value');
UserData.Inc_Hy = Va;



%% Check Mining Demand Data
function Min_checkbox_Callback(hObject, eventdata, handles)

global UserData

Va = get(handles.Min_checkbox,'Value');
UserData.Inc_Min = Va;


%% Check Underground Demand Data
function Sub_checkbox_Callback(hObject, eventdata, handles)

global UserData

value = get(handles.Sub_checkbox,'Value');

if value == 0
    set(handles.File_DmSub,'Enable','off')
else
    set(handles.File_DmSub,'Enable','on')
end

UserData.Inc_Sub = value;

%% Name File HUA
function File_HUA_Callback(hObject, eventdata, handles)

global UserData

value = get(handles.File_HUA,'String');
Tmp = strsplit(value,'.');
if strcmp(Tmp{end},'shp')
    UserData.NameFile_HUA               = value;
else
    errordlg('The file does not have the ".shp" extension','!! Error !!')
end

function File_HUA_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Name File DEM
function File_DEM_Callback(hObject, eventdata, handles)

global UserData

value = get(handles.File_DEM,'String');
Tmp = strsplit(value,'.');
if strcmp(Tmp{end},'tif')
    UserData.NameFile_DEM               = value;
else
    errordlg('The file does not have the ".tif" extension','!! Error !!')
end

function File_DEM_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Name File Streamflow
function File_Q_Callback(hObject, eventdata, handles)

global UserData

value = get(handles.File_Q,'String');
Tmp = strsplit(value,'.');
if strcmp(Tmp{end},'xlsx')
    UserData.NameFile_Q               = value;
else
    errordlg('The file does not have the ".xlsx" extension','!! Error !!')
end

function File_Q_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Name File Precipitation 
function File_P_Callback(hObject, eventdata, handles)

global UserData

value = get(handles.File_P,'String');
Tmp = strsplit(value,'.');
if strcmp(Tmp{end},'xlsx')
    UserData.NameFile_Pcp               = value;
else
    errordlg('The file does not have the ".xlsx" extension','!! Error !!')
end

function File_P_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Name File Temperature
function File_T_Callback(hObject, eventdata, handles)

global UserData

value = get(handles.File_T,'String');
Tmp = strsplit(value,'.');
if strcmp(Tmp{end},'xlsx')
    UserData.NameFile_T               = value;
else
    errordlg('The file does not have the ".xlsx" extension','!! Error !!')
end

function File_T_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Name File Evapotranspiration
function TypeFile_ETP_Callback(hObject, eventdata, handles)

global UserData

Va  = get(handles.TypeFile_ETP,'Value');

UserData.TypeFile_ETP    = Va;

function TypeFile_ETP_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Name File Evapotranspiration
function File_ETP_Callback(hObject, eventdata, handles)

global UserData

value = get(handles.File_ETP,'String');
Tmp = strsplit(value,'.');
if strcmp(Tmp{end},'xlsx')
    UserData.NameFile_ETP               = value;
else
    errordlg('The file does not have the ".xlsx" extension','!! Error !!')
end

function File_ETP_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Name File Underground Demand 
function File_DmSub_Callback(hObject, eventdata, handles)

global UserData

value = get(handles.File_DmSub,'String');
Tmp = strsplit(value,'.');
if strcmp(Tmp{end},'xlsx')
    UserData.NameFileDm_Sub               = value;
else
    errordlg('The file does not have the ".xlsx" extension','!! Error !!')
end

function File_DmSub_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ParPool.
function ParPool_Callback(hObject, eventdata, handles)

global UserData

Va  = get(handles.ParPool,'Value');

if Va == 1
    UserData.Parallel    = true;
else
    UserData.Parallel    = false;
end



% --- Executes during object creation, after setting all properties.
function ParPool_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ParPool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in NCores.
function NCores_Callback(hObject, eventdata, handles)
global UserData

Va  = get(handles.NCores,'Value');

UserData.CoresNumber   = Va*2;



% --- Executes during object creation, after setting all properties.
function NCores_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NCores (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
