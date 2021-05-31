package ar.edu.unsam.pregunta3.model

import java.util.List
import com.fasterxml.jackson.annotation.JsonTypeName
import org.springframework.data.mongodb.core.mapping.Document
import org.eclipse.xtend.lib.annotations.Accessors

@JsonTypeName("preguntaSimple")
@Accessors
@Document(collection = "pregunta")
class PreguntaSimple extends Pregunta {
	

	new(String pregunta, Integer autorId, List<Opcion> opciones) {
		this.pregunta = pregunta
		this.autorId = autorId
		this.opciones = opciones
	}
	
	
		new(){
		
	}
	
	override int puntosOtorgados() {
		10
	}
}
