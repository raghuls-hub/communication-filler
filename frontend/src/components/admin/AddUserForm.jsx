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
          âœ•
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
