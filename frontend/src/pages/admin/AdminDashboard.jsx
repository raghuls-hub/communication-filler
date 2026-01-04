import React, { useState } from "react";
import UserList from "../../components/admin/UserList";
import AddUserForm from "../../components/admin/AddUserForm";
import ManageMetadata from "../../components/admin/ManageMetadata";
import LogoutButton from "../../components/LogoutButton";

const AdminDashboard = () => {
  const [mainTab, setMainTab] = useState("management");
  const [roleTab, setRoleTab] = useState("student");
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
          <div className="flex justify-between items-center mb-6 ">
            <span>
              <div>
                <h1 className="text-3xl font-extrabold text-slate-900 tracking-tight">
                  Admin Portal
                </h1>
                <p className="text-slate-500 mt-2 text-sm font-medium">
                  Overview of system users and performance.
                </p>
              </div>
            </span>
            <span>
              <LogoutButton />
            </span>
          </div>

          <div className="flex gap-4">
            {/* Manage Classes/Departments Button */}
            <button
              onClick={() => setShowMetadata(!showMetadata)}
              className="bg-white border border-slate-300 text-slate-700 px-4 py-2.5 rounded-lg font-semibold hover:bg-slate-50 transition-all shadow-sm"
            >
              {showMetadata ? "Close Metadata" : "Manage Classes & Depts"}
            </button>

            <button
              onClick={() => {
                setEditingUser(null);
                setShowAddUser(!showAddUser);
              }}
              className="flex items-center gap-2 px-5 py-2.5 rounded-lg font-semibold shadow-sm transition-all duration-200"
            >
              {showAddUser ? "Close Form" : "+ Add User"}
            </button>
          </div>
        </div>

        {/* Content Container */}
        <div className="grid grid-cols-1 lg:grid-cols-4 gap-8">
          {/* Sidebar / Tabs */}
          <div className="lg:col-span-1 space-y-6">
            <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-4">
              <h3 className="text-xs font-bold text-slate-400 uppercase tracking-wider mb-3 px-2">
                Menu
              </h3>
              <nav className="space-y-1">
                {["management", "health"].map((tab) => (
                  <button
                    key={tab}
                    onClick={() => setMainTab(tab)}
                    className="w-full text-left px-3 py-2 rounded-lg text-sm font-medium transition-colors"
                  >
                    {tab === "management" ? "User Management" : "System Health"}
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

            {mainTab === "management" ? (
              <div className="space-y-6">
                <div className="flex p-1 bg-slate-200/50 rounded-lg w-fit">
                  {["student", "teacher", "admin"].map((role) => (
                    <button
                      key={role}
                      onClick={() => setRoleTab(role)}
                      className="px-6 py-2 rounded-md text-sm font-semibold capitalize transition-all duration-200"
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
                <h2 className="text-xl font-bold text-slate-900">
                  System Healthy
                </h2>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default AdminDashboard;
