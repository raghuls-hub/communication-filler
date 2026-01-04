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

  useEffect(() => {
    if (user && profile) {
      if (profile.role !== selectedRole) {
        setError("Unauthorized role selection");
        return;
      }
      navigate("/" + profile.role);
    }
  }, [user, profile, selectedRole, navigate]);

  const handleLogin = async () => {
    try {
      await loginUser(email, password);
    } catch (e) {
      setError(e.message);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-100">
      <div className="bg-white p-6 rounded shadow w-96">
        <h2 className="text-xl font-semibold mb-4 text-center">Login</h2>

        <div className="flex mb-4">
          {["admin","teacher","student"].map(r => (
            <button
              key={r}
              onClick={() => setSelectedRole(r)}
              className={`flex-1 py-2 text-sm ${
                selectedRole === r
                  ? "bg-blue-600 text-white"
                  : "bg-gray-200"
              }`}
            >
              {r.toUpperCase()}
            </button>
          ))}
        </div>

        <input
          className="w-full border p-2 mb-2 rounded"
          placeholder="Email"
          onChange={e => setEmail(e.target.value)}
        />

        <input
          className="w-full border p-2 mb-4 rounded"
          type="password"
          placeholder="Password"
          onChange={e => setPassword(e.target.value)}
        />

        <button
          onClick={handleLogin}
          className="w-full bg-blue-600 text-white py-2 rounded"
        >
          Login
        </button>

        {error && <p className="text-red-600 text-sm mt-3">{error}</p>}
      </div>
    </div>
  );
}
