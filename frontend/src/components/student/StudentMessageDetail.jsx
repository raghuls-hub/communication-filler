import React from 'react';

// Simple Emoji Icons to avoid external dependency issues
const ICONS = {
    task: '📝',
    event: '📅',
    material: '📚',
    form: '📋',
    TASK: '📝',
    EVENT: '📅',
    MATERIAL: '📚',
    FORM: '📋'
};

const StudentMessageDetail = ({ message, currentUser, onVote }) => {
    if (!message) return (
        <div className="h-full flex flex-col items-center justify-center text-gray-400 bg-gray-50">
            <p>Select a message to view details</p>
        </div>
    );

    // Normalize type to uppercase for consistency
    const msgType = message.type ? message.type.toUpperCase() : 'TASK';
    const isPoll = msgType === 'TASK' || msgType === 'FORM';
    
    // Check if user has voted using "pollResults" (matches your messageService)
    const userVote = message.pollResults ? message.pollResults[currentUser.uid] : null;
    const hasVoted = !!userVote;

    const handleVote = (option) => {
        if (hasVoted) return;
        onVote(message.id, option);
    };

    const renderPollButtons = () => {
        if (!isPoll) return null;
        
        const yesLabel = msgType === 'TASK' ? 'Finished' : 'Filled';
        const noLabel = msgType === 'TASK' ? 'Not Finished' : 'Not Filled';

        return (
            <div className="mt-8 pt-6 border-t border-gray-100">
                <h4 className="text-xs font-bold text-gray-500 uppercase tracking-wider mb-4">
                    Your Status
                </h4>
                <div className="flex gap-4">
                    <button
                        onClick={() => handleVote('yes')}
                        disabled={hasVoted}
                        className={`flex-1 py-3 px-4 rounded-xl font-semibold transition-all shadow-sm ${
                            userVote === 'yes'
                            ? 'bg-green-600 text-white shadow-green-200 ring-2 ring-green-600 ring-offset-2'
                            : hasVoted
                            ? 'bg-gray-100 text-gray-400 cursor-not-allowed'
                            : 'bg-white border border-gray-200 text-gray-700 hover:bg-green-50 hover:text-green-700 hover:border-green-200'
                        }`}
                    >
                        {userVote === 'yes' && '✓ '}{yesLabel}
                    </button>
                    <button
                        onClick={() => handleVote('no')}
                        disabled={hasVoted}
                        className={`flex-1 py-3 px-4 rounded-xl font-semibold transition-all shadow-sm ${
                            userVote === 'no'
                            ? 'bg-red-600 text-white shadow-red-200 ring-2 ring-red-600 ring-offset-2'
                            : hasVoted
                            ? 'bg-gray-100 text-gray-400 cursor-not-allowed'
                            : 'bg-white border border-gray-200 text-gray-700 hover:bg-red-50 hover:text-red-700 hover:border-red-200'
                        }`}
                    >
                         {userVote === 'no' && '✓ '}{noLabel}
                    </button>
                </div>
            </div>
        );
    };

    return (
        <div className="h-full flex flex-col bg-white overflow-y-auto">
            {/* Header */}
            <div className="px-8 py-6 border-b border-gray-100">
                <div className="flex justify-between items-start mb-4">
                    <span className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md text-xs font-bold uppercase tracking-wide
                        ${msgType === 'TASK' ? 'bg-blue-50 text-blue-700' : 
                          msgType === 'EVENT' ? 'bg-purple-50 text-purple-700' :
                          msgType === 'MATERIAL' ? 'bg-orange-50 text-orange-700' : 
                          'bg-teal-50 text-teal-700'}`}>
                        {ICONS[msgType] || '📝'} {msgType}
                    </span>
                    <span className="text-xs font-medium text-gray-400">
                        {message.createdAt?.seconds 
                            ? new Date(message.createdAt.seconds * 1000).toLocaleString([], { dateStyle: 'medium', timeStyle: 'short' })
                            : 'Just now'}
                    </span>
                </div>
                <h1 className="text-2xl font-bold text-gray-900 leading-snug">{message.title}</h1>
                <p className="text-sm font-medium text-gray-500 mt-1">From: {message.senderRole || 'Teacher'}</p>
            </div>

            {/* Body */}
            <div className="p-8 flex-1">
                {/* Deadline Banner */}
                {message.deadline && (
                    <div className="mb-6 flex items-center p-3 bg-red-50 border border-red-100 rounded-lg text-red-700">
                        <span className="text-lg mr-3">⏰</span>
                        <div>
                            <p className="text-xs font-bold uppercase opacity-75">Deadline</p>
                            <p className="text-sm font-semibold">{new Date(message.deadline).toLocaleString()}</p>
                        </div>
                    </div>
                )}

                {/* Content */}
                <div className="prose prose-sm max-w-none text-gray-600 leading-relaxed mb-8 whitespace-pre-wrap">
                    {message.content || message.description}
                </div>

                {/* Attachments / Links */}
                {(message.link || message.materialLink || message.formLink) && (
                    <div className="mb-8">
                        <h4 className="text-xs font-bold text-gray-900 uppercase tracking-wide mb-3">Attached Resource</h4>
                        <a 
                            href={message.link || message.materialLink || message.formLink} 
                            target="_blank" 
                            rel="noopener noreferrer"
                            className="flex items-center p-4 bg-gray-50 rounded-xl border border-gray-200 hover:border-blue-300 hover:bg-blue-50 transition-all group"
                        >
                            <span className="text-2xl mr-3 group-hover:scale-110 transition-transform">🔗</span>
                            <div className="overflow-hidden">
                                <p className="text-sm font-bold text-blue-700 truncate group-hover:underline">Open Resource</p>
                                <p className="text-xs text-gray-500 truncate">{message.link || message.materialLink || message.formLink}</p>
                            </div>
                        </a>
                    </div>
                )}

                {renderPollButtons()}
            </div>
        </div>
    );
};

export default StudentMessageDetail;
