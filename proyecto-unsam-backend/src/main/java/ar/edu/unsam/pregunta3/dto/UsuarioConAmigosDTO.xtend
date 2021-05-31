package ar.edu.unsam.pregunta3.dto

import java.time.LocalDate
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List

@Accessors
class UsuarioConAmigosDTO {
	int usuario_id;
	String nombre;
	String apellido;
	LocalDate fechaNacimiento;
	double puntajeAcumulado;
	String username;
	List<AmigoDTO> amigos;
}