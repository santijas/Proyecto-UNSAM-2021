package ar.edu.unsam.pregunta3.model

import org.springframework.data.annotation.Id
import java.time.LocalDateTime
import java.util.List
import java.util.ArrayList
import org.springframework.data.mongodb.core.mapping.Document
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
@Document(collection = "log_de_edicion")
class LogDeEdicion {
	@Id String logId
	
	String preguntaId
	
	String autorId
	
	String pregunta
	
	LocalDateTime fechaDeEdicion
	
	List<Opcion> opciones = new ArrayList<Opcion>
	
	new(Pregunta pregunta) {
		preguntaId = pregunta.preguntaId
		pregunta = pregunta.pregunta
		fechaDeEdicion = LocalDateTime.now()
		opciones = pregunta.opciones
		autorId = pregunta.autorId.toString()
	}
	
	new(){}
}