import React, { Fragment, useState, useEffect } from "react";
import './App.css';
import 'react-toastify/dist/ReactToastify.css';

import { BrowserRouter as Router, Route, Routes, Navigate } from "react-router-dom";
import {
	Navigation,
	Home,
	About,
} from "./components";

import { ToastContainer, toast } from "react-toastify";


import Login from "./components/Login";
import Register from "./components/Register";
import Dashboard from "./components/Dashboard";

import InputTodo from "./components/InputTodo";
import MovieList from "./components/ListMovies";
import Booking from "./components/Booking";

import AddScreening from "./components/AddScreening";

function App() {
	const [movies, setMovies] = useState([]);
	const [isAuth, setIsAuthenticated] = useState(false);
	const [isManager, setManagerMode] = useState(false);

	const checkAuthenticated = async () => {
		try {
			const res = await fetch("http://localhost:5000/auth/verify", {
				method: "POST",
				headers: { jwt_token: localStorage.token }
			});

			const parseRes = await res.json();

			parseRes === true ? setIsAuthenticated(true) : setIsAuthenticated(false);
			// toast.error(parseRes);
		} catch (err) {
			console.error(err.message);
		}
	};

	useEffect(() => {
		checkAuthenticated();
	}, []);

	const removeManager = () => {
		setManagerMode(false);
	}

	return (
		<Fragment>
			<div  className="bg-dark text-white">
				<Router>
					<Navigation isAuth={isAuth} isMan={isManager} />
					<ToastContainer />
					<Routes>
						<Route path="/" element={<Home /> } />
						<Route path="/about" element={<About />} />
						<Route path="/dashboard" element={isAuth ? <Dashboard setAuth={setIsAuthenticated}/> : <Navigate to="/" replace />} />
						<Route path="/login" element={isAuth ? <Navigate to="/" replace /> : <Login setAuth={setIsAuthenticated} setMan={setManagerMode}/>} />
						<Route path="/register" element={isAuth ? <Navigate to="/" replace /> : <Register setAuth={setIsAuthenticated}/>} />
						<Route path="/addscreening/:movie_id" element={<AddScreening />} />
						<Route path="/booking/:movie_id" element={<Booking />} />
					</Routes>
				</Router>
				<div className="container mt-4">
					{isManager ? <button className="btn btn-secondary btn-lg" onClick={removeManager}>Shutdown manager</button> : null}
					{isManager ? <InputTodo movies={movies} setMovies={setMovies} /> : null }
					<MovieList movies={movies} setMovies={setMovies} isMan={isManager}/>
				</div>
			</div>
		</Fragment>
	);
}

export default App;
