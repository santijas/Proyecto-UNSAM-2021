package ar.edu.unsam.pregunta3.model

import java.time.LocalDateTime
import org.eclipse.xtend.lib.annotations.Accessors
import com.fasterxml.jackson.annotation.JsonView
import ar.edu.unsam.pregunta3.dto.View
import org.springframework.data.redis.core.RedisHash
import org.springframework.data.annotation.Id
import org.springframework.data.redis.core.index.Indexed

@Accessors
@JsonView(View.Usuario.UsuarioSimple)
@RedisHash("PreguntaRespondida")
class PreguntaRespondida {
	@Id
	String preguntaRespondidaId
		
	String preguntaId
	
	@Indexed String usuarioId
	
	String preguntaString
	
	LocalDateTime fechaDeRespuesta
	
	
	int puntosOtorgados
	
	new(){}
	
	new(String _preguntaId, String _pregunta,int _puntosOtorgados, String _usuarioId){
		preguntaId = _preguntaId
		preguntaString = _pregunta
		fechaDeRespuesta = LocalDateTime.now
		puntosOtorgados = _puntosOtorgados
		usuarioId = _usuarioId
	}	
	
//	@TimeToLive
//	def long getTimeToLive() {
//	  	return 300 
//    }
}