import React from "react";

function About() {
	return (
		<div className="about">
			<div className="container">
				<div className="row align-items-center my-5">
					<div className="col-lg-7">
						<img
							className="img-fluid rounded mb-4 mb-lg-0"
							src="/cinema.jpg"
							alt=""
						/>
					</div>
					<div className="col-lg-5">
						<h1 className="display-3 my-3">About</h1>
						<p>
							This project was created in 2023.1 semester in HUST 
							for the course IT3290E - DATABASE LAB.
						</p>
						<p>
							<b>Project Members:</b>
							<br/>Nguyen Tieu Phuong
							<br/>Hoang Van Khang
							<br/>Dang Viet Hoang		
						</p>
					</div>
				</div>
			</div>
		</div>
	);
}

export default About;