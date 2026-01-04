import {
  collection,
  addDoc,
  query,
  where,
  orderBy,
  onSnapshot,
  serverTimestamp,
  updateDoc,
  doc,
  getDocs
} from "firebase/firestore";
import { db } from "../firebase";

/* =====================================================
   LISTENERS
   ===================================================== */

/**
 * Listen to CLASS messages
 */
export const listenToClassMessages = (classId, callback) => {
  const q = query(
    collection(db, "messages"),
    where("scope", "==", "class"),
    where("scopeId", "==", classId),
    orderBy("createdAt", "asc") // WhatsApp style (old → new)
  );

  return onSnapshot(q, (snapshot) => {
    const messages = snapshot.docs.map(d => ({
      id: d.id,
      ...d.data()
    }));
    callback(messages);
  });
};

/**
 * Listen to DM messages between teacher & student
 */
export const listenToDMMessages = (uid1, uid2, callback) => {
  const conversationId = [uid1, uid2].sort().join("_");

  const q = query(
    collection(db, "messages"),
    where("scope", "==", "dm"),
    where("conversationId", "==", conversationId),
    orderBy("createdAt", "asc")
  );

  return onSnapshot(q, snap => {
    const messages = snap.docs.map(d => ({
      id: d.id,
      ...d.data()
    }));
    callback(messages);
  });
};


/* =====================================================
   MESSAGE CREATION (ALL TYPES)
   ===================================================== */

/**
 * Generic message creator
 * Used for class + DM, all message types
 */
export const createMessage = async (payload) => {
  await addDoc(collection(db, "messages"), {
    ...payload,
    createdAt: serverTimestamp()
  });
};

/**
 * Backward compatibility (OPTIONAL)
 * You may remove this later
 */
export const sendClassMessage = async (classId, user, title, content) => {
  await addDoc(collection(db, "messages"), {
    scope: "class",
    scopeId: classId,
    messageType: "material",
    title,
    content,
    senderId: user.uid,
    senderRole: user.role,
    pollEnabled: false,
    createdAt: serverTimestamp()
  });
};

/* =====================================================
   POLLS (TASK / FORM)
   ===================================================== */

/**
 * Submit poll vote (Finished / Not Finished)
 */
export const submitPollVote = async (messageId, userUid, value) => {
  const ref = doc(db, "messages", messageId);
  await updateDoc(ref, {
    [`pollResults.${userUid}`]: value
  });
};

/* =====================================================
   REPLIES
   ===================================================== */

/**
 * Send reply to a message
 * replyType: "normal" | "poll" | "request"
 */
export const sendReply = async (messageId, reply) => {
  await addDoc(
    collection(db, "messages", messageId, "replies"),
    {
      ...reply,
      createdAt: serverTimestamp()
    }
  );
};

/**
 * Listen to replies of a message
 */
export const listenToReplies = (messageId, callback) => {
  const q = query(
    collection(db, "messages", messageId, "replies"),
    orderBy("createdAt", "asc")
  );

  return onSnapshot(q, (snapshot) => {
    const replies = snapshot.docs.map(d => ({
      id: d.id,
      ...d.data()
    }));
    callback(replies);
  });
};

/* =====================================================
   ADMIN / DEBUG (OPTIONAL)
   ===================================================== */

/**
 * Get all messages (admin / debug)
 */
export const getAllMessages = async () => {
  const q = query(collection(db, "messages"), orderBy("createdAt", "desc"));
  const snap = await getDocs(q);
  return snap.docs.map(d => ({ id: d.id, ...d.data() }));
};
