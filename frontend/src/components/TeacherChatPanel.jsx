import MessageFeed from "./messages/MessageFeed";
import MessageComposer from "./messages/MessageComposer";

export default function TeacherChatPanel({ target, messages }) {
  if (!target) {
    return (
      <div className="flex-1 flex items-center justify-center text-gray-400">
        Select a conversation to start chatting
      </div>
    );
  }

  return (
    <div className="flex-1 flex flex-col">
      <div className="flex-1 overflow-y-auto p-4">
        <MessageFeed messages={messages} />
      </div>

      <div className="border-t p-3">
        <MessageComposer target={target} />
      </div>
    </div>
  );
}
