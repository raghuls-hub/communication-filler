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
