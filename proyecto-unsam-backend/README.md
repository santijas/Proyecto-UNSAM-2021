# TP 2021 GRUPO 3 - SPRING BOOT

## Levantar docker-compose

Desde una **terminal** (O desde el VS Code) pararse en ./src/main/resources y ejecutar:

  **docker-compose up**


Esperar a que levante bien y empiece a hacer loop buscando conectarse a los nodos (o algo así).

Abrir otra terminal de windows (cmd o powershell) y ejecutar:

  **./win-init.sh**


Otra manera es abrir una terminal de linux (bash, ubuntu o wsl) y ejecutar:

  **./init.sh**


A esta altura ya deberían poder conectarse el Compass y el driver de mongo.

## Configuración de los shards

Por último hay que ingresar al container:

  **docker-compose exec router /bin/bash**


Ya adentro del container corremos mongo:

  **mongo**


Y configuramos nuestra BD:
- use pregunta3 _(Yo ya había corrido el driver pero sino supongo que habrá que crearla primero)_
- db.pregunta.ensureIndex({"_id": "hashed"})
- sh.enableSharding("pregunta3")
- sh.shardCollection("pregunta3.pregunta", {"_id": "hashed" }, false)
