import React from "react";

function Home() {
	var imgsrc = "/cinema.jpg";

	// Women's Day Special
	const womenDay = new Date('2000-03-08');
	const today = new Date();

	if (today.getMonth() === womenDay.getMonth() 
		&& today.getDate() === womenDay.getDate()){
		imgsrc = "/women.webp";
	}
	// Women's Day Special


	return (
		<div className="home">
			<div className="container">
				<div className="row align-items-center my-5">
					<div className="col-lg-7">
						<img
							className="img-fluid rounded mb-4 mb-lg-0 object-fit-cover"

							src={imgsrc}
							alt=""
						/>
					</div>
					<div className="col-lg-5">
						<h1 className="font-weight-light">Home</h1>
						<p>
							Welcome to our cinema website, your ultimate destination for movie lovers!
							Whether you're looking for the latest Hollywood blockbusters, timeless classics,
							or independent films, we've got you covered!
							<br/>
							(Up until 2017)
						</p>
						<p>This is an UI for the Movie Database Project 
						that allows Login, Registeration, Ticket purchase and Screening creation.</p>
					</div>
				</div>
			</div>
		</div>
	);
}

export default Home;