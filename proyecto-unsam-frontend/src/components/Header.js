import React from 'react'
import { withRouter } from 'react-router-dom'
import { useHistory } from "react-router-dom";
import { usuarioService } from '../services/usuarioService'

export const Header = () =>{
    let history = useHistory();

    const logOff = () =>{
        usuarioService.usuarioLogueado = null
        history.push('/')
    }

    const irHome = () =>{ 
        history.push('/home')
    }

    const irPerfil = () =>{ 
        history.push('/perfil')
    }

        return (
            <header className="flex justify-around ">
                <h1 className="fuentelogo py-2">Pregunta3!</h1>
                <div className="flex justify-evenly h-full w-72" >
                    <p className="pointer text-lg boton-nav h-full" onClick={irHome}>Home</p>
                    <p className="pointer text-lg boton-nav" onClick={irPerfil}>Perfil</p>
                    <p className="pointer text-lg boton-nav" onClick={logOff}>Salir</p>
                </div>

            </header>
        )
}

export default withRouter(Header)