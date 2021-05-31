package ar.edu.unsam.pregunta3.controller

import ar.edu.unsam.pregunta3.model.Pregunta
import ar.edu.unsam.pregunta3.service.PreguntaService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.CrossOrigin
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.SerializationFeature
import java.time.LocalDateTime
import com.fasterxml.jackson.annotation.JsonView
import ar.edu.unsam.pregunta3.dto.View
import org.springframework.web.bind.annotation.RequestParam
import ar.edu.unsam.pregunta3.service.PreguntaRespondidaService

@RestController
@CrossOrigin
class PreguntaController {
	@Autowired
	PreguntaService preguntaService;
	@Autowired
	PreguntaRespondidaService preguntaRespondidaService

	// -------------------------  GET A QUESTION BY ID ----------------------------------------
	@GetMapping("/pregunta/{preguntaId}")
	def getPreguntaById(@PathVariable String preguntaId) {
		return preguntaService.getPreguntaById(preguntaId)
	}

	// -------------------------  GET ALL QUESTIONS OF USER ----------------------------------------
	@GetMapping("/preguntas/{usuarioId}")
	def getAllPreguntas(@PathVariable String usuarioId, @RequestParam(defaultValue="") String palabraBuscada,
		@RequestParam(required=false) boolean activas) {
		activas
			? return preguntaService.searchPreguntasActivas(palabraBuscada, usuarioId)
			: return preguntaService.searchPreguntas(palabraBuscada, usuarioId)
	}

	// -------------------------  CREATE QUESTION ----------------------------------------
	@PutMapping("/crearpregunta")
	def crearPregunta(@RequestBody String body) {

		val pregunta = mapper.readValue(body, Pregunta)
		pregunta.fechaYHoraCreacion = LocalDateTime.now()
		pregunta.preguntaId = null
		preguntaService.addPregunta(pregunta)
		ResponseEntity.ok("Pregunta creada correctamente.")
	}

	// -------------------------  UPDATE QUESTION ----------------------------------------
	@PutMapping("/updatepregunta/{id}")
	def actualizar(@RequestBody String body, @PathVariable String id) {
			val preguntaActualizada = mapper.readValue(body, Pregunta)
			preguntaService.updatePregunta(preguntaActualizada)
			ResponseEntity.ok("Pregunta actualizada correctamente")
	}

	// -------------------------  ANSWER QUESTION  ----------------------------------------
	@JsonView(View.Usuario.UsuarioSimple)
	@GetMapping("/respuesta/{preguntaId}/{opcionString}/{usuarioId}")
	def respuestaDePregunta(@PathVariable Integer usuarioId, @PathVariable String preguntaId,
		@PathVariable String opcionString) {
			preguntaService.responderPregunta(usuarioId, preguntaId, opcionString);
	}

	static def mapper() {
		new ObjectMapper => [
			configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
			configure(SerializationFeature.INDENT_OUTPUT, true)
		]
	}
}
