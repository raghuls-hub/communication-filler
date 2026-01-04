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
            className={`pb-4 px-1 border-b-2 font-medium text-sm ${
              activeTab === 'users'
                ? 'border-indigo-500 text-indigo-600'
                : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
            }`}
          >
            User Management
          </button>
          <button
            onClick={() => setActiveTab('system')}
            className={`pb-4 px-1 border-b-2 font-medium text-sm ${
              activeTab === 'system'
                ? 'border-indigo-500 text-indigo-600'
                : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
            }`}
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