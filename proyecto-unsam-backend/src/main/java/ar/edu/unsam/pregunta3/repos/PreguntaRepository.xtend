package ar.edu.unsam.pregunta3.repos

import ar.edu.unsam.pregunta3.model.Pregunta
import java.util.List
import org.springframework.data.mongodb.repository.MongoRepository
import org.springframework.data.mongodb.repository.Query
import java.time.LocalDateTime

interface PreguntaRepository extends MongoRepository<Pregunta, String> {	

	@Query("{ pregunta: { '$regex': ?0, '$options': 'i' }, _id: { $nin: ?1} }")
	def List<Pregunta> getPreguntasNoRespondidas(String busqueda, List<String> listaIds)
	
	@Query("{ pregunta: { '$regex': ?0, '$options': 'i' }, _id: { $nin: ?1}, fechaYHoraCreacion: {$gte: ?2} }")
	def List<Pregunta> getPreguntasNoRespondidasActivas(String busqueda, List<String> listaIds, LocalDateTime fechaActual)
}