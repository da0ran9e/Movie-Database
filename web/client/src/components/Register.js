import React, { Fragment, useState } from "react";
import { Link } from "react-router-dom";
import { toast } from "react-toastify";

const Register = ({ setAuth }) => {
	const [inputs, setInputs] = useState({
		name: "",
		email: null,
		phone: null,
		password: "",
	});

	const { name, email, phone , password } = inputs;

	const onChange = e =>
		setInputs({ ...inputs, [e.target.name]: e.target.value });

	const onSubmitForm = async e => {
		e.preventDefault();

		try {
			const body = { name, email, phone, password };
			const response = await fetch(
				"http://localhost:5000/auth/register",
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
				toast.success("Register Successfully");
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
				<div className="row justify-content-end">
					<div className="col-md-4 form-dark-blue rounded-bottom p-4">
			<h1 className="text-center">Register</h1>
			<form onSubmit={onSubmitForm}>
				<input
					type="text"
					name="email"
					value={email}
					placeholder="Email"
					onChange={e => onChange(e)}
					className="form-control my-3"
				/>
				<input
					type="text"
					name="phone"
					value={phone}
					placeholder="Phone number"
					onChange={e => onChange(e)}
					className="form-control my-3"
				/>
				<input
					type="password"
					name="password"
					value={password}
					autoComplete="on"
					placeholder="Password"
					onChange={e => onChange(e)}
					className="form-control my-3"
				/>
				<input
					type="text"
					name="name"
					value={name}
					placeholder="Name"
					onChange={e => onChange(e)}
					className="form-control my-3"
				/>
				<span className="text-danger" id="input_error"></span>
				<div className="d-flex flex-row justify-content-around">
					<Link className="btn btn-dark btn-lg" to="/login">Login</Link>
					<button className="btn btn-success btn-lg">Submit</button>
				</div>
			</form>
						</div>
				</div>
			</div>
		</Fragment>
	);
};

export default Register;
