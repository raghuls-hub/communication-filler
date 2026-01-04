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
