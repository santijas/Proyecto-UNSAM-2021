export class Pregunta {     
    constructor(preguntaId, pregunta, fechaYHoraCreacion, autorId ,opciones = [], type, puntajeOtorgadoPorElAutor, activa){
        this.preguntaId = preguntaId
        this.pregunta = pregunta
        this.fechaYHoraCreacion = fechaYHoraCreacion
        this.autorId = autorId
        this.opciones = opciones
        this.type = type
        this.puntajeOtorgadoPorElAutor = puntajeOtorgadoPorElAutor
        this.activa = activa
    }


static fromJson(preguntaJSON) {
        return Object.assign(new Pregunta(),
        preguntaJSON,
            { }
        )
    }
    toJSON() {
        return {
          ...this
        }
    }

}

export class PreguntaSimple extends Pregunta {
    puntos = 10

    static fromJson(preguntaSimpleJSON) {
        return Object.assign(new PreguntaSimple(),
        preguntaSimpleJSON,
            { }
        )
    }

    toJSON() {
        return {
          ...this
        }
    }
}

export class PreguntaRiesgo extends Pregunta {
    puntos = 100

    static fromJson(preguntaRiesgoJSON) {
        return Object.assign(new PreguntaRiesgo(),
        preguntaRiesgoJSON,
            { }
        )
    }

    toJSON() {
        return {
          ...this
        }
    }
}

export class PreguntaSolidaria extends Pregunta {
    puntajeOtorgadoPorElAutor

    static fromJson(preguntaSolidariaJSON) {
        return Object.assign(new PreguntaSolidaria(),
        preguntaSolidariaJSON,
            { }
        )
    }

    toJSON() {
        return {
          ...this
        }
    }
}

export class PreguntaRespondida {
    constructor(id, pregunta, fechaDeRespuesta, puntos) {
        this.id = id
        this.pregunta = pregunta
        this.fechaDeRespuesta = new Date(fechaDeRespuesta)
        this.puntos = puntos
    }
}