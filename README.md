# MoHiTo

El crecimiento poblacional y el aumento del nivel de vida en Colombia y en el mundo, a generando que se presente una mayor demanda de alimentos impulsando la producción agrícola hacia las últimas tierras naturales remanentes. En Colombia la región de la Orinoquia dentro de su jurisdicción constituye el segundo sistema de sabanas más grande de América del Sur y se considera como la última frontera agrícola para el país. Actualmente la Orinoquia Colombiana está experimentando una rápida expansión del desarrollo agrícola a gran escala, que incluye plantaciones de palma de aceite, caucho y eucalipto, así como cultivos anuales como arroz, maíz y soja, principalmente para abastecer una demanda interna creciente. Considerando que otras regiones de Colombia han experimentado auges agrícolas similares, con poca o ninguna planificación de los cambios en el uso de la tierra y la infraestructura asociada de energía y comunicaciones; lo que ha resultado en la pérdida de la biodiversidad y los servicios del ecosistémicos. Es así que MoHiTo (Herramienta de modelación hidrológica para la toma de decisiones) es una herramienta que surge de la necesidad de entender cómo se vería afectado el recurso hídrico en la región de la Orinoquia Colombiana ante estas futuras presiones de los diferentes sectores hidrodependientes. Bajo ésta premisa surgió el proyecto “Landscape planning for agro-industrial expansion in a large, well-preserved savanna: how to plan multifunctional landscapes at scale for nature and people in the Orinoquia región, Colombia”, el cual fue desarrollado bajo un marco interinstitucional e interdisciplinar con SIAT, WCS y The Nature Conservancy.


<img src="https://github.com/The-Nature-Conservancy-NASCA/MoHiTo/blob/master/ICONS/TNC_Logo.png" width="100" height="30" />


<img src="https://github.com/The-Nature-Conservancy-NASCA/MoHiTo/blob/master/ICONS/Model.png" width="600" height="500" />

Figura 5-4. Modelo conceptual propuesto para la Orinoquia colombiana

## Estructura del modelo 

El modelo planteado fue programado en MATLAB versión 2016a con un enfoque funcional de tal forma que sea fácil la inclusión de nuevas rutinas. A continuación, se presentan los esquemas de cálculo y las ecuaciones programas.


Inicialmente, para cada una de las unidades hidrológicas definidas en el numeral 3, se resolvió el balance hídrico mediante el modelo de Thomas (1981). Este modelo considera dos compartimentos para el análisis del balance hídrico: el suelo o zona de evapotranspiración con almacenamiento <img src="https://latex.codecogs.com/gif.latex?Sw" title="Sw" /></a>, y la zona saturada con almacenamiento <img src="https://latex.codecogs.com/gif.latex?Sg" title="Sg" /></a> (Ver Figura 5-4).
Para efectos de modelación, la componente de flujo subsuperficial en la parte superficial de la zona de evapotranspiración se puede incluir en la escorrentía directa <img src="https://latex.codecogs.com/gif.latex?(Ro)" title="(Ro)" /></a>. El modelo considera despreciable el flujo lateral profundo <img src="https://latex.codecogs.com/gif.latex?(Qlat)" title="(Qlat)" /></a> en la zona no saturada, de tal forma que la recarga potencial (infiltración según Thomas) es igualada a la recarga real <img src="https://latex.codecogs.com/gif.latex?(Rg)" title="(Rg)" /></a>.
De esta forma, aplicando la ecuación de continuidad a un volumen de control <img src="https://latex.codecogs.com/gif.latex?Sw" title="Sw" /></a> tenemos:

<img src="https://latex.codecogs.com/gif.latex?P_{i}-ET_{i}-Rg_{i}-Ro_{i}=\Delta&space;Sw=Sw_{i}-Sw_{i-1}" title="P_{i}-ET_{i}-Rg_{i}-Ro_{i}=\Delta Sw=Sw_{i}-Sw_{i-1}" /></a>

Donde <img src="https://latex.codecogs.com/gif.latex?P_{i}" title="P_{i}" /></a> es la precipitación; <img src="https://latex.codecogs.com/gif.latex?{ET}_{i}" title="{ET}_{i}" /></a>, la evapotranspiración real; <img src="https://latex.codecogs.com/gif.latex?{Rg}_{i}" title="{Rg}_{i}" /></a>, la recarga; <img src="https://latex.codecogs.com/gif.latex?{Ro}_{i}" title="{Ro}_{i}" /></a>, la escorrentía directa; <img src="https://latex.codecogs.com/gif.latex?\Delta&space;Sw" title="\Delta Sw" /></a>, el cambio en el almacenamiento del suelo entre el período de cálculo <img src="https://latex.codecogs.com/gif.latex?i" title="i" /></a> <img src="https://latex.codecogs.com/gif.latex?(Sw_{i})" title="(Sw_{i})" /></a> y el período inmediatamente anterior <img src="https://latex.codecogs.com/gif.latex?(Sw_{i-1})" title="(Sw_{i-1})" /></a>. Thomas (1981) definen, además, las variables <img src="https://latex.codecogs.com/gif.latex?W_{i}" title="W_{i}" /></a> (agua disponible) e <img src="https://latex.codecogs.com/gif.latex?Y_{i}" title="Y_{i}" /></a> como:

<img src="https://latex.codecogs.com/gif.latex?W_{i}=P_{i}&plus;Sw_{i-1}" title="W_{i}=P_{i}+Sw_{i-1}" /></a>

<img src="https://latex.codecogs.com/gif.latex?Y_{i}={ETR}_{i}&plus;{Sw}_{i-1}" title="Y_{i}={ETR}_{i}+{Sw}_{i-1}" /></a>

En cada intervalo de tiempo se asume que la humedad disminuya según la ley de decaimiento exponencial, asumiendo como humedad inicial al comienzo de cada intervalo <img src="https://latex.codecogs.com/gif.latex?Y_{i}" title="Y_{i}" /></a>, donde <img src="https://latex.codecogs.com/gif.latex?{ETP}_{i}" title="{ETP}_{i}" /></a> es la evapotranspiración potencial y b(L) es un parámetro del modelo:

<img src="https://latex.codecogs.com/gif.latex?{Sw}_i=Y_{i}*e^{-\frac{{ETR}_{i}}{b}}" title="{Sw}_i=Y_{i}*e^{-\frac{{ETR}_{i}}{b}}" /></a>

Thomas (1981) define la variable de estado Y_i como una función no lineal del agua disponible según los parámetros <img src="https://latex.codecogs.com/gif.latex?a" title="a" /></a> (adimensional) y <img src="https://latex.codecogs.com/gif.latex?b" title="b" /></a>:

<img src="https://latex.codecogs.com/gif.latex?{Y}_i=\frac{{W}_{i}&plus;b}{2a}-\left[\left(\frac{{W}_{i}&plus;b}{2a}\right)^{2}-\frac{{W}_{i}b}{a}\right]^{0,5}" title="{Y}_i=\frac{{W}_{i}+b}{2a}-\left[\left(\frac{{W}_{i}+b}{2a}\right)^{2}-\frac{{W}_{i}b}{a}\right]^{0,5}" /></a>

Donde <img src="https://latex.codecogs.com/gif.latex?a" title="a" /></a> y <img src="https://latex.codecogs.com/gif.latex?b" title="b" /></a> son parámetros que pueden ser determinados a partir de mediciones de precipitación, evapotranspiración y humedad del suelo en la cuenca. Esta función asegura que <img src="https://latex.codecogs.com/gif.latex?Y_{i}\leq&space;W_{i}" title="Y_{i}\leq W_{i}" /></a>, <img src="https://latex.codecogs.com/gif.latex?Y_{i}(0)=1" title="Y_{i}(0)=1" /></a> y <img src="https://latex.codecogs.com/gif.latex?Y_{i}(\yen)=0" title="Y_{i}(\yen)=0" /></a> (Alley, 1984).
El límite superior de <img src="https://latex.codecogs.com/gif.latex?Y_{i}" title="Y_{i}" /></a> es representado por el parámetro <img src="https://latex.codecogs.com/gif.latex?b" title="b" /></a>. Thomas et al. (1983) hacen notar que, a excepción de estas propiedades, la función <img src="https://latex.codecogs.com/gif.latex?Y_{i}" title="Y_{i}" /></a> no tiene algún significado particular. Entonces, al sustituir en las ecuaciones anteriores se obtiene:

<img src="https://latex.codecogs.com/gif.latex?W_{i}-Y_{i}={Rg}_{i}&plus;{Ro}_{i}" title="W_{i}-Y_{i}={Rg}_{i}+{Ro}_{i}" /></a>

Para diferenciar la escorrentía de la recarga se asume un coeficiente de reparto <img src="https://latex.codecogs.com/gif.latex?c" title="c" /></a>:

<img src="https://latex.codecogs.com/gif.latex?{Ro}_{i}=(1-c)(W_{i}-Y_{i})" title="{Ro}_{i}=(1-c)(W_{i}-Y_{i})" /></a>

<img src="https://latex.codecogs.com/gif.latex?{Rg}_{i}=c&space;(W_{i}-Y_{i})" title="{Rg}_{i}=c (W_{i}-Y_{i})" /></a>

El caudal subterráneo <img src="https://latex.codecogs.com/gif.latex?({Qg}_{i})" title="({Qg}_{i})" /></a>, es decir, aquella fracción del caudal observado en el río que proviene del almacenamiento en la zona saturada <img src="https://latex.codecogs.com/gif.latex?({Sg}_{i})" title="({Sg}_{i})" /></a>, es:

<img src="https://latex.codecogs.com/gif.latex?{Qg}_{i}=d*{Sg}_{i}" title="{Qg}_{i}=d*{Sg}_{i}" /></a>

El almacenamiento <img src="https://latex.codecogs.com/gif.latex?{Sg}_{i}" title="{Sg}_{i}" /></a> tiene que interpretarse como un almacenamiento dinámico, expresión de la conectividad entre el río y el acuífero. Por lo tanto, al aplicar la ecuación de continuidad a un volumen de acuífero de almacenamiento <img src="https://latex.codecogs.com/gif.latex?{Sg}_{i}" title="{Sg}_{i}" /></a> tenemos:

<img src="https://latex.codecogs.com/gif.latex?{Rg}_{i}-{Qg}_{i}=\Delta&space;{Sg}_{i}={Sg}_{i}-{Sg}_{i-1}" title="{Rg}_{i}-{Qg}_{i}=\Delta {Sg}_{i}={Sg}_{i}-{Sg}_{i-1}" /></a>

Donde <img src="https://latex.codecogs.com/gif.latex?/Delta&space;{Sg}_{i}" title="\Delta {Sg}_{i}" /></a> es el cambio en almacenamiento de la zona saturada y <img src="https://latex.codecogs.com/gif.latex?{Sg}_{i-1}" title="{Sg}_{i-1}" /></a> es el almacenamiento de aguas subterráneas en el período inmediatamente anterior. Al sustituir en las ecuaciones anteriores y resolver por <img src="https://latex.codecogs.com/gif.latex?{Sg}_{i}" title="{Sg}_{i}" /></a>, tenemos:

<img src="https://latex.codecogs.com/gif.latex?{Sg}_{i}=\frac{{Rg}_{i}-{Ro}_{i}}{d&plus;1}" title="{Sg}_{i}=\frac{{Rg}_{i}-{Ro}_{i}}{d+1}" /></a>

El caudal total, es decir, el caudal observado en el río, es:
<img src="https://latex.codecogs.com/gif.latex?{Qs}_{i}={Ro}_{i}&plus;{Rg}_{i}" title="{Qs}_{i}={Ro}_{i}+{Rg}_{i}" /></a>

De acuerdo con Thomas et al. (1983), los parámetros <img src="https://latex.codecogs.com/gif.latex?a" title="a" /></a>,<img src="https://latex.codecogs.com/gif.latex?b" title="b" /></a>,<img src="https://latex.codecogs.com/gif.latex?c" title="c" /></a> y <img src="https://latex.codecogs.com/gif.latex?d" title="d" /></a> se pueden interpretar de la siguiente forma:
<img src="https://latex.codecogs.com/gif.latex?A" title="A" /></a>	refleja la tendencia de la escorrentía a ocurrir antes de que el suelo esté completamente saturado. Valores de “<img src="https://latex.codecogs.com/gif.latex?a" title="a" /></a>” menores a 1 generan escorrentía cuando <img src="https://latex.codecogs.com/gif.latex?W_{i}<&space;b" title="W_{i}< b" /></a> (Alley, 1984).
<img src="https://latex.codecogs.com/gif.latex?B" title="B" /></a>	es el límite superior a la suma de la evapotranspiración real y la humedad del suelo.
<img src="https://latex.codecogs.com/gif.latex?C" title="C" /></a>	es la fracción del caudal promedio del río que proviene del agua subterránea.
<img src="https://latex.codecogs.com/gif.latex?D" title="D" /></a>	es “el recíproco del tiempo de residencia del agua subterránea”.

<img src="https://github.com/The-Nature-Conservancy-NASCA/MoHiTo/blob/master/ICONS/Acumulacion_caudales.png" width="283" height="233"/>

Figura 5-5. Esquema de acumulación de caudales planteado para el modelo

En cada paso de tiempo se realiza el balance hídrico en todas las unidades hidrológicas mediante el modelo de Thomas, donde además se realiza la acumulación de los caudales individuales, obteniendo como resultado del caudal real simulado a la salida de cada Unidad Hidrológica - UH. El diagrama del esquema de cálculo se presenta en la Figura 5-5.

Conjuntamente con la agregación de los caudales se realiza la extracción de la demanda y la interacción del río con la planicie. Para este último se integra el modelo conceptual desarrollado por Angarita et al. (2017) el cual ha sido implementado y probado en WEAP. El esquema conceptual de este modelo se muestra en la Figura 5-6.

<img src="https://github.com/The-Nature-Conservancy-NASCA/MoHiTo/blob/master/ICONS/Integracion_rio_planicie.png" width="589" height="267"/>
Figura 5-6. Esquema conceptual de integración río planicie.

Matemáticamente, la integración del modelo de Angarita et al. (2017) en el de Thomas (1981), estaría dada en el caudal acumulado de las cuencas con planicie de inundación.

<img src="https://latex.codecogs.com/gif.latex?{Q_{T}}_{i}={{Q}_{T}}_{i}-{{Q}_{l}}_{i}&plus;{{{R}_{l}}_{i}" title="{Q_{T}}_{i}={{Q}_{T}}_{i}-{{Q}_{l}}_{i}+{{R}_{l}}_{i}" /></a>

Donde <img src="https://latex.codecogs.com/gif.latex?{Q_{T}}_{i}" title="{Q_{T}}_{i}" /></a> corresponde al caudal acumulado hasta la UHi; el <img src="https://latex.codecogs.com/gif.latex?{Q_{l}}_{i}" title="{Q_{l}}_{i}" /></a> representa los flujo lateral entre el río y llanura de inundación, mientras que el <img src="https://latex.codecogs.com/gif.latex?R_{l}" title="R_{l}" /></a> representa los flujos laterales entre el río y la llanura de inundación.

<img src="https://github.com/The-Nature-Conservancy-NASCA/MoHiTo/blob/master/ICONS/Interaccion_rio_planicie.png" width="286" height="236"/>

Figura 5-7. Esquema de interaccion río planicie. En azul se esquematizan las planicies de inundación.

En otras palabras, a medida que se está acumulando el caudal, se verifica la existencia de planicie de inundación. De existir, se detiene la acumulación y se realiza el balance mostrado anteriormente. Esquemáticamente la representación seria como lo ilustrado en la Figura 5-7.

Conceptualmente Angarita et al. (2017) plantean que la zona de inundación tendrá un área determinada <img src="https://latex.codecogs.com/gif.latex?A_{h}" title="A_{h}" /></a>, la cual a su vez será capaz de almacenar un volumen de agua <img src="https://latex.codecogs.com/gif.latex?{V_{h}}_{i}" title="{V_{h}}_{i}" /></a>, donde dicho volumen fluctúa en función de los aportes que le realice el río a la planicie de inundación, o que la planicie le realice al río, así como también de los aportes directos por precipitación <img src="https://latex.codecogs.com/gif.latex?(P)" title="(P)" /></a> y las perdidas por evapotranspiración <img src="https://latex.codecogs.com/gif.latex?(ETR)" title="(ETR)" /></a> (<img src="https://latex.codecogs.com/gif.latex?A_{T}" title="A_{T}" /></a> representa el área total acumulada hasta la unidad donde se realiza el balance).

<img src="https://latex.codecogs.com/gif.latex?{V_{h}}_{i}=-{{Q}_{l}}_{i}&plus;{R_{l}}_{i}&plus;\frac{A_{h}}{A_{T}}*(P_{i}-{ETR}_{i})" title="{V_{h}}_{i}=-{{Q}_{l}}_{i}+{R_{l}}_{i}+\frac{A_{h}}{A_{T}}*(P_{i}-{ETR}_{i})" /></a>

Los flujos bidireccionales son definidos por dos umbrales <img src="https://latex.codecogs.com/gif.latex?Q_{Umbral}" title="Q_{Umbral}" /></a> y <img src="https://latex.codecogs.com/gif.latex?V_{Umbral}" title="V_{Umbral}" /></a> según la dirección del flujo. De igual forma, es necesario tener en cuenta que no toda el agua que aporte el río a la planicie será almacenada, ni tampoco toda el agua que aporte la planicie al río se convertirá en caudal. En consecuencia, se definen dos parámetros <img src="https://latex.codecogs.com/gif.latex?T_{r\'io-planicie}" title="T_{r\'io-planicie}" /></a> y <img src="https://latex.codecogs.com/gif.latex?T_{planicie-r\'io}" title="T_{planicie-r\'io}" /></a>, los cuales indican el porcentaje de aporte en cada una de las direcciones de la interacción.

<img src="https://latex.codecogs.com/gif.latex?{Q_{l}}_{i}=\left&space;\{&space;\right.&space;{T_{r\'io-planicie}}*({Q_{T}}_{i}-Q_{Umbral}),&space;si&space;{Q_{T}}_{i}>Q_{Umbral}&space;0,&space;si&space;{Q_{T}}_{i}<Q_{Umbral}" title="{Q_{l}}_{i}=\left \{ \right. {T_{r\'io-planicie}}*({Q_{T}}_{i}-Q_{Umbral}), si {Q_{T}}_{i}>Q_{Umbral} 0, si {Q_{T}}_{i}<Q_{Umbral}" /></a>

<img src="https://latex.codecogs.com/gif.latex?{R_{l}}_{i}=\left&space;\{&space;\right.&space;{T_{planicie-r\'io}}*({V_{h}}_{i}-V_{Umbral}),&space;si&space;{V_{h}}_{i}>V_{Umbral}&space;0,&space;si&space;{V_{h}}_{i}<V_{Umbral}" title="{R_{l}}_{i}=\left \{ \right. {T_{planicie-r\'io}}*({V_{h}}_{i}-V_{Umbral}), si {V_{h}}_{i}>V_{Umbral} 0, si {V_{h}}_{i}<V_{Umbral}" /></a>

Por otra parte, la inclusión de la demanda sigue el mismo concepto utilizado para las planicies de inundación. En cada paso de tiempo se realiza la acumulación de la demanda superficial generada por los sectores hidrodependientes, de tal forma que en cada unidad se tiene la demanda superficial total acumula de todos los sectores (Ver Figura 5-8). 
 
<img src="https://github.com/The-Nature-Conservancy-NASCA/MoHiTo/blob/master/ICONS/Acumulacion_demandas.png" width="254" height="265"/>

Figura 5-8. Acumulación de demandas por unidad hidrológica. Las figuras en verde y rojo representas las zonas de demandad de los diferentes sectores y en azul se demarcan las planicies de inundación.

Al igual que en el modelo de planicies, a medida que se está acumulando el caudal, se realiza también la acumulación de la demanda, paralelamente en cada unidad se verifica si se realiza extracción o no; de existir, se detiene la acumulación y se realiza el siguiente balance:

<img src="https://latex.codecogs.com/gif.latex?{Q_{T}}_{i}={Q_{T}}_{i}-{Dsp}_{i}" title="{Q_{T}}_{i}={Q_{T}}_{i}-{Dsp}_{i}" /></a>

En lo que respecta a la demanda subterránea, el esquema acumulativo que se ha venido describiendo debe ser replanteado, dado que los límites establecidos por las unidades hidrológicas no coinciden necesariamente con las unidades hidrogeológicas <img src="https://latex.codecogs.com/gif.latex?(UHG)" title="(UHG)" /></a>.
El modelo de Thomas (1981) realiza los balances a nivel de los acuíferos para cada unidad hidrológica. En concordancia con esto, se podría extraer la demanda subterránea presente en cada unidad del almacenamiento <img src="https://latex.codecogs.com/gif.latex?{Sg}_{i}" title="{Sg}_{i}" /></a>. 
Sin embargo, la implementación de este esquema no prevé que una <img src="https://latex.codecogs.com/gif.latex?UHG" title="UHG" /></a> puede contener varias unidades hidrológicas. En este orden de ideas, se realiza una agrupación de las unidades hidrologías por <img src="https://latex.codecogs.com/gif.latex?UHG" title="UHG" /></a>. 
En cada paso de tiempo se realiza la estimación del volumen de agua total <img src="https://latex.codecogs.com/gif.latex?{Vsb}_{i}^{g}" title="{Vsb}_{i}^{g}" /></a> de las unidades hidrogeológicas “<img src="https://latex.codecogs.com/gif.latex?{g}" title="{g}" /></a>” multiplicando los almacenamientos <img src="https://latex.codecogs.com/gif.latex?{Sg}_{i}^{n}" title="{Sg}_{i}^{n}" /></a> de las unidades hidrológicas “nu” con sus respectivas áreas.
A este volumen se le extrae las demandas subterráneas <img src="https://latex.codecogs.com/gif.latex?{Dsb}_{i}^{n}" title="{Dsb}_{i}^{n}" /></a> de cada unidad quedando de esta forma afectada el agua subterránea para el paso de tiempo siguiente. El volumen resultante se redistribuye nuevamente en las unidades hidrológicas ponderando por el almacenamiento del paso anterior. Esto con el objetivo de conservar las proporciones en cada una de las unidades hidrológicas. Las expresiones matemáticas que describen este proceso son:

<img src="https://latex.codecogs.com/gif.latex?{Vsb}_{i}^{g}=\left&space;[\sum_{n=1}^{nu}{Sg}_{i}^{n}*A^n\right]-\left[&space;\sum_{n=1}^{nu}&space;{Dsb}_{i}^{n}\right]" title="{Vsb}_{i}^{g}=\left [\sum_{n=1}^{nu}{Sg}_{i}^{n}*A^n\right]-\left[ \sum_{n=1}^{nu} {Dsb}_{i}^{n}\right]" /></a>

<img src="https://latex.codecogs.com/gif.latex?{Sg}_{i}^{n}=\frac{{Vsb}_{i}^{g}}{A^n}\frac{{Sg}_{i}^{n}}{\left[\sum_{n=1}^{nu}&space;{Sg}_{i}^{n}\right]}" title="{Sg}_{i}^{n}=\frac{{Vsb}_{i}^{g}}{A^n}\frac{{Sg}_{i}^{n}}{\left[\sum_{n=1}^{nu} {Sg}_{i}^{n}\right]}" /></a>

Por último, el esquema de acumulación descrito anteriormente, permite incluir retornos superficiales, como una adición al caudal acumulado hasta cada unidad.

## Bibliografía

Alley, W.M., 1984. On the Treatment of Evapotranspiration, Soil Moisture Accounting, and Aquifer Recharge in Monthly Water Balance Models. Water Resources Research, 20(8), pp.1137–1149. Available at: http://doi.wiley.com/10.1029/WR020i008p01137.

Arnold, J.G. et al., 1998. LARGE AREA HYDROLOGIC MODELING AND ASSESSMENT PART I: MODEL DEVELOPMENT. Journal of the American Water Resources Association, 34(1), pp.73–89. Available at: http://doi.wiley.com/10.1111/j.1752-1688.1998.tb05961.x.

Black, D., 2015. GR4J - SRG. eWater, p.1. Available at: https://wiki.ewater.org.au/display/SD41/GR4J+-+SRG [Accessed October 1, 2017].

Carvajal, L.F. & Roldan, E., 2007. Agregado GR4J Aplicación : Cuenca Del río Aburrá Calibration of GR4J Lumped Rainfall-Runoff Model Application : Rio Aburrá Cachtment. Dyna, 74, pp.73–87.

Centro de Cambio Global-Universidad Católica de Chile, 2009. Guía Metodológica – Modelación Hidrológica y de Recursos Hídricos con el Modelo WEAP, Chile. Corporinoquia et al., 2004. Plan de acción en biodiversidad de la cuenca del Orinoco – Colombia 2005 – 2015, propuesta técnica, Available at: https://www.cbd.int/doc/world/co/co-nbsap-oth-es.pdf [Accessed May 16, 2017].

Correa, A. & Díaz, C., 2005. Implementación del modelo de Thomas para el balance hídrico empleando la herramienta computacional HidroSIG - Java.

Dawson, C.W., Abrahart, R.J. & See, L.M., 2007. HydroTest: A web-based toolbox of evaluation metrics for the standardised assessment of hydrological forecasts. Environmental Modelling & Software, 22(7), pp.1034–1052. Available at: http://linkinghub.elsevier.com/retrieve/pii/S1364815206001642.

Devia, G.K., Ganasri, B.P. & Dwarakish, G.S., 2015. A Review on Hydrological Models. Aquatic Procedia, 4(Icwrcoe), pp.1001–1007.
Domínguez, C., 1998. La gran cuenca del Orinoco, Available at: http://www.bdigital.unal.edu.co/7322/1/LA GRAN CUENCA DEL ORINOCO.pdf [Accessed May 6, 2017].

Domínguez, E., 2001. Modelo matemático para la formulación de escenarios de escorrentía ante posibles variantes del cambio climático. Meteorología Colombiana, 3(391), pp.93–102.

Domínguez, E., 2000. Protocolo para la modelacion matematica de procesos hidrologicos. Meteorología Colombiana, 2(May), pp.33–38.

Duan, Q.Y., Gupta, V.K. & Sorooshian, S., 1993. Shuffled complex evolution approach for effective and efficient global minimization. Journal of Optimization Theory and Applications, 76(3), pp.501–521.

Enrique, O., 2012. Memoria-Informe Sobre Modelos De Previsión Hidrológica Empleados En Otras Organizaciones, Valencia.

Estrela, T., 1992. Modelos matemáticos para la evaluación de recursos hídricos Centro de.,

Falkenauer, E., 1998. Genetic algorithms and grouping problems Chichester., Reino Unido.

Fragala, F. & Obregón, N., 2011. Estimación de la recarga media anual en los acuíferos de la sabana de bogotá. Ingenieria y Universidad, 15(1), pp.145–169. Available at: http://revistas.javeriana.edu.co/index.php/iyu/article/view/1137/807.

Green WH, A., 1911. Studies on soil physics: 1. The flow of air and water through soils. J Agric Sci, 4, pp.11–24.

IGAC, 2008. Mapa de Suelos de Colombia. IGAC. Available at: www.igac.gov.co/.

Jeziorska, J., 2016. Applicability of TOPMODEL in the mountainous catchments in the upper Nysa Kłodzka River basin (SW Poland). Justyna Jeziorska, p.1. Available at: http://inia82.wixsite.com/jjeziorska/single-post/2016/03/04/Hydrological-Modeling-TOPMODEL.

King, K.., Arnold, J.. & Bingner, R.., 1999. Comparison of green-ampt and curve number methods on goodwin creek watershed using SWAT. ASAE, 42(4), pp.1403–1422.

Kurtz, W. et al., 2017. Integrating hydrological modelling, data assimilation and cloud computing for real-time management of water resources. Environmental Modelling & Software, 93, pp.418–435.

Lehmann, E. L.; Casella, G., 1998. Theory of Point Estimation Second edition. Springer Texts in Statistics.,

Van Liew, M.., Arnold, J.. & Garbrecht, J.., 2003. Hydrologic simulation on agricultural watersheds: choosing between two models. Transactions of the American Society of Agricultural Engineers, 46(6), pp.1539–1551.

Lopez, F., 1998. Restauración hidrológica forestal de cuencas y control de erosión., Madrid.

Mangin, A., 1982. L’approche systémique du karst, conséquences conceptuelles et méthodologiques, Pamplona.

Moriasi, D.N. et al., 2007. Evaluation Guidelines for Systematic Quantification of Accuracy in Watershed Simulation. American Society of Agricultural and Biological Engineers, 50(23351), pp.885–900.

Murillo, J.M. & Navarro, J.A., 2011. Aplicación del modelo de te ́mez a la determinación de la aportación superficial y subterránea del sistema hidrológico cornisa-vega de granada para su implementación en un modelo de uso conjunto. Boletin Geologico y Minero, 122(3), pp.363–388.

Neitsch, S.L. et al., 2011. Soil and water assessment tool — theoretical documentation — version 2009,

Norris, N., 2017. Sacramento Model - SRG. eWater, p.1. Available at: https://wiki.ewater.org.au/display/SD41/Sacramento+Model+-+SRG [Accessed October 1, 2017].

OMM, O.M.M., 2011. Guía de prácticas climatológicas, Available at: https://library.wmo.int/pmb ged/wmo 100 es.pdf.

Oster, R., 1979. La Precipitación en Colombia, Bogota D.C.

Overton, D., 1966. Muskingum flood routing of upland streamflow. J Hydrol, 4, pp.185–200.

Perrin, C., Michel, C. & Andréassian, V., 2003. Improvement of a parsimonious model for streamflow simulation. Journal of Hydrology, 279(1–4), pp.275–289. Available at: http://linkinghub.elsevier.com/retrieve/pii/S0022169403002257.

Pizarro, R., 1996. Análisis comparativo de modelos matemáticos precipitación-escorrentia en cuencas de España peninsular. Universidad Politécnica de Madrid.

Ponce, V., 1989. Engineering Hydrology: Principles and Practices H. P. Collage, ed.,

Ponce, V.. & Hawkins, R.., 1996. Runoff curve number: has it reached maturity? J Hydrol Eng, 1(1), pp.11–19.

Poveda, G., Gil, M. & Quiceno, N., 1998. El ciclo anual de la hidrología de Colombia en relación con el ENSO y la NAO.pdf. Bulletin Institute Francaise d´Etudes Andines, 27(3), pp.721–731.

Poveda, G. & Mesa, Ó.J., 1996. Las fases extremas del fenómeno ENSO ( El Niño y La Niña ). Ingenieria Hidraulica en mexico, XI(October 2016), pp.21–37.

Poveda, G. & Rojas, W., 1997. Evidencias de la asociación entre brotes epidemcos de malaria en Colombia y el Fenomeno El Niño- oscilación del Sur. Revista Academica Colombiana de ciencias, 21, pp.421–29.

Poveda, G., Velez, J. & Mesa, O., 2002. Influencia de fenómenos macroclimáticos sobre el ciclo anual de la hidrología colombiana: cuantificación lineal, no lineal y percentiles probabilísticos. Meteorología Colombiana, (January 2016), pp.121–130. Available at: http://www.geociencias.unal.edu.co/unciencias/data-file/user 23/file/METEOROLOGIA/13Poveda Clima Nuevo.pdf.

Purkey, D.R. et al., 2008. Robust analysis of future climate change impacts on water for agriculture and other sectors: a case study in the Sacramento Valley. Climatic Change, 87(S1), pp.109–122. Available at: http://link.springer.com/10.1007/s10584-007-9375-8.

Ramos, S., 2007. Modelos y Optimización I: Heurísticas y Problemas Combinatorios,

Rincón, J.C., 2006. Aplicación de algoritmos genéticos en la optimizacion del sistema de abastacimiento de Barquisimeto-Cabudare. Avances en Recursos Hidráulicos, (14), pp.25–38.

Sánchez, F., 2001. Análisis y evaluación comparativa de siete modelos Precipitación-Escorrentia (Budyko, Coutgne, Grunsky, Peñuelas, Pizarro, Turc, Turc-Pike) en la cuenca del río Malleco, IX región. Universidad de Talca.

Sandu, M.-A. & Virsta, A., 2015. Applicability of MIKE SHE to Simulate Hydrology in Argesel River Catchment. Agriculture and Agricultural Science Procedia, 6, pp.517–524. Available at: http://linkinghub.elsevier.com/retrieve/pii/S2210784315002685.

SIAC, 2012. Coberturas de la Tierra. Sistema de Informacion Ambiental Colombiano.

Teegavarapu, R. & Elshorbagy, A., 2005. Fuzzy conjunto medida de error basado en la evaluación del modelo hidrológico. Journal of Hydroinformatics,, 7(3), pp.199–207.

Témez, J.R., 1977. Modelo Matemático de trasformación “precipitación- escorrentía,” Madrid.

Thomas, H.A., 1981. Improved methods for National Water Assessment, Wahington, DC, USA. Available at: https://pubs.usgs.gov/unnumbered/70046351/report.pdf.

Thomas, H.A. et al., 1983. Methodology for water resource assessment, Virginia.

Thornthwaite, C.. & Mather, J.., 1955. The water balance. Climatology, VIII, p.104.

Todini, E., 1996. The ARNO rainfall—runoff model. Journal of Hydrology, 175(1–4), pp.339–382.

Tolson, B.A. & Shoemaker, C.A., 2007. Dynamically dimensioned search algorithm for computationally efficient watershed model calibration. Water Resources Research, 43(1), pp.1–16.

Tuppad, P. et al., 2010. Simulation of Agricultural Management Alternatives for Watershed Protection. Water Resources Management, 24(12), pp.3115–3144. Available at: http://link.springer.com/10.1007/s11269-010-9598-8.

Vazquez, R.F., 2015. Modelación hidrológica de una microcuenca Altoandina ubicada en el Austro Ecuatoriano. Maskana, 1(1), pp.79–90.

Velez, J., Poveda, G. & Mesa, O., 2000. Balances Hidrologicos de Colombia U. Nacional, ed., Medellin.

Williams, J.., 1975. Sediment routing for agricultural watersheds. Water Resour Bull, 11(5), pp.965–974.

Zhang, Z. et al., 2008. Evaluation of the MIKE SHE model for application in the Loess Plateau, China. Journal of the American Water Resources Association, 44(5), pp.1108–1120.
