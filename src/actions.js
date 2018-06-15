import {CHANGE_SEARCHFIELD,
REQUEST_ROBOTS_PENDING,
REQUEST_ROBOTS_FAILED,
REQUEST_ROBOTS_SUCCES} from './constants.js' ;

export const setSearchField = (text) => ({
	type : CHANGE_SEARCHFIELD ,
	payload : text 

}) 

export const requestRobots = () => (dispatch) => {
	dispatch({type : REQUEST_ROBOTS_PENDING}) ; 
			fetch('https://jsonplaceholder.typicode.com/users')
			.then(response => {return response.json()})
			.then(data => dispatch({type: REQUEST_ROBOTS_SUCCES, payload : data }))
			.catch(error => dispatch({type : REQUEST_ROBOTS_FAILED, payload:error}))
			 ; 
}