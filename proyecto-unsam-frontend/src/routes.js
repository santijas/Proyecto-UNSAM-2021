import { BrowserRouter as Router, Route, Switch } from 'react-router-dom'
import { Login } from './components/Login.js'
import { Perfil } from './components/Perfil.js'
import { Header } from './components/Header'
import { Footer } from './components/Footer'
import { React } from 'react'
import { Preguntas } from './components/Preguntas'
import { Home } from './components/Home.js'
import { Ediciones } from './components/Ediciones.js'

export const Routes = () => {

    return (
        <Router>    
              <Switch>
            <Route exact={true} path="/"><Login/></Route>
            <Route><div>
                    <Route><Header/></Route> 
                    <Route path="/home"><Home/></Route>
                    <Route path="/perfil"><Perfil/></Route>
                    <Route path="/edit/:id"><Preguntas edicion={true}/></Route>
                    <Route path="/crear/:id"><Preguntas edicion={true} creacion={true}/></Route>
                    <Route path="/pregunta/:id"><Preguntas edicion={false}/></Route>
                    <Route path="/ediciones"><Ediciones/></Route>
            </div></Route>
            <Route><Footer/></Route>
            </Switch>
        </Router>
    )
}