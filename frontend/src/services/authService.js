import { 
  createUserWithEmailAndPassword, 
  signInWithEmailAndPassword, 
  signOut 
} from "firebase/auth";
import { doc, setDoc, serverTimestamp } from "firebase/firestore";
import { auth, db } from "../firebase";

/**
 * ADMIN ONLY (Caution: Logs out current user)
 * Creates Firebase Auth user + Firestore profile
 */
export const registerUser = async (email, password, userData) => {
  try {
    const cred = await createUserWithEmailAndPassword(auth, email, password);
    
    // Create the user document in Firestore
    await setDoc(doc(db, "users", cred.user.uid), {
      uid: cred.user.uid,
      email,
      ...userData,
      createdAt: serverTimestamp()
    });

    return cred.user;
  } catch (error) {
    console.error("Register user failed:", error);
    throw error;
  }
};

/**
 * Login (All roles)
 */
export const loginUser = async (email, password) => {
  try {
    const result = await signInWithEmailAndPassword(auth, email, password);
    return result.user;
  } catch (error) {
    console.error("Login failed:", error);
    throw error;
  }
};

/**
 * Logout
 */
export const logoutUser = async () => {
  try {
    await signOut(auth);
  } catch (error) {
    console.error("Logout failed:", error);
    throw error;
  }
};
