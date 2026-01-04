import { createContext, useContext, useEffect, useState } from "react";
import { onAuthStateChanged } from "firebase/auth";
import { auth, db } from "../firebase";
import { doc, getDoc } from "firebase/firestore";

const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [profile, setProfile] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const unsub = onAuthStateChanged(auth, async (u) => {
      try {
        if (u) {
          const ref = doc(db, "users", u.uid);
          const snap = await getDoc(ref);

          if (!snap.exists()) {
            console.error("Firestore user profile not found for UID:", u.uid);
            setUser(u);
            setProfile(null);
          } else {
            setUser(u);
            setProfile(snap.data());
          }
        } else {
          setUser(null);
          setProfile(null);
        }
      } catch (err) {
        console.error("AuthContext error:", err);
        setUser(null);
        setProfile(null);
      } finally {
        setLoading(false);
      }
    });

    return () => unsub();
  }, []);

  // 🔴 VERY IMPORTANT: block app if profile missing
  if (loading) {
    return <div>Loading...</div>;
  }

  if (user && !profile) {
    return (
      <div style={{ padding: "20px", color: "red" }}>
        User profile not found in Firestore.
        <br />
        Please contact administrator.
      </div>
    );
  }

  return (
    <AuthContext.Provider value={{ user, profile, loading }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => useContext(AuthContext);
