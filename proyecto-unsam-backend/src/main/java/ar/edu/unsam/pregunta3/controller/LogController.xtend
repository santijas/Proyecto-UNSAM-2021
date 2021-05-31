package ar.edu.unsam.pregunta3.controller

import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.RestController
import org.springframework.beans.factory.annotation.Autowired
import ar.edu.unsam.pregunta3.repos.LogRepository
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.server.ResponseStatusException
import org.springframework.http.HttpStatus

@RestController
@CrossOrigin
class LogController {
	
	@Autowired
	LogRepository logRepo
	
	@GetMapping("/logEdicion/{autorId}")
	def getEdicionesByAutor(@PathVariable String autorId) {
		return logRepo.findByAutorId(autorId).orElseThrow([
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario " + autorId + " no existe")
		])
	}
}