DejateCaer
==========

[![Build Status](https://travis-ci.org/LabPLC/DejateCaer.svg?branch=master)](https://travis-ci.org/LabPLC/DejateCaer)

Aplicación en iOS que encuentra eventos a tu alrededor.

Es una Aplicación en iOS que permite al usuario encontrar eventos en la ciudad de mexico de una manera facil y amigable, los eventos que esta app presenta al usuario son eventos que distintas secretarias del gobierno de la ciudad de México provee.

Con esto se logra promover la cultura de la Ciudad de México , dando asi al usuario la opcción de encontrar la oferta diaria de eventos en la ciudad.

#Construir 

Para compilar el proyecto y probarlo con iOS 7.1.1  , se necesita XCODE Version 5.1.1 (5B1008).
Los Frameworks que carga el proyecto para el funcionamiento de la aplicaciones son :

1. CoreLocation
2. MapKit
3. Foundation 
4. CoreGraphics
5. XCTest (para Test  del archivo ViewControllerTest.m)

#Datos 

Los datos que la aplicacion presentan provienen de la Secretaria de Turismo y la Secretaria de Cultura de la Ciudad de México, para consultalos en su formato original sigue los siguiente enlaces:

1. [Cultura](http://www.cultura.df.gob.mx/index.php/cartelera/eventos)
2. [Turismo](http://www.mexicocity.gob.mx/calendario.php?cat=21100&sub=0&evento=2014-4-19)

Para consultar los datos en formato json :

1.  [CodigoCDMX](http://codigo.labplc.mx/~rockarloz/dejatecaer/dejatecaer.php?longitud=-99.13330667&latitud=19.42342714&radio=2000&fecha=2014-03-18)

Para realizar una peticion al servidor de CodigoCDMX debes tomar encuenta que debes mandar los siguientes parametros:
1. Latitud
2. Longitud
3. Radio de búsqueda.

#Ejecutar Aplicación 

Para ejecutar la aplicación desde el simulador debes emular la ubicacion del simulador en la ciudad de México y asi poder tener resultados.

Para ejecutar la aplicación desde el Dispositivo desbes usar tus provisionamientos de desarrollador, permitir de obtener la ubicación a la aplicación.


#¿Cómo Funciona?

La aplicación inicia buscando eventos cerca del a ubicación del usuario a un radio predeterminado de 2Km.

<p align="center">
  <img src="https://raw.githubusercontent.com/LabPLC/DejateCaer/master/Capturas/mapa.png" alt="cerca" height="460" width="240"/>
  </p>


El usuario puede ralizar la búsqueda eventos alrededor del lugar que indique en la barra de búsqueda:

![alt text](https://github.com/LabPLC/DejateCaer/blob/master/Capturas/buscar.png?raw=true "buscar")

La aplicacíon presenta los eventos de 2 formas:

Enseña marcadores en el mapa:

![alt text](https://github.com/LabPLC/DejateCaer/blob/master/Capturas/mapa.png?raw=true "mapa")

Lista de lugares:

En la lista de lugares los eventos de manera que se enseñen primero los eventos mas cercanos al punto de búsqueda.

![alt text](https://github.com/LabPLC/DejateCaer/blob/master/Capturas/lista.png?raw=true "lista")
![alt text](https://github.com/LabPLC/DejateCaer/blob/master/Capturas/lista2.png?raw=true "lista2")

Al seleccionar un eventos en cualquiera de las vistas, se mostrara los detalles de dicho evento, y tambien compartir dicha informacion en las redes sociales.

![alt text](https://github.com/LabPLC/DejateCaer/blob/master/Capturas/detalles.png?raw=true "detalles")

Tambien puedes configurar el radio de búsqueda en la sección Opcciones
![alt text](https://github.com/LabPLC/DejateCaer/blob/master/Capturas/opcciones.png?raw=true "opcciones")

#Comentarios

Para dejar dudas, sugerencias o comentarios:
* Twitter: [@rockarloz](www.twitter.com/rockarloz)
* e-mail: rockarlos@me.com
* Web-Site: [Eventario](www.eventario.mx)
