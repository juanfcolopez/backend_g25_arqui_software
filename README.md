## Framework Ruby on Rails



## Comandos

- sudo docker-compose run app rails db:create
- sudo docker-compose run app rails db:migrate
- sudo docker-compose up

## Consideraciones generales

- Pueden encontrar la API sin cache en https://arqui-example.tk/, y con cache en https://arqui-e1-with-cache.tk/
- Se debe crear un archivo config/local_env.yml para almacenar las variables de entorno para la base de datos.
- Para el proyecto, utilizamos RDS para la base de datos, lo que permite el autoescalado correcto.



## Requisitos

Por parte de backend los requisitos que hicimos o no hicimos son los siguientes:

## Parte mínima

### Sección mínima (50%) (30p)

#### **Backend**
* **RF1: (3p)** Se debe poder enviar mensajes y se debe registrar su timestamp. Estos mensajes deben aparecer en otro usuario, ya sea en tiempo real o refrescando la página. **El no cumplir este requisito completamente limita la nota a 3.9**. COMPLETO
* **RF2: (5p)** Se deben exponer endpoints HTTP que realicen el procesamiento y cómputo del chat para permitir desacoplar la aplicación. **El no cumplir este requisito completamente limita la nota a 3.9**. COMPLETO

* **RF3: (7p)** Establecer un AutoScalingGroup con una AMI de su instancia EC2 para lograr autoescalado direccionado desde un ELB (_Elastic Load Balancer_).
    * **(4p)** Debe estar implementado el Load Balancer. COMPLETO
    * **(3p)** Se debe añadir al header del request información sobre cuál instancia fue utilizada para manejar el request. Se debe señalar en el Readme cuál fue el header agregado. COMPLETO
* **RF4: (2p)** El servidor debe tener un nombre de dominio de primer nivel (tech, me, tk, ml, ga, com, cl, etc). COMPLETO

* **RF4: (3p)** El dominio debe estar asegurado por SSL con Let's Encrypt. No se pide *auto renew*. Tambien pueden usar el servicio de certificados de AWS para el ELB
    * **(2p)** Debe tener SSL. COMPLETO
    * **(1p)** Debe redirigir HTTP a HTTPS. COMPLETO
    
#### **Frontend**
* **RF5: (3p)** Utilizar un CDN para exponer los *assets* de su frontend. (ej. archivos estáticos, el mismo *frontend*, etc.). Para esto recomendamos fuertemente usar cloudfront en combinacion con S3. COMPLETO
* **RF6: (7p)** Realizar una aplicación para el *frontend* que permita ejecutar llamados a los endpoints HTTP del *backend*. COMPLETO
    * **(3p)** Debe hacer llamados al servidor correctamente. COMPLETO
    * Elegir **$1$** de los siguientes. No debe ser una aplicación compleja en diseño. No pueden usar una aplicacion que haga rendering via template de los sitios web. Debe ser una app que funcione via endpoints REST
        * **(4p)** Hacer una aplicación móvil (ej. Flutter, ReactNative) COMPLETO

## Sección variable

### Caché (25%) (15p)
Para esta sección variable la idea es implementar una capa de Caché para almacenar información y reducir la carga en el sistema. Para almacenar información para la aplicación recomendamos el uso de **Redis**, así como recomendamos Memcached para fragmentos de HTML o respuestas de cara al cliente. 

* **RF1: (4p)** Levantar la infraestructura necesaria de caché. Se puede montar en otra máquina o usando el servicios administrado por AWS. Se debe indicar como funciona en local y en producción. COMPLETO
* **RF2: (6p)** Utilizar la herramienta seleccionada de caché para almacenar las información para al menos 2 casos de uso. Por ejemplo las salas y sus últimos mensajes o credenciales de acceso (login). SEMI COMPLETO (SOLO UN CASO)
* **RF3: (5p)** Documentar y explicar la selección de la tecnología y su implementación en el sistema. Responder a preguntas como: "¿por qué se usó el FIFO/LRU o almacenar un hash/list/array?" para cada caso de uso implementado. COMPLETO (al final de este README)


### Mensajes en tiempo real (25%) (15p)
El objetivo de esta sección es implementar la capacidad de enviar actualizaciones hacia otros servicios. Servicios recomendados a utilizar: SNS, Sockets (front), AWS Pinpoint entre otras. 

* **RF1: (5p)** Cuando se escriben mensajes en un chat/sala que el usuario está viendo, se debe reflejar dicha acción sin que éste deba refrescar su aplicación. COMPLETO
* **RF2: (5p)** Independientemente si el usuario está conectado o no, si es nombrado con @ o # se le debe enviar una notificación (al menos crear un servicio que diga que lo hace, servicio que imprime "se está enviando un correo"). COMPLETO
* **RF3: (5p)** Debe documentar los mecanismos utilizados para cada uno de los puntos anteriores indicando sus limitaciones/restricciones. COMPLETO

### RF3 Caché
El caché se montó en un servicio Elasticache de AWS, utilizando Redis. Luego este caché se conecta con las instancias de EC2. En un principio se pensó en implementar el caché en la misma EC2, pero no era válido al escalar, si no que se se necesitaba que todas las instancias compartieran un mismo caché.

El caso de uso implementado fue de las salas, donde el caché almacena el hash que entrega la API al recibir la request correspondiente. En este caso, no se utiliza alguna política FIFO o LRU, ya que para que valga la pena tener el caché se debe almacenar la información de todas las salas. Este caché expira cuando se crea una sala nueva o cuando pasan 10 minutos, tiempo que puede ser modificado según sea necesario.