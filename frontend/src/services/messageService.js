import { collection, addDoc, query, where, orderBy, onSnapshot, serverTimestamp } from "firebase/firestore";
import { db } from "../firebase";

export const listenToClassMessages = (classId, callback) => {
  const q = query(
    collection(db, "messages"),
    where("scope", "==", "class"),
    where("scopeId", "==", classId),
    orderBy("createdAt", "desc")
  );

  return onSnapshot(q, (snapshot) => {
    const messages = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data()
    }));
    callback(messages);
  });
};

export const sendClassMessage = async (classId, user, title, content) => {
  await addDoc(collection(db, "messages"), {
    scope: "class",
    scopeId: classId,
    senderId: user.uid,
    senderRole: user.role,
    title,
    content,
    createdAt: serverTimestamp()
  });
};
