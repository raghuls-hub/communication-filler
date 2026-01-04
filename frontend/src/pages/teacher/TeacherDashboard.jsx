import LogoutButton from "../../components/LogoutButton";
import MessageComposer from "../../components/messages/MessageComposer"
import MessageFeed from "../../components/messages/MessageFeed"
export default function Dashboard() {
  return (
    <div className="min-h-screen bg-gray-100 p-6">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold">Dashboard</h1>
        <LogoutButton />
      </div>
      <div>
        <MessageComposer/>
        {/* <MessageFeed/> */}
      </div>
    </div>
  );
}
