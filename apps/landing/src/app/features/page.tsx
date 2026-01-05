"use client";

import { motion } from "framer-motion";
import { Activity, Heart, Shield, Smartphone, Globe, Zap, Database, Lock, Share2 } from "lucide-react";

const features = [
  {
    icon: Activity,
    title: "나노 센서 측정",
    desc: "초정밀 나노 센서를 통해 혈압, 맥박, 산소포화도 등 12가지 생체 신호를 실시간으로 측정합니다.",
    detail: "의료기기 수준의 정확도를 자랑하며, 비침습적 방식으로 고통 없이 데이터를 수집합니다."
  },
  {
    icon: Heart,
    title: "AI 메디컬 코치",
    desc: "수집된 데이터를 딥러닝 알고리즘으로 분석하여 개인 맞춤형 건강 가이드를 제공합니다.",
    detail: "사용자의 생활 습관과 건강 상태를 학습하여 최적의 운동, 식단, 수면 패턴을 제안합니다."
  },
  {
    icon: Shield,
    title: "블록체인 보안",
    desc: "모든 의료 데이터는 블록체인에 암호화되어 저장되며, 위변조가 불가능합니다.",
    detail: "데이터의 소유권은 오직 사용자에게 있으며, 사용자의 승인 없이는 누구도 열람할 수 없습니다."
  },
  {
    icon: Smartphone,
    title: "심리스 모바일 연동",
    desc: "Flutter 기반의 크로스 플랫폼 앱으로 iOS와 Android 어디서든 완벽하게 작동합니다.",
    detail: "워치, 밴드 등 다양한 웨어러블 기기와도 손쉽게 연동되어 끊김 없는 경험을 제공합니다."
  },
  {
    icon: Globe,
    title: "글로벌 텔레메디신",
    desc: "언어 장벽 없는 실시간 번역 기능을 통해 전 세계 의료진과 상담할 수 있습니다.",
    detail: "AI 기반 실시간 통역 시스템이 의학 용어까지 정확하게 번역하여 전달합니다."
  },
  {
    icon: Database,
    title: "통합 건강 데이터",
    desc: "병원, 약국, 검진센터에 흩어진 나의 건강 기록을 한곳에 모아 관리합니다.",
    detail: "PHR(Personal Health Record) 표준을 준수하여 데이터 호환성을 보장합니다."
  },
];

export default function FeaturesPage() {
  return (
    <div className="min-h-screen bg-paper pt-20 pb-32">
      <div className="container mx-auto px-6">
        {/* Header */}
        <motion.div 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="text-center mb-24"
        >
          <span className="text-accent font-serif font-bold tracking-widest mb-4 block">CORE TECHNOLOGY</span>
          <h1 className="text-6xl md:text-7xl font-brush text-ink-900 mb-8">핵심 기능 상세</h1>
          <p className="text-xl text-ink-600 font-serif max-w-2xl mx-auto leading-loose">
            최첨단 기술과 인간 중심 디자인의 만남.<br/>
            만파식 생태계가 제공하는 혁신적인 기능들을 확인하세요.
          </p>
        </motion.div>

        {/* Features Grid */}
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
          {features.map((feature, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, y: 30 }}
              whileInView={{ opacity: 1, y: 0 }}
              transition={{ delay: index * 0.1 }}
              viewport={{ once: true }}
              className="bg-white/60 backdrop-blur-sm p-8 rounded-3xl border border-ink-100 hover:border-ink-300 hover:shadow-xl transition-all duration-300 group"
            >
              <div className="w-14 h-14 bg-ink-900 text-paper rounded-2xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform">
                <feature.icon size={28} />
              </div>
              <h3 className="text-2xl font-brush text-ink-900 mb-4">{feature.title}</h3>
              <p className="text-ink-700 font-serif mb-4 leading-relaxed font-bold">
                {feature.desc}
              </p>
              <p className="text-ink-500 font-serif text-sm leading-relaxed">
                {feature.detail}
              </p>
            </motion.div>
          ))}
        </div>
      </div>
    </div>
  );
}
