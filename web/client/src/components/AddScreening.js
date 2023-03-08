import React, { Fragment, useState, useEffect } from "react";
import { useParams } from "react-router-dom";
import { toast } from "react-toastify";

const AddScreening = () => {
	const [inputs, setInputs] = useState({
		screen_date: "", 
		start_time: "", 
		room_id: "", 
	});

	const [rooms, setRooms] = useState([]);

	async function getRooms() {
		const res = await fetch("http://localhost:5000/rooms");
		var roomArray = await res.json();
		// Set the state
		setRooms(roomArray);
	}

	useEffect(() => {
		getRooms();
	}, []);


	const { screen_date, start_time, room_id } = inputs;
	const { movie_id } = useParams();

	const onChange = e => {
		setInputs({ ...inputs, [e.target.name]: e.target.value });
		console.log(inputs);
	}


	const onSubmitForm = async e => {
		e.preventDefault();

		try {
			const body = { screen_date, start_time, room_id, movie_id };
			const response = await fetch(
				"http://localhost:5000/manager/addscreening",
				{
					method: "POST",
					headers: {
						"Content-type": "application/json"
					},
					body: JSON.stringify(body)
				}
			);

			const parseRes = await response.json();

			if (parseRes.value === 'Success') {
				toast.success("Added Screening Successfully");
			} else {
				toast.error(parseRes);
				console.error(parseRes);
			}
		} catch (err) {
			console.error(err.message);
		}
	};

	return (
		<Fragment>
			<div className="form-dark-blue">
				<div className="container rounded-bottom col-sm-8">
					<h1 className="text-center pt-4">Add Screening</h1>
					<form className="p-4" onSubmit={onSubmitForm}>
							{rooms.map(room => (
								<div key={room.room_id} className="form-check form-check-inline" onChange={e => onChange(e)}>
									<label>Room {room.room_id} - {room.room_type}</label>
									<input type="radio" className="form-check-input" name="room_id" value={room.room_id} />
								</div>
							))}
						<input
							type="date"
							name="screen_date"
							value={screen_date}
							onChange={e => onChange(e)}
							className="form-control my-3"
						/>
						<input
							type="time"
							name="start_time"
							value={start_time}
							onChange={e => onChange(e)}
							className="form-control my-3"
						/>
						<div className="d-flex flex-row justify-content-around">
							<button className="btn btn-success btn-lg">Submit</button>
						</div>
					</form>
				</div>
			</div>
		</Fragment>
	);
};

export default AddScreening;
