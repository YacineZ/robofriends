import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './containers/App' ; 
import {Provider} from 'react-redux' ;
import {createLogger} from 'redux-logger' ;
import thunkMiddleWare from 'redux-thunk' ;
import {createStore,applyMiddleware, combineReducers} from 'redux' ;
import {searchRobots,requestRobots} from './reducers.js' ; 
import 'tachyons' ;

import registerServiceWorker from './registerServiceWorker';

const logger  = createLogger()  ;
const rootReducer = combineReducers({searchRobots,requestRobots}); 
const store  = createStore(rootReducer
				,applyMiddleware(thunkMiddleWare,logger)) ;
ReactDOM.render(
<Provider store={store} > 
	<App />
</Provider> , document.getElementById('root'));
registerServiceWorker();
