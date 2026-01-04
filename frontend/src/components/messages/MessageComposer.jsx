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
