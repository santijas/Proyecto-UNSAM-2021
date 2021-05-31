export class Usuario {
    
    constructor(usuarioId, nombre, apellido, username, fechaNacimiento, puntajeAcumulado){ 
      this.usuarioId = usuarioId
      this.nombre = nombre
      this.apellido = apellido
      this.username = username
      this.fechaNacimiento = fechaNacimiento
      this.puntajeAcumulado = puntajeAcumulado
    }


    static fromJson(usuarioJSON) {
        return Object.assign(new Usuario(),
        usuarioJSON,
          { }
        )
      }

    toJSON() {
        return {
          ...this
        }
    }
}


export class LoginUsuario {

    constructor(username, password){
        this.username = username
        this.password = password
    }

    toJSON() {
        return {
          ...this
        }
      }
}