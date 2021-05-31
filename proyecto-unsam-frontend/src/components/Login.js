import React, { useEffect, useState } from 'react'
import { useHistory } from "react-router-dom";
import { LoginUsuario } from "../domain/usuario";
import { usuarioService } from '../services/usuarioService'
import { ErrorComponent } from './ErrorComponent'



export const Login = () => {
    const [username, setUsername] = useState('')
    const [password, setPassword] = useState('')
    const [error, setError] = useState(null)
    let history = useHistory()

    const loguearUsuario = async () => {
        const login = new LoginUsuario(username, password)
        try{
         await usuarioService.loguearUsuario(login)
          history.push('/home')
        }catch(error){
         setError(error)
        }
    } 

    useEffect(() => {    
        setError(null)
        },[]
    )

    return (
        <div className="flex h-full justify-center  items-center  flex-col">    
            <div className="flex fondoprimario rounded-lg">
                <div className="flex flex-col mx-20 my-5 ">
                    <h1 className="fuentelogo ml-10 mb-2">Pregunta3!</h1>
                    <input className="m-2 rounded-sm p-2 " id="username" placeholder="Username" type="text" value={username} onChange={(event) => setUsername(event.target.value)}></input>
                    <input className="m-2 rounded-sm p-2 " id="password" placeholder="Password" type="password" value={password} onChange={(event) => setPassword(event.target.value)}></input>
                    <input className="boton-login p-2 mt-4 mx-10 rounded-lg letrablanca pointer" type ="button" value="Ingresar" onClick={loguearUsuario}></input>
                </div>

            </div>  
            <div className="errorLogin">
                { error && <ErrorComponent className="flex w-100" textoError="Error al intentar acceder" setError={(e) => setError(e)}/> }    
            </div>
        </div>
    ) 
}
