import React, { useEffect, useState } from "react";
import { toast } from "react-toastify";

const Dashboard = ({ setAuth }) => {
	const [name, setName] = useState("");

	const getProfile = async () => {
		try {
			const res = await fetch("http://localhost:5000/dashboard/", {
				method: "POST",
				headers: { jwt_token: localStorage.token }
			});

			const parseData = await res.json();
			setName(parseData.user_name);
		} catch (err) {
			console.error(err.message);
		}
	};

	const logout = async e => {
		e.preventDefault();
		try {
			localStorage.removeItem("token");
			setAuth(false);
			toast.success("Logout successfully");
		} catch (err) {
			console.error(err.message);
		}
	};

	useEffect(() => {
		getProfile();
	}, []);

	return (
		<div className="container">
				<div className="row align-items-center my-5">
					<div className="col-lg-7">
						<img
							className="img-fluid rounded mb-4 mb-lg-0"
							src="http://placehold.it/900x400"
							alt=""
						/>
					</div>
					<div className="col-lg-5">
						<h1 className="font-weight-light">Dashboard</h1>
						<h3>Welcome {name}</h3>
						<button onClick={e => logout(e)} className="btn btn-primary">
							Logout
						</button>
					</div>
				</div>
		</div>
	);
};

export default Dashboard;
