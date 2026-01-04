Write-Host "Setting up Base Messaging Feature..."

# -------------------------------
# Create folders
# -------------------------------
$folders = @(
  "src/services",
  "src/components/messages"
)

foreach ($folder in $folders) {
  if (!(Test-Path $folder)) {
    New-Item -ItemType Directory -Path $folder | Out-Null
  }
}

# -------------------------------
# messageService.js
# -------------------------------
@'
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
'@ | Set-Content src/services/messageService.js

# -------------------------------
# MessageFeed.jsx
# -------------------------------
@'
export default function MessageFeed({ messages }) {
  return (
    <div>
      <h3>Class Messages</h3>
      {messages.map(msg => (
        <div key={msg.id} style={{ border: "1px solid #ccc", margin: "8px", padding: "8px" }}>
          <strong>{msg.title}</strong>
          <p>{msg.content}</p>
          <small>By {msg.senderRole}</small>
        </div>
      ))}
    </div>
  );
}
'@ | Set-Content src/components/messages/MessageFeed.jsx

# -------------------------------
# MessageComposer.jsx
# -------------------------------
@'
import { useState } from "react";
import { sendClassMessage } from "../../services/messageService";
import { useAuth } from "../../context/AuthContext";

export default function MessageComposer() {
  const { profile } = useAuth();
  const [title, setTitle] = useState("");
  const [content, setContent] = useState("");

  const handleSend = async () => {
    if (!title || !content) return;
    await sendClassMessage(profile.classId, profile, title, content);
    setTitle("");
    setContent("");
  };

  return (
    <div>
      <h4>Create Message</h4>
      <input placeholder="Title" value={title} onChange={e => setTitle(e.target.value)} />
      <textarea placeholder="Message" value={content} onChange={e => setContent(e.target.value)} />
      <button onClick={handleSend}>Send</button>
    </div>
  );
}
'@ | Set-Content src/components/messages/MessageComposer.jsx

# -------------------------------
# Update Teacher Dashboard
# -------------------------------
@'
import { useEffect, useState } from "react";
import { listenToClassMessages } from "../../services/messageService";
import { useAuth } from "../../context/AuthContext";
import MessageFeed from "../../components/messages/MessageFeed";
import MessageComposer from "../../components/messages/MessageComposer";

export default function TeacherDashboard() {
  const { profile } = useAuth();
  const [messages, setMessages] = useState([]);

  useEffect(() => {
    if (!profile?.classId) return;
    return listenToClassMessages(profile.classId, setMessages);
  }, [profile]);

  return (
    <div>
      <h2>Teacher Dashboard</h2>
      <MessageComposer />
      <MessageFeed messages={messages} />
    </div>
  );
}
'@ | Set-Content src/pages/teacher/TeacherDashboard.jsx

# -------------------------------
# Update Student Dashboard
# -------------------------------
@'
import { useEffect, useState } from "react";
import { listenToClassMessages } from "../../services/messageService";
import { useAuth } from "../../context/AuthContext";
import MessageFeed from "../../components/messages/MessageFeed";

export default function StudentDashboard() {
  const { profile } = useAuth();
  const [messages, setMessages] = useState([]);

  useEffect(() => {
    if (!profile?.classId) return;
    return listenToClassMessages(profile.classId, setMessages);
  }, [profile]);

  return (
    <div>
      <h2>Student Dashboard</h2>
      <MessageFeed messages={messages} />
    </div>
  );
}
'@ | Set-Content src/pages/student/StudentDashboard.jsx

Write-Host "Base messaging feature setup complete."
