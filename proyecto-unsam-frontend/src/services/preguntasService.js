import { REST_SERVER_URL } from './configuration'
import { Pregunta } from "../domain/pregunta";
import { usuarioService } from "./usuarioService";
import axios from 'axios'

class PreguntasService{
    
    getUsuarioLogueadoId(){
        return usuarioService.usuarioLogueado.usuarioId
    }

    async getPreguntas(palabraBuscada){
        const preguntasJSON = await axios.get(`${REST_SERVER_URL}/preguntas/${this.getUsuarioLogueadoId()}`, {params:{ palabraBuscada }})
        return preguntasJSON.data.map((preguntaJSON) => Pregunta.fromJson(preguntaJSON))
    }

    async getPreguntasActivas(palabraBuscada){
        const preguntasJSON = await axios.get(`${REST_SERVER_URL}/preguntas/${this.getUsuarioLogueadoId()}`, {params:{ palabraBuscada, activas:true }})
        return preguntasJSON.data.map((preguntaJSON) => Pregunta.fromJson(preguntaJSON))
    }

    async getPregunta(preguntaId) {
        const preguntaJSON = await axios.get(`${REST_SERVER_URL}/pregunta/${preguntaId}`)
        return Pregunta.fromJson(preguntaJSON.data)
    }

    async crearPregunta(pregunta) {
        await axios.put(`${REST_SERVER_URL}/crearpregunta`, pregunta.toJSON())
    }

    async updatePregunta(pregunta) {
        await axios.put(`${REST_SERVER_URL}/updatepregunta/${pregunta.preguntaId}`, pregunta.toJSON())
    }

    async contestarPregunta(preguntaId,opcionString, usuarioId) {
        await axios.get(`${REST_SERVER_URL}/respuesta/${preguntaId}/${opcionString}/${usuarioId}`)
    }

}

export const preguntasService = new PreguntasService()