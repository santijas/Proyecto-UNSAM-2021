import React, { useEffect, useState } from 'react'
import { Busqueda } from './Busqueda';
import { preguntasService } from "../services/preguntasService";
import { TablaPreguntas } from './TablaPreguntas';

export const Home = () =>{
  const [preguntas, setPreguntas] = useState([])

  const busqueda = async (textoABuscar, boleeanActivas) =>{
    fetchPreguntas(boleeanActivas, textoABuscar)
  }

   const fetchPreguntas = async (soloActivas, textoBusqueda) => {
    soloActivas? fetchPreguntasActivas(textoBusqueda) : fetchAllPreguntas(textoBusqueda)
    }

   const fetchPreguntasActivas = async (textoBusqueda) =>{
      const preguntasEncontradas = await preguntasService.getPreguntasActivas(textoBusqueda)
      setPreguntas(preguntasEncontradas)
    }

    const fetchAllPreguntas = async (textoBusqueda) =>{
      const preguntasEncontradas = await preguntasService.getPreguntas(textoBusqueda)
      setPreguntas(preguntasEncontradas)
    }

    useEffect( ()  =>  {
      fetchPreguntas(false, "")
    },[])

    return (
        
        <div className="flex justify-center flex-col">
            <Busqueda titulo="preguntas" busqueda={ async (texto, boolean) => busqueda(texto, boolean)} />
            <div className="flex justify-center flex-col items-center">
              <h2 className="flex text-lg mt-2 font-bold container">Resultados de la búsqueda</h2>
              <TablaPreguntas preguntas={preguntas}/>
            </div>
            
    </div>

    )
}