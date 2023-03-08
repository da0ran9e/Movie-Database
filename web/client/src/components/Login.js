import React, { Fragment, useState } from "react";
import { Link, Navigate } from "react-router-dom";
import { toast } from "react-toastify";

const Login = ({ setAuth, setMan, isMan }) => {
	const [inputs, setInputs] = useState({
		email_phone: "",
		password: ""
	});

	const { email_phone, password } = inputs;

	const onChange = e =>
		setInputs({ ...inputs, [e.target.name]: e.target.value });

	const onSubmitForm = async e => {
		e.preventDefault();

		try {
			if (email_phone === '123' && password === '123') {
				setMan(true);
				return;
			}


			const body = { email_phone, password };
			const response = await fetch(
				"http://localhost:5000/auth/login",
				{
					method: "POST",
					headers: {
						"Content-type": "application/json"
					},
					body: JSON.stringify(body)
				}
			);

			const parseRes = await response.json();

			if (parseRes.jwToken) {
				localStorage.setItem("token", parseRes.jwToken);

				setAuth(true);
				toast.success("Logged in Successfully");
			} else {
				setAuth(false);
				toast.error(parseRes);
				console.error(parseRes);
			}
		} catch (err) {
			console.error(err.message);
		}
	};

	return (
		<Fragment>
			<div className="container">
				{isMan ? <Navigate to="/" replace /> : null}
				<div className="row justify-content-end">
					<div className="col p-4 text-end">
						<p>
							Login as user: '123'
							<br/>and password: '123'
							<br/>to add screenings
						</p>
					</div>
					<div className="col-md-4 form-dark-blue rounded-bottom p-4">
			<h1 className="text-center">Login</h1>
			<form onSubmit={onSubmitForm}>
				<input
					type="text"
					name="email_phone"
					value={email_phone}
					placeholder="Email or Phone number"
					onChange={e => onChange(e)}
					className="form-control my-3"
				/>
				<input
					type="password"
					name="password"
					value={password}
					placeholder="Password"
					onChange={e => onChange(e)}
					className="form-control my-3"
					autoComplete="on"
				/>
				<div className="d-flex flex-row justify-content-around">
					<Link className="btn btn-dark btn-lg" to="/register">Register</Link>
					<button className="btn btn-success btn-lg">Submit</button>
				</div>
			</form>
					</div>
				</div>
			</div>
		</Fragment>
	);
};

export default Login;
