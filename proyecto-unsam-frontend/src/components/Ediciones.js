import React, { useEffect, useState,useRef } from 'react'
import { Toast } from 'primereact/toast';
import { usuarioService } from '../services/usuarioService'
import { useHistory } from "react-router-dom";

export const Ediciones = () => {
    let history = useHistory();
    const [logsEdicion,setlogsEdicion] = useState('')
    const toast = useRef(null);

    const traerListaDeAmigos = async () => {        
        try {
            let listaDeLogs = await usuarioService.getLogsDeUsuario(usuarioService.usuarioLogueado.usuarioId)
            console.log(listaDeLogs)
            setlogsEdicion(listaDeLogs) 
        } catch (error) {
            toast.current.show({severity:'error', summary: 'Error al traer datos', detail: error, life: 3000})
        }
    }

    const volver = () => {
        history.push('/perfil')
    }

    useEffect(() => {
        traerListaDeAmigos()
    },[])

    return (
        <main>
            <div>
            <Toast ref={toast} />
            </div>
            <div className="main-top flex flex-col">
                <h1 className="text-center font-bold mt-10 text-3xl">Mis ediciones</h1>
            </div>
            <div className="main-bot py-3 px-10 relative  flex flex-col">
                <div className="lista-logs">
                    { logsEdicion && logsEdicion.map((log) => 
                        <div className="log-edicion mt-2 flex p-2">
                            <div className="w-1/2 pl-4">
                                <div><span className="font-bold">Pregunta ID:</span> <span>{log.preguntaId}</span></div>
                                <div><span className="font-bold">Pregunta:</span> <span>{log.pregunta}</span></div>
                                <div><span className="font-bold">Fecha de edición:</span> <span>{log.fechaDeEdicion}</span></div>
                            </div>
                            <div className="w-1/2 flex pl-4">
                                <div className="font-bold">Opciones:</div>
                                <div> 
                                    {logsEdicion && log.opciones.map((opcion) =>
                                         
                                           [ opcion.esCorrecta && <div className="text-green-600 ml-4">{opcion.descripcion}</div>,
                                            !opcion.esCorrecta && <div className="text-red-600 ml-4">{opcion.descripcion}</div>]
                                        )}
                                </div>
                            </div>
                        </div>
                        ) }
                </div>
                <div className="flex justify-end">
                    <button className="boton2 py-2 px-5 mr-5 rounded-lg letrablanca" onClick={() => volver()}>Volver</button>
                </div>
            </div>
        </main>
    )
}