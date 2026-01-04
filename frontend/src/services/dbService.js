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
