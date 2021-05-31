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
import ar.edu.unsam.pregunta3.model.Pregunta

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@DisplayName("Dado un controller de Preguntas")
class PreguntaControllerTest {
	
	@Autowired
	MockMvc mockMvc
	
	@Test
	@DisplayName("Consultamos una pregunta y la trae correctamente.")
	def void getQuestion() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/pregunta/8")).andReturn.response
		val pregunta = responseEntity.contentAsString.fromJson(Pregunta)
		assertEquals(200, responseEntity.status)
		assertNotNull(pregunta)
		assertEquals(pregunta.pregunta, "Quien escribio El Codigo Da Vinci")
	}
	
	@Test
	@DisplayName("Consultamos una pregunta y arroja 404 not found.")
	def void getQuestionNotFound() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/pregunta/200")).andReturn.response
		assertEquals(404, responseEntity.status)
	}
	
	@Test
	@DisplayName("Consultamos todas las preguntas que no contestó un usuario (ocho).")
	def void getQuestionNotResponded() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/preguntas/1").param("palabraBuscada","")).andReturn.response
		val preguntas = responseEntity.contentAsString.fromJsonToList(Pregunta)
		assertEquals(200, responseEntity.status)
		assertEquals(preguntas.length, 9)
	}
	
		@Test
	@DisplayName("Consultamos todas las preguntas que no contestó un usuario que contengan Quien (dos).")
	def void getQuestionNotRespondedWithFilter() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/preguntas/1").param("palabraBuscada","Quien")).andReturn.response
		val preguntas = responseEntity.contentAsString.fromJsonToList(Pregunta)
		assertEquals(200, responseEntity.status)
		assertEquals(preguntas.length, 2)
	}
	
	@Test
	@DisplayName("Consultamos todas las preguntas ACTIVAS que no contestó un usuario.")
	def void getActiveQuestionNotResponded() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/preguntas/1").param("palabraBuscada","").param("activas", "true")).andReturn.response
		val preguntas = responseEntity.contentAsString.fromJsonToList(Pregunta)
		assertEquals(200, responseEntity.status)
		assertEquals(preguntas.length, 3)
	}
	
	@Test
	@DisplayName("Consultamos todas las preguntas ACTIVAS que no contestó un usuario que contengan Mirtha (Una).")
	def void getActiveQuestionNotRespondedWithFilter() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/preguntas/1").param("palabraBuscada","Mirtha").param("activas", "true")).andReturn.response
		val preguntas = responseEntity.contentAsString.fromJsonToList(Pregunta)
		assertEquals(200, responseEntity.status)
		assertEquals(preguntas.length, 1)
	}
	
	@Test
	@DisplayName("Se actualiza una pregunta correctamente.")
	@Transactional
	def void updateQuestion() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.put("/updatepregunta/8")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"preguntaId" : 8, "pregunta": "Como se llama Duhalde" , "type" : "preguntaSimple"}')
		)
		.andExpect(status.isOk)
	}
	
	@Test
	@DisplayName("No se actualiza una pregunta debido a que no encuentra ID.")
	@Transactional
	def void updateQuestionNotFound() {
		mockMvc
		.perform(
			MockMvcRequestBuilders.put("/updatepregunta/850")
			.contentType(MediaType.APPLICATION_JSON)
			.content('{"preguntaId" : 850, "pregunta": "Como se llama Duhalde" , "type" : "preguntaSimple"}')
		)
		.andExpect(status.notFound)
	}
	
	
	@Test
	@DisplayName("Respondemos una pregunta activa.")
	@Transactional
	def void respondActiveQuestion() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/respuesta/12/14/4")).andReturn.response
		assertEquals(200, responseEntity.status)
	}  // ME TIRA NOT FOUND POR METODO responderPregunta EN LA LINEA getPreguntaById, QUE NO ME ENCUENTRA LA PREGUNTA.
	
		@Test
	@DisplayName("Respondemos una pregunta inactiva y devuelve method not allowed.")
	@Transactional
	def void respondNoActiveQuestion() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/respuesta/8/10/1")).andReturn.response
		assertEquals(405, responseEntity.status)
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