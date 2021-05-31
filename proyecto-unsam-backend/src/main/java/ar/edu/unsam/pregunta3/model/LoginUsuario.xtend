package ar.edu.unsam.pregunta3.model

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class LoginUsuario{
	
	String username
	String password
	
	new(){}
	
    new(String _username , String _password){ 
    	username = _username
    	password = _password
    }
}