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

const InkBlotCard = ({ icon: Icon, title, desc, delay }: { icon: any; title: string; desc: string; delay: number }) => (
  <motion.div
    initial={{ opacity: 0, scale: 0.9 }}
    whileInView={{ opacity: 1, scale: 1 }}
    transition={{ duration: 0.8, delay, ease: "easeOut" }}
    viewport={{ once: true }}
    className="relative p-10 flex flex-col items-center text-center group"
  >
    {/* Ink Blot Background */}
    <div className="absolute inset-0 bg-ink-50 rounded-[3rem] rotate-3 group-hover:rotate-0 transition-transform duration-500 -z-10" />
    <div className="absolute inset-0 bg-white/50 rounded-[2rem] -rotate-2 group-hover:rotate-0 transition-transform duration-500 -z-10 border border-ink-100" />

    <div className="w-20 h-20 bg-ink-900 rounded-full flex items-center justify-center mb-6 group-hover:scale-110 transition-transform duration-500 shadow-xl">
      <Icon className="w-10 h-10 text-paper" />
    </div>
    <h3 className="text-3xl font-brush mb-4 text-ink-900">{title}</h3>
    <p className="text-ink-600 font-serif leading-relaxed">{desc}</p>
  </motion.div>
);

export default function Home() {
  const targetRef = useRef(null);
  const { scrollYProgress } = useScroll({
    target: targetRef,
    offset: ["start start", "end start"],
  });

  const opacity = useTransform(scrollYProgress, [0, 0.5], [1, 0]);
  const scale = useTransform(scrollYProgress, [0, 0.5], [1, 1.1]); // Slight zoom in
  const y = useTransform(scrollYProgress, [0, 0.5], [0, 100]); // Parallax effect

  return (
    <div className="w-full bg-paper overflow-hidden">
      {/* Hero Section */}
      <Section className="h-screen relative">
        <motion.div 
          style={{ opacity, scale, y }} 
          className="absolute inset-0 z-0"
        >
          <Image
            src="/hero-bg.png"
            alt="Manpasik Ink Landscape"
            fill
            className="object-cover opacity-90"
            priority
          />
          <div className="absolute inset-0 bg-gradient-to-b from-transparent via-paper/10 to-paper" />
        </motion.div>

        <div className="relative z-10 text-center max-w-5xl px-6">
          <motion.div
            initial={{ opacity: 0, filter: "blur(10px)" }}
            animate={{ opacity: 1, filter: "blur(0px)" }}
            transition={{ duration: 1.5, ease: "easeOut" }}
            className="mb-8"
          >
            <h1 className="text-9xl md:text-[10rem] font-brush text-ink-900 mb-2 drop-shadow-2xl leading-none mix-blend-multiply">
              만파식
            </h1>
            <p className="text-2xl md:text-4xl font-serif text-ink-800 tracking-[0.5em] font-light">
              MANPASIK ECOSYSTEM
            </p>
          </motion.div>

          <motion.p
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 1, delay: 0.8 }}
            className="text-xl md:text-3xl text-ink-700 mb-16 font-serif leading-loose"
          >
            <span className="font-bold text-ink-900 border-b-2 border-accent">홍익인간(弘益人間)</span>의 뜻으로<br />
            세상의 모든 파도를 잠재우고<br />
            당신의 건강을 평온하게 지킵니다.
          </motion.p>

          <motion.div
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 1, delay: 1.2 }}
            className="flex flex-col md:flex-row gap-8 justify-center items-center"
          >
            <a href="http://localhost:3001" target="_blank" rel="noopener noreferrer">
              <InkButton primary>
                생태계 시작하기 <ArrowRight className="w-5 h-5" />
              </InkButton>
            </a>
            <InkButton>
              백서(Whitepaper) 읽기
            </InkButton>
          </motion.div>
        </div>

        {/* Scroll Indicator */}
        <motion.div
          animate={{ y: [0, 15, 0], opacity: [0.5, 1, 0.5] }}
          transition={{ duration: 2, repeat: Infinity }}
          className="absolute bottom-12 left-1/2 -translate-x-1/2 text-ink-400 flex flex-col items-center gap-2"
        >
          <span className="text-xs font-serif tracking-widest uppercase">Scroll to Discover</span>
          <div className="w-[1px] h-20 bg-gradient-to-b from-ink-400 to-transparent" />
        </motion.div>
      </Section>

      {/* Philosophy Section */}
      <Section className="bg-paper relative">
        {/* Background Elements */}
        <div className="absolute top-20 left-10 text-[20rem] font-brush text-ink-50 opacity-50 select-none -z-10">
          息
        </div>
        
        <div className="container mx-auto px-6 grid md:grid-cols-2 gap-20 items-center">
          <motion.div
            initial={{ opacity: 0, x: -50 }}
            whileInView={{ opacity: 1, x: 0 }}
            transition={{ duration: 1 }}
            viewport={{ once: true }}
            className="relative"
          >
            <div className="absolute -top-20 -left-20 w-80 h-80 bg-ink-100 rounded-full blur-[100px] opacity-60" />
            <h2 className="text-7xl font-brush mb-10 text-ink-900 relative z-10 leading-tight">
              근심을 없애는<br />
              <span className="text-accent">신비한 피리</span>
            </h2>
            <p className="text-xl text-ink-700 font-serif leading-loose mb-8">
              만파식적(萬波息笛)은 신라 시대의 전설적인 피리로, 이 피리를 불면 적군이 물러가고 병이 나으며 가뭄에는 비가 오고 장마는 개며 바람이 잦아들고 물결이 평온해졌다고 합니다.
            </p>
            <p className="text-xl text-ink-700 font-serif leading-loose border-l-4 border-ink-900 pl-6">
              우리는 이 전설을 현대 기술로 재해석했습니다. 복잡하고 불안한 현대인의 건강 데이터를 <strong>만파식 생태계</strong>라는 피리를 통해 조화롭고 평온한 상태로 이끕니다.
            </p>
          </motion.div>
          
          <motion.div
            initial={{ opacity: 0, scale: 0.9, rotate: 5 }}
            whileInView={{ opacity: 1, scale: 1, rotate: 0 }}
            transition={{ duration: 1.2, type: "spring" }}
            viewport={{ once: true }}
            className="relative h-[600px] w-full bg-ink-900 rounded-[3rem] overflow-hidden shadow-2xl group"
          >
            {/* Abstract visualization of waves calming down */}
            <div className="absolute inset-0 bg-[url('/hero-bg.png')] bg-cover opacity-50 group-hover:scale-110 transition-transform duration-1000" />
            <div className="absolute inset-0 bg-gradient-to-t from-black via-transparent to-transparent" />
            <div className="absolute bottom-0 left-0 right-0 p-12">
               <span className="text-paper/20 text-9xl font-brush block mb-4">平穩</span>
               <p className="text-paper/80 font-serif text-lg">Peace of Mind through Data</p>
            </div>
          </motion.div>
        </div>
      </Section>

      {/* Features Grid */}
      <Section className="bg-ink-50 relative overflow-hidden">
         <div className="absolute -right-20 top-40 text-[30rem] font-brush text-white opacity-50 select-none pointer-events-none">
          波
        </div>

        <div className="container mx-auto px-6 relative z-10">
          <motion.div
            initial={{ opacity: 0, y: 30 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8 }}
            viewport={{ once: true }}
            className="text-center mb-24"
          >
            <span className="text-accent font-serif font-bold tracking-[0.5em] mb-6 block">CORE FEATURES</span>
            <h2 className="text-6xl font-brush text-ink-900">생태계 주요 기능</h2>
          </motion.div>

          <div className="grid md:grid-cols-3 gap-10">
            <InkBlotCard
              icon={Activity}
              title="정밀 측정"
              desc="나노 센서 기술을 통해 당신의 생체 신호를 실시간으로 포착하고 분석합니다."
              delay={0.2}
            />
            <InkBlotCard
              icon={Heart}
              title="AI 닥터 코칭"
              desc="수집된 데이터를 바탕으로 AI가 개인 맞춤형 건강 가이드를 제공합니다."
              delay={0.4}
            />
            <InkBlotCard
              icon={Shield}
              title="데이터 주권"
              desc="블록체인 기술로 당신의 의료 데이터를 안전하게 보호하고 관리합니다."
              delay={0.6}
            />
            <InkBlotCard
              icon={Smartphone}
              title="모바일 연동"
              desc="언제 어디서나 스마트폰으로 건강 상태를 확인하고 관리하세요."
              delay={0.8}
            />
            <InkBlotCard
              icon={Globe}
              title="글로벌 표준"
              desc="FDA, HIPAA 등 국제 표준을 준수하여 전 세계 어디서나 통용됩니다."
              delay={1.0}
            />
            <InkBlotCard
              icon={Zap}
              title="실시간 케어"
              desc="응급 상황 발생 시 즉각적인 알림과 의료진 연결을 지원합니다."
              delay={1.2}
            />
          </div>
        </div>
      </Section>

      {/* Call to Action */}
      <Section className="bg-ink-900 text-paper relative overflow-hidden">
        <div className="absolute inset-0 bg-[url('/hero-bg.png')] bg-cover opacity-10 mix-blend-overlay" />
        
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          whileInView={{ opacity: 1, scale: 1 }}
          transition={{ duration: 1 }}
          viewport={{ once: true }}
          className="text-center max-w-4xl px-6 relative z-10"
        >
          <h2 className="text-7xl md:text-8xl font-brush mb-10 leading-tight">지금, <span className="text-accent">평온</span>을 찾으세요</h2>
          <p className="text-2xl font-serif text-ink-300 mb-16 leading-relaxed">
            만파식 생태계는 단순한 건강 관리 앱이 아닙니다.<br />
            당신의 삶에 균형과 조화를 찾아주는 디지털 동반자입니다.
          </p>
          <div className="flex justify-center gap-6">
             <a href="http://localhost:3001" target="_blank" rel="noopener noreferrer">
              <button className="px-12 py-5 bg-paper text-ink-900 rounded-full font-serif text-xl hover:bg-accent hover:text-white transition-all duration-300 shadow-2xl hover:shadow-accent/50 liquid-hover">
                무료로 시작하기
              </button>
            </a>
          </div>
        </motion.div>
      </Section>

    </div>
  );
}
