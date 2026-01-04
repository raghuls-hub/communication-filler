# -------------------------------------------------------------------------
# FIREBASE FEATURE INTEGRATION SCRIPT
# -------------------------------------------------------------------------
# ✅ Updates Auth Service (User Provided Code)
# ✅ Adds Class & Department Management (Firestore)
# ✅ Adds Dropdown Selection in User Form
# ✅ Enables Edit Functionality
# -------------------------------------------------------------------------

Write-Host "Starting Feature Integration..."

# 1. UPDATE authService.js
# -------------------------------------------------------------------------
$AuthServiceContent = @"
import { 
  createUserWithEmailAndPassword, 
  signInWithEmailAndPassword, 
  signOut 
} from "firebase/auth";
import { doc, setDoc, serverTimestamp } from "firebase/firestore";
import { auth, db } from "../firebase";

/**
 * ADMIN ONLY (Caution: Logs out current user)
 * Creates Firebase Auth user + Firestore profile
 */
export const registerUser = async (email, password, userData) => {
  try {
    const cred = await createUserWithEmailAndPassword(auth, email, password);
    
    // Create the user document in Firestore
    await setDoc(doc(db, "users", cred.user.uid), {
      uid: cred.user.uid,
      email,
      ...userData,
      createdAt: serverTimestamp()
    });

    return cred.user;
  } catch (error) {
    console.error("Register user failed:", error);
    throw error;
  }
};

/**
 * Login (All roles)
 */
export const loginUser = async (email, password) => {
  try {
    const result = await signInWithEmailAndPassword(auth, email, password);
    return result.user;
  } catch (error) {
    console.error("Login failed:", error);
    throw error;
  }
};

/**
 * Logout
 */
export const logoutUser = async () => {
  try {
    await signOut(auth);
  } catch (error) {
    console.error("Logout failed:", error);
    throw error;
  }
};
"@

$AuthServicePath = "src/services/authService.js"
Set-Content -Path $AuthServicePath -Value $AuthServiceContent -Encoding UTF8
Write-Host "✅ Updated: $AuthServicePath"

# 2. CREATE dbService.js (For Classes/Departments/Updates)
# -------------------------------------------------------------------------
$DbServiceContent = @"
import { db } from "../firebase";
import { collection, addDoc, getDocs, doc, updateDoc, serverTimestamp } from "firebase/firestore";

// --- METADATA (Classes & Departments) ---

export const addDepartment = async (deptName) => {
  try {
    await addDoc(collection(db, "departments"), {
      name: deptName,
      createdAt: serverTimestamp()
    });
  } catch (error) {
    console.error("Error adding department:", error);
    throw error;
  }
};

export const addClass = async (className) => {
  try {
    await addDoc(collection(db, "classes"), {
      name: className,
      createdAt: serverTimestamp()
    });
  } catch (error) {
    console.error("Error adding class:", error);
    throw error;
  }
};

export const getDepartments = async () => {
  const snapshot = await getDocs(collection(db, "departments"));
  return snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
};

export const getClasses = async () => {
  const snapshot = await getDocs(collection(db, "classes"));
  return snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
};

// --- USER UPDATES ---

export const updateUserProfile = async (uid, updateData) => {
  try {
    const userRef = doc(db, "users", uid);
    await updateDoc(userRef, updateData);
  } catch (error) {
    console.error("Error updating user:", error);
    throw error;
  }
};
"@

$DbServicePath = "src/services/dbService.js"
if (-not (Test-Path "src/services")) { New-Item -Path "src/services" -ItemType Directory -Force | Out-Null }
Set-Content -Path $DbServicePath -Value $DbServiceContent -Encoding UTF8
Write-Host "✅ Created: $DbServicePath"

# 3. CREATE ManageMetadata.jsx (UI for Adding Classes/Depts)
# -------------------------------------------------------------------------
$MetadataContent = @"
import React, { useState } from 'react';
import { addClass, addDepartment } from '../../services/dbService';

const ManageMetadata = ({ onClose, onRefresh }) => {
  const [deptName, setDeptName] = useState('');
  const [className, setClassName] = useState('');
  const [loading, setLoading] = useState(false);

  const handleAddDept = async (e) => {
    e.preventDefault();
    if (!deptName.trim()) return;
    setLoading(true);
    try {
      await addDepartment(deptName);
      setDeptName('');
      alert('Department added!');
      if (onRefresh) onRefresh();
    } catch (error) {
      alert('Error adding department');
    } finally {
      setLoading(false);
    }
  };

  const handleAddClass = async (e) => {
    e.preventDefault();
    if (!className.trim()) return;
    setLoading(true);
    try {
      await addClass(className);
      setClassName('');
      alert('Class added!');
      if (onRefresh) onRefresh();
    } catch (error) {
      alert('Error adding class');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="bg-white p-6 rounded-xl shadow-lg border border-slate-200">
      <div className="flex justify-between items-center mb-4">
        <h3 className="text-xl font-bold text-slate-900">Manage Metadata</h3>
        <button onClick={onClose} className="text-slate-400 hover:text-slate-600">✕</button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Add Department */}
        <form onSubmit={handleAddDept} className="bg-slate-50 p-4 rounded-lg">
          <label className="block text-sm font-bold text-slate-700 mb-2">Add Department</label>
          <div className="flex gap-2">
            <input 
              type="text" 
              value={deptName}
              onChange={(e) => setDeptName(e.target.value)}
              placeholder="e.g. Computer Science"
              className="flex-1 border border-slate-300 rounded px-3 py-2 text-sm"
            />
            <button disabled={loading} className="bg-blue-600 text-white px-3 py-2 rounded text-sm hover:bg-blue-700">Add</button>
          </div>
        </form>

        {/* Add Class */}
        <form onSubmit={handleAddClass} className="bg-slate-50 p-4 rounded-lg">
          <label className="block text-sm font-bold text-slate-700 mb-2">Add Class</label>
          <div className="flex gap-2">
            <input 
              type="text" 
              value={className}
              onChange={(e) => setClassName(e.target.value)}
              placeholder="e.g. CS-A"
              className="flex-1 border border-slate-300 rounded px-3 py-2 text-sm"
            />
            <button disabled={loading} className="bg-blue-600 text-white px-3 py-2 rounded text-sm hover:bg-blue-700">Add</button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default ManageMetadata;
"@

$MetadataPath = "src/components/admin/ManageMetadata.jsx"
Set-Content -Path $MetadataPath -Value $MetadataContent -Encoding UTF8
Write-Host "✅ Created: $MetadataPath"

# 4. UPDATE AddUserForm.jsx (Real Logic + Dropdowns + Edit Mode)
# -------------------------------------------------------------------------
$AddUserFormContent = @"
import React, { useState, useEffect } from 'react';
import { registerUser } from '../../services/authService';
import { getClasses, getDepartments, updateUserProfile } from '../../services/dbService';

const AddUserForm = ({ onClose, initialUser = null }) => {
  const isEditMode = !!initialUser;

  const [formData, setFormData] = useState({
    email: '',
    password: '',
    displayName: '',
    role: 'student',
    department: '',
    classId: ''
  });

  const [departments, setDepartments] = useState([]);
  const [classes, setClasses] = useState([]);
  const [loading, setLoading] = useState(false);

  // Load Metadata (Classes/Depts)
  useEffect(() => {
    const loadMetadata = async () => {
      try {
        const [d, c] = await Promise.all([getDepartments(), getClasses()]);
        setDepartments(d);
        setClasses(c);
      } catch (err) {
        console.error("Failed to load metadata", err);
      }
    };
    loadMetadata();

    // Pre-fill if editing
    if (isEditMode) {
      setFormData({
        email: initialUser.email || '',
        password: '***', // Password cannot be edited directly via Client SDK
        displayName: initialUser.displayName || '',
        role: initialUser.role || 'student',
        department: initialUser.department || '',
        classId: initialUser.classId || ''
      });
    }
  }, [initialUser, isEditMode]);

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    try {
      if (isEditMode) {
        // --- EDIT MODE ---
        // Only update Firestore fields
        const updates = {
          displayName: formData.displayName,
          role: formData.role,
          department: formData.department,
          classId: formData.classId
        };
        
        // Remove empty fields based on role
        if (formData.role !== 'student') delete updates.classId;
        if (formData.role === 'admin') delete updates.department;

        await updateUserProfile(initialUser.id, updates);
        alert('User updated successfully!');
        if (onClose) onClose();
      
      } else {
        // --- CREATE MODE ---
        // Creates Auth User + Firestore Doc
        const confirmMsg = "Creating a new user will sign you out (Firebase Client Limitation). You will need to log in again. Continue?";
        if (!window.confirm(confirmMsg)) {
          setLoading(false);
          return;
        }

        const userData = {
          displayName: formData.displayName,
          role: formData.role,
          department: formData.department,
          classId: formData.classId
        };

        // Clean up data based on role
        if (formData.role !== 'student') delete userData.classId;
        if (formData.role === 'admin') delete userData.department;

        await registerUser(formData.email, formData.password, userData);
        
        // Note: Code below this might not run if the page reloads/redirects on logout
        alert('User created! You are being logged out.');
        if (onClose) onClose();
      }
    } catch (error) {
      console.error('Operation failed:', error);
      alert(error.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="bg-white p-8 rounded-xl shadow-lg border border-slate-200 transition-all">
      <div className="flex justify-between items-center mb-6">
        <h3 className="text-xl font-bold text-slate-900">
          {isEditMode ? 'Edit User' : 'Add New User'}
        </h3>
        <button onClick={onClose} className="text-slate-400 hover:text-slate-600">✕</button>
      </div>

      <form onSubmit={handleSubmit} className="space-y-5">
        
        {/* Email - Read Only in Edit Mode */}
        <div>
          <label className="block text-sm font-semibold text-slate-700 mb-1">Email</label>
          <input
            type="email"
            name="email"
            required
            disabled={isEditMode}
            className={`w-full border rounded-lg px-3 py-2.5 outline-none focus:ring-2 focus:ring-blue-500/20 ${isEditMode ? 'bg-slate-100 text-slate-500' : 'border-slate-300'}`}
            value={formData.email}
            onChange={handleChange}
          />
        </div>

        {/* Password - Hidden in Edit Mode */}
        {!isEditMode && (
          <div>
            <label className="block text-sm font-semibold text-slate-700 mb-1">Password</label>
            <input
              type="password"
              name="password"
              required
              minLength={6}
              className="w-full border border-slate-300 rounded-lg px-3 py-2.5 outline-none focus:ring-2 focus:ring-blue-500/20"
              value={formData.password}
              onChange={handleChange}
            />
          </div>
        )}

        {/* Name */}
        <div>
          <label className="block text-sm font-semibold text-slate-700 mb-1">Full Name</label>
          <input
            type="text"
            name="displayName"
            required
            className="w-full border border-slate-300 rounded-lg px-3 py-2.5 outline-none focus:ring-2 focus:ring-blue-500/20"
            value={formData.displayName}
            onChange={handleChange}
          />
        </div>

        {/* Role */}
        <div>
          <label className="block text-sm font-semibold text-slate-700 mb-1">Role</label>
          <select
            name="role"
            className="w-full border border-slate-300 rounded-lg px-3 py-2.5 bg-white outline-none focus:ring-2 focus:ring-blue-500/20"
            value={formData.role}
            onChange={handleChange}
          >
            <option value="student">Student</option>
            <option value="teacher">Teacher</option>
            <option value="admin">Admin</option>
          </select>
        </div>

        {/* Dynamic Fields (Class / Dept) */}
        {formData.role === 'student' && (
          <div className="bg-blue-50/50 p-4 rounded-lg border border-blue-100/50 space-y-3">
             {/* Class Selection */}
             <div>
              <label className="block text-xs font-bold text-blue-800 uppercase tracking-wide mb-1">Class</label>
              <select
                name="classId"
                className="w-full border border-blue-200 rounded-md px-3 py-2 text-sm outline-none focus:ring-2 focus:ring-blue-500/20"
                value={formData.classId}
                onChange={handleChange}
              >
                <option value="">Select Class</option>
                {classes.map(c => (
                  <option key={c.id} value={c.name}>{c.name}</option>
                ))}
              </select>
            </div>
            {/* Department Selection */}
            <div>
              <label className="block text-xs font-bold text-blue-800 uppercase tracking-wide mb-1">Department</label>
              <select
                name="department"
                className="w-full border border-blue-200 rounded-md px-3 py-2 text-sm outline-none focus:ring-2 focus:ring-blue-500/20"
                value={formData.department}
                onChange={handleChange}
              >
                <option value="">Select Department</option>
                {departments.map(d => (
                  <option key={d.id} value={d.name}>{d.name}</option>
                ))}
              </select>
            </div>
          </div>
        )}

        {formData.role === 'teacher' && (
           <div className="bg-indigo-50/50 p-4 rounded-lg border border-indigo-100/50">
            <label className="block text-xs font-bold text-indigo-800 uppercase tracking-wide mb-1">Department</label>
            <select
                name="department"
                className="w-full border border-indigo-200 rounded-md px-3 py-2 text-sm outline-none focus:ring-2 focus:ring-indigo-500/20"
                value={formData.department}
                onChange={handleChange}
              >
                <option value="">Select Department</option>
                {departments.map(d => (
                  <option key={d.id} value={d.name}>{d.name}</option>
                ))}
              </select>
          </div>
        )}

        <div className="flex gap-3 pt-4">
          <button
            type="submit"
            disabled={loading}
            className="flex-1 bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2.5 rounded-lg shadow-sm transition-all disabled:opacity-50"
          >
            {loading ? 'Processing...' : (isEditMode ? 'Update User' : 'Create User')}
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
Write-Host "✅ Updated: $AddUserFormPath"

# 5. UPDATE UserList.jsx (Wire up Edit Button)
# -------------------------------------------------------------------------
$UserListContent = @"
import React, { useEffect, useState } from 'react';
import { db } from '../../firebase';
import { collection, getDocs, query, where, limit } from 'firebase/firestore';

const UserList = ({ roleFilter, onEditUser }) => {
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
                   {user.classId || user.department ? (
                     <div className="flex flex-col gap-1">
                      {user.classId && <span className="text-xs">Class: {user.classId}</span>}
                      {user.department && <span className="text-xs">Dept: {user.department}</span>}
                     </div>
                   ) : (
                     <span className="text-slate-400 italic">No details</span>
                   )}
                </td>
                <td className="py-4 px-6 text-right text-sm font-medium">
                  <button 
                    onClick={() => onEditUser(user)}
                    className="text-blue-600 hover:text-blue-800 transition-colors"
                  >
                    Edit
                  </button>
                </td>
              </tr>
            ))}
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
Write-Host "✅ Updated: $UserListPath"

# 6. UPDATE AdminDashboard.jsx (Orchestrator)
# -------------------------------------------------------------------------
$AdminDashboardContent = @"
import React, { useState } from 'react';
import UserList from '../../components/admin/UserList';
import AddUserForm from '../../components/admin/AddUserForm';
import ManageMetadata from '../../components/admin/ManageMetadata';

const AdminDashboard = () => {
  const [mainTab, setMainTab] = useState('management');
  const [roleTab, setRoleTab] = useState('student');
  const [showAddUser, setShowAddUser] = useState(false);
  const [showMetadata, setShowMetadata] = useState(false);
  const [editingUser, setEditingUser] = useState(null);

  const handleEditUser = (user) => {
    setEditingUser(user);
    setShowAddUser(true);
  };

  const closeForm = () => {
    setShowAddUser(false);
    setEditingUser(null);
  };

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
             {/* Manage Classes/Departments Button */}
             <button 
               onClick={() => setShowMetadata(!showMetadata)}
               className="bg-white border border-slate-300 text-slate-700 px-4 py-2.5 rounded-lg font-semibold hover:bg-slate-50 transition-all shadow-sm"
             >
               {showMetadata ? 'Close Metadata' : 'Manage Classes & Depts'}
             </button>

             <button 
              onClick={() => { setEditingUser(null); setShowAddUser(!showAddUser); }}
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
          </div>

          {/* Main Panel */}
          <div className="lg:col-span-3">
             
            {/* Metadata Manager */}
            {showMetadata && (
              <div className="mb-8">
                <ManageMetadata onClose={() => setShowMetadata(false)} />
              </div>
            )}

            {/* Add/Edit User Form */}
            {showAddUser && (
              <div className="mb-8">
                <AddUserForm onClose={closeForm} initialUser={editingUser} />
              </div>
            )}

            {mainTab === 'management' ? (
              <div className="space-y-6">
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

                {/* Pass onEditUser to enable editing */}
                <UserList roleFilter={roleTab} onEditUser={handleEditUser} />
              </div>
            ) : (
              <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-12 text-center">
                 <h2 className="text-xl font-bold text-slate-900">System Healthy</h2>
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
Write-Host "✅ Updated: $AdminDashboardPath"

Write-Host "✅ All features integrated successfully."