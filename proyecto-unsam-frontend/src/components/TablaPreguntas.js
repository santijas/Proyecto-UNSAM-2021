import React from 'react'
import { useHistory } from "react-router-dom";
import { usuarioService } from '../services/usuarioService';

export const TablaPreguntas = ({preguntas}) =>{

    let history = useHistory();
    
    const esAutor = (pregunta) => {
        return pregunta.autorId === usuarioService.usuarioLogueado.usuarioId
    }

    const editarPregunta = (id) => {
        history.push(`/edit/${id}`)
    }

    const responderPregunta = (id) => {
        history.push(`/pregunta/${id}`)
    }

    const crearPregunta = () => {
        history.push(`/crear/-1`)
    }

    return (
    <div className="container">
        <table className="table mt-4 w-full pregunta-tabla">
            {
                preguntas.map((pregunta) => 
                <tr key={pregunta.preguntaId} className="bg-white preguntas">
                    <td className="mt-4">{pregunta.pregunta}</td>
                    <td className="text-right mt-4">
                        {esAutor(pregunta)? (<button className="boton letrablanca boton-tabla p-2 rounded-lg" onClick={() => editarPregunta(pregunta.preguntaId)}>Editar</button>)
                        : (<button className="boton letrablanca boton-tabla p-2 rounded-lg" onClick={() => responderPregunta(pregunta.preguntaId)}>Responder</button>)
                    }
                </td>
                 </tr>
                )
            }
        </table>
        <button className="flex boton p-2 mt-4 rounded-lg letrablanca py-2 px-3 self-end text-right" onClick={() => crearPregunta()}>Nueva pregunta</button>
    </div>    
    )
  }
