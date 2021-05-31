

export class LogDeEdicion {
    constructor(logId, preguntaId, autorId, pregunta, fechaDeEdicion, opciones = []) {
        this.logId = logId
        this.preguntaId = preguntaId
        this.autorId = autorId
        this.pregunta = pregunta
        this.fechaDeEdicion = fechaDeEdicion
        this.opciones = opciones
    }

    static fromJson(logJSON) {
        return Object.assign(new LogDeEdicion(),
        logJSON,
            { }
        )
    }
}