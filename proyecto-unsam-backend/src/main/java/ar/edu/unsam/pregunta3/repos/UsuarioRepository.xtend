package ar.edu.unsam.pregunta3.repos

import ar.edu.unsam.pregunta3.model.Usuario
import java.util.List
import java.util.Optional
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository
import org.springframework.data.jpa.repository.EntityGraph

@Repository
interface UsuarioRepository extends CrudRepository<Usuario, Integer> {
	
	override Optional<Usuario> findById (Integer usuarioId)
	
	def Optional<Usuario> findByUsernameAndPassword(String username, String password) 
	
	@Query(value = "SELECT * FROM usuario_amigos INNER JOIN usuario ON usuario_id = usuario_amigos.amigos_usuario_id where usuario_usuario_id= :usuarioId" , nativeQuery=true)
	def List<Usuario> getAllFriends(Integer usuarioId)
	
	@Query(value = "SELECT * FROM usuario WHERE usuario_id NOT IN(SELECT usuario_id FROM usuario INNER JOIN usuario_amigos ON usuario_id = usuario_amigos.amigos_usuario_id where usuario_usuario_id=:usuarioId) AND usuario_id != :usuarioId" , nativeQuery=true)
	def List<Usuario> getNoFriends(Integer usuarioId)
}

