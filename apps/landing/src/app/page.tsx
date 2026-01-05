"use client";

import { motion, useScroll, useTransform } from "framer-motion";
import { ArrowRight, Activity, Heart, Shield, Smartphone, Globe, Zap } from "lucide-react";
import Image from "next/image";
import { useRef } from "react";

// Components
const Section = ({ children, className = "" }: { children: React.ReactNode; className?: string }) => (
  <section className={`min-h-screen flex flex-col justify-center items-center relative overflow-hidden py-20 ${className}`}>
    {children}
  </section>
);

const InkButton = ({ children, primary = false }: { children: React.ReactNode; primary?: boolean }) => (
  <motion.button
    whileHover={{ scale: 1.05 }}
    whileTap={{ scale: 0.95 }}
    className={`px-8 py-3 rounded-full font-serif text-lg transition-all duration-300 relative overflow-hidden group ${
      primary ? "bg-ink-900 text-paper" : "border-2 border-ink-900 text-ink-900 hover:bg-ink-100"
    }`}
  >
    <span className="relative z-10 flex items-center gap-2">{children}</span>
    {primary && (
      <div className="absolute inset-0 bg-accent opacity-0 group-hover:opacity-100 transition-opacity duration-500 blur-xl" />
    )}
  </motion.button>
);

const FeatureCard = ({ icon: Icon, title, desc, delay }: { icon: any; title: string; desc: string; delay: number }) => (
  <motion.div
    initial={{ opacity: 0, y: 50 }}
    whileInView={{ opacity: 1, y: 0 }}
    transition={{ duration: 0.8, delay, ease: "easeOut" }}
    viewport={{ once: true }}
    className="bg-white/50 backdrop-blur-sm p-8 rounded-2xl border border-ink-100 shadow-lg hover:shadow-xl transition-shadow duration-300 flex flex-col items-center text-center group"
  >
    <div className="w-16 h-16 bg-ink-100 rounded-full flex items-center justify-center mb-6 group-hover:bg-ink-900 transition-colors duration-500">
      <Icon className="w-8 h-8 text-ink-900 group-hover:text-paper transition-colors duration-500" />
    </div>
    <h3 className="text-2xl font-brush mb-4 text-ink-900">{title}</h3>
    <p className="text-ink-500 font-serif leading-relaxed">{desc}</p>
  </motion.div>
);

export default function Home() {
  const targetRef = useRef(null);
  const { scrollYProgress } = useScroll({
    target: targetRef,
    offset: ["start start", "end start"],
  });

  const opacity = useTransform(scrollYProgress, [0, 0.5], [1, 0]);
  const scale = useTransform(scrollYProgress, [0, 0.5], [1, 0.8]);
  const y = useTransform(scrollYProgress, [0, 0.5], [0, -50]);

  return (
    <main className="w-full bg-paper">
      {/* Hero Section */}
      <Section className="h-screen">
        <motion.div 
          style={{ opacity, scale, y }} 
          className="absolute inset-0 z-0"
        >
          <Image
            src="/hero-bg.png"
            alt="Manpasik Ink Landscape"
            fill
            className="object-cover opacity-80"
            priority
          />
          <div className="absolute inset-0 bg-gradient-to-b from-transparent via-paper/20 to-paper" />
        </motion.div>

        <div className="relative z-10 text-center max-w-4xl px-6">
          <motion.div
            initial={{ opacity: 0, scale: 0.8 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 1.5, ease: "easeOut" }}
            className="mb-8"
          >
            <h1 className="text-8xl md:text-9xl font-brush text-ink-900 mb-4 drop-shadow-2xl">
              만파식
            </h1>
            <p className="text-2xl md:text-3xl font-serif text-ink-700 tracking-widest">
              MANPASIK ECOSYSTEM
            </p>
          </motion.div>

          <motion.p
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 1, delay: 0.8 }}
            className="text-xl md:text-2xl text-ink-600 mb-12 font-serif leading-loose"
          >
            <span className="font-bold text-ink-900">홍익인간(弘益人間)</span>의 뜻으로<br />
            세상의 모든 파도를 잠재우고<br />
            당신의 건강을 평온하게 지킵니다.
          </motion.p>

          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 1, delay: 1.2 }}
            className="flex flex-col md:flex-row gap-6 justify-center"
          >
            <a href="http://localhost:3001" target="_blank" rel="noopener noreferrer">
              <InkButton primary>
                생태계 시작하기 <ArrowRight className="w-4 h-4" />
              </InkButton>
            </a>
            <InkButton>
              백서(Whitepaper) 읽기
            </InkButton>
          </motion.div>
        </div>

        {/* Scroll Indicator */}
        <motion.div
          animate={{ y: [0, 10, 0] }}
          transition={{ duration: 2, repeat: Infinity }}
          className="absolute bottom-10 left-1/2 -translate-x-1/2 text-ink-300"
        >
          <div className="w-[1px] h-16 bg-gradient-to-b from-ink-300 to-transparent mx-auto mb-2" />
          <span className="text-xs font-serif tracking-widest">SCROLL</span>
        </motion.div>
      </Section>

      {/* Philosophy Section */}
      <Section className="bg-paper">
        <div className="container mx-auto px-6 grid md:grid-cols-2 gap-16 items-center">
          <motion.div
            initial={{ opacity: 0, x: -50 }}
            whileInView={{ opacity: 1, x: 0 }}
            transition={{ duration: 1 }}
            viewport={{ once: true }}
            className="relative"
          >
            <div className="absolute -top-20 -left-20 w-64 h-64 bg-ink-100 rounded-full blur-3xl opacity-50" />
            <h2 className="text-6xl font-brush mb-8 text-ink-900 relative z-10">
              근심을 없애는<br />
              신비한 피리
            </h2>
            <p className="text-lg text-ink-600 font-serif leading-loose mb-6">
              만파식적(萬波息笛)은 신라 시대의 전설적인 피리로, 이 피리를 불면 적군이 물러가고 병이 나으며 가뭄에는 비가 오고 장마는 개며 바람이 잦아들고 물결이 평온해졌다고 합니다.
            </p>
            <p className="text-lg text-ink-600 font-serif leading-loose">
              우리는 이 전설을 현대 기술로 재해석했습니다. 복잡하고 불안한 현대인의 건강 데이터를 <strong>만파식 생태계</strong>라는 피리를 통해 조화롭고 평온한 상태로 이끕니다.
            </p>
          </motion.div>
          
          <motion.div
            initial={{ opacity: 0, scale: 0.8 }}
            whileInView={{ opacity: 1, scale: 1 }}
            transition={{ duration: 1 }}
            viewport={{ once: true }}
            className="relative h-[500px] w-full bg-ink-900 rounded-[2rem] overflow-hidden shadow-2xl"
          >
            {/* Abstract visualization of waves calming down */}
            <div className="absolute inset-0 bg-gradient-to-br from-ink-800 to-black opacity-90" />
            <div className="absolute inset-0 flex items-center justify-center">
               <span className="text-paper/20 text-9xl font-brush rotate-12">평온</span>
            </div>
          </motion.div>
        </div>
      </Section>

      {/* Features Grid */}
      <Section className="bg-ink-50">
        <div className="container mx-auto px-6">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8 }}
            viewport={{ once: true }}
            className="text-center mb-20"
          >
            <span className="text-accent font-serif font-bold tracking-widest mb-4 block">CORE FEATURES</span>
            <h2 className="text-5xl font-brush text-ink-900">생태계 주요 기능</h2>
          </motion.div>

          <div className="grid md:grid-cols-3 gap-8">
            <FeatureCard
              icon={Activity}
              title="정밀 측정"
              desc="나노 센서 기술을 통해 당신의 생체 신호를 실시간으로 포착하고 분석합니다."
              delay={0.2}
            />
            <FeatureCard
              icon={Heart}
              title="AI 닥터 코칭"
              desc="수집된 데이터를 바탕으로 AI가 개인 맞춤형 건강 가이드를 제공합니다."
              delay={0.4}
            />
            <FeatureCard
              icon={Shield}
              title="데이터 주권"
              desc="블록체인 기술로 당신의 의료 데이터를 안전하게 보호하고 관리합니다."
              delay={0.6}
            />
            <FeatureCard
              icon={Smartphone}
              title="모바일 연동"
              desc="언제 어디서나 스마트폰으로 건강 상태를 확인하고 관리하세요."
              delay={0.8}
            />
            <FeatureCard
              icon={Globe}
              title="글로벌 표준"
              desc="FDA, HIPAA 등 국제 표준을 준수하여 전 세계 어디서나 통용됩니다."
              delay={1.0}
            />
            <FeatureCard
              icon={Zap}
              title="실시간 케어"
              desc="응급 상황 발생 시 즉각적인 알림과 의료진 연결을 지원합니다."
              delay={1.2}
            />
          </div>
        </div>
      </Section>

      {/* Call to Action */}
      <Section className="bg-ink-900 text-paper">
        <motion.div
          initial={{ opacity: 0 }}
          whileInView={{ opacity: 1 }}
          transition={{ duration: 1 }}
          viewport={{ once: true }}
          className="text-center max-w-3xl px-6"
        >
          <h2 className="text-6xl font-brush mb-8">지금, 평온을 찾으세요</h2>
          <p className="text-xl font-serif text-ink-300 mb-12 leading-relaxed">
            만파식 생태계는 단순한 건강 관리 앱이 아닙니다.<br />
            당신의 삶에 균형과 조화를 찾아주는 디지털 동반자입니다.
          </p>
          <InkButton primary>
            무료로 시작하기
          </InkButton>
        </motion.div>
      </Section>

    </div>
  );
}
