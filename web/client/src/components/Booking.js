import { React, Fragment, useState } from "react";
import { Navigate, useParams } from "react-router-dom";
import { toast } from "react-toastify";
import moment from "moment";

const Booking = ({ isAuth }) => {
	const [ticket, setTicket] = useState({
		select_day: moment().subtract(1, 'days').format('YYYY-MM-DD'),
		screen_id: "",
		room_id: "",
		room_type: "",
		email: ""
	});

	const { movie_id } = useParams();

	const [screens, setScreens] = useState([]);
	const [seats, setSeats] = useState([]);
	const [ticketPrice, setPrice] = useState(0);
	const [bookings, setBooking] = useState(new Set());
	// const { select_day, scr}

	function clearSeats () {
		setSeats([]);
		setBooking(new Set());
	}

	const onChangeDate = (e) => {
		clearSeats();
		setTicket({ ...ticket, [e.target.name]: e.target.value });

		getScreening(e.target.value);
	}
	const onChangeScreen = (e) => {
		clearSeats();
		setTicket({ ...ticket, [e.target.name]: e.target.value, 
				room_id: e.target.dataset.roomid, 
				room_type: e.target.dataset.roomtype });

		getSeat(e.target.value);
		getPrice(e.target.value);
	}
	const onChangeSeat = (e) => {
		setTicket({ ...ticket, [e.target.name]: e.target.value });


		const now_book = new Set(bookings);
		if (e.target.checked) {
			now_book.add(e.target.value);
		} else {
			now_book.delete(e.target.value);
		}

		setBooking(now_book);
	}
	const onChangeEmail = (e) => {
		setTicket({ ...ticket, [e.target.name]: e.target.value });
	}


	const getScreening = async (select_day) => {
		try {
			const body = { movie_id, select_day };
			const response = await fetch(
				"http://localhost:5000/screenings",
				{
					method: "POST",
					headers: {
						"Content-type": "application/json"
					},
					body: JSON.stringify(body)
				}
			);

			const screenArray = await response.json();

			// Set the state
			setScreens(screenArray);
			// if (screenArray.length === 0) {
			// 	noScreening = true;
			// 	toast.success("Added Screening Successfully");
			// } else {
			// 	toast.error(parseRes);
			// 	console.error(parseRes);
			// }
		} catch (err) {
			console.error(err.message);
		}
	}

	const getSeat = async (screen_id) => {
		try {
			const res = await fetch("http://localhost:5000/seats/" + screen_id);
			const seatArray = await res.json();
			// Set the state
			setSeats(seatArray);
		} catch (err) {
			console.error(err.message);
		}
	};

	const getPrice = async (screen_id) => {
		try {
			const res = await fetch("http://localhost:5000/price/" + screen_id);
			const seatPrice = await res.json();
			// Set the state
			setPrice(seatPrice);
		} catch (err) {
			console.error(err.message);
		}
	};

	const [finished, setFinished] = useState(0);
	const purchaseTicket = async () => {
		try {
			const screen_id = ticket.screen_id;
			const email = ticket.email;

			const buy_tickets = Array.from(bookings);
			let user_id = null;

			if (isAuth) {
				const res = await fetch("http://localhost:5000/getuser/", {
					method: "POST",
					headers: { jwt_token: localStorage.token }
				});
				user_id = await res.json();
			}

			const body = { screen_id, buy_tickets, user_id, email };
			const response = await fetch(
				"http://localhost:5000/purchase",
				{
					method: "POST",
					headers: {
						"Content-type": "application/json"
					},
					body: JSON.stringify(body)
				}
			);

			const parseRes = await response.json();

			if (parseRes === 1) {
				toast.success("Purchased Ticket Successfully");
				setFinished(1);
			} else {
				toast.error(parseRes);
				console.error(parseRes);
			}
		} catch (err) {
			console.error(err.message);
		}
	}


	const renderSeatTable = () => {
		if (seats.length < 1) {
			return null;
		}

		const renderAlphaCol = () => {
			const letter = 'ABCDEFGHIJ'.split('');

			return (
				<div className="container h-100 d-flex flex-column">
				{letter.map(aaa =>
					<div key={aaa} className="row flex-grow-1 justify-content-center align-items-center" 
						style={{backgroundColor: "#495057"}}
					>{aaa}</div>
				)}
				</div>
			);
		}

		const renderRow = (row) => {
			return (
				<tr key={row}>
					{seats.slice(row * 15, row * 15 + 15).map(seat => {
						const new_id = "seat" + seat.seat_id;

						return <td key={new_id}>
							<input
								type="checkbox"
								name="seat_id"
								value={seat.seat_id}
								id={new_id}
								autoComplete="off"
								className="btn-check"

								onClick={onChangeSeat}
								disabled={seat.book}

								defaultChecked={seat.book}
							/>
							<label htmlFor={new_id} className={"w-100 btn rounded-0 " + (seat.book ? "btn-danger" : "btn-success")}>
								{seat.seat_num}
							</label>
						</td>
					})}
				</tr>
			);
		};

		const renderedSeats = [];
		for (let i = 0; i < 10; i++) {
			renderedSeats.push(renderRow(i));
		}

		return (
			<Fragment>
				<div className="container-md">
					<h4>Select your seat(s): Room {ticket.room_id} - {ticket.room_type}</h4>
					<div className="row justify-content-center">
						<div className="col-10 bg-secondary text-center mt-2 mb-3 p-1"><h2>Screen</h2></div>
					</div>
					<div className="row flex-nowrap">
						<div className="col">{renderAlphaCol()}</div>
						<div className="col-10">
							<table className="table m-0" style={{tableLayout: "fixed"}}>
								{renderedSeats}
							</table>
						</div>
						<div className="col">{renderAlphaCol()}</div>
					</div>
					<div className="container" style={{width: `${100 * 10 / 15}%`}}>
						<div className="row m-4 d-flex align-items-center">
							<button className="col-1 btn rounded-0 btn-outline-success p-2">
								&nbsp;
							</button>
							<h6 className="col m-0">Available</h6>
							<button className="col-1 btn rounded-0 btn-success p-2">
								&nbsp;
							</button>
							<h6 className="col m-0">Selected</h6>
							<button className="col-1 btn rounded-0 btn-danger p-2" disabled>
								&nbsp;
							</button>
							<h6 className="col m-0">Taken</h6>
						</div>
					</div>
				</div>
			</Fragment>
		);
	};


	const renderScreening = () => {
		if (screens.length < 1) {
			return <p>No screening found.</p>;
		}

		return (
			<Fragment>
				<h4>Select a time:</h4>
				{screens.map(g => (
					<button
						key={g.screen_id}
						type="btn"
						name="screen_id"
						value={g.screen_id}

						data-roomid={g.room_id}
						data-roomtype={g.room_type}
						onClick={onChangeScreen}
						className="col-sm-auto btn btn-success mx-2 my-2"
					>{moment(g.start_time, 'HH:mm:ss').format('HH:mm')}</button>
				))}
			</Fragment>
		);
	}

	const renderPrice = () => {
		if (seats.length < 1) {
			return;
		}

		if (bookings.size < 1) {
			return <p>No ticket chosen.</p>;
		}

		const totalPrice = ticketPrice * bookings.size;

		return (
			<Fragment>
				<h4>Ticket Count: {bookings.size}</h4>
				<h4>Total: {Intl.NumberFormat('en-US', { style: 'currency', currency: 'VND' }).format(totalPrice)}</h4>
				{!isAuth ? <input
					type="text"
					name="email"
					value={ticket.email}
					placeholder="Email or Phone number"
					onChange={onChangeEmail}
					className="form-control mt-2"
				/> : null}
				<button
					className="btn btn-info btn-lg m-2"

					onClick={purchaseTicket}
					// disabled
				>Purchase</button>
			</Fragment>
		);
	}
	
	return (
		<Fragment>
			<div className="container-md border-bottom">
				<h2 className="text-center display-3 my-3">⚜ Booking ⚜</h2>
				<h4>Select a date:</h4>
				<input
					type="date"
					name="select_day"
					value={ticket.select_day}
					onChange={onChangeDate}
					className="form-control my-3"
				/>
				<div className="row">
					<div className="col">
						{renderScreening()}
					</div>
					<div className="col-lg-8 p-0">
						{renderSeatTable()}
					</div>
				</div>
				<div className="row my-3 justify-content-end">
					<div className="col-sm-3">
						{renderPrice()}
					</div>
				</div>
			</div>
			{finished ? <Navigate to="/" replace /> : null}
		</Fragment>
	)
}

export default Booking;