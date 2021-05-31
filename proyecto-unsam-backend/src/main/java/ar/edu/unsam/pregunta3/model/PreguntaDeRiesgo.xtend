package ar.edu.unsam.pregunta3.model

import java.util.List
import java.time.Duration
import java.time.LocalDateTime
import com.fasterxml.jackson.annotation.JsonTypeName
import org.springframework.data.mongodb.core.mapping.Document
import org.eclipse.xtend.lib.annotations.Accessors

@JsonTypeName("preguntaDeRiesgo")
@Accessors
@Document(collection = "pregunta")
class PreguntaDeRiesgo extends Pregunta {


	new(String pregunta, Integer autorId, List<Opcion> opciones) {
		this.pregunta = pregunta
		this.autorId = autorId
		this.opciones = opciones
	}

	
	new(){
		
	}
	
	override int puntosOtorgados() {
		100
	}

	override void respondidaCorrectamente(Usuario autor) {
		if (Duration.between(fechaYHoraCreacion, LocalDateTime.now()).toMinutes < 1) {
			autor.restarPuntos(50)
		}
	}
	

}
