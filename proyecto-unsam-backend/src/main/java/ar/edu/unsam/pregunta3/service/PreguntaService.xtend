package ar.edu.unsam.pregunta3.service

import org.springframework.stereotype.Service
import ar.edu.unsam.pregunta3.model.Pregunta
import org.springframework.beans.factory.annotation.Autowired
import ar.edu.unsam.pregunta3.repos.PreguntaRepository
import org.springframework.web.server.ResponseStatusException
import org.springframework.http.HttpStatus
import javax.transaction.Transactional
import java.time.LocalDateTime
import ar.edu.unsam.pregunta3.model.LogDeEdicion
import ar.edu.unsam.pregunta3.repos.LogRepository
import ar.edu.unsam.pregunta3.repos.PreguntaRespondidaRedisRepository

@Service
class PreguntaService {
	@Autowired
	PreguntaRepository preguntaRepository
	@Autowired
	UsuarioService usuarioService;
	@Autowired
	LogRepository logRepository;
	@Autowired
	PreguntaRespondidaService preguntaRespondidaService
	@Autowired
	PreguntaRespondidaRedisRepository preguntaRespondidaRepository

	def addPregunta(Pregunta nuevaPregunta) {
		validateAndUpdate(nuevaPregunta)
	}

	def validateAndUpdate(Pregunta pregunta) {
		pregunta.validar()
		preguntaRepository.save(pregunta)
		logRepository.save(new LogDeEdicion(pregunta))
	}

	def Pregunta getPreguntaById(String preguntaId) {
		preguntaRepository.findById(preguntaId).orElseThrow([
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Pregunta " + preguntaId + " no existe")
		])
	}

	def updatePregunta(Pregunta pregunta) {
		val Pregunta preguntaFound = getPreguntaById(pregunta.preguntaId)
		preguntaFound.merge(pregunta)
		validateAndUpdate(preguntaFound)
	}

	def searchPreguntas(String palabraBuscada, String usuarioId) {
		preguntaRepository.getPreguntasNoRespondidas(palabraBuscada, listaDePreguntasRespondidas(usuarioId))
	}

	def searchPreguntasActivas(String palabraBuscada, String usuarioId) {
		val LocalDateTime fechaActual = LocalDateTime.now().minusMinutes(5)
		preguntaRepository.getPreguntasNoRespondidasActivas(palabraBuscada, listaDePreguntasRespondidas(usuarioId), fechaActual)
	}
	
	def listaDePreguntasRespondidas(String usuarioId){		
			val listaDeIds = preguntaRespondidaService.findPreguntasRespondidasDeUsuario(usuarioId).map[respuesta | respuesta.preguntaId]
			return listaDeIds
	}

	@Transactional
	def responderPregunta(Integer usuarioId, String preguntaId, String opcionElegidaString) throws Exception {
		val usuario = usuarioService.getUsuarioById(usuarioId)
		val pregunta = this.getPreguntaById(preguntaId)
		val autor = usuarioService.getUsuarioById(pregunta.autorId)
		
		if(pregunta.estaActiva){
			val respuesta = usuario.responderPregunta(pregunta, opcionElegidaString, autor)
			usuarioService.validateAndUpdate(usuario)
			usuarioService.validateAndUpdate(autor)
			preguntaRespondidaRepository.save(respuesta)
		} else{
			throw new ResponseStatusException(HttpStatus.METHOD_NOT_ALLOWED, "No es posible responder pregunta no activa.")
		}
	}
}
