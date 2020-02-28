function [Fig] = Plot_Eval_Model_Paper(UserData) 
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
% INPUT DATA
% -------------------------------------------------------------------------
%  Param         [1, 9]             = Parameters of the Models
%  UserData      [Struct]
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
%   Fig            [Obj Matlab]     = Figure Calibration Model
%   SummaryCal     [1, 21]          = Summary of the Functions Target

%%
PoPo    = UserData.PoPo;

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

nt = UserData.nt;

%% Date 
Date    = datenum(UserData.Date);
Date    = Date(ID_Po1:ID_Po2);

%% Precipitation 
P = mean(UserData.P(ID_Po1:ID_Po2,PoPo),2,'omitnan');

%% Simulation 
sim  = reshape(Qsim(QArcID,1,:),[],1);

%% Observation
obs  = UserData.Qobs;

%% Plot 
Fig     = figure('color',[1 1 1]);
T       = [15, 12];
set(Fig, 'Units', 'Inches', 'PaperPosition', [0, 0, T],'Position',...
[0, 0, T],'PaperUnits', 'Inches','PaperSize', T,'PaperType','usletter', 'Visible','off')

FontLabels = 22;
FontTick   = 15;
FontLegend = 16;

Carajo = (1:13);

%% Precipitacion
subplot(32,15, (1:(9*15)));
bar(Date, P,'FaceColor',[0 .5 .5])
datetick('x','yyyy')
axis([min(Date) (max(Date) + 60) 0 (max(P) + (max(P)*0.1))])
box off 

set(gca, 'FontSize',FontTick,'Color','none')
ylabel('\bf Precipitation (mm)','interpreter','latex','FontSize',FontLabels, 'FontWeight','bold','FontName','Arial');

ax = gca;
ax.TickLabelInterpreter = 'latex';
ax.XAxis.LineWidth      = 2;
ax.YAxis.LineWidth      = 2;
% ax.XTickLabel           = [];
ax.FontName             = 'Arial';
ax.FontWeight           = 'bold';


%% Caudales
subplot(32,15,((11*15) + 1):(19*15))

Ax1 = plot(Date, obs,'Color',ColorsF('persian blue'),'LineWidth', 2);
hold on

Ax2 = plot(Date,sim ,'s-','Color',ColorsF('orange (web color)'), 'LineWidth', 1.5, 'MarkerEdgeColor',ColorsF('jasper'),...
    'MarkerFaceColor',ColorsF('jasper'),...
    'MarkerSize',4);

datetick('x','yyyy')
axis([min(Date) (max(Date) + 60) 0 (max([obs; sim]) + (max([obs; sim])*0.2))])

set(gca, 'TickLabelInterpreter','latex','FontSize',FontTick, 'FontWeight','bold','linewidth',2,'Color','none')
xlabel('\bf Time (Months)','interpreter','latex','FontSize',FontLabels, 'FontWeight','bold','FontName','Arial');
ylabel('\bf Flow $\bf {(m^3/s)}$','interpreter','latex','FontSize',FontLabels, 'FontWeight','bold','FontName','Arial');

le = legend([Ax1 Ax2],'\bf Observed', '\bf Simulated');
set(le,'interpreter','latex','FontSize',FontLegend, 'FontWeight','bold', 'NumColumns',2,'box','off','color','none')

box off

%% Obs Vs Sim
subplot(32,15,[((302:314) + 100) ((16:20) + 120) ((16:20) + 140) ((16:20) + 160) ((16:20) + 180)])
Limit   = max([max(obs); max(sim)]);
x       = [0; Limit];
plot(x,x,'k','LineWidth',1.5)
hold on
scatter(obs, sim, 30,ColorsF('jasper'),'filled', 'MarkerEdgeColor',ColorsF('jazzberry jam'),'LineWidth',2)
axis([0 Limit 0 Limit])
set(gca, 'TickLabelInterpreter','latex','FontSize',FontTick, 'FontWeight','bold', 'linewidth',2)
xlabel('\bf Flow Observed $\bf {(m^3/s)}$','interpreter','latex','FontSize',FontLabels, 'FontWeight','bold');
ylabel('\bf Flow Simulated $\bf {(m^3/s)}$','interpreter','latex','FontSize',FontLabels, 'FontWeight','bold');

box off

