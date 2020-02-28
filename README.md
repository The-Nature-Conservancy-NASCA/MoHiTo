# MoHiTo

El crecimiento poblacional y el aumento del nivel de vida en Colombia y en el mundo, a generando que se presente una mayor demanda de alimentos impulsando la producción agrícola hacia las últimas tierras naturales remanentes. En Colombia la región de la Orinoquia dentro de su jurisdicción constituye el segundo sistema de sabanas más grande de América del Sur y se considera como la última frontera agrícola para el país. Actualmente la Orinoquia Colombiana está experimentando una rápida expansión del desarrollo agrícola a gran escala, que incluye plantaciones de palma de aceite, caucho y eucalipto, así como cultivos anuales como arroz, maíz y soja, principalmente para abastecer una demanda interna creciente. Considerando que otras regiones de Colombia han experimentado auges agrícolas similares, con poca o ninguna planificación de los cambios en el uso de la tierra y la infraestructura asociada de energía y comunicaciones; lo que ha resultado en la pérdida de la biodiversidad y los servicios del ecosistémicos. Es así que MoHiTo (Herramienta de modelación hidrológica para la toma de decisiones) es una herramienta que surge de la necesidad de entender cómo se vería afectado el recurso hídrico en la región de la Orinoquia Colombiana ante estas futuras presiones de los diferentes sectores hidrodependientes. Bajo ésta premisa surgió el proyecto “Landscape planning for agro-industrial expansion in a large, well-preserved savanna: how to plan multifunctional landscapes at scale for nature and people in the Orinoquia región, Colombia”, el cual fue desarrollado bajo un marco interinstitucional e interdisciplinar con SIAT, WCS y The Nature Conservancy.


<img src="https://github.com/The-Nature-Conservancy-NASCA/MoHiTo/ICONS/Logo_TNC.jpg" width="1000" height="300" />


<img src="https://github.com/The-Nature-Conservancy-NASCA/MoHiTo/ICONS/Model.jpg" width="1000" height="300" />

## Estructura del modelo 

El modelo planteado fue programado en MATLAB versión 2016a con un enfoque funcional de tal forma que sea fácil la inclusión de nuevas rutinas. A continuación, se presentan los esquemas de cálculo y las ecuaciones programas.


Inicialmente, para cada una de las unidades hidrológicas definidas en el numeral 3, se resolvió el balance hídrico mediante el modelo de Thomas (1981). Este modelo considera dos compartimentos para el análisis del balance hídrico: el suelo o zona de evapotranspiración con almacenamiento Sw, y la zona saturada con almacenamiento Sg (Ver Figura 5 4).
Para efectos de modelación, la componente de flujo subsuperficial en la parte superficial de la zona de evapotranspiración se puede incluir en la escorrentía directa (Ro). El modelo considera despreciable el flujo lateral profundo (Qlat) en la zona no saturada, de tal forma que la recarga potencial (infiltración según Thomas) es igualada a la recarga real (Rg).
De esta forma, aplicando la ecuación de continuidad a un volumen de control Sw tenemos:
P_i- ET_i- Rg_i-Ro_i= ∆Sw= Sw_i- Sw_(i-1)
Donde P_i es la precipitación; 〖ET〗_i, la evapotranspiración real; 〖Rg〗_i, la recarga; 〖Ro〗_i, la escorrentía directa; ∆Sw, el cambio en el almacenamiento del suelo entre el período de cálculo i (〖Sw〗_i) y el período inmediatamente anterior (〖Sw〗_(i-1)). Thomas (1981) definen, además, las variables W_i (agua disponible) e Y_i como:
W_i= P_i+ Sw_(i-1)  
Y_i=ETR_i+Sw_(i-1)
En cada intervalo de tiempo se asume que la humedad disminuya según la ley de decaimiento exponencial, asumiendo como humedad inicial al comienzo de cada intervalo Y_i, donde 〖ETP〗_i es la evapotranspiración potencial y b(L) es un parámetro del modelo:
Sw_i= Y_i*e^(-ETR_i/b)
Thomas (1981) define la variable de estado Y_i como una función no lineal del agua disponible según los parámetros a (adimensional) y b:
Y_i=  (W_i+b)/2a 〖-[((W_i+b)/2a)^2- (W_i b)/a]〗^0,5
Donde a y b son parámetros que pueden ser determinados a partir de mediciones de precipitación, evapotranspiración y humedad del suelo en la cuenca. Esta función asegura que Y_i≤W_i,Y_i (0)=1 y Y_i (¥)= 0  (Alley, 1984).
El límite superior de Y_i es representado por el parámetro b. Thomas et al. (1983) hacen notar que, a excepción de estas propiedades, la función Y_i no tiene algún significado particular. Entonces, al sustituir en las ecuaciones anteriores se obtiene:
W_i- Y_i= 〖Rg〗_i+〖Ro〗_i
Para diferenciar la escorrentía de la recarga se asume un coeficiente de reparto c:
〖Ro〗_i=(1-c)(W_i- Y_i) 
〖Rg〗_i=c(W_i- Y_i) 
El caudal subterráneo (〖Qg〗_i), es decir, aquella fracción del caudal observado en el río que proviene del almacenamiento en la zona saturada (〖Sg〗_i), es:
〖Qg〗_i=d*〖Sg〗_i
El almacenamiento 〖Sg〗_i tiene que interpretarse como un almacenamiento dinámico, expresión de la conectividad entre el río y el acuífero. Por lo tanto, al aplicar la ecuación de continuidad a un volumen de acuífero de almacenamiento 〖Sg〗_i tenemos:
〖Rg〗_i  - 〖Qg〗_i= 〖∆Sg〗_i=  〖Sg〗_i- 〖Sg〗_(i-1)
Donde 〖∆Sg〗_i es el cambio en almacenamiento de la zona saturada y 〖Sg〗_(i-1) es el almacenamiento de aguas subterráneas en el período inmediatamente anterior. Al sustituir en las ecuaciones anteriores y resolver por 〖Sg〗_i, tenemos:
〖Sg〗_i=  (〖Rg〗_i+〖Ro〗_i)/(d+1)
El caudal total, es decir, el caudal observado en el río, es:
〖Qs〗_i=〖Ro〗_i+〖Rg〗_i
De acuerdo con Thomas et al. (1983), los parámetros a, b, c, y d se pueden interpretar de la siguiente forma:
A	refleja la tendencia de la escorrentía a ocurrir antes de que el suelo esté completamente saturado. Valores de “a” menores a 1 generan escorrentía cuando W_i<b (Alley, 1984).
B	es el límite superior a la suma de la evapotranspiración real y la humedad del suelo.
C	es la fracción del caudal promedio del río que proviene del agua subterránea.
D	es “el recíproco del tiempo de residencia del agua subterránea”.
 
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
