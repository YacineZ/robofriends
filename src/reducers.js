import {CHANGE_SEARCHFIELD,
REQUEST_ROBOTS_PENDING,
REQUEST_ROBOTS_FAILED,
REQUEST_ROBOTS_SUCCES} from './constants.js' ;


const  initialStateSearch = {
	searchField : ''
}

export const searchRobots = (state=initialStateSearch,action={}) => {
	switch(action.type){
		case CHANGE_SEARCHFIELD : 
		return Object.assign({},state,{searchField: action.payload}); 
		default : 
		return state ; 
	}
}
const initialStateRobots = {
	isPending : false, 
	robots : [] , 
	error : ''
}
export const requestRobots = (state=initialStateRobots,action={}) => {
	switch(action.type){
		case REQUEST_ROBOTS_PENDING : 
		return Object.assign({},state,{isPending: true}); 
				case REQUEST_ROBOTS_SUCCES : 
		return Object.assign({},state,{isPending: false, robots:action.payload}); 
				case REQUEST_ROBOTS_FAILED : 
		return Object.assign({},state,{isPending: false,error:action.payload}); 
		default : 
		return state ; 
	}
}
