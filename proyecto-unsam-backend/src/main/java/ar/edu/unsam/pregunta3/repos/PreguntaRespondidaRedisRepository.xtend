package ar.edu.unsam.pregunta3.repos

import org.springframework.data.repository.CrudRepository
import ar.edu.unsam.pregunta3.model.PreguntaRespondida
import org.springframework.data.repository.query.QueryByExampleExecutor

interface PreguntaRespondidaRedisRepository extends CrudRepository<PreguntaRespondida, String>, QueryByExampleExecutor<PreguntaRespondida> {
	
}