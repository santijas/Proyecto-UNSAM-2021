package ar.edu.unsam.pregunta3.dto

import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unsam.pregunta3.model.Pregunta

@Accessors
class PreguntaDTO {
	String preguntaId;
	String pregunta;

	
	private new() {}
	
	def static fromPregunta(Pregunta pregunta) {
		new PreguntaDTO => [
			preguntaId = pregunta.preguntaId
			pregunta = pregunta.pregunta

		]
	}
}