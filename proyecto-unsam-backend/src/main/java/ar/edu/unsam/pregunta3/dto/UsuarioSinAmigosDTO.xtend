package ar.edu.unsam.pregunta3.dto

import org.eclipse.xtend.lib.annotations.Accessors
import java.time.LocalDate

@Accessors
class UsuarioSinAmigosDTO {
	int usuario_id;
	String nombre;
	String apellido;
	LocalDate fechaNacimiento;
	double puntajeAcumulado;
	String username	
}