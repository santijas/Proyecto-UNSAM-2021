package ar.edu.unsam.pregunta3.repos

import ar.edu.unsam.pregunta3.model.LogDeEdicion
import org.springframework.data.mongodb.repository.MongoRepository
import java.util.Optional
import java.util.List

interface LogRepository extends MongoRepository<LogDeEdicion, String> {
	
	def Optional<List<LogDeEdicion>> findByAutorId (String autorId)
}