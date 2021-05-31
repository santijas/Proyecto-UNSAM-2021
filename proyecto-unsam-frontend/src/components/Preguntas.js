import { useHistory, useParams } from "react-router-dom";
import React, { useEffect, useState, useRef } from 'react'
import { preguntasService } from '../services/preguntasService'
import { Pregunta } from "../domain/pregunta";
import { usuarioService } from "../services/usuarioService";
import { Opcion } from "../domain/opcion";
import { Toast } from 'primereact/toast';

export const Preguntas = ({edicion, creacion}) => {

    const [pregunta, setPregunta] = useState('')
    const [textoIngresado, setTextoIngresado] = useState('')
    const [tituloPregunta, setTituloPregunta] = useState('')
    const [opcionElegida, setOpcionElegida] = useState('')
    const [esCorrecta, setEsCorrecta] = useState(false)
    const [ultimaOpcionBorrada, setUltimaOpcionBorrada] = useState("")
    const [contestoPregunta, setContestoPregunta] = useState(false)
    const [puntosPregunta, setPuntosPregunta] = useState(10)
    const [autor, setAutor] = useState('')

    const toast = useRef(null);
    const params = useParams()
    const history = useHistory()

    const toggleChange = () =>{
        setEsCorrecta(!esCorrecta)
    } 

    const traerPregunta = async () => {
        try {
            let preguntaRecibida
            if(params.id === "-1"){
                preguntaRecibida = new Pregunta(params.id, null, null, usuarioService.usuarioLogueado.usuarioId)
                traerAutor(usuarioService.usuarioLogueado.usuarioId)
            } else{
                preguntaRecibida = await preguntasService.getPregunta(params.id)
                traerAutor(preguntaRecibida.autorId)
            }
            setPregunta(preguntaRecibida)
            
             
        } catch (error) {
            toast.current.show({severity:'error', summary: 'Error al traer datos', detail: "No se pudo conectar con el servidor", life: 3000})
        }
    }

    const funcionEnviarNuevaPregunta = async () => {
        try{
            pregunta.pregunta = tituloPregunta
            pregunta.puntajeOtorgadoPorElAutor = puntosPregunta

            if(validarPregunta()){
                await preguntasService.crearPregunta(pregunta)
                history.push('/home')
            }else{
                esSolidaria()?
                toast.current.show({severity:'error', summary: 'La pregunta no cumple con requisitos', detail: "Pregunta debe tener una sola respuesta correcta, tres opciones, contener titulo y los puntos no deben sobrepasar los puntos actuales que posees.", life: 3000})
                :
                toast.current.show({severity:'error', summary: 'La pregunta no cumple con requisitos', detail: "Pregunta debe tener una sola respuesta correcta, tres opciones, contener titulo y un tipo de pregunta seleccionado para que sea valida.", life: 3000})
            }
        } catch (error) {
            toast.current.show({severity:'error', summary: 'Error en Actualización', detail: "No se pudo conectar con el servidor", life: 3000})
        }
    }

    const validarPregunta = () => {
        return pregunta.type !== undefined && pregunta.pregunta !== "" && pregunta.opciones.length === 3
        && pregunta.opciones.some( opcion => opcion.esCorrecta) && !sobrepasaPuntos()
    }

    const funcionEnviarEdicion = async () => {
        try{
            if(validarPregunta()){
                await preguntasService.updatePregunta(pregunta)
                history.push('/home')
            }else{
                toast.current.show({severity:'error', summary: 'La pregunta no cumple con requisitos', detail: "Pregunta debe tener una sola respuesta correcta y tres opciones para que sea valida.", life: 3000})
            }
        }catch (error){
            toast.current.show({severity:'error', summary: 'Error en Actualización', detail: "No se pudo conectar con el servidor", life: 3000})
        }
    }

    const funcionEnviarRespuesta = async () => {
        try {
            if(esSolidaria()){
                sobrepasaPuntos()? 
                toast.current.show({severity:'error', summary: 'Pregunta Solidaria sin puntos!', detail: "No se puede responder pregunta ya que el autor no posee los puntos para entregar.", life: 3000})
                :
                contestarPregunta()
            } else{
                contestarPregunta()
            }

        } catch (error) {
            toast.current.show({severity:'error', summary: 'Error al responder pregunta', detail: "No se pudo conectar con el servidor", life: 3000})
        }
    }

    const contestarPregunta = async () => {
        try{
            if(pregunta.activa){
            await preguntasService.contestarPregunta(pregunta.preguntaId,opcionElegida.descripcion,usuarioService.usuarioLogueado.usuarioId)
            setContestoPregunta(true)
        }else {
            toast.current.show({severity:'error', summary: 'La pregunta no esta activa', detail: "La pregunta no puede ser respondida porque no está activa", life: 3000})
        }
        }
        catch (error){
            toast.current.show({severity:'error', summary: 'Error al responder pregunta', detail: "No se pudo conectar con el servidor", life: 3000})
        }
       
    }

    const funcionCancelar = () => {
        history.push('/home')
    }

    const esSolidaria = () => {
       return pregunta.type === "preguntaSolidaria"
    }

    const sobrepasaPuntos = () =>{ 
       return pregunta.puntajeOtorgadoPorElAutor > autor.puntajeAcumulado
    }

    const setearPuntosPorDefecto = () =>{
        esSolidaria()? setPuntosPregunta(10) : setPuntosPregunta(0)
    }

    const comprobarOpcion = () =>{
        if(esCorrecta){
            pregunta.opciones.some( opcion => opcion.esCorrecta)?
            toast.current.show({severity:'error', summary: 'Error en Actualización', detail: "No puede haber mas de una opcion correcta.", life: 3000})
            :
            agregarOpcion()
        }else {
            agregarOpcion()
        }
    }

    const agregarOpcion = () =>{
        if(pregunta.opciones.length < 3 && !pregunta.opciones.some( opcion => opcion.descripcion === textoIngresado)){
            pregunta.opciones.push(new Opcion(textoIngresado, esCorrecta))
            setTextoIngresado("")
            setEsCorrecta(false)
        } else{
            toast.current.show({severity:'error', summary: 'Maximo de opciones alcanzado', detail: "La pregunta solo puede tener tres opciones como maximo y no puede repetirse.", life: 3000})
        }
    }

    const quitarOpcion = (opcionAQuitar) =>{
        let index = pregunta.opciones.findIndex(opcion => opcion.descripcion === opcionAQuitar.descripcion)
        if (index!==-1){
            pregunta.opciones.splice(index, 1)
            setUltimaOpcionBorrada(opcionAQuitar)
        }
    }

    const handleSelectChange = (event)  =>{
        pregunta.type = event.target.value
        setearPuntosPorDefecto()
        setUltimaOpcionBorrada({...ultimaOpcionBorrada})
      }  

     const handleSelectOption = (opcion)  =>{
         setOpcionElegida(opcion)
      }    

      const traerAutor = async (usuarioId) =>{
          let autor = await usuarioService.getUsuario(usuarioId)
          setAutor(autor) 
      }

    useEffect( ()  =>  {
        traerPregunta()
    },[])

    return (
        <main>
          <Toast ref={toast} />
            <div className="main-top flex flex-col"> 
                { !creacion && pregunta && <div className="m-1 text-right pr-10 mt-2"><span className="font-semibold">Autor:</span> {autor.nombre + " " + autor.apellido}</div> }
                { !creacion && <h2 className="text-center font-bold mt-3 text-2xl">{ pregunta.pregunta }</h2> }
                { creacion && <input className="justify-self-center text-center font-bold mt-10 mx-16 text-2xl bg-transparent crear-input-name" placeholder="Ingresá nueva pregunta" value={tituloPregunta} onChange={(event) => setTituloPregunta(event.target.value)}></input> }
            </div>

            <div className="main-bot py-3 px-10 relative  flex flex-col">
                { creacion && edicion && <div className="flex justify-between pt-6 pb-8">
                    <div className="text-xl font-bold">Tipo de Pregunta</div>
                    <div className="flex flex-col pr-6">
                        <select name="tipo" value={pregunta.type} id="tipo" className="w-26 p-1 font-bold text-lg" onChange={handleSelectChange}>
                            <option value="undefined">Opcion</option>
                            <option value="preguntaSimple">Simple</option>
                            <option value="preguntaDeRiesgo">Riesgo</option>
                            <option value="preguntaSolidaria">Solidaria</option>
                        </select>
                       { pregunta && pregunta.type ==="preguntaSolidaria" && <div className="inline-block mt-6">
                            <div className="inline-block">Puntos</div>
                            <input type="number" min="10" step="10" pattern=" 0+\.[0-9]*[1-9][0-9]*$"  onKeyDown={(e) => { e.preventDefault() }} className="inline-block font-bold mt-6 w-10 text-center ml-2 border-2 border-gray-400 rounded-sm" value={puntosPregunta} onChange={(event) => setPuntosPregunta(event.target.value)}></input>
                        </div>}
                    </div>
                    
                    </div> 
                }
                <div className="mt-10 ml-4 w-11/12 top-32">
                    {pregunta && pregunta.opciones.map( opcion =>
                    <div className="flex-col static" key={opcion.descripcion}>
                        <div className={`py-1 pb-3 flex justify-between ${(opcion.esCorrecta && edicion) || (contestoPregunta && opcion.esCorrecta)? "border-correcta": ""} ${(contestoPregunta && !opcion.esCorrecta)? "border-incorrecta": ""}`}>
                            <div className="text-lg">{opcion.descripcion}</div>
                            <div className="flex items-center">
                            {  !edicion &&
                                <div className="flex"><input type="radio" name="pregunta" id={opcion.descripcion} className="pointer"/>
                                <label className="custom-input pointer mr-2" htmlFor={opcion.descripcion} onClick={() => handleSelectOption(opcion)}></label>
                                </div>}
                                { edicion && <i className="far fa-trash-alt pointer" onClick={() => quitarOpcion(opcion)}></i> }
                            </div>
                        </div>
                        <div className="p-1 border-t mx-1 border-grey"></div>
                    </div>
                    )}
                    

                </div>
                { edicion && <div className="my-12 "> 
                    <div className="font-bold flex">Nueva opción</div>
                    <div className="flex justify-between mt-1">
                        <div className="w-full pr-10 flex items-center">
                            <input className="mb-1.5 py-1 w-full" placeholder="Ingresá una nueva opción" value={textoIngresado} onChange={(event) => setTextoIngresado(event.target.value)}></input>
                            <input className="m-4" type="checkbox" id="cbox" value="second_checkbox" checked={esCorrecta}  onChange={toggleChange} /> <label htmlFor="cbox">Correcta</label>
                        </div>
                        <div className="boton py-1.5 px-3.5 rounded letrablanca pointer" onClick={() => comprobarOpcion()}>Agregar</div>
                    </div>
                </div> }
                
                <div className="flex justify-end">
                {!contestoPregunta && <div className="botones-ac flex ">
                    {edicion && creacion &&  <button className="boton py-2 px-3 mt-4  rounded-lg letrablanca mr-1.5 " onClick={() => funcionEnviarNuevaPregunta()}>Aceptar</button>}
                    {edicion && !creacion &&  <button className="boton py-2 px-3 mt-4  rounded-lg letrablanca mr-1.5 " onClick={() => funcionEnviarEdicion()}>Aceptar</button>}
                    {!edicion && <button className="boton py-2 px-3 mt-4  rounded-lg letrablanca mr-1.5 " onClick={() => funcionEnviarRespuesta()}>Aceptar</button>} 
                    <button className="boton2 py-2 px-3 mt-4 ml-1.5 rounded-lg letrablanca " onClick={() => funcionCancelar()}>Cancelar</button>
                 </div>}
                 {contestoPregunta && <button className="boton2 py-2 px-3 mt-4 ml-1.5 rounded-lg letrablanca " onClick={() => funcionCancelar()}>Volver</button>}
                </div>
            </div>
        </main>
    )
} 

export const blockInvalidChar = e => ['e', 'E', '+', '-'].includes(e.key) && e.preventDefault();