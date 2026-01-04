export default function ClassSelector({
  classes,
  students,
  onSelectStudent,
  onSelectClass
}) {
  return (
    <div className="w-1/4 border-r p-3">
      <select
        className="w-full border p-2 mb-3 rounded"
        onChange={e => onSelectClass(e.target.value)}
      >
        <option value="">Select Class</option>
        {classes.map(c => (
          <option key={c.id} value={c.id}>{c.name}</option>
        ))}
      </select>

      <button
        className="w-full bg-blue-600 text-white py-2 rounded mb-3"
        onClick={() => onSelectClass("ALL")}
      >
        Message Entire Class
      </button>

      <div className="space-y-2">
        {students.map(s => (
          <div
            key={s.uid}
            className="flex justify-between items-center bg-slate-50 p-2 rounded"
          >
            <span>{s.displayName}</span>
            <button
              onClick={() => onSelectStudent(s)}
              className="text-blue-600 text-sm"
            >
              Message
            </button>
          </div>
        ))}
      </div>
    </div>
  );
}
