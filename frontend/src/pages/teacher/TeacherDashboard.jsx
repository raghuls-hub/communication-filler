import { useEffect, useState } from "react";
import { listenToClassMessages } from "../../services/messageService";
import { useAuth } from "../../context/AuthContext";
import MessageFeed from "../../components/messages/MessageFeed";
import MessageComposer from "../../components/messages/MessageComposer";
import LogoutButton from "../../components/LogoutButton";

export default function TeacherDashboard() {
  const { profile } = useAuth();
  const [messages, setMessages] = useState([]);

  useEffect(() => {
    if (!profile?.classId) return;
    return listenToClassMessages(profile.classId, setMessages);
  }, [profile]);

  return (
    <div>
      <h2>Teacher Dashboard</h2>
      <LogoutButton/>
      <MessageComposer />
      <MessageFeed messages={messages} />
    </div>
  );
}
