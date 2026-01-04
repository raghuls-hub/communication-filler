import { useEffect, useState } from "react";
import { listenToClassMessages } from "../../services/messageService";
import { useAuth } from "../../context/AuthContext";
import MessageFeed from "../../components/messages/MessageFeed";
import LogoutButton from "../../components/LogoutButton";

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
      <LogoutButton/>
    </div>
  );
}
