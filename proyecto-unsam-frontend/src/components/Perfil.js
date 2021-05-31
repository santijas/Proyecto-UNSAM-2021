import React, { useEffect, useState,useRef } from 'react'
import { usuarioService } from '../services/usuarioService'
import { preguntasService } from '../services/preguntasService'
import { useHistory } from "react-router-dom";
import { Toast } from 'primereact/toast';
 
export const Perfil = () => {
    let history = useHistory();
    const [usuarioModificado,setUsuarioModificado] = useState('')
    const [usuariofijo,setUsuarioFijo] = useState('')
    const [listaAmigos, setListaAmigos] = useState([])
    const [listaUsuarios, setListaUsuarios] = useState([])
    const [mostrarUsuarios, setMostrarUsuarios] = useState(false)
    const [potencialAmigo, setPotencialAmigo] = useState(null)
    const toast = useRef(null);

    const actualizarValor = (event) => {
        setUsuarioModificado({
            ...usuarioModificado,
            [event.target.id]: event.target.value
        })
    }

    const inyectarUsuario = () => {
        agregarTryCatch(async ()  => {
            let usuarioRecibido = await usuarioService.getUsuario(usuarioService.usuarioLogueado.usuarioId)
            console.log(usuarioRecibido)
            setUsuarioModificado(usuarioRecibido)
            setUsuarioFijo(usuarioRecibido)
        })
    }

    const traerListaDeAmigos = () => {       
        agregarTryCatch( async () => {
            let listaDeAmigos = await usuarioService.getlistaDeAmigos(usuarioService.usuarioLogueado.usuarioId)
            setListaAmigos(listaDeAmigos)
        })
    }

    const traerListaDeUsuarios = async () => {
        agregarTryCatch( async () => {
            let listaDeUsuarios = await usuarioService.getListaUsuarios(usuarioService.usuarioLogueado.usuarioId)
            setListaUsuarios(listaDeUsuarios)
        })
    }
    
    const funcionAceptar = async () => {
        if (camposValidos()){
            try {
                await usuarioService.updateUser(usuarioModificado)
                await usuarioService.updateListaDeAmigos(listaAmigos,usuarioService.usuarioLogueado.usuarioId)
                history.push('/home')
            }catch(errorRecibido){
                toast.current.show({severity:'error', summary: 'Error en Actualización', detail: "No fue posible actualizar los datos del usuario", life: 3000})
            } 
        } else toast.current.show({severity:'error', summary: 'Error de validación', detail: "No debe haber campos vacíos o fecha posterior al día de hoy", life: 3000})
    }
    
    const funcionCancelar = () => {
        history.push('/home')
    }

    const irALogs = () => {
        history.push('/ediciones')
    }

    const fechaValida = () => {
        let fechaActual = new Date()
        let fechaEnCampo = new Date(usuarioModificado.fechaNacimiento)
        return fechaActual.getTime() >= fechaEnCampo.getTime()
    }

    const camposValidos = () => {
        return (!(usuarioModificado.nombre.length === 0) &&
        !(usuarioModificado.apellido.length === 0) &&
        fechaValida())
    }

    const agregarTryCatch = (funcion) => {
        try { funcion() } catch (error) {
            toast.current.show({severity:'error', summary: 'Error al traer datos', detail: error, life: 3000})
        }
    }

    const agregarAmigo = () => {
        if(potencialAmigo != null) {
            let listaAux = [...listaAmigos]
            listaAux.push(potencialAmigo)
            setListaAmigos(listaAux)
            cerrarListaUsuarios()
            quitarUsuario()
        }
    }

    const quitarUsuario = () => {
        let listaAux = [...listaUsuarios]
        let indexUsuario = listaAux.findIndex(usuario => usuario.usuarioId === potencialAmigo.id)
        listaAux.splice(indexUsuario, 1)
        setListaUsuarios(listaAux)
    }

    const cerrarListaUsuarios = () => {
        setPotencialAmigo(null)
        setMostrarUsuarios(false)
    }
    
    useEffect(() => {
        inyectarUsuario()
        traerListaDeAmigos()
        traerListaDeUsuarios()
    },[])

    return (
        <main>
            <div>
            <Toast ref={toast} />
            </div>
            {usuariofijo && <div className="main-top ">
                <div className="flex w-full h-full">
                    <img className="perfil-img rounded-tl-md" src="https://p4.wallpaperbetter.com/wallpaper/653/46/534/actresses-jennifer-connelly-wallpaper-preview.jpg"/>
                    <div className="flex justify-between w-full p-3 pr-10 font-bold text-2xl">
                        { usuariofijo && <div>{usuariofijo.nombre + " " + usuariofijo.apellido}</div>}
                       {usuariofijo && <div>{usuariofijo.puntajeAcumulado} Puntos</div>}
                    </div>
                </div>
            </div>}
            <div className="main-bot flex justify-center">
                <div className="w-full my-3 mx-20">
                    <div className="flex w-full h-1/2 p-2">
                        <div className="w-1/2 h-full px-3">
                            <div className="flex p-1 my-2 w-full justify-between items-center">
                                <label htmlFor="nombre" className="font-bold">Nombre</label>
                                <input className="p-1 perfil-datos" id="nombre" type="text" value={usuarioModificado.nombre} onChange={(event) => actualizarValor(event)} name="nombre" placeholder="Ingrese su nombre"></input>
                            </div>
                            <div className="flex p-1 my-2 w-full justify-between items-center">
                                <label htmlFor="apellido" className="font-bold">Apellido</label>
                                <input className="p-1 perfil-datos" type="text" id="apellido" name="apellido" value={usuarioModificado.apellido} onChange={(event) => actualizarValor(event)} placeholder="Ingrese su apellido"></input>
                            </div>
                            <div className="flex p-1 my-2 w-full justify-between items-center">
                                <label htmlFor="nacimiento" className="font-bold">Nacimiento</label>
                                <input className="p-1 px-2 perfil-datos" type="date" id="fechaNacimiento" value={usuarioModificado.fechaNacimiento} onChange={(event) => actualizarValor(event)} name="nacimiento"></input>
                            </div>
                        </div>
                        <div className="w-1/2 h-full px-3 ">
                            { !mostrarUsuarios && 
                            <div className="flex justify-between p-1 mt-2 items-center">
                                <span className="font-bold text-lg">Amigos</span>
                                <button className="boton py-1.5 px-3.5 rounded letrablanca pointer" onClick={() => setMostrarUsuarios(true)}>Agregar</button> 
                            </div> }
                            { mostrarUsuarios && 
                            <div className=" my-4 flex justify-between">
                                <span className="font-bold text-lg">Usuarios disponibles</span>
                                <div className="w-14 flex justify-between mr-2">
                                    <i className="fas fa-plus icono-plus-perfil iconos-formato" onClick={() => agregarAmigo()}></i>
                                    <i className="fas fa-times icono-times-perfil iconos-formato" onClick={() => cerrarListaUsuarios()}></i>
                                </div>
                            </div> }
                            <div className="p-1 my-2">
                                <div className="perfil-tabla-titulo perfil-tabla-borde"> Nombres </div>
                                <div className="perfil-tabla-lista perfil-tabla-borde overflow-auto overflow-x-hidden">
                                    { !mostrarUsuarios && listaAmigos.map( (amigo) => 
                                    <div className="perfil-lista-bloque p-1 my-1 mx-4 font-bold text-center" key={amigo.id}>
                                        {amigo.nombre + " " + amigo.apellido}
                                    </div> ) }
                                    { mostrarUsuarios && listaUsuarios.map( (usuario) => 
                                    <button className="perfil-lista-bloque p-1 my-1 font-bold text-center block w-full" onClick={() => setPotencialAmigo(usuario)} key={usuario.usuarioId}>
                                        {usuario.nombre + " " + usuario.apellido}
                                    </button> )

                                    }
                                </div>
                            </div>
                        </div>
                    </div>
                    <div className="h-1/2">
                        <div className="flex  justify-between">
                            <h2 className="font-bold mb-2">Preguntas Respondidas</h2>
                            <button className="boton2 rounded letrablanca font-bold py-1 px-3 mr-5 mb-2" onClick={() => irALogs()}>Ediciones</button>
                        </div>   
                        <div className="h-48 w-full">

                            <table className="w-full tablaperfil">
                                <thead className="w-full">
                                    <tr className="h-9 w-full">
                                        <th className="th">Pregunta</th>
                                        <th className="th">Fecha de respuesta</th>
                                        <th className="th">Puntos</th>
                                    </tr>
                                </thead>
                               
                                <tbody className="w-full">
                                    { usuariofijo && usuariofijo.preguntasRespondidas.map((pregunta) =>
                                     <tr className=" text-center" key={pregunta.preguntaId}>
                                        <td className="td">{pregunta.preguntaString}</td>
                                        <td className="td">{pregunta.fechaDeRespuesta.substring(0,10)}</td>
                                        <td className="td">{pregunta.puntosOtorgados}</td>
                                    </tr> ) }
                                                             
                                </tbody>

                            </table>              
                        </div>

                        <div className="perfil-botones-cont flex h-14 relative">
                            <div className="perfil-botones-ac right-0 bottom-0 absolute">
                            <div className="botones-ac">
                                <button className="boton py-2 mt-4 mx-10 rounded-lg letrablanca py-2 px-4 mr-1.5" onClick={() => funcionAceptar()}>Aceptar</button>
                                <button className="boton2 py-2 px-3 ml-1.5 rounded-lg letrablanca" onClick={() => funcionCancelar()}>Cancelar</button>
                            </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    )
}