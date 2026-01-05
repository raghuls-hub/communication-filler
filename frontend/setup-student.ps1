# Fix StudentDashboard.jsx to handle null currentUser safely
$dashboardPath = "src/pages/student/StudentDashboard.jsx"
$dashboardContent = @'
import React, { useState, useEffect, useMemo } from 'react';
import { useAuth } from '../../context/AuthContext';
// Named imports to match your service structure
import { listenToClassMessages, submitPollVote, markAsRead } from '../../services/messageService';
import StudentMessageDetail from '../../components/student/StudentMessageDetail';

const StudentDashboard = () => {
    const { userProfile, currentUser } = useAuth();
    const [messages, setMessages] = useState([]);
    const [selectedMsgId, setSelectedMsgId] = useState(null);
    const [loading, setLoading] = useState(true);

    // 1. Listen to Class Messages
    useEffect(() => {
        if (!userProfile?.classId) return;

        const unsubscribe = listenToClassMessages(userProfile.classId, (fetchedMessages) => {
            setMessages(fetchedMessages);
            setLoading(false);
        });

        return () => unsubscribe();
    }, [userProfile?.classId]);

    // 2. Process Data (Sort & Filter)
    const { allMessages, unreadMessages } = useMemo(() => {
        // DEFENSIVE CHECK: If no user, return empty arrays to prevent crash
        if (!currentUser || !messages) return { allMessages: [], unreadMessages: [] };

        // Reverse array for Newest -> Oldest
        const sorted = [...messages].reverse();

        const unread = sorted.filter(m => {
            // Safely check readBy array
            return !m.readBy || !m.readBy.includes(currentUser.uid);
        });

        return { allMessages: sorted, unreadMessages: unread };
    }, [messages, currentUser]); // Dependency changed to currentUser object

    // 3. Handle Message Selection
    const handleSelectMessage = async (msg) => {
        if (!currentUser) return;
        setSelectedMsgId(msg.id);
        
        // Mark as Read if needed
        if (!msg.readBy || !msg.readBy.includes(currentUser.uid)) {
            try {
                if (typeof markAsRead === 'function') {
                    await markAsRead(msg.id, currentUser.uid);
                }
            } catch (err) {
                console.error("Failed to mark read:", err);
            }
        }
    };

    // 4. Handle Voting
    const handleVote = async (messageId, option) => {
        if (!currentUser) return;
        try {
            await submitPollVote(messageId, currentUser.uid, option);
        } catch (error) {
            console.error("Vote failed:", error);
            alert("Failed to submit status. Please try again.");
        }
    };

    // Loading State: Wait for Auth AND Data
    if (!currentUser || (loading && !messages.length)) {
        return <div className="h-screen flex items-center justify-center bg-gray-50 text-gray-500">Loading Dashboard...</div>;
    }

    if (!userProfile?.classId) {
        return <div className="h-screen flex items-center justify-center text-red-500">No Class Assigned. Contact Admin.</div>;
    }

    const selectedMessage = messages.find(m => m.id === selectedMsgId);

    return (
        <div className="h-screen w-full bg-white flex overflow-hidden font-sans">
            
            {/* PANEL 1: LEFT - UNREAD INBOX */}
            <div className="w-72 border-r border-gray-200 flex flex-col bg-gray-50 flex-shrink-0">
                <div className="p-4 border-b border-gray-200 bg-white">
                    <div className="flex items-center justify-between">
                        <h2 className="font-bold text-gray-800">Inbox</h2>
                        {unreadMessages.length > 0 && (
                            <span className="bg-red-500 text-white text-xs font-bold px-2 py-0.5 rounded-full">
                                {unreadMessages.length} New
                            </span>
                        )}
                    </div>
                </div>
                <div className="flex-1 overflow-y-auto p-2 space-y-2">
                    {unreadMessages.length === 0 ? (
                        <div className="text-center py-10 opacity-50">
                            <span className="text-4xl block mb-2">🎉</span>
                            <p className="text-xs">All caught up!</p>
                        </div>
                    ) : (
                        unreadMessages.map(msg => (
                            <div 
                                key={msg.id}
                                onClick={() => handleSelectMessage(msg)}
                                className={`p-3 rounded-lg border cursor-pointer transition-all hover:shadow-sm ${
                                    selectedMsgId === msg.id 
                                    ? 'bg-white border-blue-500 shadow-sm' 
                                    : 'bg-white border-gray-200 hover:border-blue-300'
                                }`}
                            >
                                <div className="flex justify-between items-center mb-1">
                                    <span className="text-[10px] font-bold uppercase text-blue-600 tracking-wider">{msg.type}</span>
                                    {msg.deadline && <span className="text-[10px] text-red-500 font-medium">Due soon</span>}
                                </div>
                                <h3 className="text-sm font-semibold text-gray-800 line-clamp-2 leading-snug">{msg.title}</h3>
                                <p className="text-xs text-gray-400 mt-2">
                                    {msg.createdAt?.seconds ? new Date(msg.createdAt.seconds * 1000).toLocaleDateString() : 'Just now'}
                                </p>
                            </div>
                        ))
                    )}
                </div>
            </div>

            {/* PANEL 2: MIDDLE - ALL MESSAGES */}
            <div className="w-80 border-r border-gray-200 flex flex-col bg-white flex-shrink-0">
                <div className="p-4 border-b border-gray-200">
                    <h2 className="font-bold text-gray-800">History</h2>
                </div>
                <div className="flex-1 overflow-y-auto">
                    {allMessages.map(msg => {
                        // Safe check for readBy
                        const isRead = msg.readBy && msg.readBy.includes(currentUser.uid);
                        const isSelected = selectedMsgId === msg.id;
                        
                        return (
                            <div 
                                key={msg.id}
                                onClick={() => handleSelectMessage(msg)}
                                className={`px-4 py-3 border-b border-gray-100 cursor-pointer transition-colors ${
                                    isSelected ? 'bg-blue-50' : 'hover:bg-gray-50'
                                }`}
                            >
                                <div className="flex justify-between items-baseline">
                                    <span className={`text-sm truncate pr-2 ${!isRead ? 'font-bold text-gray-900' : 'font-medium text-gray-600'}`}>
                                        {msg.title}
                                    </span>
                                    {!isRead && <span className="w-2 h-2 bg-blue-500 rounded-full flex-shrink-0"></span>}
                                </div>
                                <div className="flex justify-between mt-1">
                                    <span className="text-xs text-gray-400 capitalize">{msg.type?.toLowerCase() || 'message'}</span>
                                    <span className="text-xs text-gray-400">
                                        {msg.createdAt?.seconds ? new Date(msg.createdAt.seconds * 1000).toLocaleDateString() : ''}
                                    </span>
                                </div>
                            </div>
                        );
                    })}
                </div>
            </div>

            {/* PANEL 3: RIGHT - DETAIL VIEW */}
            <div className="flex-1 bg-white h-full overflow-hidden">
                <StudentMessageDetail 
                    message={selectedMessage} 
                    currentUser={currentUser} 
                    onVote={handleVote} 
                />
            </div>

        </div>
    );
};

export default StudentDashboard;
'@

Set-Content -Path $dashboardPath -Value $dashboardContent
Write-Host "✅ Fixed: Added null checks for currentUser in StudentDashboard.jsx" -ForegroundColor Green