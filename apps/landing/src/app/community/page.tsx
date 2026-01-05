"use client";

import { motion } from "framer-motion";
import { Users } from "lucide-react";

export default function CommunityPage() {
  return (
    <div className="min-h-screen bg-paper pt-20 pb-32 flex items-center justify-center">
      <div className="text-center px-6">
        <motion.div
          initial={{ opacity: 0, scale: 0.8 }}
          animate={{ opacity: 1, scale: 1 }}
          className="w-24 h-24 bg-ink-100 rounded-full flex items-center justify-center mx-auto mb-8"
        >
          <Users size={40} className="text-ink-900" />
        </motion.div>
        
        <motion.h1 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
          className="text-5xl font-brush text-ink-900 mb-6"
        >
          커뮤니티 준비 중
        </motion.h1>
        
        <motion.p 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.4 }}
          className="text-xl text-ink-600 font-serif mb-8"
        >
          더 나은 소통 공간을 위해 준비하고 있습니다.<br/>
          조금만 기다려주세요.
        </motion.p>

        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.6 }}
          className="p-6 bg-white rounded-2xl border border-ink-100 max-w-md mx-auto"
        >
          <p className="text-ink-500 font-serif text-sm">
            문의사항은 <a href="mailto:contact@manpasik.io" className="text-ink-900 font-bold underline">contact@manpasik.io</a>로 보내주세요.
          </p>
        </motion.div>
      </div>
    </div>
  );
}
