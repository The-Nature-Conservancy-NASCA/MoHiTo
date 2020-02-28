function [Fig, Summary, ResultsModel] = Plot_Eval_Model(UserData) 
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

%% Simulation 
sim  = reshape(Qsim(QArcID,1,:),[],1);
sim  = sim(nt:end);

%% Observation
obs  = UserData.Qobs;
obs  = obs(nt:end);

%% Coefficient Nash
Nash        = 1 - ((mean((obs - sim).^2, 'omitnan'))./var(obs( isnan(obs) == 0)));

%% Absolute Mean error 
Fuc_AME     = max(abs(obs-sim));
    
%% unlike peaks 
Fuc_PDIFF   = max(obs)-max(sim);

%% Mean Absolute Error 
Fuc_MAE     = mean(abs(obs-sim),'omitnan');

%% Mean Square Error 
Fuc_MSE     = mean((obs-sim).^2,'omitnan');

%% Mean Error
% Fuc_ME      = nanmean(obs-sim);

%% Root Mean Square Error
Fuc_RMSE    = sqrt(Fuc_MSE);

%% Root Fourth Mean Square Fourth Error
Fuc_R4MS4E  = nthroot((mean((obs-sim).^4,'omitnan')),4);

%% Root Absolute Error 
Fuc_RAE     = sum(abs(obs-sim),'omitnan')/sum(abs(obs-mean(obs,'omitnan')),'omitnan');

%% percent Error in peak 
Fuc_PEP     = ((max(obs)-max(sim))/max(obs))*100;

%% Mean Absolute Relative Error
Fuc_MARE    = mean(sum((abs(obs-sim))/obs,'omitnan'),'omitnan');

%% Mean Relative Error 
Fuc_MRE     = mean(sum((obs-sim)/obs,'omitnan'),'omitnan');

%% Mean Square Relative Error 
Fuc_MSRE    = mean(sum(((obs-sim)/obs).^2,'omitnan'),'omitnan');

%% Relative Volume Error
Fuc_RVE     = sum(obs-sim,'omitnan')/sum(obs,'omitnan');

%% Nash-Sutcliffe Coefficient of Efficiency
Enum    = sum((obs-sim).^2,'omitnan');
Edenom  = sum((obs-mean(obs,'omitnan')).^2,'omitnan');
Fuc_CE      = 1-Enum/Edenom;

%% Correlation Coefficient
Rnum    = sum((obs-mean(obs,'omitnan')).*(sim-mean(sim,'omitnan')),'omitnan');
Rdenom  = sqrt(sum((obs-mean(obs,'omitnan')).^2,'omitnan')*sum((sim-mean(sim,'omitnan')).^2,'omitnan'));
Fuc_R       = Rnum/Rdenom;

%% Percentage Bias Error
Fuc_PBE     = sum(sim-obs,'omitnan')/sum(obs,'omitnan')*100;

%% Average Absolute Relative Error
Fuc_ARE     = abs(((sim-obs)./obs)*100);
Fuc_ARE(isnan(Fuc_ARE)) = 0; Fuc_ARE(isinf(Fuc_ARE)) = 0;
Fuc_AARE    = mean(Fuc_ARE,'omitnan');

%% Threshold Statistics
p = zeros(1,size(obs,1)); 
q = zeros(1,size(obs,1)); 
r = zeros(1,size(obs,1)); 
s = zeros(1,size(obs,1));

for l = 1:size(obs,1)
       if Fuc_ARE(l)<1;   p(l) = 1; else, p(l) = 0; end
       if Fuc_ARE(l)<25;  q(l) = 1; else, q(l) = 0; end
       if Fuc_ARE(l)<50;  r(l) = 1; else, r(l) = 0; end
       if Fuc_ARE(l)<100; s(l) = 1; else, s(l) = 0; end      
end

Fuc_TS1   = mean(p,'omitnan')*100;
Fuc_TS25  = mean(q,'omitnan')*100;
Fuc_TS50  = mean(r,'omitnan')*100;
Fuc_TS100 = mean(s,'omitnan')*100;

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
T       = [20, 8];
set(Fig, 'Units', 'Inches', 'PaperPosition', [0, 0, T],'Position',...
[0, 0, T],'PaperUnits', 'Inches','PaperSize', T,'PaperType','usletter', 'Visible','off')

FontLabels = 22;
FontTick   = 15;
FontLegend = 16;

Carajo = (1:13);

%% Precipitacion
subplot(10,20,[Carajo (Carajo + 20) (Carajo + 40) (Carajo + 60)]);
bar(Date, P,'FaceColor',[0 .5 .5])
datetick('x','yyyy')
axis([min(Date) (max(Date) + 365) 0 (max(P) + (max(P)*0.1))])
box off 

set(gca, 'FontSize',FontTick,'Color','none')

ax = gca;
ax.TickLabelInterpreter = 'latex';
ax.XAxis.LineWidth      = 2;
ax.YAxis.LineWidth      = 2;
% ax.XTickLabel           = [];
ax.FontName             = 'Arial';
ax.FontWeight           = 'bold';
ylabel('\bf Precipitation (mm)','interpreter','latex','FontSize',FontLabels, 'FontWeight','bold','FontName','Arial');

%% Caudales
subplot(10,20,[(Carajo + 100) (Carajo + 120) (Carajo + 140) (Carajo + 160) (Carajo + 180)])

% h = area(Date, sim);
% h.FaceColor = ColorsF('orange (web color)');
% h.FaceAlpha = 0.1   ;
% hold on

Ax1 = plot(Date, obs,'Color',ColorsF('persian blue'),'LineWidth', 2);
hold on

Ax2 = plot(Date,sim ,'s-','Color',ColorsF('orange (web color)'), 'LineWidth', 1.5, 'MarkerEdgeColor',ColorsF('jasper'),...
    'MarkerFaceColor',ColorsF('jasper'),...
    'MarkerSize',4);

datetick('x','yyyy')
axis([min(Date) (max(Date) + 365) 0 (max([obs; sim]) + (max([obs; sim])*0.2))])
box off
set(gca, 'TickLabelInterpreter','latex','FontSize',FontTick, 'FontWeight','bold','linewidth',2,'Color','none')
xlabel('\bf Time (Months)','interpreter','latex','FontSize',FontLabels, 'FontWeight','bold','FontName','Arial');
ylabel('\bf Flow $\bf {(m^3/s)}$','interpreter','latex','FontSize',FontLabels, 'FontWeight','bold','FontName','Arial');

le = legend([Ax1 Ax2],'\bf Observed', '\bf Simulated');
set(le,'interpreter','latex','FontSize',FontLegend, 'FontWeight','bold', 'NumColumns',2,'box','off','color','none')


%% Obs Vs Sim
subplot(10,20,[((16:20) + 100) ((16:20) + 120) ((16:20) + 140) ((16:20) + 160) ((16:20) + 180)])
Limit   = max([max(obs); max(sim)]);
x       = [0; Limit];
plot(x,x,'k','LineWidth',1.5)
hold on
scatter(obs, sim, 25,ColorsF('jasper'),'filled', 'MarkerEdgeColor',ColorsF('jazzberry jam'),'LineWidth',2)
axis([0 Limit 0 Limit])
set(gca, 'TickLabelInterpreter','latex','FontSize',FontTick, 'FontWeight','bold', 'linewidth',2)
xlabel('\bf Flow Observed $\bf {(m^3/s)}$','interpreter','latex','FontSize',FontLabels, 'FontWeight','bold');
ylabel('\bf Flow Simulated $\bf {(m^3/s)}$','interpreter','latex','FontSize',FontLabels, 'FontWeight','bold');

box off

%% Tabla
subplot(10,20,[16:20 ((16:20) + 20) ((16:20) + 40) ((16:20) + 60) ((16:20) + 80)]);
plot(0:1, 0:1.2, '.', 'color', [1 1 1])
set(gca, 'box','off','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[], 'XColor','none','YColor','none','linewidth',2)
Coor_X = 0.2;
maxcor = 1; max(max(obs),max(sim));
mincor = 0; min(min(obs),min(sim));

FnZ = 12;
lkn = 0.05;
% Dont change the spaces after the words 
text(Coor_X,((lkn*20*(maxcor-mincor))+ mincor),'\bf NASH', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*19*(maxcor-mincor))+ mincor),'\bf AME', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*18*(maxcor-mincor))+ mincor),'\bf PDIFF', 'interpreter','latex', 'FontSize',FnZ)
text(Coor_X,((lkn*17*(maxcor-mincor))+ mincor),'\bf MAE', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*16*(maxcor-mincor))+ mincor),'\bf MSE', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*15*(maxcor-mincor))+ mincor),'\bf RMSE', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*14*(maxcor-mincor))+ mincor),'\bf R4MS4E', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*13*(maxcor-mincor))+ mincor),'\bf RAE', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*12*(maxcor-mincor))+ mincor),'\bf PEP', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*11*(maxcor-mincor))+ mincor),'\bf MARE', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*10*(maxcor-mincor))+ mincor),'\bf MRE', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*9*(maxcor-mincor))+ mincor),'\bf MSRE', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*8*(maxcor-mincor))+ mincor),'\bf RVE', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*7*(maxcor-mincor))+ mincor),'\bf R', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*6*(maxcor-mincor))+ mincor),'\bf CE', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*5*(maxcor-mincor))+ mincor),'\bf PBE', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*4*(maxcor-mincor))+ mincor),'\bf AARE', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*3*(maxcor-mincor))+ mincor),'\bf TS1', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*2*(maxcor-mincor))+ mincor),'\bf TS25', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*1*(maxcor-mincor))+ mincor),'\bf TS50', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.00*(maxcor-mincor))+ mincor),'\bf TS100', 'interpreter','latex', 'FontSize', FnZ)

Coor_X = 0.5;

text(Coor_X,((1.00*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.95*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.90*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.85*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.80*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.75*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.70*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.65*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.60*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.55*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.50*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.45*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.40*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.35*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.30*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.25*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.20*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.15*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.10*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.05*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.00*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)

Coor_X = 0.6;

text(Coor_X,((1.00*(maxcor-mincor))+ mincor),num2str(Nash,'%0.3f'), 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.95*(maxcor-mincor))+ mincor),num2str(Fuc_AME,'%0.3f'), 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.90*(maxcor-mincor))+ mincor),num2str(Fuc_PDIFF,'%0.3f'), 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.85*(maxcor-mincor))+ mincor),num2str(Fuc_MAE,'%0.3f'), 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.80*(maxcor-mincor))+ mincor),num2str(Fuc_MSE,'%0.3f'), 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.75*(maxcor-mincor))+ mincor),num2str(Fuc_RMSE,'%0.3f'), 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.70*(maxcor-mincor))+ mincor),num2str(Fuc_R4MS4E,'%0.3f'), 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.65*(maxcor-mincor))+ mincor),num2str(Fuc_RAE,'%0.3f'), 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.60*(maxcor-mincor))+ mincor),num2str(Fuc_PEP,'%0.3f'), 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.55*(maxcor-mincor))+ mincor),num2str(Fuc_MARE,'%0.3f'), 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.50*(maxcor-mincor))+ mincor),num2str(Fuc_MRE,'%0.3f'), 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.45*(maxcor-mincor))+ mincor),num2str(Fuc_MSRE,'%0.3f'), 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.40*(maxcor-mincor))+ mincor),num2str(Fuc_RVE,'%0.3f'), 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.35*(maxcor-mincor))+ mincor),num2str(Fuc_R,'%0.3f'), 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.30*(maxcor-mincor))+ mincor),num2str(Fuc_CE,'%0.3f'), 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.25*(maxcor-mincor))+ mincor),num2str(Fuc_PBE/100,'%0.3f'), 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.20*(maxcor-mincor))+ mincor),num2str(Fuc_AARE,'%0.3f'), 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.15*(maxcor-mincor))+ mincor),num2str(Fuc_TS1/100,'%0.3f'), 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.10*(maxcor-mincor))+ mincor),num2str(Fuc_TS25/100,'%0.3f'), 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.05*(maxcor-mincor))+ mincor),num2str(Fuc_TS50/100,'%0.3f'), 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.00*(maxcor-mincor))+ mincor),num2str(Fuc_TS100/100,'%0.3f'), 'interpreter','latex', 'FontSize', FnZ)

%% Summary metric 
Summary = [ Nash,...
            Fuc_AME, Fuc_PDIFF, Fuc_MAE, Fuc_MSE, Fuc_RMSE, Fuc_R4MS4E, Fuc_RAE,...
            Fuc_PEP, Fuc_MARE, Fuc_MRE, Fuc_MSRE, Fuc_RVE, Fuc_R, Fuc_CE, Fuc_PBE/100,...
            Fuc_AARE, Fuc_TS1/100, Fuc_TS25/100, Fuc_TS50/100, Fuc_TS100/100];
        
ResultsModel = [obs sim];