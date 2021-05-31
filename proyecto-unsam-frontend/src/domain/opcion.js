export class Opcion {     
    constructor(descripcion, esCorrecta){
        this.descripcion = descripcion
        this.esCorrecta = esCorrecta
    }

static fromJson(opcionJSON) {
        return Object.assign(new Opcion(),
        opcionJSON,
            { }
        )
    }
}