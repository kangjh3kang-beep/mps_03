"use client";

import { motion } from "framer-motion";
import { Users } from "lucide-react";

export default function CommunityPage() {
  return (
    <div className="min-h-screen bg-paper pt-20 pb-32 flex items-center justify-center relative overflow-hidden">
      {/* Background Ink Splash */}
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[500px] h-[500px] bg-ink-100 rounded-full blur-[100px] opacity-50 -z-10" />
      <div className="absolute top-20 right-20 text-[20rem] font-brush text-ink-50 opacity-50 select-none -z-10 rotate-12">
        社
      </div>

      <div className="text-center px-6 relative z-10">
        <motion.div
          initial={{ opacity: 0, scale: 0.8, rotate: -10 }}
          animate={{ opacity: 1, scale: 1, rotate: 0 }}
          transition={{ type: "spring", duration: 1.5 }}
          className="w-32 h-32 bg-ink-900 rounded-[2rem] flex items-center justify-center mx-auto mb-10 shadow-2xl rotate-3"
        >
          <Users size={48} className="text-paper" />
        </motion.div>
        
        <motion.h1 
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
          className="text-6xl font-brush text-ink-900 mb-6"
        >
          커뮤니티 준비 중
        </motion.h1>
        
        <motion.p 
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.4 }}
          className="text-2xl text-ink-600 font-serif mb-12 leading-relaxed"
        >
          더 나은 소통 공간을 위해<br/>
          <span className="font-bold text-ink-900 border-b-2 border-accent">먹을 갈고 붓을 다듬고</span> 있습니다.
        </motion.p>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.6 }}
          className="p-8 bg-white/80 backdrop-blur-md rounded-3xl border border-ink-100 max-w-lg mx-auto shadow-lg"
        >
          <p className="text-ink-500 font-serif mb-4">
            오픈 시 알림을 받고 싶으신가요?
          </p>
          <div className="flex gap-2">
            <input 
              type="email" 
              placeholder="이메일 주소를 입력하세요" 
              className="flex-1 px-4 py-3 bg-paper border border-ink-200 rounded-xl focus:outline-none focus:border-ink-900 font-serif"
            />
            <button className="px-6 py-3 bg-ink-900 text-paper rounded-xl font-serif hover:bg-ink-800 transition-colors">
              알림 신청
            </button>
          </div>
          <p className="text-ink-400 font-serif text-xs mt-4">
            문의사항은 <a href="mailto:contact@manpasik.io" className="text-ink-900 font-bold underline hover:text-accent transition-colors">contact@manpasik.io</a>로 보내주세요.
          </p>
        </motion.div>
      </div>
    </div>
  );
}
