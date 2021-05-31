package ar.edu.unsam.pregunta3.model

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import com.fasterxml.jackson.annotation.JsonIgnore
import java.util.ArrayList
import java.time.LocalDate
import com.fasterxml.jackson.annotation.JsonFormat
import com.fasterxml.jackson.annotation.JsonProperty
import java.time.format.DateTimeFormatter
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.GeneratedValue
import javax.persistence.Column
import javax.persistence.OneToMany
import javax.persistence.FetchType
import javax.persistence.CascadeType
import javax.persistence.ManyToMany
import com.fasterxml.jackson.annotation.JsonView
import ar.edu.unsam.pregunta3.dto.View
import javax.persistence.Transient

@Accessors
@Entity
class Usuario {
	
	@Id @GeneratedValue
	@JsonView(View.Usuario.UsuarioSimple,View.Pregunta.PreguntaSimple, View.Pregunta.PreguntaConUsuario)
	Integer usuarioId;
	
	@Column(length=50)
	@JsonView(View.Usuario.UsuarioSimple,View.Pregunta.PreguntaSimple,View.Pregunta.PreguntaConUsuario)
	String nombre;
	
	@Column(length=50)
	@JsonView(View.Usuario.UsuarioSimple,View.Pregunta.PreguntaSimple,View.Pregunta.PreguntaConUsuario)
	String apellido;
	
	@Column
	@JsonView(View.Usuario.UsuarioSimple,View.Pregunta.PreguntaConUsuario)
	LocalDate fechaNacimiento;

	@ManyToMany(fetch= FetchType.LAZY)
    List<Usuario> amigos = new ArrayList<Usuario>
    
    @JsonView(View.Usuario.UsuarioSimple,View.Pregunta.PreguntaConUsuario)
	double puntajeAcumulado;
	
	@Column(length=50)
	String username
	
	@Column(length=50)
	@JsonIgnore String password
	
	@OneToMany(fetch= FetchType.LAZY, cascade=CascadeType.ALL)
	@JsonView(View.Usuario.UsuarioSimple)
	@Transient
	List<PreguntaRespondida> preguntasRespondidas = new ArrayList<PreguntaRespondida>
	
	new (String _nombre, String _apellido, LocalDate _fechaNacimiento){
		nombre = _nombre
		apellido = _apellido
		fechaNacimiento = _fechaNacimiento 
	}
	
	new (){	
	}
	
	
	@JsonProperty("fechaNacimiento")
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
	def getFechaNacimiento(){
		return fechaNacimiento
	}
	
	@JsonProperty("fechaNacimiento")
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
	def setFechaNacimiento(String _fechaNueva){
		
		if(_fechaNueva !== null)
		fechaNacimiento = LocalDate.parse(_fechaNueva, formatter)
	}
	
	def formatter() {
		DateTimeFormatter.ofPattern("yyyy-MM-dd")
	}
	
	def void agregarAmigo(Usuario usuario){
		amigos.add(usuario)
	}
		
	def loginCorrecto(LoginUsuario busqueda){
		return ((busqueda.username == username) && (busqueda.password == password))
	}
	
	def responderPregunta(Pregunta pregunta, String opcionElegidaString, Usuario autor){
		var puntosPorPregunta = 0
		
		if(pregunta.esCorrecta(opcionElegidaString)){
			respuestaCorrecta(pregunta, autor)
			puntosPorPregunta = pregunta.puntosOtorgados()
		}
		return new PreguntaRespondida (pregunta.preguntaId, pregunta.pregunta, puntosPorPregunta, usuarioId.toString())
	}
	
	def respuestaCorrecta(Pregunta pregunta, Usuario autor){
		puntajeAcumulado+= pregunta.puntosOtorgados()
		pregunta.respondidaCorrectamente(autor)
			
	}
	
	def validar(){
		if (nombre.nullOrEmpty) {
			throw new UserException("Debe ingresar nombre")
		}
		
		if (apellido.nullOrEmpty) {
			throw new UserException("Debe ingresar apellido")
		}
		
		if (fechaNacimiento === null) {
			throw new UserException("Debe ingresar fecha")
		}
	}
	
	def sumarPuntos(int puntos){
		puntajeAcumulado += puntos
	}
	
	def restarPuntos(int puntos){
		puntajeAcumulado -= puntos
	}
	
	def merge(Usuario otroUsuario) {
		nombre = otroUsuario.nombre ?: nombre
		apellido = otroUsuario.apellido ?: apellido
		fechaNacimiento = otroUsuario.fechaNacimiento ?: fechaNacimiento
	}
	
	
}
