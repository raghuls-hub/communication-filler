# -------------------------------------------------------------------------
# UPDATE: MAP CLASS TO DEPARTMENT
# -------------------------------------------------------------------------
# ✅ Update dbService.js: addClass() now links to Department
# ✅ Update ManageMetadata.jsx: Add Department selection dropdown
# -------------------------------------------------------------------------

Write-Host "Integrating Class-Department Mapping..."

# 1. UPDATE dbService.js
# -------------------------------------------------------------------------
$DbServiceContent = @"
import { db } from "../firebase";
import { 
  collection, 
  addDoc, 
  getDocs, 
  doc, 
  updateDoc, 
  serverTimestamp, 
  arrayUnion,
  query,
  where
} from "firebase/firestore";

// --- METADATA (Classes & Departments) ---

export const addDepartment = async (deptName) => {
  try {
    await addDoc(collection(db, "departments"), {
      name: deptName,
      classIds: [],   // Array of Class IDs belonging to this dept
      teacherIds: [], // Array of Teacher UIDs
      createdAt: serverTimestamp()
    });
  } catch (error) {
    console.error("Error adding department:", error);
    throw error;
  }
};

/**
 * Creates a Class and maps it to a Department
 */
export const addClass = async (className, departmentName) => {
  if (!className || !departmentName) throw new Error("Class name and Department are required.");

  try {
    // 1. Create the Class Document
    const classRef = await addDoc(collection(db, "classes"), {
      name: className,
      department: departmentName, // Link to Dept
      studentIds: [],             
      classTeacherId: "",         
      createdAt: serverTimestamp()
    });

    // 2. Add this Class ID to the Department's 'classIds' array
    const deptRef = collection(db, "departments");
    const q = query(deptRef, where("name", "==", departmentName));
    const querySnapshot = await getDocs(q);

    if (!querySnapshot.empty) {
      const deptDoc = querySnapshot.docs[0];
      await updateDoc(doc(db, "departments", deptDoc.id), {
        classIds: arrayUnion(classRef.id) // Add Class ID to Dept
      });
    }

    return classRef.id;
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

// --- RELATIONSHIP UPDATES ---

export const assignStudentToClass = async (className, studentUid) => {
  if (!className || !studentUid) return;
  try {
    const classesRef = collection(db, "classes");
    const q = query(classesRef, where("name", "==", className));
    const querySnapshot = await getDocs(q);

    if (!querySnapshot.empty) {
      const classDoc = querySnapshot.docs[0];
      await updateDoc(doc(db, "classes", classDoc.id), {
        studentIds: arrayUnion(studentUid)
      });
    }
  } catch (error) {
    console.error("Error assigning student to class:", error);
  }
};

export const assignTeacherToDepartment = async (deptName, teacherUid) => {
  if (!deptName || !teacherUid) return;
  try {
    const deptRef = collection(db, "departments");
    const q = query(deptRef, where("name", "==", deptName));
    const querySnapshot = await getDocs(q);

    if (!querySnapshot.empty) {
      const deptDoc = querySnapshot.docs[0];
      await updateDoc(doc(db, "departments", deptDoc.id), {
        teacherIds: arrayUnion(teacherUid)
      });
    }
  } catch (error) {
    console.error("Error assigning teacher to department:", error);
  }
};

export const assignClassTeacher = async (className, teacherUid) => {
  if (!className || !teacherUid) return;
  try {
    const classesRef = collection(db, "classes");
    const q = query(classesRef, where("name", "==", className));
    const querySnapshot = await getDocs(q);

    if (!querySnapshot.empty) {
      const classDoc = querySnapshot.docs[0];
      await updateDoc(doc(db, "classes", classDoc.id), {
        classTeacherId: teacherUid
      });
    }
  } catch (error) {
    console.error("Error assigning class teacher:", error);
  }
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
Set-Content -Path $DbServicePath -Value $DbServiceContent -Encoding UTF8
Write-Host "✅ Updated: $DbServicePath"


# 2. UPDATE ManageMetadata.jsx (Add Dept Dropdown)
# -------------------------------------------------------------------------
$MetadataContent = @"
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
        <button onClick={onClose} className="text-slate-400 hover:text-slate-600 font-bold px-2">✕</button>
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
"@

$MetadataPath = "src/components/admin/ManageMetadata.jsx"
Set-Content -Path $MetadataPath -Value $MetadataContent -Encoding UTF8
Write-Host "✅ Updated: $MetadataPath"

Write-Host "✅ Class mapping integration complete."