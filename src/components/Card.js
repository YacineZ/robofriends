import React from 'react' ; 

const Card = ({name,email,id}) => {
	return (
		<div className='tc bg-light-green dib br3 pa3 ma2 grow bw2 hadow-5'> 
			<img src={`https://robohash.org/${id}?200x200`} alt='robot'/> 
			<div>
				<h1> {name}</h1>
				<p> {email}</p>
			</div>
		</div>
		) ;
}

export default Card ; 