package ar.edu.unsam.pregunta3.model

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import java.util.ArrayList
import java.time.LocalDateTime
import com.fasterxml.jackson.annotation.JsonTypeInfo
import com.fasterxml.jackson.annotation.JsonSubTypes
import java.time.temporal.ChronoUnit
import com.fasterxml.jackson.annotation.JsonProperty
import org.springframework.data.mongodb.core.mapping.Document
import org.springframework.data.annotation.Id

@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, include = JsonTypeInfo.As.PROPERTY, property = "type", visible = true)
@JsonSubTypes( @JsonSubTypes.Type(name = "preguntaSimple", value = PreguntaSimple ), @JsonSubTypes.Type(name = "preguntaDeRiesgo", value = PreguntaDeRiesgo ) , @JsonSubTypes.Type(name = "preguntaSolidaria", value = PreguntaSolidaria ) )
@Accessors 
@Document(collection = "pregunta")
abstract class Pregunta {
	@Id String preguntaId
	
	String pregunta
	
	LocalDateTime fechaYHoraCreacion = LocalDateTime.now()
	
	Integer autorId
	
	List<Opcion> opciones = new ArrayList<Opcion>
	
	@JsonProperty("fechaYHoraCreacion")
	def getFechaYHoraCreacion(){
		return fechaYHoraCreacion
	}
	
	@JsonProperty("fechaYHoraCreacion")
	def setFechaYHoraCreacion(String _fechaNueva){
		
		if(_fechaNueva !== null)
		fechaYHoraCreacion = LocalDateTime.parse(_fechaNueva)
	}
	
	def boolean esValida(){
		pregunta !== null && pregunta !== "" && opciones.length == 3 && opciones.exists[ opcion | opcion.esCorrecta ] &&
		opciones.filter[ opcion | opcion.esCorrecta ].length == 1
	}

	@JsonProperty("activa")
	def boolean estaActiva() {
		ChronoUnit.MINUTES.between( fechaYHoraCreacion ,LocalDateTime.now() ) < 5
	}
	
	def Opcion opcionCorrecta(){
		opciones.findFirst[ opcion | opcion.esCorrecta ]
	}
	
	def boolean esCorrecta(String opcionElegidaString){
		opcionCorrecta().descripcion == opcionElegidaString
	}

	def int puntosOtorgados()
	
	def void respondidaCorrectamente(Usuario autor){}
	
	def void validar(){
		if (pregunta.nullOrEmpty) {
			throw new UserException("Debe ingresar la pregunta")
		}
		
		if (opciones.length != 3) {
			throw new UserException("Debe tener tres opciones")
		}
		
		if(opciones.filter[ opcion | opcion.esCorrecta ].length != 1){
			throw new UserException("Debe existir una unica pregunta correcta")
		}
	}
	
	def merge(Pregunta otraPregunta) {
		pregunta = otraPregunta.pregunta ?: pregunta
		otraPregunta.opciones.length == 0 ? 
		opciones = opciones :
		opciones = otraPregunta.opciones
	}	
}
