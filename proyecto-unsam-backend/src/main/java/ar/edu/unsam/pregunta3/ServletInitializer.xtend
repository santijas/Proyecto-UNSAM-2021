package ar.edu.unsam.pregunta3

import org.springframework.boot.builder.SpringApplicationBuilder
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer

class ServletInitializer extends SpringBootServletInitializer {
	override protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
		return application.sources(Pregunta3Application)
	}
}
