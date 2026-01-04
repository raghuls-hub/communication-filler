export default function TeacherInbox({ conversations, onSelect, activeId }) {
  return (
    <div className="w-1/4 border-r overflow-y-auto">
      <h3 className="p-3 font-semibold">Inbox</h3>
      {conversations.map(c => (
        <div
          key={c.id}
          onClick={() => onSelect(c)}
          className={`p-3 cursor-pointer ${
            activeId === c.id ? "bg-slate-200" : "hover:bg-slate-100"
          }`}
        >
          <p className="font-medium">{c.title}</p>
          <p className="text-xs text-gray-500 truncate">{c.lastMessage}</p>
        </div>
      ))}
    </div>
  );
}
