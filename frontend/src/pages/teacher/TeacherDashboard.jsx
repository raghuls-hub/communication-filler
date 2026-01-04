import { useEffect, useState } from "react";
import { useAuth } from "../../context/AuthContext";
import LogoutButton from "../../components/LogoutButton";
import TeacherInbox from "../../components/TeacherInbox";
import ClassSelector from "../../components/ClassSelector";
import TeacherChatPanel from "../../components/TeacherChatPanel";
import { listenToClassMessages } from "../../services/messageService";
import { collection, getDocs, query, where } from "firebase/firestore";
import { db } from "../../firebase";

export default function TeacherDashboard() {
  const { profile } = useAuth();

  const [classes, setClasses] = useState([]);
  const [students, setStudents] = useState([]);
  const [conversations, setConversations] = useState([]);
  const [activeChat, setActiveChat] = useState(null);
  const [messages, setMessages] = useState([]);

  useEffect(() => {
    const loadClasses = async () => {
      const q = query(
        collection(db, "classes"),
        where("classTeacherId", "==", profile.uid)
      );
      const snap = await getDocs(q);
      setClasses(snap.docs.map(d => ({ id: d.id, ...d.data() })));
    };
    loadClasses();
  }, [profile]);

  const loadStudents = async (classId) => {
    const q = query(
      collection(db, "users"),
      where("role", "==", "student"),
      where("classId", "==", classId)
    );
    const snap = await getDocs(q);
    setStudents(snap.docs.map(d => d.data()));
  };

  const selectClass = (classId) => {
    loadStudents(classId);
    setActiveChat({ type: "class", id: classId });
    listenToClassMessages(classId, setMessages);
  };

  const selectStudent = (student) => {
    setActiveChat({ type: "dm", id: student.uid });
  };

  return (
    <div className="flex h-screen">
      <TeacherInbox
        conversations={conversations}
        activeId={activeChat?.id}
        onSelect={setActiveChat}
      />

      <ClassSelector
        classes={classes}
        students={students}
        onSelectClass={selectClass}
        onSelectStudent={selectStudent}
      />

      <TeacherChatPanel
        target={activeChat}
        messages={messages}
      />

      <div className="absolute top-4 right-4">
        <LogoutButton />
      </div>
    </div>
  );
}
