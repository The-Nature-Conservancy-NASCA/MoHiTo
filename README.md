# MoHiTo

El crecimiento poblacional y el aumento del nivel de vida en Colombia y en el mundo, a generando que se presente una mayor demanda de alimentos impulsando la producción agrícola hacia las últimas tierras naturales remanentes. En Colombia la región de la Orinoquia dentro de su jurisdicción constituye el segundo sistema de sabanas más grande de América del Sur y se considera como la última frontera agrícola para el país. Actualmente la Orinoquia Colombiana está experimentando una rápida expansión del desarrollo agrícola a gran escala, que incluye plantaciones de palma de aceite, caucho y eucalipto, así como cultivos anuales como arroz, maíz y soja, principalmente para abastecer una demanda interna creciente. Considerando que otras regiones de Colombia han experimentado auges agrícolas similares, con poca o ninguna planificación de los cambios en el uso de la tierra y la infraestructura asociada de energía y comunicaciones; lo que ha resultado en la pérdida de la biodiversidad y los servicios del ecosistémicos. Es así que MoHiTo (Herramienta de modelación hidrológica para la toma de decisiones) es una herramienta que surge de la necesidad de entender cómo se vería afectado el recurso hídrico en la región de la Orinoquia Colombiana ante estas futuras presiones de los diferentes sectores hidrodependientes. Bajo ésta premisa surgió el proyecto “Landscape planning for agro-industrial expansion in a large, well-preserved savanna: how to plan multifunctional landscapes at scale for nature and people in the Orinoquia región, Colombia”, el cual fue desarrollado bajo un marco interinstitucional e interdisciplinar con SIAT, WCS y The Nature Conservancy.


<img src="https://github.com/The-Nature-Conservancy-NASCA/MoHiTo/blob/master/ICONS/TNC_Logo.png" width="100" height="30" />


<img src="https://github.com/The-Nature-Conservancy-NASCA/MoHiTo/blob/master/ICONS/Model.png" width="600" height="500" />
Figura 5-4

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

<img src="https://github.com/The-Nature-Conservancy-NASCA/Images_Repository/blob/master/Exploratory_Module_SIMA/Frag.jpg" width="1000" height="300" />

Figura 5 5. Esquema de acumulación de caudales planteado para el modelo
En cada paso de tiempo se realiza el balance hídrico en todas las unidades hidrológicas mediante el modelo de Thomas, donde además se realiza la acumulación de los caudales individuales, obteniendo como resultado del caudal real simulado a la salida de cada Unidad Hidrológica - UH. El diagrama del esquema de cálculo se presenta en la Figura 5 5.

Conjuntamente con la agregación de los caudales se realiza la extracción de la demanda y la interacción del río con la planicie. Para este último se integra el modelo conceptual desarrollado por Angarita et al. (2017) el cual ha sido implementado y probado en WEAP. El esquema conceptual de este modelo se muestra en la Figura 5 6.
 
Figura 5 6. Esquema conceptual de integración río planicie.
Matemáticamente, la integración del modelo de Angarita et al. (2017) en el de Thomas (1981), estaría dada en el caudal acumulado de las cuencas con planicie de inundación.
Q_(T_i )=Q_(T_i )-Q_(l_i )+ R_(l_i )
Donde Q_(T_i ) corresponde al caudal acumulado hasta la UHi; el Q_(l_i ) representa los flujo lateral entre el río y llanura de inundación, mientras que el R_l representa los flujos laterales entre el río y la llanura de inundación.
 
Figura 5 7. Esquema de interaccion río planicie. En azul se esquematizan las planicies de inundación.

En otras palabras, a medida que se está acumulando el caudal, se verifica la existencia de planicie de inundación. De existir, se detiene la acumulación y se realiza el balance mostrado anteriormente. Esquemáticamente la representación seria como lo ilustrado en la Figura 5 7.
Conceptualmente Angarita et al. (2017) plantean que la zona de inundación tendrá un área determinada A_h, la cual a su vez será capaz de almacenar un volumen de agua V_(h_i ), donde dicho volumen fluctúa en función de los aportes que le realice el río a la planicie de inundación, o que la planicie le realice al río, así como también de los aportes directos por precipitación (P) y las perdidas por evapotranspiración (ETR) (A_T representa el área total acumulada hasta la unidad donde se realiza el balance ).
V_(h_i )= -Q_(l_i )+R_(l_i )+  A_h/A_T *(P_i-〖ETR〗_i)
Los flujos bidireccionales son definidos por dos umbrales Q_Umbral y V_Umbral según la dirección del flujo. De igual forma, es necesario tener en cuenta  que no toda el agua que aporte el río a la planicie será almacenada, ni tampoco toda el agua que aporte la planicie al río se convertirá en caudal. En consecuencia, se definen dos parámetros T_(río-planicie) y T_(planicie-río), los cuales indican el porcentaje de aporte en cada una de las direcciones de la interacción.
Q_(l_i )={█(T_(río-planicie)*(Q_(T_i )- Q_Umbral ),si  Q_(T_i )> Q_Umbral@0,si  Q_(T_i )< Q_Umbral )┤
R_(l_i )={█(T_(planicie-río)*(V_(h_i )- V_Umbral ),si  V_(h_i )> V_Umbral@0,si  V_(h_i )< V_Umbral )┤
Por otra parte, la inclusión de la demanda sigue el mismo concepto utilizado para las planicies de inundación. En cada paso de tiempo se realiza la acumulación de la demanda superficial generada por los sectores hidrodependientes, de tal forma que en cada unidad se tiene la demanda superficial total acumula de todos los sectores (Ver Figura 5 8). 
  
Figura 5 8. Acumulación de demandas por unidad hidrológica. Las figuras en verde y rojo representas las zonas de demandad de los diferentes sectores y en azul se demarcan las planicies de inundación.

Al igual que en el modelo de planicies, a medida que se está acumulando el caudal, se realiza también la acumulación de la demanda, paralelamente en cada unidad se verifica si se realiza extracción o no; de existir, se detiene la acumulación y se realiza el siguiente balance:
Q_(T_i )=Q_(T_i )-〖Dsp〗_i
En lo que respecta a la demanda subterránea, el esquema acumulativo que se ha venido describiendo debe ser replanteado, dado que los límites establecidos por las unidades hidrológicas no coinciden necesariamente con las unidades hidrogeológicas (UHG).
El modelo de Thomas (1981) realiza los balances a nivel de los acuíferos para cada unidad hidrológica. En concordancia con esto, se podría extraer la demanda subterránea presente en cada unidad del almacenamiento 〖Sg〗_i. 
Sin embargo, la implementación de este esquema no prevé que una UHG puede contener varias unidades hidrológicas. En este orden de ideas, se realiza una agrupación de las unidades hidrologías por UHG. 
En cada paso de tiempo se realiza la estimación del volumen de agua total 〖Vsb〗_i^g de las unidades hidrogeológicas “g” multiplicando los almacenamientos 〖Sg〗_i^n de las unidades hidrológicas “nu” con sus respectivas áreas.
A este volumen se le extrae las demandas subterráneas 〖Dsb〗_i^n de cada unidad quedando de esta forma afectada el agua subterránea para el paso de tiempo siguiente. El volumen resultante se redistribuye nuevamente en las unidades hidrológicas ponderando por el almacenamiento del paso anterior. Esto con el objetivo de conservar las proporciones en cada una de las unidades hidrológicas. Las expresiones matemáticas que describen este proceso son:
〖Vsb〗_i^g=[∑_(n=1)^nu▒〖Sg〗_i^n *A^n ]-[∑_(n=1)^nu▒〖Dsb〗_i^n ]
 〖Sg〗_i^n  =(〖Vsb〗_i^g)/A^n    (〖Sg〗_i^n)/[∑_(n=1)^nu▒〖Sg〗_i^n ]   
Por último, el esquema de acumulación descrito anteriormente, permite incluir retornos superficiales, como una adición al caudal acumulado hasta cada unidad.
