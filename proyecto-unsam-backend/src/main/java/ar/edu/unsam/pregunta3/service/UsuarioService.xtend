package ar.edu.unsam.pregunta3.service

import org.springframework.stereotype.Service
import java.util.List
import ar.edu.unsam.pregunta3.model.Usuario
import org.springframework.beans.factory.annotation.Autowired
import ar.edu.unsam.pregunta3.repos.UsuarioRepository
import ar.edu.unsam.pregunta3.model.LoginUsuario
import org.springframework.web.server.ResponseStatusException
import org.springframework.http.HttpStatus
import javax.transaction.Transactional

@Service
class UsuarioService {
	@Autowired
	UsuarioRepository usuarioRepo
	@Autowired
	PreguntaRespondidaService preguntaRespondidaService

	def List<Usuario> getAllUsuarios() {
		return usuarioRepo.findAll().toList
	}

	def Usuario getUsuarioById(int usuarioId) {
		val Usuario usuario = usuarioRepo.findById(usuarioId).orElseThrow([
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario " + usuarioId + " no existe")
		])
		val respuestas = preguntaRespondidaService.findPreguntasRespondidasDeUsuario(usuarioId.toString())
		usuario.preguntasRespondidas = respuestas
		return usuario
	}
	
	
	def Usuario loginUser(LoginUsuario busqueda){
		usuarioRepo.findByUsernameAndPassword(busqueda.username, busqueda.password).orElseThrow([
			throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Usuario o contraseña incorrecto")])
	}
	
	
	@Transactional
	def updateUser(Usuario usuario){
		val Usuario usuarioFound = getUsuarioById(usuario.usuarioId)
		usuarioFound.merge(usuario)
		validateAndUpdate(usuarioFound)
	}
	
	
	def validateAndUpdate(Usuario usuario){
			usuario.validar()
			usuarioRepo.save(usuario)
	}
	

	def listaDeAmigos(int usuarioId){
		usuarioRepo.getAllFriends(usuarioId)
	}
	
	
	def listaDeNoAmigos(int usuarioId){
		usuarioRepo.getNoFriends(usuarioId)
	}
	

	def actualizarListaDeAmigos(int usuarioId, List<Usuario> listaDeAmigos) {
		val Usuario usuarioFound = getUsuarioById(usuarioId)
		usuarioFound.amigos = listaDeAmigos
		validateAndUpdate(usuarioFound)
	}
}
