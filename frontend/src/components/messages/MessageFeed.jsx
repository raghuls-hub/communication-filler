export default function MessageFeed({ messages }) {
  return (
    <div className="space-y-3">
      {messages.map(msg => (
        <div key={msg.id} className="bg-white p-4 rounded shadow">
          <h4 className="font-semibold">{msg.title}</h4>
          <p className="text-gray-700">{msg.content}</p>
          <span className="text-xs text-gray-500">By {msg.senderRole}</span>
        </div>
      ))}
    </div>
  );
}
