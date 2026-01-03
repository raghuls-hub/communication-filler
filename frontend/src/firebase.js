import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";

const firebaseConfig = {
  apiKey: "AIzaSyAUmLBAq2WcMV_6GIyFG5yBrm7-mf5IBGA",
  authDomain: "college-communication-pl-196c7.firebaseapp.com",
  projectId: "college-communication-pl-196c7",
  appId: "1:44347564734:web:d9ed6c411f4ff97b3ef4ef"
};

const app = initializeApp(firebaseConfig);

export const auth = getAuth(app);
export const db = getFirestore(app);
