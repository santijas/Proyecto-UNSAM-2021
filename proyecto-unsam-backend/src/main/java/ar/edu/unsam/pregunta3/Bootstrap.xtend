package ar.edu.unsam.pregunta3

import ar.edu.unsam.pregunta3.model.Opcion
import ar.edu.unsam.pregunta3.model.PreguntaDeRiesgo
import ar.edu.unsam.pregunta3.model.PreguntaSimple
import ar.edu.unsam.pregunta3.model.PreguntaSolidaria
import ar.edu.unsam.pregunta3.model.Usuario
import ar.edu.unsam.pregunta3.repos.PreguntaRepository
import ar.edu.unsam.pregunta3.repos.UsuarioRepository
import java.time.LocalDate
import java.time.LocalDateTime
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.springframework.beans.factory.InitializingBean


@Service
class Bootstrap implements InitializingBean {
	@Autowired
	UsuarioRepository usuarioRepo

	@Autowired
	PreguntaRepository preguntaRepo
	

	val usuario1 = new Usuario("Eduardo", "Biloni", LocalDate.now()) => [username = "edu" password = "1234"]
	val usuario2 = new Usuario("Alberto", "Sabatini", LocalDate.now()) => [username = "alber" password = "1234"]
	val usuario3 = new Usuario("Lucas", "Gimenez", LocalDate.now()) => [username = "lucas" password = "1234"]
	val usuario4 = new Usuario("Roberto", "Perfumo", LocalDate.now()) => [username = "rober" password = "1234"]
	val usuario5 = new Usuario("Ezequiel", "De Santo", LocalDate.now()) => [username = "eze" password = "1234"]
	val usuario6 = new Usuario("Marcelo", "Gallardo", LocalDate.now()) => [username = "marce" password = "1234"]
	val usuario7 = new Usuario("Lionel", "Messi", LocalDate.now()) => [username = "lio" password = "1234"]

	val opcion1 = new Opcion("Caracas", false)
	val opcion2 = new Opcion("Kingston", false)
	val opcion3 = new Opcion("Puerto Principe", true)
	val opcion4 = new Opcion("84", true)
	val opcion5 = new Opcion("La misma edad que la Tierra", false)
	val opcion6 = new Opcion("109", false)
	val opcion7 = new Opcion("1492", true)
	val opcion8 = new Opcion("1323", false)
	val opcion9 = new Opcion("1622", false)
	val opcion10 = new Opcion("Neil Armstrong", true)
	val opcion11 = new Opcion("Elon Musk", false)
	val opcion12 = new Opcion("Chiche Gelblung", false)
	val opcion13 = new Opcion("A Soultrain", false)
	val opcion14 = new Opcion("A comprar cigarrillos", true)
	val opcion15 = new Opcion("A dirigir Chacarita", false)
	val opcion16 = new Opcion("961.8 °C", true)
	val opcion17 = new Opcion("1323.2 °C", false)
	val opcion18 = new Opcion("643.52 °C", false)
	val opcion19 = new Opcion("A King's Landing", false)
	val opcion20 = new Opcion("Al escondite de Bin Laden", false)
	val opcion21 = new Opcion("A la estratosfera", true)
	val opcion22 = new Opcion("Nisman", false)
	val opcion23 = new Opcion("El Mono Mario", false)
	val opcion24 = new Opcion("Dan Brown", true)
	val opcion25 = new Opcion("Un poeta", true)
	val opcion26 = new Opcion("Un gamer", false)
	val opcion27 = new Opcion("Un elefante", false)

	val pregunta1 = new PreguntaSimple("Capital de Haiti?", 1, #[opcion1, opcion2, opcion3]) => [
		fechaYHoraCreacion = LocalDateTime.now()
	]
	val pregunta2 = new PreguntaDeRiesgo("Edad de Mirtha Legrand?", 2, #[opcion4, opcion5, opcion6]) => [
		fechaYHoraCreacion = LocalDateTime.now()
	]
	val pregunta3 = new PreguntaSolidaria("En que año se descubrio America?", 3, #[opcion7, opcion8, opcion9],
		30) => [fechaYHoraCreacion = LocalDateTime.of(2020, 03, 24, 17, 0)]
	val pregunta4 = new PreguntaSimple("Primer hombre que llego a la luna?", 2,
		#[opcion10, opcion11, opcion12]) => [fechaYHoraCreacion = LocalDateTime.now()]
	val pregunta5 = new PreguntaDeRiesgo("A donde se fue el papa de Nelson en los Simpsons?", 1,
		#[opcion13, opcion14, opcion15]) => [fechaYHoraCreacion = LocalDateTime.now()]
	val pregunta6 = new PreguntaSolidaria("A que temperatura se funde la plata?", 3,
		#[opcion16, opcion17, opcion18], 30) => [fechaYHoraCreacion = LocalDateTime.now()]
	val pregunta7 = new PreguntaSimple("Hacia donde se remontaría la nave de Menem?", 3,
		#[opcion19, opcion20, opcion21]) => [fechaYHoraCreacion = LocalDateTime.now()]
	val pregunta8 = new PreguntaDeRiesgo("Quien escribio El Codigo Da Vinci", 2,
		#[opcion22, opcion23, opcion24]) => [fechaYHoraCreacion = LocalDateTime.of(2020, 03, 24, 17, 0)]
	val pregunta9 = new PreguntaSolidaria("Quien fue Garcia Lorca?", 1, #[opcion25, opcion26, opcion27], 60) => [
		fechaYHoraCreacion = LocalDateTime.of(2020, 03, 24, 17, 0)
	]

	def void run() {
	}

	def void crearUsuarios() {
		usuario1.agregarAmigo(usuario2)
		usuario1.agregarAmigo(usuario3)
		usuario2.agregarAmigo(usuario1)
		usuario2.agregarAmigo(usuario3)
		usuario3.agregarAmigo(usuario1)
		usuario3.agregarAmigo(usuario2)
		usuarioRepo.saveAll(#[usuario1, usuario2, usuario3, usuario4, usuario5, usuario6, usuario7])
	}

	def void crearPreguntas() {
		preguntaRepo => [
			save(pregunta1)
			save(pregunta2)
			save(pregunta3)
			save(pregunta4)
			save(pregunta5)
			save(pregunta6)
			save(pregunta7)
			save(pregunta8)
			save(pregunta9)
			 
		]
		
	}

	override afterPropertiesSet() throws Exception {
		println("************************************************************************")
		println("Running initialization")
		println("************************************************************************")
		crearUsuarios()
		crearPreguntas()
	}

}
