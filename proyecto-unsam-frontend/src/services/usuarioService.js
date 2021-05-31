import axios from 'axios'
import { REST_SERVER_URL } from './configuration'
import { Usuario } from "../domain/usuario";
import { LogDeEdicion } from "../domain/logDeEdicion";


class UsuarioService{
    
    usuarioLogueado = null

    usuarioAJson(usuarioJSON) {
        return Usuario.fromJson(usuarioJSON)
    }
    
    async loguearUsuario(login){     
        const usuarioJson = await axios.post(`${REST_SERVER_URL}/login`, login.toJSON())
        this.usuarioLogueado = this.usuarioAJson(usuarioJson.data)  
    }

    async getlistaDeAmigos(usuarioId){
        const listaDeAmigosJSON = await axios.get(`${REST_SERVER_URL}/listaAmigos/${usuarioId}`)
        return listaDeAmigosJSON.data
    }

    async getUsuario(usuarioId){
        const usuarioJson = await axios.get(`${REST_SERVER_URL}/usuario/${usuarioId}`)
        return this.usuarioAJson(usuarioJson.data)
    }

    async updateUser(user){
        const nuevoUsuario = new Usuario(user.usuarioId, user.nombre, user.apellido, user.username, user.fechaNacimiento, user.puntajeAcumulado)
        await axios.put(`${REST_SERVER_URL}/perfil`, nuevoUsuario.toJSON())
        this.usuarioLogueado = nuevoUsuario
    }

    async updateListaDeAmigos(listaAmigos,usuarioId) {
        console.log(listaAmigos)
        await axios.put(`${REST_SERVER_URL}/listaAmigos/update/${usuarioId}`, listaAmigos)
    }

    async getListaUsuarios(usuarioId) {
        const listaUsuariosJSON = await axios.get(`${REST_SERVER_URL}/listaUsuarios/${usuarioId}`)
        return listaUsuariosJSON.data
    }

    async getLogsDeUsuario(usuarioId) {
        const listaDeLogsJSON = await axios.get(`${REST_SERVER_URL}/logEdicion/${usuarioId}`)
        return listaDeLogsJSON.data.map((logJSON) => LogDeEdicion.fromJson(logJSON))
    }
}

export const usuarioService = new UsuarioService()