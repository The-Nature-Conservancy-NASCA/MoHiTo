function [Nash, varargout]   = Function_Obj(Param, UserData)
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
% This is the obeject function by perform the Calibration of the ABCD-FP-D
% Model through of the Shuffled complex evolution
%
% -------------------------------------------------------------------------
% INPUT DATA
% -------------------------------------------------------------------------
% Param         [1, 9]      = Parameters of the Models
% UserData      [Struct]
%   .CalMode        [1 or 9]        = 1 for the Thomas Model Parameters 
%                                     0 for the Floodplains Model Parameters
%   .Date           [t,1]           = Date                                                                      [Datenum]
%   .ArcID          [Cat,1]         = ArcID                                                                     [Ad]
%   .BasinArea      [Cat,1]         = Basin Area                                                                [m^2]
%   .P              [t,Cat]         = Precipitation                                                             [mm]
%   .ET             [t,Cat]         = Potential Evapotranspiration                                              [mm]
%   .DemandSup      [t,Cat]         = Demand                                                                    [m^3]
%   .Returns        [t,Cat]         = Returns                                                                   [m^3]
%   .IDExtAgri      [Cat,1]         = ID of the HUA where to extraction Agricultural Demand                     [Ad]
%   .IDExtDom       [Cat,1]         = ID of the HUA where to extraction Domestic Demand                         [Ad]
%   .IDExtLiv       [Cat,1]         = ID of the HUA where to extraction Livestock Demand                        [Ad]
%   .IDExtMin       [Cat,1]         = ID of the HUA where to extraction Mining Demand                           [Ad]
%   .IDExtHy        [Cat,1]         = ID of the HUA where to extraction Hydrocarbons Demand                     [Ad]
%   .IDRetDom       [Cat,1]         = ID of the HUA where to return Domestic Demand                             [Ad]
%   .IDRetLiv       [Cat,1]         = ID of the HUA where to return Livestock Demand                            [Ad]
%   .IDRetMin       [Cat,1]         = ID of the HUA where to return Mining Demand                               [Ad]
%   .IDRetHy        [Cat,1]         = ID of the HUA where to return Hydrocarbons Demand                         [Ad]
%   .FloodArea      [t,Cat]         = Floodplain Area                                                           [m^2]
%   .Arc_InitNode   [t,Cat]         = Initial node of each section of the network                               [Ad]
%   .Arc_EndNode    [t,Cat]         = End node of each section of the network                                   [Ad] 
%   .DownGauges     [t,Cat]         = ID of the end node of accumulation                                        [Ad]
%   .PoPo           [n,1]           = ID of the HUA to calibrate                                                [Ad]
%   .PoPoFlood      [n,1]           = ID of the HUA to calibrate with floodplains                               [Ad]
%   .IDPoPo         [n,1]           = ID of the HUA where signate the model parameters to calibrate             [Ad]
%   .IDPoPoFlood    [n,1]           = ID of the HUA where signate the model parameters to calibrate floodplains [Ad]
%   .a              [Cat,1]         = Soil Retention Capacity                                                   [Ad]
%   .b              [Cat,1]         = Maximum Capacity of Soil Storage                                          [Ad]
%   .c              [Cat,1]         = Flow Fraction Soil - Aquifer                                              [Ad]
%   .d              [Cat,1]         = Flow Fraction Aquifer - Soil                                              [Ad]
%   .Trp            [CatFlood,1]    = Percentage lateral flow between river and floodplain                      [Ad]
%   .Tpr            [CatFlood,1]    = Percentage return flow from floodplain to river                           [Ad]
%   .Q_Umb          [CatFlood,1]    = Threshold lateral flow between river and floodplain                       [mm]
%   .V_Umb          [CatFlood,1]    = Threshold return flow from floodplain to river                            [mm]
%   .ParamExtSup    [t,Cat]         = Porcentage of Superficial Water Extraction                                [Ad]
%   .ArcIDFlood     [CatFlood,1]    = ID basins with floodplain                                                 [Ad]
%   .Sg             [Cat,1]         = Aquifer Storage                                                           [mm]
%   .Sw             [Cat,1]         = Soil Moinsture                                                            [mm]
%   .Vh             [Cat,1]         = Volume of the floodplain Initial                                          [mm]
%
% -------------------------------------------------------------------------
% OUTPUT DATA
% -------------------------------------------------------------------------
%   Nash            [1,1]           =   Function Object     [Ad]

%%
IDPoPo                          = UserData.IDPoPo;
PoPo                            = UserData.PoPo;

IDPoPo_tmp = IDPoPo;
IDPoPo_tmp(isnan(UserData.a) == 0) = 0;
UserData.a(IDPoPo_tmp)              = Param(1);

IDPoPo_tmp = IDPoPo;
IDPoPo_tmp(isnan(UserData.b) == 0) = 0;
UserData.b(IDPoPo_tmp)              = Param(2);

IDPoPo_tmp = IDPoPo;
IDPoPo_tmp(isnan(UserData.c) == 0) = 0;
UserData.c(IDPoPo_tmp)              = Param(3);

IDPoPo_tmp = IDPoPo;
IDPoPo_tmp(isnan(UserData.d) == 0) = 0;
UserData.d(IDPoPo_tmp)              = Param(4);

if UserData.PnoP
    IDPoPo_tmp = IDPoPo;
    IDPoPo_tmp(isnan(UserData.Q_Umb) == 0) = 0;
    UserData.Q_Umb(IDPoPo_tmp)          = Param(5);

    IDPoPo_tmp = IDPoPo;
    IDPoPo_tmp(isnan(UserData.V_Umb) == 0) = 0;
    UserData.V_Umb(IDPoPo_tmp)          = Param(6);

    IDPoPo_tmp = IDPoPo;
    IDPoPo_tmp(isnan(UserData.Tpr) == 0) = 0;
    UserData.Tpr(IDPoPo_tmp)            = Param(7);

    IDPoPo_tmp = IDPoPo;
    IDPoPo_tmp(isnan(UserData.Trp) == 0) = 0;
    UserData.Trp(IDPoPo_tmp)            = Param(8);

    IDPoPo_tmp = IDPoPo;
    IDPoPo_tmp(isnan(UserData.ParamExtSup) == 0) = 0;
    UserData.ParamExtSup(IDPoPo_tmp)    = Param(9);
    
    %% Correct Flood Plains 
    Tmp     = find(UserData.IDPoPo);
    JoJa    = UserData.FloodArea(Tmp) == 0;
    Tmp1    = Tmp(JoJa);
    UserData.Q_Umb(Tmp1) = 0; 
    UserData.V_Umb(Tmp1) = 0; 
    UserData.Tpr(Tmp1)   = 0; 
    UserData.Trp(Tmp1)   = 0;
    
else
    IDPoPo_tmp = IDPoPo;
    IDPoPo_tmp(isnan(UserData.Q_Umb) == 0) = 0;
    UserData.Q_Umb(IDPoPo_tmp)          = 0;

    IDPoPo_tmp = IDPoPo;
    IDPoPo_tmp(isnan(UserData.V_Umb) == 0) = 0;
    UserData.V_Umb(IDPoPo_tmp)          = 0;

    IDPoPo_tmp = IDPoPo;
    IDPoPo_tmp(isnan(UserData.Tpr) == 0) = 0;
    UserData.Tpr(IDPoPo_tmp)            = 0;

    IDPoPo_tmp = IDPoPo;
    IDPoPo_tmp(isnan(UserData.Trp) == 0) = 0;
    UserData.Trp(IDPoPo_tmp)            = 0;

    IDPoPo_tmp = IDPoPo;
    IDPoPo_tmp(isnan(UserData.ParamExtSup) == 0) = 0;
    UserData.ParamExtSup(IDPoPo_tmp)    = Param(5);
    
end
    
%% Date Calibration
ID_Po1 = UserData.ID_Po1;
ID_Po2 = UserData.ID_Po2;

[Qsim,~,~,~,~] = HMO(   UserData.Date(ID_Po1:ID_Po2),...
                        UserData.P(ID_Po1:ID_Po2,PoPo),...
                        UserData.ETP(ID_Po1:ID_Po2,PoPo),...
                        UserData.DemandSup(ID_Po1:ID_Po2,PoPo,:),...
                        UserData.DemandSub(ID_Po1:ID_Po2,PoPo),...
                        UserData.Returns(ID_Po1:ID_Po2,PoPo,:),...
                        UserData.BasinArea(PoPo),...
                        UserData.FloodArea(PoPo),... 
                        UserData.ArcID(PoPo),...
                        UserData.Arc_InitNode(PoPo),...
                        UserData.Arc_EndNode(PoPo),...
                        UserData.DownGauges,...
                        UserData.a(PoPo),...
                        UserData.b(PoPo),...
                        UserData.c(PoPo),...
                        UserData.d(PoPo),...
                        UserData.Tpr(PoPo),...
                        UserData.Trp(PoPo),...
                        UserData.Q_Umb(PoPo),...
                        UserData.V_Umb(PoPo),...
                        UserData.IDExtAgri(PoPo),...
                        UserData.IDExtDom(PoPo),...
                        UserData.IDExtLiv(PoPo),... 
                        UserData.IDExtHy(PoPo),... 
                        UserData.IDExtMin(PoPo),...
                        UserData.IDRetAgri(PoPo),...
                        UserData.IDRetDom(PoPo),...
                        UserData.IDRetLiv(PoPo),...
                        UserData.IDRetHy(PoPo),...
                        UserData.IDRetMin(PoPo),...
                        UserData.ParamExtSup(PoPo),...
                        UserData.Sw(PoPo),...
                        UserData.Sg(PoPo),...
                        UserData.Vh(PoPo),...
                        UserData.IDAq(PoPo),...
                        UserData.PoPis(PoPo),...
                        UserData.Mode);
                    
ArcID       = UserData.ArcID(PoPo);
QArcID      = (ArcID == UserData.DownGauges);

%% Nash
nt          = UserData.nt;
Qsim_i      = reshape(Qsim(QArcID,1,:),[],1);

Qobs        = UserData.Qobs(nt:end);
Qsim_i      = Qsim_i(nt:end);

A1          = mean((Qobs - Qsim_i).^2,'omitnan');
B1          = var(Qobs( isnan(Qobs) == 0));
Nash        = A1./B1 ;

varargout{1} = reshape(Qsim(QArcID,1,:),[],1);
