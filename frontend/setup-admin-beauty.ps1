# -------------------------------------------------------------------------
# TAILWIND v4 ADMIN UI SETUP SCRIPT
# -------------------------------------------------------------------------
# ✅ Optimized for Tailwind v4 (No custom config dependencies)
# ✅ Premium Blue/Slate Theme
# ✅ Role-Based Tabs (Student, Teacher, Admin)
# ✅ Safe UI scaffolding (No Auth Logic)
# -------------------------------------------------------------------------

Write-Host "Applying Tailwind v4 Admin UI Updates..."

# 1. Ensure directories exist
$dirs = @(
    "src/pages/admin",
    "src/components/admin"
)

foreach ($dir in $dirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "Created: $dir"
    }
}

# -------------------------------------------------------------------------
# 1. UPDATE AddUserForm.jsx
# -------------------------------------------------------------------------

$AddUserFormContent = @"
import React, { useState } from 'react';

const AddUserForm = ({ onClose }) => {
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    displayName: '',
    role: 'student',
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
      // FUTURE: Cloud Function logic
      console.log(' [FUTURE] Creating User:', formData);
      await new Promise(resolve => setTimeout(resolve, 800)); // Simulate delay
      if (onClose) onClose();
    } catch (error) {
      console.error('Error:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="bg-white p-6 md:p-8 rounded-xl shadow-lg border border-slate-200 transition-all duration-300">
      <div className="flex justify-between items-center mb-6">
        <div>
          <h3 className="text-xl font-bold text-slate-900">Add New User</h3>
          <p className="text-sm text-slate-500">Create a new account in the system.</p>
        </div>
        <button 
          onClick={onClose} 
          className="text-slate-400 hover:text-slate-600 p-2 hover:bg-slate-100 rounded-full transition-colors"
        >
          ✕
        </button>
      </div>

      <form onSubmit={handleSubmit} className="space-y-5">
        
        {/* Email */}
        <div>
          <label className="block text-sm font-semibold text-slate-700 mb-1.5">Email Address</label>
          <input
            type="email"
            name="email"
            required
            className="w-full border border-slate-300 rounded-lg px-3 py-2.5 text-slate-700 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all"
            placeholder="user@university.edu"
            value={formData.email}
            onChange={handleChange}
          />
        </div>

        {/* Password */}
        <div>
          <label className="block text-sm font-semibold text-slate-700 mb-1.5">Temporary Password</label>
          <input
            type="password"
            name="password"
            required
            minLength={6}
            className="w-full border border-slate-300 rounded-lg px-3 py-2.5 text-slate-700 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all"
            value={formData.password}
            onChange={handleChange}
          />
        </div>

        {/* Name */}
        <div>
          <label className="block text-sm font-semibold text-slate-700 mb-1.5">Full Name</label>
          <input
            type="text"
            name="displayName"
            required
            className="w-full border border-slate-300 rounded-lg px-3 py-2.5 text-slate-700 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all"
            value={formData.displayName}
            onChange={handleChange}
          />
        </div>

        {/* Role Selection */}
        <div>
          <label className="block text-sm font-semibold text-slate-700 mb-1.5">Role</label>
          <div className="relative">
            <select
              name="role"
              className="w-full border border-slate-300 rounded-lg px-3 py-2.5 bg-white text-slate-700 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 appearance-none transition-all"
              value={formData.role}
              onChange={handleChange}
            >
              <option value="student">Student</option>
              <option value="teacher">Teacher</option>
              <option value="admin">Admin</option>
            </select>
            <div className="absolute inset-y-0 right-0 flex items-center px-2 pointer-events-none">
              <svg className="w-4 h-4 text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 9l-7 7-7-7"></path></svg>
            </div>
          </div>
        </div>

        {/* Context Fields */}
        {formData.role === 'student' && (
          <div className="bg-blue-50/50 p-4 rounded-lg border border-blue-100/50 space-y-3">
            <div>
              <label className="block text-xs font-bold text-blue-800 uppercase tracking-wide mb-1">Class ID</label>
              <input
                type="text"
                name="classId"
                placeholder="e.g., CS-2024-A"
                className="w-full border border-blue-200 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 text-sm"
                value={formData.classId}
                onChange={handleChange}
              />
            </div>
            <div>
              <label className="block text-xs font-bold text-blue-800 uppercase tracking-wide mb-1">Department</label>
              <input
                type="text"
                name="department"
                placeholder="e.g., Computer Science"
                className="w-full border border-blue-200 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 text-sm"
                value={formData.department}
                onChange={handleChange}
              />
            </div>
          </div>
        )}

        {formData.role === 'teacher' && (
           <div className="bg-indigo-50/50 p-4 rounded-lg border border-indigo-100/50">
            <label className="block text-xs font-bold text-indigo-800 uppercase tracking-wide mb-1">Department</label>
            <input
              type="text"
              name="department"
              placeholder="e.g., Mathematics"
              className="w-full border border-indigo-200 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 text-sm"
              value={formData.department}
              onChange={handleChange}
            />
          </div>
        )}

        <div className="flex gap-3 pt-4">
          <button
            type="submit"
            disabled={loading}
            className="flex-1 bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2.5 rounded-lg shadow-sm hover:shadow transition-all disabled:opacity-70 disabled:cursor-not-allowed"
          >
            {loading ? 'Processing...' : 'Create User'}
          </button>
          <button
            type="button"
            onClick={onClose}
            className="px-6 py-2.5 border border-slate-300 text-slate-700 font-medium rounded-lg hover:bg-slate-50 transition-colors"
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
# 2. UPDATE UserList.jsx
# -------------------------------------------------------------------------

$UserListContent = @"
import React, { useEffect, useState } from 'react';
import { db } from '../../firebase';
import { collection, getDocs, query, where, limit } from 'firebase/firestore';

const UserList = ({ roleFilter }) => {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchUsers = async () => {
      setLoading(true);
      setError(null);
      try {
        const usersRef = collection(db, 'users');
        let q;

        if (roleFilter && roleFilter !== 'all') {
          q = query(usersRef, where('role', '==', roleFilter), limit(50));
        } else {
          q = query(usersRef, limit(50));
        }

        const querySnapshot = await getDocs(q);
        const userList = querySnapshot.docs.map(doc => ({
          id: doc.id,
          ...doc.data()
        }));
        setUsers(userList);
      } catch (err) {
        console.error("Error:", err);
        setError("Could not load users. Check permissions.");
      } finally {
        setLoading(false);
      }
    };

    fetchUsers();
  }, [roleFilter]);

  if (loading) return (
    <div className="p-12 text-center">
      <div className="inline-block animate-spin rounded-full h-8 w-8 border-4 border-blue-500 border-t-transparent"></div>
      <p className="mt-2 text-slate-500 font-medium">Loading {roleFilter}s...</p>
    </div>
  );

  if (error) return (
    <div className="p-4 mx-4 mt-4 bg-red-50 border border-red-100 text-red-600 rounded-lg text-sm font-medium">
      {error}
    </div>
  );

  return (
    <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
      <div className="overflow-x-auto">
        <table className="min-w-full divide-y divide-slate-100">
          <thead className="bg-slate-50/50">
            <tr>
              <th className="py-3 px-6 text-left text-xs font-bold text-slate-500 uppercase tracking-wider">User Details</th>
              <th className="py-3 px-6 text-left text-xs font-bold text-slate-500 uppercase tracking-wider">Role</th>
              <th className="py-3 px-6 text-left text-xs font-bold text-slate-500 uppercase tracking-wider">Context</th>
              <th className="py-3 px-6 text-right text-xs font-bold text-slate-500 uppercase tracking-wider">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-100 bg-white">
            {users.map(user => (
              <tr key={user.id} className="hover:bg-slate-50/80 transition-colors duration-150">
                <td className="py-4 px-6 whitespace-nowrap">
                  <div className="flex items-center">
                    <div className="h-10 w-10 flex-shrink-0 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-full flex items-center justify-center text-white font-bold shadow-sm">
                      {(user.displayName || '?').charAt(0).toUpperCase()}
                    </div>
                    <div className="ml-4">
                      <div className="text-sm font-semibold text-slate-900">{user.displayName || 'Unnamed User'}</div>
                      <div className="text-sm text-slate-500">{user.email}</div>
                    </div>
                  </div>
                </td>
                <td className="py-4 px-6 whitespace-nowrap">
                  <span className={\`inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium border capitalize
                    \${user.role === 'admin' 
                      ? 'bg-purple-50 text-purple-700 border-purple-100' 
                      : user.role === 'teacher' 
                        ? 'bg-indigo-50 text-indigo-700 border-indigo-100' 
                        : 'bg-emerald-50 text-emerald-700 border-emerald-100'}\`}>
                    {user.role}
                  </span>
                </td>
                <td className="py-4 px-6 text-sm text-slate-500">
                  <div className="flex flex-col gap-1">
                    {user.classId && (
                      <span className="inline-flex items-center gap-1.5 text-xs text-slate-600">
                        <span className="w-1.5 h-1.5 rounded-full bg-slate-400"></span>
                        {user.classId}
                      </span>
                    )}
                    {user.department && (
                      <span className="inline-flex items-center gap-1.5 text-xs text-slate-600">
                        <span className="w-1.5 h-1.5 rounded-full bg-slate-400"></span>
                        {user.department}
                      </span>
                    )}
                    {!user.classId && !user.department && <span className="text-slate-400 italic">No details</span>}
                  </div>
                </td>
                <td className="py-4 px-6 text-right text-sm font-medium">
                  <button className="text-blue-600 hover:text-blue-800 transition-colors">Edit</button>
                </td>
              </tr>
            ))}
            {users.length === 0 && (
              <tr>
                <td colSpan="4" className="py-12 text-center text-slate-400 text-sm">
                  No {roleFilter}s found in the database.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default UserList;
"@

$UserListPath = "src/components/admin/UserList.jsx"
Set-Content -Path $UserListPath -Value $UserListContent -Encoding UTF8
Write-Host "Generated: $UserListPath"

# -------------------------------------------------------------------------
# 3. UPDATE AdminDashboard.jsx
# -------------------------------------------------------------------------

$AdminDashboardContent = @"
import React, { useState } from 'react';
import UserList from '../../components/admin/UserList';
import AddUserForm from '../../components/admin/AddUserForm';

const AdminDashboard = () => {
  const [mainTab, setMainTab] = useState('management');
  const [roleTab, setRoleTab] = useState('student');
  const [showAddUser, setShowAddUser] = useState(false);

  return (
    <div className="min-h-screen bg-slate-50 p-4 md:p-8 font-sans text-slate-900">
      <div className="max-w-7xl mx-auto space-y-8">
        
        {/* Header */}
        <div className="flex flex-col md:flex-row justify-between items-start md:items-end gap-4 border-b border-slate-200 pb-6">
          <div>
            <h1 className="text-3xl font-extrabold text-slate-900 tracking-tight">Admin Portal</h1>
            <p className="text-slate-500 mt-2 text-sm font-medium">Overview of system users and performance.</p>
          </div>
          
          <div className="flex gap-4">
             <button 
              onClick={() => setShowAddUser(!showAddUser)}
              className={\`flex items-center gap-2 px-5 py-2.5 rounded-lg font-semibold shadow-sm transition-all duration-200
                \${showAddUser 
                  ? 'bg-slate-200 text-slate-700 hover:bg-slate-300' 
                  : 'bg-blue-600 text-white hover:bg-blue-700 hover:shadow-md'}\`}
            >
              {showAddUser ? 'Close Form' : '+ Add User'}
            </button>
          </div>
        </div>

        {/* Content Container */}
        <div className="grid grid-cols-1 lg:grid-cols-4 gap-8">
          
          {/* Sidebar / Tabs */}
          <div className="lg:col-span-1 space-y-6">
             {/* Add User Drawer (Mobile responsive placement) */}
             {showAddUser && (
                <div className="mb-6 lg:hidden">
                  <AddUserForm onClose={() => setShowAddUser(false)} />
                </div>
              )}

            <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-4">
              <h3 className="text-xs font-bold text-slate-400 uppercase tracking-wider mb-3 px-2">Menu</h3>
              <nav className="space-y-1">
                {['management', 'health'].map((tab) => (
                  <button
                    key={tab}
                    onClick={() => setMainTab(tab)}
                    className={\`w-full text-left px-3 py-2 rounded-lg text-sm font-medium transition-colors
                      \${mainTab === tab
                        ? 'bg-blue-50 text-blue-700'
                        : 'text-slate-600 hover:bg-slate-50 hover:text-slate-900'
                      }\`}
                  >
                    {tab === 'management' ? 'User Management' : 'System Health'}
                  </button>
                ))}
              </nav>
            </div>

            {/* Stats Mini Cards */}
            <div className="grid grid-cols-2 lg:grid-cols-1 gap-4">
               <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm">
                  <p className="text-slate-500 text-xs font-semibold uppercase">Total Students</p>
                  <p className="text-2xl font-bold text-slate-900 mt-1">--</p>
               </div>
               <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm">
                  <p className="text-slate-500 text-xs font-semibold uppercase">Total Teachers</p>
                  <p className="text-2xl font-bold text-slate-900 mt-1">--</p>
               </div>
            </div>
          </div>

          {/* Main Panel */}
          <div className="lg:col-span-3">
             
            {/* Desktop Add User Form */}
            {showAddUser && (
              <div className="hidden lg:block mb-8">
                <AddUserForm onClose={() => setShowAddUser(false)} />
              </div>
            )}

            {mainTab === 'management' ? (
              <div className="space-y-6">
                {/* Role Tabs */}
                <div className="flex p-1 bg-slate-200/50 rounded-lg w-fit">
                  {['student', 'teacher', 'admin'].map((role) => (
                    <button
                      key={role}
                      onClick={() => setRoleTab(role)}
                      className={\`px-6 py-2 rounded-md text-sm font-semibold capitalize transition-all duration-200
                        \${roleTab === role
                          ? 'bg-white text-slate-900 shadow-sm ring-1 ring-black/5'
                          : 'text-slate-600 hover:text-slate-900'
                        }\`}
                    >
                      {role}s
                    </button>
                  ))}
                </div>

                <UserList roleFilter={roleTab} />
              </div>
            ) : (
              <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-12 text-center">
                 <div className="inline-flex items-center justify-center w-16 h-16 rounded-full bg-emerald-100 text-emerald-600 mb-4">
                    <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                 </div>
                 <h2 className="text-xl font-bold text-slate-900">System Healthy</h2>
                 <p className="text-slate-500 mt-2">All services are operating normally.</p>
              </div>
            )}
          </div>

        </div>
      </div>
    </div>
  );
};

export default AdminDashboard;
"@

$AdminDashboardPath = "src/pages/admin/AdminDashboard.jsx"
Set-Content -Path $AdminDashboardPath -Value $AdminDashboardContent -Encoding UTF8
Write-Host "Generated: $AdminDashboardPath"

Write-Host "✅ Admin UI updated for Tailwind v4."