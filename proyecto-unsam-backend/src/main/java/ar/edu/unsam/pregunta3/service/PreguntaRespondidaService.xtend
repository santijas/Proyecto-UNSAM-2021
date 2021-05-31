package ar.edu.unsam.pregunta3.service

import org.springframework.stereotype.Service
import org.springframework.beans.factory.annotation.Autowired
import ar.edu.unsam.pregunta3.repos.PreguntaRespondidaRedisRepository
import java.util.List
import ar.edu.unsam.pregunta3.model.PreguntaRespondida
import org.springframework.data.domain.Example
import org.springframework.web.server.ResponseStatusException
import org.springframework.http.HttpStatus

@Service
class PreguntaRespondidaService {
	
	@Autowired
	PreguntaRespondidaRedisRepository preguntaRespondidaRepository
	
 	def List<PreguntaRespondida> findPreguntasRespondidasDeUsuario(String _usuarioId){
 		
 		try {			
	 		val PreguntaRespondida example = new PreguntaRespondida() => [ usuarioId = _usuarioId ]
	 		return preguntaRespondidaRepository.findAll(Example.of(example)).toList			
		} catch (Exception e) { 
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario ID inválido")
		}
 	}
}