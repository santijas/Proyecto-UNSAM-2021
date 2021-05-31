package ar.edu.unsam.pregunta3

import org.springframework.boot.SpringApplication
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.context.annotation.ComponentScan

@SpringBootApplication
@ComponentScan(basePackages=#["ar.edu.unsam.pregunta3"])
 class Pregunta3Application {
	def static void main(String[] args) {
		SpringApplication.run(Pregunta3Application, args)
	}
}
