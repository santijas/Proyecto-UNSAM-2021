package ar.edu.unsam.pregunta3.dto

import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unsam.pregunta3.model.Usuario

@Accessors
class AmigoDTO {
	int usuarioId;
	String nombre;
	String apellido;
	double puntajeAcumulado;
	
	private new() {}
	
	def static fromAmigo(Usuario amigo) {
		new AmigoDTO => [
			usuarioId = amigo.usuarioId
			nombre = amigo.nombre
			apellido = amigo.apellido
			puntajeAcumulado = amigo.puntajeAcumulado
		]
	}
}