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

        {/* Story Section 1 */}
        <div className="grid md:grid-cols-2 gap-16 items-center mb-32">
          <motion.div
            initial={{ opacity: 0, x: -50 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
            className="relative h-[400px] bg-ink-100 rounded-2xl overflow-hidden"
          >
            {/* Placeholder for Manpasikjeok Image */}
            <div className="absolute inset-0 flex items-center justify-center bg-ink-900/5">
                <span className="font-brush text-6xl text-ink-200">만파식적</span>
            </div>
          </motion.div>
          <motion.div
            initial={{ opacity: 0, x: 50 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
          >
            <h2 className="text-4xl font-brush text-ink-900 mb-6">파도를 잠재우는 피리</h2>
            <p className="text-lg text-ink-600 font-serif leading-loose mb-6">
              신라 신문왕 때, 동해의 용이 대나무를 보내왔습니다. 이 대나무로 피리를 만들어 부니, 적병이 물러가고 병이 나으며, 가뭄에는 비가 오고 장마는 개며, 바람이 잦아들고 물결이 평온해졌습니다.
            </p>
            <p className="text-lg text-ink-600 font-serif leading-loose">
              이것이 바로 <strong>만파식적(萬波息笛)</strong>입니다. 세상의 모든 근심과 걱정을 해결해주는 신비한 보물입니다.
            </p>
          </motion.div>
        </div>

        {/* Story Section 2 */}
        <div className="grid md:grid-cols-2 gap-16 items-center mb-32">
          <motion.div
            initial={{ opacity: 0, x: -50 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
            className="order-2 md:order-1"
          >
            <h2 className="text-4xl font-brush text-ink-900 mb-6">널리 인간을 이롭게 하라</h2>
            <p className="text-lg text-ink-600 font-serif leading-loose mb-6">
              <strong>홍익인간(弘益人間)</strong>은 대한민국의 건국 이념이자 교육 이념입니다. 우리는 이 정신을 디지털 헬스케어에 접목했습니다.
            </p>
            <p className="text-lg text-ink-600 font-serif leading-loose">
              특정 계층만이 아닌, 전 세계 모든 인류가 평등하게 최상의 의료 서비스를 누릴 수 있도록. 만파식 생태계는 기술을 통해 홍익인간을 실현합니다.
            </p>
          </motion.div>
          <motion.div
            initial={{ opacity: 0, x: 50 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
            className="order-1 md:order-2 relative h-[400px] bg-ink-100 rounded-2xl overflow-hidden"
          >
             {/* Placeholder for Hongik Ingan Image */}
             <div className="absolute inset-0 flex items-center justify-center bg-ink-900/5">
                <span className="font-brush text-6xl text-ink-200">홍익인간</span>
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
