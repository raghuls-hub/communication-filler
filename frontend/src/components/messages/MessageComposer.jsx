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
    <div className="bg-white p-4 rounded shadow mb-4">
      <input
        className="border p-2 w-full mb-2 rounded"
        placeholder="Title"
        value={title}
        onChange={e => setTitle(e.target.value)}
      />
      <textarea
        className="border p-2 w-full mb-2 rounded"
        placeholder="Message"
        value={content}
        onChange={e => setContent(e.target.value)}
      />
      <button
        onClick={handleSend}
        className="bg-green-600 text-white px-4 py-2 rounded"
      >
        Send
      </button>
    </div>
  );
}
