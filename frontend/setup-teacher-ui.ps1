Write-Host "Integrating 4 Message Types into Messaging Panel..." -ForegroundColor Cyan

# --------------------------------------------------
# Replace MessageComposer.jsx with Type-aware Composer
# --------------------------------------------------
@'
import { useState } from "react";
import { createMessage } from "../../services/messageService";
import { useAuth } from "../../context/AuthContext";

const MESSAGE_TYPES = ["task", "event", "material", "form"];

export default function MessageComposer({ target }) {
  const { profile } = useAuth();

  const [type, setType] = useState("material");
  const [title, setTitle] = useState("");
  const [content, setContent] = useState("");
  const [link, setLink] = useState("");
  const [deadline, setDeadline] = useState("");

  const handleSend = async () => {
    if (!title || !content || !target) return;

    const payload = {
      scope: target.type === "dm" ? "dm" : "class",
      scopeId: target.type === "dm" ? target.id : profile.classId,

      messageType: type,
      title,
      content,

      senderId: profile.uid,
      senderRole: profile.role,

      createdAt: new Date()
    };

    if (type === "task" || type === "form") {
      payload.deadline = deadline ? new Date(deadline) : null;
      payload.pollEnabled = true;
      payload.pollResults = {};
    }

    if (type === "event") {
      payload.eventDeadline = deadline ? new Date(deadline) : null;
    }

    if (type === "material" || type === "form") {
      payload.link = link;
    }

    await createMessage(payload);

    setTitle("");
    setContent("");
    setLink("");
    setDeadline("");
  };

  return (
    <div className="bg-white p-3 rounded shadow">
      {/* Message Type Switcher */}
      <div className="flex gap-2 mb-3">
        {MESSAGE_TYPES.map(t => (
          <button
            key={t}
            onClick={() => setType(t)}
            className={`px-3 py-1 rounded text-sm ${
              type === t ? "bg-blue-600 text-white" : "bg-gray-200"
            }`}
          >
            {t.toUpperCase()}
          </button>
        ))}
      </div>

      <input
        className="border p-2 w-full mb-2 rounded"
        placeholder="Title"
        value={title}
        onChange={e => setTitle(e.target.value)}
      />

      <textarea
        className="border p-2 w-full mb-2 rounded"
        placeholder={
          type === "task"
            ? "Mission details"
            : type === "event"
            ? "Event details"
            : type === "form"
            ? "Form description"
            : "Material description"
        }
        value={content}
        onChange={e => setContent(e.target.value)}
      />

      {(type === "material" || type === "form") && (
        <input
          className="border p-2 w-full mb-2 rounded"
          placeholder="Link (Material / Form)"
          value={link}
          onChange={e => setLink(e.target.value)}
        />
      )}

      {(type === "task" || type === "event" || type === "form") && (
        <input
          type="datetime-local"
          className="border p-2 w-full mb-3 rounded"
          value={deadline}
          onChange={e => setDeadline(e.target.value)}
        />
      )}

      <button
        onClick={handleSend}
        className="bg-green-600 text-white px-4 py-2 rounded w-full"
      >
        Send
      </button>
    </div>
  );
}
'@ | Set-Content src/components/messages/MessageComposer.jsx

Write-Host "MessageComposer updated with Task / Event / Material / Form support." -ForegroundColor Green
Write-Host "Integration completed successfully."
