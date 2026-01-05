"use client";

import { motion } from "framer-motion";
import { FileText, Download, ExternalLink } from "lucide-react";

export default function WhitepaperPage() {
  return (
    <div className="min-h-screen bg-paper pt-20 pb-32">
      <div className="container mx-auto px-6 max-w-4xl">
        {/* Header */}
        <motion.div 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="text-center mb-24"
        >
          <span className="text-accent font-serif font-bold tracking-widest mb-4 block">TECHNICAL PAPER</span>
          <h1 className="text-6xl md:text-7xl font-brush text-ink-900 mb-8">만파식 백서</h1>
          <p className="text-xl text-ink-600 font-serif max-w-2xl mx-auto leading-loose">
            만파식 생태계의 기술적 구조와 토크노믹스,<br/>
            그리고 미래 로드맵을 투명하게 공개합니다.
          </p>
          
          <div className="flex justify-center gap-4 mt-8">
            <button className="flex items-center gap-2 bg-ink-900 text-paper px-6 py-3 rounded-full font-serif hover:bg-ink-800 transition-colors">
              <Download size={18} /> PDF 다운로드
            </button>
            <button className="flex items-center gap-2 border border-ink-300 text-ink-700 px-6 py-3 rounded-full font-serif hover:bg-ink-100 transition-colors">
              <ExternalLink size={18} /> 기술 문서 보기
            </button>
          </div>
        </motion.div>

        {/* Content Preview */}
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.2 }}
          className="bg-white p-12 rounded-3xl shadow-sm border border-ink-100 font-serif leading-loose text-ink-800"
        >
          <h2 className="text-3xl font-bold mb-6">1. 서론 (Introduction)</h2>
          <p className="mb-8">
            현대 의료 시스템은 파편화된 데이터, 높은 비용, 그리고 접근성의 불평등이라는 문제에 직면해 있습니다. 만파식(Manpasik) 프로젝트는 이러한 문제를 해결하기 위해 블록체인과 AI 기술을 결합한 탈중앙화 헬스케어 생태계를 제안합니다.
          </p>

          <h2 className="text-3xl font-bold mb-6">2. 생태계 구조 (Ecosystem Architecture)</h2>
          <p className="mb-4">
            만파식 생태계는 크게 세 가지 레이어로 구성됩니다:
          </p>
          <ul className="list-disc pl-6 mb-8 space-y-2">
            <li><strong>Data Layer:</strong> 개인의 생체 데이터를 수집하고 블록체인에 안전하게 기록하는 레이어입니다.</li>
            <li><strong>Service Layer:</strong> AI 분석, 원격 진료, 맞춤형 코칭 등 실제 가치를 제공하는 애플리케이션 레이어입니다.</li>
            <li><strong>Value Layer:</strong> 데이터 제공에 대한 보상과 서비스 이용을 위한 토큰 이코노미가 작동하는 레이어입니다.</li>
          </ul>

          <h2 className="text-3xl font-bold mb-6">3. 핵심 기술 (Core Technology)</h2>
          <div className="bg-ink-50 p-6 rounded-xl mb-8">
            <h3 className="text-xl font-bold mb-2">3.1. Proof of Health (PoH)</h3>
            <p>
              사용자가 자신의 건강 데이터를 지속적으로 생성하고 검증함으로써 보상을 받는 합의 알고리즘입니다. 이는 데이터의 무결성을 보장하고 사용자의 건강 증진 활동을 장려합니다.
            </p>
          </div>

          <h2 className="text-3xl font-bold mb-6">4. 결론 (Conclusion)</h2>
          <p>
            만파식 생태계는 단순한 기술적 혁신을 넘어, 인류의 건강한 삶과 평온한 일상을 위한 사회적 혁신을 목표로 합니다. 홍익인간의 정신으로, 우리는 전 세계 모든 사람들에게 평등하고 수준 높은 의료 서비스를 제공할 것입니다.
          </p>
        </motion.div>
      </div>
    </div>
  );
}
