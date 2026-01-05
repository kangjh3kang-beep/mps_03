"use client";

import { motion } from "framer-motion";
import Image from "next/image";

export default function AboutPage() {
  return (
    <div className="min-h-screen bg-paper pt-20 pb-32">
      <div className="container mx-auto px-6">
        {/* Header */}
        <motion.div 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="text-center mb-24"
        >
          <span className="text-accent font-serif font-bold tracking-widest mb-4 block">OUR PHILOSOPHY</span>
          <h1 className="text-6xl md:text-7xl font-brush text-ink-900 mb-8">만파식적과 홍익인간</h1>
          <p className="text-xl text-ink-600 font-serif max-w-2xl mx-auto leading-loose">
            천년의 지혜를 현대의 기술로 잇다.<br/>
            우리는 데이터를 통해 세상을 널리 이롭게 합니다.
          </p>
        </motion.div>

        {/* Timeline Section */}
        <div className="relative max-w-4xl mx-auto">
          {/* Vertical Line */}
          <div className="absolute left-1/2 -translate-x-1/2 top-0 bottom-0 w-[2px] bg-ink-200" />

          {/* Timeline Item 1 */}
          <motion.div
            initial={{ opacity: 0, y: 50 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="relative grid grid-cols-1 md:grid-cols-2 gap-8 mb-32"
          >
            <div className="md:text-right md:pr-12">
              <h3 className="text-3xl font-brush text-ink-900 mb-4">신라 시대 (682년)</h3>
              <p className="text-ink-600 font-serif leading-relaxed">
                동해의 용이 대나무를 보내와 만파식적을 만들었습니다.<br/>
                피리를 불면 나라의 모든 근심이 사라졌습니다.
              </p>
            </div>
            <div className="absolute left-1/2 -translate-x-1/2 top-0 w-4 h-4 bg-ink-900 rounded-full border-4 border-paper z-10" />
            <div className="md:pl-12">
               <div className="h-48 bg-ink-100 rounded-2xl rotate-2 hover:rotate-0 transition-transform duration-500 overflow-hidden relative group">
                  <div className="absolute inset-0 bg-ink-900/10 group-hover:bg-transparent transition-colors" />
                  <div className="absolute inset-0 flex items-center justify-center">
                    <span className="font-brush text-5xl text-ink-300">傳說</span>
                  </div>
               </div>
            </div>
          </motion.div>

          {/* Timeline Item 2 */}
          <motion.div
            initial={{ opacity: 0, y: 50 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="relative grid grid-cols-1 md:grid-cols-2 gap-8 mb-32"
          >
            <div className="order-2 md:order-1 md:text-right md:pr-12">
               <div className="h-48 bg-ink-900 rounded-2xl -rotate-2 hover:rotate-0 transition-transform duration-500 overflow-hidden relative group">
                  <div className="absolute inset-0 flex items-center justify-center">
                    <span className="font-brush text-5xl text-paper/30">理念</span>
                  </div>
               </div>
            </div>
            <div className="absolute left-1/2 -translate-x-1/2 top-0 w-4 h-4 bg-ink-900 rounded-full border-4 border-paper z-10" />
            <div className="order-1 md:order-2 md:pl-12">
              <h3 className="text-3xl font-brush text-ink-900 mb-4">홍익인간 정신</h3>
              <p className="text-ink-600 font-serif leading-relaxed">
                널리 인간을 이롭게 하라는 건국 이념.<br/>
                우리는 이 정신을 기술로 계승합니다.
              </p>
            </div>
          </motion.div>

          {/* Timeline Item 3 */}
          <motion.div
            initial={{ opacity: 0, y: 50 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="relative grid grid-cols-1 md:grid-cols-2 gap-8"
          >
            <div className="md:text-right md:pr-12">
              <h3 className="text-3xl font-brush text-ink-900 mb-4">2026년, 만파식 생태계</h3>
              <p className="text-ink-600 font-serif leading-relaxed">
                블록체인과 AI로 재탄생한 디지털 만파식적.<br/>
                당신의 데이터가 당신을 치유합니다.
              </p>
            </div>
            <div className="absolute left-1/2 -translate-x-1/2 top-0 w-4 h-4 bg-accent rounded-full border-4 border-paper z-10 animate-pulse" />
            <div className="md:pl-12">
               <div className="h-48 bg-gradient-to-br from-ink-800 to-black rounded-2xl rotate-1 hover:rotate-0 transition-transform duration-500 overflow-hidden relative shadow-xl">
                  <div className="absolute inset-0 flex items-center justify-center">
                    <span className="font-brush text-5xl text-accent/50">未來</span>
                  </div>
               </div>
            </div>
          </motion.div>
        </div>

        {/* Vision */}
        <div className="text-center bg-ink-50 rounded-3xl p-16">
          <h2 className="text-4xl font-brush text-ink-900 mb-8">우리의 비전</h2>
          <p className="text-2xl font-serif text-ink-700 leading-relaxed italic">
            "데이터로 연결된 건강한 인류,<br/>
            평온한 삶을 위한 디지털 만파식적"
          </p>
        </div>
      </div>
    </div>
  );
}
