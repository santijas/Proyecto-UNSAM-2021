package ar.edu.unsam.pregunta3.model

import java.util.List
import com.fasterxml.jackson.annotation.JsonTypeName
import javax.persistence.Column
import org.eclipse.xtend.lib.annotations.Accessors
import com.fasterxml.jackson.annotation.JsonView
import ar.edu.unsam.pregunta3.dto.View
import org.springframework.data.mongodb.core.mapping.Document

@JsonTypeName("preguntaSolidaria")
@Accessors
@Document(collection = "pregunta")
class PreguntaSolidaria extends Pregunta {

	@Column
	@JsonView(View.Pregunta.PreguntaSimple, View.Pregunta.PreguntaConUsuario)
	int puntajeOtorgadoPorElAutor

	new(String pregunta, Integer autorId, List<Opcion> opciones, int puntajeOtorgadoPorElAutor) {
		this.pregunta = pregunta
		this.autorId = autorId
		this.opciones = opciones
		this.puntajeOtorgadoPorElAutor = puntajeOtorgadoPorElAutor
	}
	
	new(){
		
	}

	override int puntosOtorgados() {
		puntajeOtorgadoPorElAutor
	}

	override void respondidaCorrectamente(Usuario autor) {
		autor.restarPuntos(puntajeOtorgadoPorElAutor)
	}
	
	override void validar(){
		super.validar()
		
		if (puntajeOtorgadoPorElAutor <= 0) {
			throw new UserException("Debe definir el puntaje otorgado por el autor")
		}
	}

}
