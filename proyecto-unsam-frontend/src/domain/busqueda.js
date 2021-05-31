
export class Busqueda {

    constructor(palabraBuscada){
        this.palabraBuscada = palabraBuscada
    }

    toJSON() {
        return {
          ...this
        }
      }
}