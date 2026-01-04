# -------------------------------------------------------------------------
# SAFE ADMIN UI SCAFFOLDING SCRIPT
# -------------------------------------------------------------------------
# ✅ Extends existing frontend structure
# ✅ Adds Admin UI scaffolding ONLY
# ✅ DOES NOT touch Firebase Auth Logic
# ✅ DOES NOT use secondary Firebase Apps
# -------------------------------------------------------------------------

Write-Host "Starting Safe Admin UI Scaffolding..."

# 1. Ensure directories exist
$dirs = @(
    "src/pages/admin",
    "src/components/admin"
)

foreach ($dir in $dirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "Created directory: $dir"
    }
}

# -------------------------------------------------------------------------
# 2. CREATE AddUserForm.jsx (UI ONLY - NO AUTH LOGIC)
# -------------------------------------------------------------------------
# This component creates the visual form for adding users.
# It DOES NOT interact with Firebase Auth.
# It prepares the payload for a future Cloud Function.
# -------------------------------------------------------------------------

$AddUserFormContent = @"
import React, { useState } from 'react';

const AddUserForm = ({ onClose }) => {
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    displayName: '',
    role: 'student', // default
    department: '',
    classId: ''
  });

  const [loading, setLoading] = useState(false);

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    try {
      // ---------------------------------------------------------
      // SAFE IMPLEMENTATION NOTE:
      // ---------------------------------------------------------
      // Frontend cannot create Auth users directly.
      // This is a placeholder for the future Cloud Function call.
      // e.g., httpsCallable(functions, 'createNewUser')(formData)
      // ---------------------------------------------------------
      
      console.log(' [FUTURE CLOUD FUNCTION] Create User Payload:', formData);
      alert('UI Only: This would trigger a Cloud Function to create the user safely.');
      
      if (onClose) onClose();
    } catch (error) {
      console.error('Error preparing user creation:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="bg-white p-6 rounded-lg shadow-md border border-gray-200">
      <h3 className="text-xl font-bold mb-4">Add New User (UI Stub)</h3>
      <form onSubmit={handleSubmit} className="space-y-4">
        
        {/* Email */}
        <div>
          <label className="block text-sm font-medium text-gray-700">Email</label>
          <input
            type="email"
            name="email"
            required
            className="mt-1 block w-full border border-gray-300 rounded-md p-2"
            value={formData.email}
            onChange={handleChange}
          />
        </div>

        {/* Password */}
        <div>
          <label className="block text-sm font-medium text-gray-700">Temporary Password</label>
          <input
            type="password"
            name="password"
            required
            minLength={6}
            className="mt-1 block w-full border border-gray-300 rounded-md p-2"
            value={formData.password}
            onChange={handleChange}
          />
        </div>

        {/* Name */}
        <div>
          <label className="block text-sm font-medium text-gray-700">Full Name</label>
          <input
            type="text"
            name="displayName"
            required
            className="mt-1 block w-full border border-gray-300 rounded-md p-2"
            value={formData.displayName}
            onChange={handleChange}
          />
        </div>

        {/* Role Selection */}
        <div>
          <label className="block text-sm font-medium text-gray-700">Role</label>
          <select
            name="role"
            className="mt-1 block w-full border border-gray-300 rounded-md p-2"
            value={formData.role}
            onChange={handleChange}
          >
            <option value="student">Student</option>
            <option value="teacher">Teacher</option>
            <option value="admin">Admin</option>
          </select>
        </div>

        {/* Context Fields based on Role */}
        {formData.role === 'student' && (
          <div>
            <label className="block text-sm font-medium text-gray-700">Class ID</label>
            <input
              type="text"
              name="classId"
              placeholder="e.g., CS-2024-A"
              className="mt-1 block w-full border border-gray-300 rounded-md p-2"
              value={formData.classId}
              onChange={handleChange}
            />
          </div>
        )}

        {(formData.role === 'teacher' || formData.role === 'student') && (
          <div>
            <label className="block text-sm font-medium text-gray-700">Department</label>
            <input
              type="text"
              name="department"
              placeholder="e.g., Computer Science"
              className="mt-1 block w-full border border-gray-300 rounded-md p-2"
              value={formData.department}
              onChange={handleChange}
            />
          </div>
        )}

        <div className="flex gap-2 pt-4">
          <button
            type="submit"
            disabled={loading}
            className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 disabled:opacity-50"
          >
            {loading ? 'Processing...' : 'Simulate Create'}
          </button>
          <button
            type="button"
            onClick={onClose}
            className="bg-gray-200 text-gray-800 px-4 py-2 rounded hover:bg-gray-300"
          >
            Cancel
          </button>
        </div>
      </form>
    </div>
  );
};

export default AddUserForm;
"@

$AddUserFormPath = "src/components/admin/AddUserForm.jsx"
Set-Content -Path $AddUserFormPath -Value $AddUserFormContent -Encoding UTF8
Write-Host "Generated: $AddUserFormPath"

# -------------------------------------------------------------------------
# 3. CREATE UserList.jsx (READ-ONLY)
# -------------------------------------------------------------------------
# Retrieves user documents from Firestore.
# Does NOT touch Auth.
# -------------------------------------------------------------------------

$UserListContent = @"
import React, { useEffect, useState } from 'react';
import { db } from '../../firebase';
import { collection, getDocs, query, limit } from 'firebase/firestore';

const UserList = () => {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        // Safe Read-Only Operation
        const q = query(collection(db, 'users'), limit(50));
        const querySnapshot = await getDocs(q);
        const userList = querySnapshot.docs.map(doc => ({
          id: doc.id,
          ...doc.data()
        }));
        setUsers(userList);
      } catch (err) {
        console.error("Error fetching users:", err);
        setError("Failed to load users. Ensure Firestore permissions allow admin access.");
      } finally {
        setLoading(false);
      }
    };

    fetchUsers();
  }, []);

  if (loading) return <div className="p-4">Loading users...</div>;
  if (error) return <div className="p-4 text-red-600">{error}</div>;

  return (
    <div className="overflow-x-auto">
      <table className="min-w-full bg-white border border-gray-300">
        <thead className="bg-gray-50">
          <tr>
            <th className="py-2 px-4 border-b text-left">Name</th>
            <th className="py-2 px-4 border-b text-left">Email</th>
            <th className="py-2 px-4 border-b text-left">Role</th>
            <th className="py-2 px-4 border-b text-left">Details</th>
          </tr>
        </thead>
        <tbody>
          {users.map(user => (
            <tr key={user.id} className="hover:bg-gray-50">
              <td className="py-2 px-4 border-b">{user.displayName || 'N/A'}</td>
              <td className="py-2 px-4 border-b">{user.email}</td>
              <td className="py-2 px-4 border-b">
                <span className={\`px-2 py-1 rounded text-xs \${
                  user.role === 'admin' ? 'bg-purple-100 text-purple-800' :
                  user.role === 'teacher' ? 'bg-blue-100 text-blue-800' :
                  'bg-green-100 text-green-800'
                }\`}>
                  {user.role}
                </span>
              </td>
              <td className="py-2 px-4 border-b text-sm text-gray-500">
                {user.role === 'student' && user.classId && \`Class: \${user.classId}\`}
                {user.department && \` Dept: \${user.department}\`}
              </td>
            </tr>
          ))}
          {users.length === 0 && (
            <tr>
              <td colSpan="4" className="py-4 text-center text-gray-500">
                No users found in 'users' collection.
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
};

export default UserList;
"@

$UserListPath = "src/components/admin/UserList.jsx"
Set-Content -Path $UserListPath -Value $UserListContent -Encoding UTF8
Write-Host "Generated: $UserListPath"

# -------------------------------------------------------------------------
# 4. UPDATE AdminDashboard.jsx (Layout Container)
# -------------------------------------------------------------------------
# Combines UserList and AddUserForm.
# -------------------------------------------------------------------------

$AdminDashboardContent = @"
import React, { useState } from 'react';
import UserList from '../../components/admin/UserList';
import AddUserForm from '../../components/admin/AddUserForm';

const AdminDashboard = () => {
  const [activeTab, setActiveTab] = useState('users');
  const [showAddUser, setShowAddUser] = useState(false);

  return (
    <div className="p-6 max-w-7xl mx-auto">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold text-gray-800">Admin Dashboard</h1>
        <button 
          onClick={() => setShowAddUser(!showAddUser)}
          className="bg-indigo-600 text-white px-4 py-2 rounded hover:bg-indigo-700 transition"
        >
          {showAddUser ? 'Close Form' : 'Add New User'}
        </button>
      </div>

      {/* Action Area */}
      {showAddUser && (
        <div className="mb-8">
          <AddUserForm onClose={() => setShowAddUser(false)} />
        </div>
      )}

      {/* Tabs */}
      <div className="border-b border-gray-200 mb-6">
        <nav className="-mb-px flex space-x-8">
          <button
            onClick={() => setActiveTab('users')}
            className={\`pb-4 px-1 border-b-2 font-medium text-sm \${
              activeTab === 'users'
                ? 'border-indigo-500 text-indigo-600'
                : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
            }\`}
          >
            User Management
          </button>
          <button
            onClick={() => setActiveTab('system')}
            className={\`pb-4 px-1 border-b-2 font-medium text-sm \${
              activeTab === 'system'
                ? 'border-indigo-500 text-indigo-600'
                : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
            }\`}
          >
            System Health (Placeholder)
          </button>
        </nav>
      </div>

      {/* Content Area */}
      <div>
        {activeTab === 'users' && <UserList />}
        {activeTab === 'system' && (
          <div className="p-8 text-center text-gray-500 bg-gray-50 rounded border border-dashed border-gray-300">
            System stats and logs will appear here.
          </div>
        )}
      </div>
    </div>
  );
};

export default AdminDashboard;
"@

$AdminDashboardPath = "src/pages/admin/AdminDashboard.jsx"
Set-Content -Path $AdminDashboardPath -Value $AdminDashboardContent -Encoding UTF8
Write-Host "Generated: $AdminDashboardPath"

Write-Host "✅ Safe Admin UI Scaffolding Complete."