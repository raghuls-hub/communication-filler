import React, { useState, useEffect } from 'react';
import { addClass, addDepartment, getDepartments } from '../../services/dbService';

const ManageMetadata = ({ onClose, onRefresh }) => {
  const [deptName, setDeptName] = useState('');
  const [className, setClassName] = useState('');
  const [selectedDeptForClass, setSelectedDeptForClass] = useState('');
  
  const [departments, setDepartments] = useState([]);
  const [loading, setLoading] = useState(false);

  // Fetch departments on load to populate the dropdown
  const fetchDepartments = async () => {
    try {
      const data = await getDepartments();
      setDepartments(data);
    } catch (error) {
      console.error("Error fetching departments:", error);
    }
  };

  useEffect(() => {
    fetchDepartments();
  }, []);

  const handleAddDept = async (e) => {
    e.preventDefault();
    if (!deptName.trim()) return;
    setLoading(true);
    try {
      await addDepartment(deptName);
      setDeptName('');
      alert('Department added!');
      fetchDepartments(); // Refresh list for the dropdown
      if (onRefresh) onRefresh();
    } catch (error) {
      alert('Error adding department: ' + error.message);
    } finally {
      setLoading(false);
    }
  };

  const handleAddClass = async (e) => {
    e.preventDefault();
    if (!className.trim() || !selectedDeptForClass) {
      alert("Please enter a class name and select a department.");
      return;
    }
    setLoading(true);
    try {
      await addClass(className, selectedDeptForClass);
      setClassName('');
      setSelectedDeptForClass('');
      alert('Class added and linked to ' + selectedDeptForClass);
      if (onRefresh) onRefresh();
    } catch (error) {
      alert('Error adding class: ' + error.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="bg-white p-6 rounded-xl shadow-lg border border-slate-200">
      <div className="flex justify-between items-center mb-6">
        <h3 className="text-xl font-bold text-slate-900">Manage Structure</h3>
        <button onClick={onClose} className="text-slate-400 hover:text-slate-600 font-bold px-2">âœ•</button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
        
        {/* 1. Add Department */}
        <div className="bg-indigo-50/50 p-5 rounded-xl border border-indigo-100">
          <h4 className="font-bold text-indigo-900 mb-3 text-sm uppercase tracking-wide">1. Create Department</h4>
          <form onSubmit={handleAddDept} className="space-y-3">
            <div>
              <input 
                type="text" 
                value={deptName}
                onChange={(e) => setDeptName(e.target.value)}
                placeholder="e.g. Computer Science"
                className="w-full border border-indigo-200 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-indigo-500/20 outline-none"
              />
            </div>
            <button 
              disabled={loading} 
              className="w-full bg-indigo-600 text-white px-3 py-2 rounded-lg text-sm font-semibold hover:bg-indigo-700 transition disabled:opacity-50"
            >
              Add Department
            </button>
          </form>
        </div>

        {/* 2. Add Class */}
        <div className="bg-blue-50/50 p-5 rounded-xl border border-blue-100">
          <h4 className="font-bold text-blue-900 mb-3 text-sm uppercase tracking-wide">2. Create Class</h4>
          <form onSubmit={handleAddClass} className="space-y-3">
            {/* Class Name */}
            <div>
              <label className="block text-xs font-semibold text-blue-800 mb-1">Class Name</label>
              <input 
                type="text" 
                value={className}
                onChange={(e) => setClassName(e.target.value)}
                placeholder="e.g. CS-2024-A"
                className="w-full border border-blue-200 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500/20 outline-none"
              />
            </div>

            {/* Department Mapping Dropdown */}
            <div>
              <label className="block text-xs font-semibold text-blue-800 mb-1">Map to Department</label>
              <select
                value={selectedDeptForClass}
                onChange={(e) => setSelectedDeptForClass(e.target.value)}
                className="w-full border border-blue-200 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500/20 outline-none bg-white"
              >
                <option value="">-- Select Department --</option>
                {departments.map(d => (
                  <option key={d.id} value={d.name}>{d.name}</option>
                ))}
              </select>
            </div>

            <button 
              disabled={loading} 
              className="w-full bg-blue-600 text-white px-3 py-2 rounded-lg text-sm font-semibold hover:bg-blue-700 transition disabled:opacity-50"
            >
              Add Class
            </button>
          </form>
        </div>

      </div>
    </div>
  );
};

export default ManageMetadata;
