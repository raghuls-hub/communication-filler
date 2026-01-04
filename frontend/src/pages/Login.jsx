import { useState, useEffect } from "react";
import { loginUser } from "../services/authService";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";

export default function Login() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [selectedRole, setSelectedRole] = useState("student");
  const [error, setError] = useState("");

  const navigate = useNavigate();
  const { user, profile } = useAuth();

  // Redirect after successful login & profile load
  useEffect(() => {
    if (user && profile) {
      if (profile.role !== selectedRole) {
        setError("You are not authorized to login as this role.");
        return;
      }

      if (profile.role === "admin") navigate("/admin");
      if (profile.role === "teacher") navigate("/teacher");
      if (profile.role === "student") navigate("/student");
    }
  }, [user, profile, selectedRole, navigate]);

  const handleLogin = async () => {
    setError("");
    try {
      await loginUser(email, password);
    } catch (e) {
      setError(e.message);
    }
  };

  return (
    <div style={{ maxWidth: "400px", margin: "auto" }}>
      <h2>Login</h2>

      {/* Role Tabs */}
      <div style={{ display: "flex", marginBottom: "16px" }}>
        {["admin", "teacher", "student"].map(role => (
          <button
            key={role}
            onClick={() => setSelectedRole(role)}
            style={{
              flex: 1,
              padding: "8px",
              backgroundColor: selectedRole === role ? "#1976d2" : "#e0e0e0",
              color: selectedRole === role ? "#fff" : "#000",
              border: "none",
              cursor: "pointer"
            }}
          >
            {role.toUpperCase()}
          </button>
        ))}
      </div>

      {/* Login Form */}
      <input
        placeholder="Email"
        value={email}
        onChange={e => setEmail(e.target.value)}
        style={{ width: "100%", marginBottom: "8px" }}
      />

      <input
        placeholder="Password"
        type="password"
        value={password}
        onChange={e => setPassword(e.target.value)}
        style={{ width: "100%", marginBottom: "12px" }}
      />

      <button onClick={handleLogin} style={{ width: "100%" }}>
        Login as {selectedRole}
      </button>

      {error && <p style={{ color: "red", marginTop: "10px" }}>{error}</p>}
    </div>
  );
}
