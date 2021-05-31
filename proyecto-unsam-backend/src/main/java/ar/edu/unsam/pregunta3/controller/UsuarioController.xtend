package ar.edu.unsam.pregunta3.controller
import org.springframework.web.bind.annotation.RestController
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import ar.edu.unsam.pregunta3.model.Usuario
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.http.ResponseEntity
import ar.edu.unsam.pregunta3.service.UsuarioService
import com.fasterxml.jackson.databind.SerializationFeature
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.DeserializationFeature
import ar.edu.unsam.pregunta3.model.LoginUsuario
import org.springframework.web.bind.annotation.CrossOrigin
import java.util.List
import ar.edu.unsam.pregunta3.dto.AmigoDTO
import com.fasterxml.jackson.annotation.JsonView
import ar.edu.unsam.pregunta3.dto.View

@RestController
@CrossOrigin
class UsuarioController {
	@Autowired
	UsuarioService usuarioService;

	// -------------------------  GET USER ----------------------------------------
	@JsonView(View.Usuario.UsuarioSimple)
	@GetMapping("/usuario/{usuarioId}")
	def getusuarioById(@PathVariable int usuarioId) {
		return usuarioService.getUsuarioById(usuarioId)
	}

	// -------------------------  LOGIN ENDPOINT ----------------------------------------
	@PostMapping("/login")
	def loginUsuario(@RequestBody LoginUsuario busqueda) {
		return AmigoDTO.fromAmigo(usuarioService.loginUser(busqueda))
	}

	// -------------------------  UPDATE USER ----------------------------------------
	@JsonView(View.Usuario.UsuarioSimple)
	@PutMapping("/perfil")
	def actualizarUsuario(@RequestBody Usuario usuarioActualizado) {
			usuarioService.updateUser(usuarioActualizado)
	}

	// -------------------------  LIST FRIENDS  ----------------------------------------
	@GetMapping("/listaAmigos/{usuarioId}")
	def getAmigos(@PathVariable int usuarioId) {
		return usuarioService.listaDeAmigos(usuarioId).map[ AmigoDTO.fromAmigo(it)]
	}


	// -------------------------  LIST NO FRIENDS --------------------------------------------
	
	@GetMapping("/listaUsuarios/{usuarioId}")
	def getUsuarios(@PathVariable Integer usuarioId) {
		return usuarioService.listaDeNoAmigos(usuarioId).map[ AmigoDTO.fromAmigo(it)]
	}
	
	// -------------------------  UPDATE USER FRIEND LIST ----------------------------------
	
	@PutMapping("/listaAmigos/update/{usuarioId}")
	def updateListaDeAmigos(@PathVariable Integer usuarioId, @RequestBody List<Usuario> listaDeAmigos) {
			usuarioService.actualizarListaDeAmigos(usuarioId, listaDeAmigos)
			ResponseEntity.ok("Lista de Amigos actualizada")
	}
	
	// -------------------------  MAPPER  ----------------------------------------

	static def mapper() {
		new ObjectMapper => [
			configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
			configure(SerializationFeature.INDENT_OUTPUT, true)
			disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS)
		]
	}

}
