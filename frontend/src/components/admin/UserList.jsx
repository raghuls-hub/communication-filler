import React, { useEffect, useState } from 'react';
import { db } from '../../firebase';
import { collection, getDocs, query, limit } from 'firebase/firestore';

const UserList = () => {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        // Safe Read-Only Operation
        const q = query(collection(db, 'users'), limit(50));
        const querySnapshot = await getDocs(q);
        const userList = querySnapshot.docs.map(doc => ({
          id: doc.id,
          ...doc.data()
        }));
        setUsers(userList);
      } catch (err) {
        console.error("Error fetching users:", err);
        setError("Failed to load users. Ensure Firestore permissions allow admin access.");
      } finally {
        setLoading(false);
      }
    };

    fetchUsers();
  }, []);

  if (loading) return <div className="p-4">Loading users...</div>;
  if (error) return <div className="p-4 text-red-600">{error}</div>;

  return (
    <div className="overflow-x-auto">
      <table className="min-w-full bg-white border border-gray-300">
        <thead className="bg-gray-50">
          <tr>
            <th className="py-2 px-4 border-b text-left">Name</th>
            <th className="py-2 px-4 border-b text-left">Email</th>
            <th className="py-2 px-4 border-b text-left">Role</th>
            <th className="py-2 px-4 border-b text-left">Details</th>
          </tr>
        </thead>
        <tbody>
          {users.map(user => (
            <tr key={user.id} className="hover:bg-gray-50">
              <td className="py-2 px-4 border-b">{user.name || 'N/A'}</td>
              <td className="py-2 px-4 border-b">{user.email}</td>
              <td className="py-2 px-4 border-b">
                <span className={`px-2 py-1 rounded text-xs ${
                  user.role === 'admin' ? 'bg-purple-100 text-purple-800' :
                  user.role === 'teacher' ? 'bg-blue-100 text-blue-800' :
                  'bg-green-100 text-green-800'
                }`}>
                  {user.role}
                </span>
              </td>
              <td className="py-2 px-4 border-b text-sm text-gray-500">
                {user.role !== 'admin' && user.classId && `Class: ${user.classId} `}
                {user.department && `Dept: ${user.departmentId}`}
              </td>
            </tr>
          ))}
          {users.length === 0 && (
            <tr>
              <td colSpan="4" className="py-4 text-center text-gray-500">
                No users found in 'users' collection.
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
};

export default UserList;