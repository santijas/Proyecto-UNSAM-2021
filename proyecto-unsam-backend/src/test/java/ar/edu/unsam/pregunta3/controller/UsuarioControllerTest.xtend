package ar.edu.unsam.pregunta3.controller

import javax.transaction.Transactional
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.test.context.ActiveProfiles
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders
import static org.junit.jupiter.api.Assertions.assertEquals
import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.SerializationFeature
import java.util.List
import ar.edu.unsam.pregunta3.model.Usuario
import static org.junit.jupiter.api.Assertions.assertNotNull
import org.springframework.http.MediaType

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@DisplayName("Dado un controller de Usuarios")
class UsuarioControllerTest {
	
	@Autowired
	MockMvc mockMvc
	
	@Test
	@DisplayName("Consultamos un usuario y lo trae correctamente.")
	def void getUser() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/usuario/1")).andReturn.response
		val usuario = responseEntity.contentAsString.fromJson(Usuario)
		assertEquals(200, responseEntity.status)
		assertNotNull(usuario)
		assertEquals(usuario.nombre, "Eduardo")
	}
	
	@Test
	@DisplayName("Consultamos un usuario y arroja 404 not found.")
	def void getUserNotFound() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/usuario/200")).andReturn.response
		assertEquals(404, responseEntity.status)
	}
	
	@DisplayName("Se realiza un login correcto")
	@Test
	def void loginCorrecto() {
		
		mockMvc
		.perform(
			MockMvcRequestBuilders.post("/login")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"username": "edu", "password": "1234"}')
		)
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
	}
	
	@DisplayName("Se realiza un login incorrecto y devuelve error")
	@Test
	def void loginIncorrecto() {
			mockMvc
		.perform(
			MockMvcRequestBuilders.post("/login")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"username": "edu", "password": "123456"}')
		)
		.andExpect(status.unauthorized)
	}
	
	@Test
	@DisplayName("Se actualiza un usuario correctamente.")
	@Transactional
	def void updateUser() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.put("/perfil")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"nombre": "Osvaldito", "apellido": "Blanco", "usuarioId":"1"}')
		)
		.andExpect(status.isOk)
		.andExpect(content.contentType("application/json"))
		.andExpect(jsonPath("$.nombre").value('Osvaldito'))
	}
	
	@Test
	@DisplayName("No se actualiza un usuario debido a que no existe el ID.")
	@Transactional
	def void notUpdateUser() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.put("/perfil")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"nombre": "Pedrito", "usuarioId":"100"}')
		)
		.andExpect(status.notFound)
	}
	
	@Test
	@DisplayName("Consultamos la lista de amigos de un usuario.")
	def void getUserFriends() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/listaAmigos/1")).andReturn.response
		val usuarios = responseEntity.contentAsString.fromJsonToList(Usuario)
		assertEquals(200, responseEntity.status)
		assertNotNull(usuarios)
		assertEquals(usuarios.length, 2)
	}
	
	@Test
	@DisplayName("Consultamos la lista de amigos de un usuario que no posee amigos.")
	def void getUserWithNoFriends() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/listaAmigos/6")).andReturn.response
		val usuarios = responseEntity.contentAsString.fromJsonToList(Usuario)
		assertEquals(200, responseEntity.status)
		assertEquals(usuarios.length, 0)
	}
	
	@Test
	@DisplayName("Consultamos la lista de NO amigos de un usuario.")
	def void getUserNoFriends() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/listaUsuarios/1")).andReturn.response
		val usuarios = responseEntity.contentAsString.fromJsonToList(Usuario)
		assertEquals(200, responseEntity.status)
		assertNotNull(usuarios)
		assertEquals(usuarios.length, 4)
	}
	
	@Test
	@DisplayName("Se actualiza lista de amigos de un usuario correctamente.")
	@Transactional
	def void updateUserFriendlist() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.put("/listaAmigos/update/1")
			.contentType(MediaType.APPLICATION_JSON)
			.content('[
		    {
		        "usuarioId": 4,
		        "nombre": "Roberto",
		        "apellido": "Perfumo",
		        "puntajeAcumulado": 0
		    },
		    {
		        "usuarioId": 7,
		        "nombre": "Lionel",
		        "apellido": "Messi",
		        "puntajeAcumulado": 0
		    }]')
		)
		.andExpect(status.isOk)
	}
	
	
	@Test
	@DisplayName("Se actualiza lista de amigos de un usuario con una lista vacia.")
	@Transactional
	def void updateUserFriendlistEmpty() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.put("/listaAmigos/update/1")
			.contentType(MediaType.APPLICATION_JSON)
			.content('[]')
		)
		.andExpect(status.isOk)
	}
	
	@Test
	@DisplayName("Se actualiza lista de amigos de un usuario con un payload invalido.")
	@Transactional
	def void updateUserFriendlistInvalid() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.put("/listaAmigos/update/1")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{}')
		)
		.andExpect(status.badRequest)
	}
	
	
		static def <T extends Object> fromJson(String json, Class<T> expectedType) {
		mapper.readValue(json, expectedType)
	}

	static def <T extends Object> List<T> fromJsonToList(String json, Class<T> expectedType) {
		val type = mapper.getTypeFactory().constructCollectionType(List, expectedType)
		mapper.readValue(json, type)
	}
	
	static def mapper() {
		new ObjectMapper => [
			configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
			configure(SerializationFeature.INDENT_OUTPUT, true)
		]
	}
}