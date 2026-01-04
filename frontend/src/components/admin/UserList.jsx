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
                  <span className="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium border capitalize
                    ">
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
