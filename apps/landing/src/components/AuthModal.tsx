"use client";

import { motion, AnimatePresence } from "framer-motion";
import { X, User, Lock, ArrowRight } from "lucide-react";
import { useState } from "react";

interface AuthModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export default function AuthModal({ isOpen, onClose }: AuthModalProps) {
  const [isLogin, setIsLogin] = useState(true);

  return (
    <AnimatePresence>
      {isOpen && (
        <>
          {/* Backdrop */}
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onClick={onClose}
            className="fixed inset-0 bg-black/60 backdrop-blur-sm z-[60]"
          />

          {/* Modal */}
          <motion.div
            initial={{ opacity: 0, scale: 0.9, y: 20 }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            exit={{ opacity: 0, scale: 0.9, y: 20 }}
            className="fixed inset-0 m-auto w-full max-w-md h-fit bg-paper rounded-3xl shadow-2xl z-[70] overflow-hidden border border-ink-100"
          >
            {/* Ink Decoration */}
            <div className="absolute top-0 right-0 w-32 h-32 bg-ink-100 rounded-bl-full opacity-50 -z-10" />
            
            <div className="p-8">
              <div className="flex justify-between items-center mb-8">
                <h2 className="text-3xl font-brush text-ink-900">
                  {isLogin ? "로그인" : "회원가입"}
                </h2>
                <button onClick={onClose} className="text-ink-500 hover:text-ink-900 transition-colors">
                  <X size={24} />
                </button>
              </div>

              <form className="space-y-6" onSubmit={(e) => e.preventDefault()}>
                <div className="space-y-2">
                  <label className="text-sm font-serif text-ink-600 block">이메일</label>
                  <div className="relative">
                    <User className="absolute left-4 top-1/2 -translate-y-1/2 text-ink-400" size={20} />
                    <input 
                      type="email" 
                      className="w-full bg-white border border-ink-200 rounded-xl py-3 pl-12 pr-4 focus:outline-none focus:border-ink-900 transition-colors font-serif"
                      placeholder="example@manpasik.io"
                    />
                  </div>
                </div>

                <div className="space-y-2">
                  <label className="text-sm font-serif text-ink-600 block">비밀번호</label>
                  <div className="relative">
                    <Lock className="absolute left-4 top-1/2 -translate-y-1/2 text-ink-400" size={20} />
                    <input 
                      type="password" 
                      className="w-full bg-white border border-ink-200 rounded-xl py-3 pl-12 pr-4 focus:outline-none focus:border-ink-900 transition-colors font-serif"
                      placeholder="••••••••"
                    />
                  </div>
                </div>

                <button 
                  className="w-full bg-ink-900 text-paper py-4 rounded-xl font-serif text-lg hover:bg-ink-800 transition-all duration-300 flex items-center justify-center gap-2 group"
                >
                  {isLogin ? "시작하기" : "가입하기"}
                  <ArrowRight size={20} className="group-hover:translate-x-1 transition-transform" />
                </button>
              </form>

              <div className="mt-8 text-center">
                <p className="text-ink-500 font-serif text-sm">
                  {isLogin ? "계정이 없으신가요?" : "이미 계정이 있으신가요?"}
                  <button 
                    onClick={() => setIsLogin(!isLogin)}
                    className="ml-2 text-ink-900 font-bold hover:underline"
                  >
                    {isLogin ? "회원가입" : "로그인"}
                  </button>
                </p>
              </div>
            </div>
            
            {/* Social Login */}
            <div className="bg-ink-50 p-6 text-center border-t border-ink-100">
              <p className="text-xs text-ink-400 font-serif mb-4">또는 소셜 계정으로 계속하기</p>
              <div className="flex justify-center gap-4">
                {/* Mock Social Buttons */}
                <button className="w-10 h-10 rounded-full bg-white border border-ink-200 flex items-center justify-center hover:bg-ink-100 transition-colors">G</button>
                <button className="w-10 h-10 rounded-full bg-white border border-ink-200 flex items-center justify-center hover:bg-ink-100 transition-colors">K</button>
                <button className="w-10 h-10 rounded-full bg-white border border-ink-200 flex items-center justify-center hover:bg-ink-100 transition-colors">N</button>
              </div>
            </div>
          </motion.div>
        </>
      )}
    </AnimatePresence>
  );
}
