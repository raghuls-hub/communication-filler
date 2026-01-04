Write-Host "Setting up Tailwind CSS for React project..."

# -----------------------------
# 1. Install Tailwind dependencies
# -----------------------------
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p

# -----------------------------
# 2. Configure tailwind.config.js
# -----------------------------
@'
/** @type {import("tailwindcss").Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,jsx}"
  ],
  theme: {
    extend: {},
  },
  plugins: [],
};
'@ | Set-Content tailwind.config.js

# -----------------------------
# 3. Configure index.css
# -----------------------------
@'
@tailwind base;
@tailwind components;
@tailwind utilities;
'@ | Set-Content src/index.css

# -----------------------------
# 4. Neutralize App.css (keep file)
# -----------------------------
@'
/* Tailwind CSS in use. This file is intentionally minimal. */
'@ | Set-Content src/App.css

# -----------------------------
# 5. Update Login.jsx
# -----------------------------
@'
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
'@ | Set-Content src/pages/Login.jsx

# -----------------------------
# 6. Dashboards styling
# -----------------------------
$dashboards = @(
  "src/pages/admin/AdminDashboard.jsx",
  "src/pages/teacher/TeacherDashboard.jsx",
  "src/pages/student/StudentDashboard.jsx"
)

foreach ($file in $dashboards) {
@'
import LogoutButton from "../../components/LogoutButton";

export default function Dashboard() {
  return (
    <div className="min-h-screen bg-gray-100 p-6">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold">Dashboard</h1>
        <LogoutButton />
      </div>
    </div>
  );
}
'@ | Set-Content $file
}

# -----------------------------
# 7. Message components styling
# -----------------------------
@'
export default function MessageFeed({ messages }) {
  return (
    <div className="space-y-3">
      {messages.map(msg => (
        <div key={msg.id} className="bg-white p-4 rounded shadow">
          <h4 className="font-semibold">{msg.title}</h4>
          <p className="text-gray-700">{msg.content}</p>
          <span className="text-xs text-gray-500">By {msg.senderRole}</span>
        </div>
      ))}
    </div>
  );
}
'@ | Set-Content src/components/messages/MessageFeed.jsx

@'
import { useState } from "react";
import { sendClassMessage } from "../../services/messageService";
import { useAuth } from "../../context/AuthContext";

export default function MessageComposer() {
  const { profile } = useAuth();
  const [title, setTitle] = useState("");
  const [content, setContent] = useState("");

  const handleSend = async () => {
    if (!title || !content) return;
    await sendClassMessage(profile.classId, profile, title, content);
    setTitle("");
    setContent("");
  };

  return (
    <div className="bg-white p-4 rounded shadow mb-4">
      <input
        className="border p-2 w-full mb-2 rounded"
        placeholder="Title"
        value={title}
        onChange={e => setTitle(e.target.value)}
      />
      <textarea
        className="border p-2 w-full mb-2 rounded"
        placeholder="Message"
        value={content}
        onChange={e => setContent(e.target.value)}
      />
      <button
        onClick={handleSend}
        className="bg-green-600 text-white px-4 py-2 rounded"
      >
        Send
      </button>
    </div>
  );
}
'@ | Set-Content src/components/messages/MessageComposer.jsx

# -----------------------------
# 8. LogoutButton styling
# -----------------------------
@'
import { signOut } from "firebase/auth";
import { auth } from "../firebase";
import { useNavigate } from "react-router-dom";

export default function LogoutButton() {
  const navigate = useNavigate();

  const handleLogout = async () => {
    await signOut(auth);
    navigate("/login");
  };

  return (
    <button className="bg-red-600 text-white px-4 py-2 rounded" onClick={handleLogout}>
      Logout
    </button>
  );
}
'@ | Set-Content src/components/LogoutButton.jsx

# -----------------------------
# 9. Unauthorized page
# -----------------------------
@'
export default function Unauthorized() {
  return (
    <div className="min-h-screen flex items-center justify-center text-red-600 text-xl">
      Access Denied
    </div>
  );
}
'@ | Set-Content src/pages/Unauthorized.jsx

Write-Host "Tailwind CSS setup complete."
