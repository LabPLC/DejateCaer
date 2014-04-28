DejateCaer
==========

[![Build Status](https://travis-ci.org/LabPLC/DejateCaer.svg?branch=master)](https://travis-ci.org/LabPLC/DejateCaer)

Aplicación en iOS que encuentra eventos a tu alrededor.

Es una Aplicación en iOS que permite al usuario encontrar eventos en la ciudad de mexico de una manera facil y amigable, los eventos que esta app presenta al usuario son eventos que distintas secretarias del gobierno de la ciudad de México provee.

La aplicación inicia buscando eventos cerca del a ubicación del usuario a un radio predeterminado de 2Km.

![alt text](https://github.com/LabPLC/DejateCaer/blob/master/Capturas/cerca.png?raw=true "cerca")

El usuario puede ralizar la busque da eventos alrededor del lugar que indique en la barra de búsqueda:

![alt text](https://github.com/LabPLC/DejateCaer/blob/master/Capturas/buscar.png?raw=true "buscar")

La aplicaíon presenta los eventos de 2 formas:

Enseña marcadores en el mapa:

![alt text](https://github.com/LabPLC/DejateCaer/blob/master/Capturas/mapa.png?raw=true "mapa")

Lista de lugares:

![alt text](https://github.com/LabPLC/DejateCaer/blob/master/Capturas/lista.png?raw=true "lista")
![alt text](https://github.com/LabPLC/DejateCaer/blob/master/Capturas/lista2.png?raw=true "lista2")

Al seleccionar un eventos en cualquiera de las vistas, se mostrara los detalles de dicho evento

![alt text](https://github.com/LabPLC/DejateCaer/blob/master/Capturas/detalles.png?raw=true "detalles")

Tambien puedes configurar el radio de búsqueda en la sección Opcciones
![alt text](https://github.com/LabPLC/DejateCaer/blob/master/Capturas/opcciones.png?raw=true "opcciones")


Para compilar el proyecto y probarlo con iOS 7.1.1  , se necesita XCODE Version 5.1.1 (5B1008).
Los Frameworks que carga el proyecto para el funcionamiento de la aplicaciones son :

1. CoreLocation
2. MapKit
3. Foundation 
4. CoreGraphics
5. XCTest (para Test  del archivo ViewControllerTest.m)
