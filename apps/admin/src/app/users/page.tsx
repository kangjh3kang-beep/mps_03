/**
 * 사용자 관리 페이지
 * @path /users
 */

'use client';

import { useState, useEffect } from 'react';

interface User {
  id: string;
  email: string;
  name: string;
  role: string;
  active: boolean;
  verified: boolean;
  createdAt: string;
  lastLogin: string;
}

export default function UsersPage() {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState('');
  const [roleFilter, setRoleFilter] = useState('all');
  const [selectedUser, setSelectedUser] = useState<User | null>(null);
  const [showModal, setShowModal] = useState(false);

  // 샘플 데이터
  useEffect(() => {
    const sampleUsers: User[] = [
      { id: '1', email: 'admin@manpasik.com', name: '관리자', role: 'admin', active: true, verified: true, createdAt: '2026-01-01', lastLogin: '2026-01-05' },
      { id: '2', email: 'user1@example.com', name: '김건강', role: 'user', active: true, verified: true, createdAt: '2026-01-02', lastLogin: '2026-01-04' },
      { id: '3', email: 'user2@example.com', name: '이운동', role: 'user', active: true, verified: false, createdAt: '2026-01-03', lastLogin: '2026-01-03' },
      { id: '4', email: 'doctor@hospital.com', name: '박의사', role: 'provider', active: true, verified: true, createdAt: '2026-01-01', lastLogin: '2026-01-05' },
      { id: '5', email: 'inactive@test.com', name: '비활성 사용자', role: 'user', active: false, verified: true, createdAt: '2025-12-15', lastLogin: '2025-12-20' },
    ];
    setUsers(sampleUsers);
    setLoading(false);
  }, []);

  const filteredUsers = users.filter(user => {
    const matchesSearch = user.email.toLowerCase().includes(searchQuery.toLowerCase()) ||
                          user.name.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesRole = roleFilter === 'all' || user.role === roleFilter;
    return matchesSearch && matchesRole;
  });

  const handleEditUser = (user: User) => {
    setSelectedUser(user);
    setShowModal(true);
  };

  const handleToggleActive = (userId: string) => {
    setUsers(users.map(u => u.id === userId ? { ...u, active: !u.active } : u));
  };

  return (
    <div className="p-6 bg-gray-900 min-h-screen text-white">
      <h1 className="text-3xl font-bold mb-6">👥 사용자 관리</h1>
      
      {/* 검색 및 필터 */}
      <div className="flex gap-4 mb-6">
        <input
          type="text"
          placeholder="이메일 또는 이름으로 검색..."
          className="flex-1 px-4 py-2 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none focus:ring-2 focus:ring-cyan-500"
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
        />
        <select
          className="px-4 py-2 bg-gray-800 border border-gray-700 rounded-lg focus:outline-none focus:ring-2 focus:ring-cyan-500"
          value={roleFilter}
          onChange={(e) => setRoleFilter(e.target.value)}
        >
          <option value="all">모든 역할</option>
          <option value="admin">관리자</option>
          <option value="user">일반 사용자</option>
          <option value="provider">의료진</option>
        </select>
        <button className="px-4 py-2 bg-cyan-600 hover:bg-cyan-700 rounded-lg font-semibold">
          + 사용자 추가
        </button>
      </div>

      {/* 통계 카드 */}
      <div className="grid grid-cols-4 gap-4 mb-6">
        <div className="bg-gray-800 p-4 rounded-lg">
          <div className="text-2xl font-bold text-cyan-400">{users.length}</div>
          <div className="text-gray-400">전체 사용자</div>
        </div>
        <div className="bg-gray-800 p-4 rounded-lg">
          <div className="text-2xl font-bold text-green-400">{users.filter(u => u.active).length}</div>
          <div className="text-gray-400">활성 사용자</div>
        </div>
        <div className="bg-gray-800 p-4 rounded-lg">
          <div className="text-2xl font-bold text-yellow-400">{users.filter(u => !u.verified).length}</div>
          <div className="text-gray-400">미인증 사용자</div>
        </div>
        <div className="bg-gray-800 p-4 rounded-lg">
          <div className="text-2xl font-bold text-purple-400">{users.filter(u => u.role === 'provider').length}</div>
          <div className="text-gray-400">의료진</div>
        </div>
      </div>

      {/* 사용자 테이블 */}
      <div className="bg-gray-800 rounded-lg overflow-hidden">
        <table className="w-full">
          <thead className="bg-gray-700">
            <tr>
              <th className="px-4 py-3 text-left">사용자</th>
              <th className="px-4 py-3 text-left">이메일</th>
              <th className="px-4 py-3 text-left">역할</th>
              <th className="px-4 py-3 text-left">상태</th>
              <th className="px-4 py-3 text-left">가입일</th>
              <th className="px-4 py-3 text-left">최종 로그인</th>
              <th className="px-4 py-3 text-center">작업</th>
            </tr>
          </thead>
          <tbody>
            {filteredUsers.map((user) => (
              <tr key={user.id} className="border-t border-gray-700 hover:bg-gray-750">
                <td className="px-4 py-3">
                  <div className="flex items-center gap-2">
                    <div className="w-8 h-8 bg-cyan-600 rounded-full flex items-center justify-center">
                      {user.name.charAt(0)}
                    </div>
                    <span>{user.name}</span>
                  </div>
                </td>
                <td className="px-4 py-3">{user.email}</td>
                <td className="px-4 py-3">
                  <span className={`px-2 py-1 rounded text-xs ${
                    user.role === 'admin' ? 'bg-red-600' :
                    user.role === 'provider' ? 'bg-purple-600' : 'bg-blue-600'
                  }`}>
                    {user.role}
                  </span>
                </td>
                <td className="px-4 py-3">
                  <span className={`px-2 py-1 rounded text-xs ${user.active ? 'bg-green-600' : 'bg-gray-600'}`}>
                    {user.active ? '활성' : '비활성'}
                  </span>
                  {!user.verified && <span className="ml-2 text-yellow-400 text-xs">미인증</span>}
                </td>
                <td className="px-4 py-3 text-gray-400">{user.createdAt}</td>
                <td className="px-4 py-3 text-gray-400">{user.lastLogin}</td>
                <td className="px-4 py-3 text-center">
                  <button 
                    onClick={() => handleEditUser(user)}
                    className="px-2 py-1 bg-gray-600 hover:bg-gray-500 rounded text-sm mr-2"
                  >
                    편집
                  </button>
                  <button 
                    onClick={() => handleToggleActive(user.id)}
                    className={`px-2 py-1 rounded text-sm ${user.active ? 'bg-red-600 hover:bg-red-500' : 'bg-green-600 hover:bg-green-500'}`}
                  >
                    {user.active ? '비활성화' : '활성화'}
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* 모달 (간단한 구현) */}
      {showModal && selectedUser && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-gray-800 p-6 rounded-lg w-96">
            <h2 className="text-xl font-bold mb-4">사용자 편집</h2>
            <div className="space-y-4">
              <input 
                type="text" 
                defaultValue={selectedUser.name}
                className="w-full px-4 py-2 bg-gray-700 rounded"
                placeholder="이름"
              />
              <input 
                type="email" 
                defaultValue={selectedUser.email}
                className="w-full px-4 py-2 bg-gray-700 rounded"
                placeholder="이메일"
              />
              <select defaultValue={selectedUser.role} className="w-full px-4 py-2 bg-gray-700 rounded">
                <option value="user">일반 사용자</option>
                <option value="admin">관리자</option>
                <option value="provider">의료진</option>
              </select>
            </div>
            <div className="flex gap-2 mt-6">
              <button 
                onClick={() => setShowModal(false)}
                className="flex-1 px-4 py-2 bg-gray-600 rounded"
              >
                취소
              </button>
              <button 
                onClick={() => setShowModal(false)}
                className="flex-1 px-4 py-2 bg-cyan-600 rounded"
              >
                저장
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
