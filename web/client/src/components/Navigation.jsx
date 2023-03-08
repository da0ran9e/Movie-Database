import { React, Fragment } from "react";
import { NavLink } from "react-router-dom";

function Navigation({ isAuth, isMan }) {


	function managerview(){
		if (!isMan) {
			return (<ul className="navbar-nav ml-auto">
				<li className="nav-item">
					<NavLink className="nav-link" to="/">Home</NavLink>
				</li>
				<li className="nav-item">
					<NavLink className="nav-link" to="/about">About</NavLink>
				</li>
				<li className="nav-item">
					{!isAuth ? (
						<NavLink className="nav-link" to="/login">Login</NavLink>
					) : (
						<NavLink className="nav-link" to="/dashboard">Profile</NavLink>
					)}
				</li>
			</ul>)

		} else {

			return (<ul className="navbar-nav ml-auto">
				<li className="nav-item">
					<NavLink className="nav-link" to="/">Home</NavLink>
				</li>
				<li className="nav-item">
					<NavLink className="nav-link" to="/about">Add Movie</NavLink>
				</li>
			</ul>)
		}
	}

	return (
		<Fragment>
		<div className="navigation">
			<nav className="navbar navbar-expand navbar-dark form-dark-blue" >
				<div className="container">
					<NavLink className="navbar-brand" to="/">
						React Multi-Page Website
					</NavLink>
					<div>
						{managerview()}
					</div>
				</div>
			</nav>
		</div>
		</Fragment>
	);
}

export default Navigation;