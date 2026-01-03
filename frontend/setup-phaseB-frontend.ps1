Write-Host "Setting up Phase B Frontend (Permissions + Dashboards)..."

# -------------------------------
# Create folders
# -------------------------------
$folders = @(
  "src/utils",
  "src/pages/admin",
  "src/pages/teacher",
  "src/pages/student"
)

foreach ($folder in $folders) {
  if (!(Test-Path $folder)) {
    New-Item -ItemType Directory -Path $folder | Out-Null
  }
}

# -------------------------------
# permissions.js
# -------------------------------
@'
export const can = {
  manageUsers: (role) => role === "admin",

  viewUser: (viewer, target) => {
    if (viewer.role === "admin") return true;
    if (viewer.role === "teacher" && target.role === "student") {
      return viewer.departmentId === target.departmentId;
    }
    return viewer.uid === target.uid;
  },

  modifyClass: (role) => role === "admin" || role === "teacher",

  createMessage: (role) => role === "admin" || role === "teacher"
};
'@ | Set-Content src/utils/permissions.js

# -------------------------------
# Update ProtectedRoute.jsx
# -------------------------------
@'
import { Navigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";

const ProtectedRoute = ({ allowedRoles, children }) => {
  const { user, profile } = useAuth();

  if (!user) return <Navigate to="/login" />;
  if (allowedRoles && !allowedRoles.includes(profile.role)) {
    return <Navigate to="/unauthorized" />;
  }
  return children;
};

export default ProtectedRoute;
'@ | Set-Content src/routes/ProtectedRoute.jsx

# -------------------------------
# Admin Dashboard
# -------------------------------
@'
export default function AdminDashboard() {
  return (
    <div>
      <h2>Admin Dashboard</h2>
      <p>Manage users and classes</p>
    </div>
  );
}
'@ | Set-Content src/pages/admin/AdminDashboard.jsx

# -------------------------------
# Teacher Dashboard
# -------------------------------
@'
export default function TeacherDashboard() {
  return (
    <div>
      <h2>Teacher Dashboard</h2>
      <p>Manage class students & messages</p>
    </div>
  );
}
'@ | Set-Content src/pages/teacher/TeacherDashboard.jsx

# -------------------------------
# Student Dashboard
# -------------------------------
@'
export default function StudentDashboard() {
  return (
    <div>
      <h2>Student Dashboard</h2>
      <p>Read-only class messages</p>
    </div>
  );
}
'@ | Set-Content src/pages/student/StudentDashboard.jsx

# -------------------------------
# Unauthorized Page
# -------------------------------
@'
export default function Unauthorized() {
  return <h2>Access Denied</h2>;
}
'@ | Set-Content src/pages/Unauthorized.jsx

# -------------------------------
# Update App.jsx
# -------------------------------
@'
import { BrowserRouter, Routes, Route } from "react-router-dom";
import { AuthProvider } from "./context/AuthContext";
import ProtectedRoute from "./routes/ProtectedRoute";

import Login from "./pages/Login";
import Unauthorized from "./pages/Unauthorized";

import AdminDashboard from "./pages/admin/AdminDashboard";
import TeacherDashboard from "./pages/teacher/TeacherDashboard";
import StudentDashboard from "./pages/student/StudentDashboard";

function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>

          <Route path="/login" element={<Login />} />
          <Route path="/unauthorized" element={<Unauthorized />} />

          <Route
            path="/admin"
            element={
              <ProtectedRoute allowedRoles={["admin"]}>
                <AdminDashboard />
              </ProtectedRoute>
            }
          />

          <Route
            path="/teacher"
            element={
              <ProtectedRoute allowedRoles={["teacher"]}>
                <TeacherDashboard />
              </ProtectedRoute>
            }
          />

          <Route
            path="/student"
            element={
              <ProtectedRoute allowedRoles={["student"]}>
                <StudentDashboard />
              </ProtectedRoute>
            }
          />

        </Routes>
      </BrowserRouter>
    </AuthProvider>
  );
}

export default App;
'@ | Set-Content src/App.jsx

Write-Host "Phase B frontend setup complete."
Write-Host "Next: apply backend rules & test role-based routing."
