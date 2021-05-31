package ar.edu.unsam.pregunta3.model

import org.eclipse.xtend.lib.annotations.Accessors
import org.springframework.data.annotation.Id
import javax.persistence.GeneratedValue

@Accessors
class Opcion{
	
	String descripcion
	
	boolean esCorrecta
	
	new(){}
	
	new(String _descripcion, boolean _esCorrecta){
		descripcion = _descripcion
		esCorrecta = _esCorrecta
	}
}