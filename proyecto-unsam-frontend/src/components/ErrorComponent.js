import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faTimes } from '@fortawesome/free-solid-svg-icons'

export const ErrorComponent = ({setError, textoError}) => {
    return (
        <div p-d-flex className="mensajeError px-4 py-2 mt-2 flex justify-around items-center">
            <i className="pi pi-times-circle tamañoiconos"></i>
            <div >{textoError}</div>
            <FontAwesomeIcon className="ml-4 pointer" icon={faTimes} onClick={() => setError(null)} />
        </div>
    )
}