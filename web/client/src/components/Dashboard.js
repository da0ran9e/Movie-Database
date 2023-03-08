import React, { useEffect, useState, useCallback } from "react";
import { toast } from "react-toastify";

const Dashboard = ({ setAuth }) => {
	const [name, setName] = useState("");

	const getProfile = useCallback(async () => {
		try {
			const res = await fetch("http://localhost:5000/dashboard/", {
				method: "POST",
				headers: { jwt_token: localStorage.token }
			});

			const parseData = await res.json();
			setName(parseData);
		} catch (err) {
			console.error(err.message);
		}
	}, [setName]);

	const logout = async e => {
		e.preventDefault();
		try {
			localStorage.removeItem("jwt_token");
			setAuth(false);
			toast.success("Logout successfully");
		} catch (err) {
			console.error(err.message);
		}
	};

	useEffect(() => {
		getProfile();
	}, [getProfile]);

	return (
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
						<h1 className="display-3 my-3">Dashboard</h1>
						<h3 className="display-6 mb-4">Welcome back, <b>{name}</b></h3>
						<button onClick={e => logout(e)} className="btn btn-danger">
							Logout
						</button>
					</div>
				</div>
		</div>
	);
};

export default Dashboard;
