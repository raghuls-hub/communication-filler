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
              // Logic added for Add User button color toggle
              className={`flex items-center gap-2 px-5 py-2.5 rounded-lg font-semibold shadow-sm transition-all duration-200 ${
                showAddUser 
                ? 'bg-rose-100 text-rose-700 hover:bg-rose-200' 
                : 'bg-indigo-600 text-white hover:bg-indigo-700'
              }`}
            >
              {showAddUser ? 'Close Form' : '+ Add User'}
            </button>
          </div>
        </div>

        {/* Content Container */}
        <div className="grid grid-cols-1 lg:grid-cols-4 gap-8">
          
          {/* Sidebar */}
          <div className="lg:col-span-1 space-y-6">
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
                    // Added conditional classes for Sidebar Tabs
                    className={`w-full text-left px-3 py-2 rounded-lg text-sm font-medium transition-colors ${
                      mainTab === tab 
                      ? 'bg-indigo-50 text-indigo-700' 
                      : 'text-slate-600 hover:bg-slate-100'
                    }`}
                  >
                    {tab === 'management' ? 'User Management' : 'System Health'}
                  </button>
                ))}
              </nav>
            </div>

            {/* Stats */}
            <div className="grid grid-cols-2 lg:grid-cols-1 gap-4">
               <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm">
                  <p className="text-slate-500 text-xs font-semibold uppercase">Total Students</p>
                  <p className="text-2xl font-bold text-slate-900 mt-1">245</p>
               </div>
               <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm">
                  <p className="text-slate-500 text-xs font-semibold uppercase">Total Teachers</p>
                  <p className="text-2xl font-bold text-slate-900 mt-1">12</p>
               </div>
            </div>
          </div>

          {/* Main Panel */}
          <div className="lg:col-span-3">
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
                      // Added conditional logic for Role Tabs
                      className={`px-6 py-2 rounded-md text-sm font-semibold capitalize transition-all duration-200 ${
                        roleTab === role 
                        ? 'bg-white text-indigo-600 shadow-sm' 
                        : 'text-slate-500 hover:text-slate-700'
                      }`}
                    >
                      {role}s
                    </button>
                  ))}
                </div>

                <div className="bg-white rounded-xl shadow-sm border border-slate-200">
                   <UserList roleFilter={roleTab} />
                </div>
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