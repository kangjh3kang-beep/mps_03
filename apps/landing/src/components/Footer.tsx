import Link from "next/link";

export default function Footer() {
  return (
    <footer className="bg-ink-900 text-ink-300 py-16 border-t border-ink-800">
      <div className="container mx-auto px-6">
        <div className="grid md:grid-cols-4 gap-12 mb-12">
          {/* Brand */}
          <div className="col-span-1 md:col-span-2">
            <h3 className="text-4xl font-brush text-paper mb-4">만파식</h3>
            <p className="font-serif leading-relaxed text-ink-400 max-w-md">
              홍익인간의 이념으로 세상을 치유하고,<br />
              만파식적의 평온함으로 당신의 건강을 지킵니다.
            </p>
          </div>

          {/* Links */}
          <div>
            <h4 className="text-paper font-serif font-bold mb-6">생태계</h4>
            <ul className="space-y-4 font-serif">
              <li><Link href="/about" className="hover:text-paper transition-colors">소개</Link></li>
              <li><Link href="/features" className="hover:text-paper transition-colors">주요 기능</Link></li>
              <li><Link href="/whitepaper" className="hover:text-paper transition-colors">백서</Link></li>
              <li><Link href="/roadmap" className="hover:text-paper transition-colors">로드맵</Link></li>
            </ul>
          </div>

          {/* Legal */}
          <div>
            <h4 className="text-paper font-serif font-bold mb-6">지원</h4>
            <ul className="space-y-4 font-serif">
              <li><Link href="/faq" className="hover:text-paper transition-colors">자주 묻는 질문</Link></li>
              <li><Link href="/contact" className="hover:text-paper transition-colors">문의하기</Link></li>
              <li><Link href="/privacy" className="hover:text-paper transition-colors">개인정보처리방침</Link></li>
              <li><Link href="/terms" className="hover:text-paper transition-colors">이용약관</Link></li>
            </ul>
          </div>
        </div>

        <div className="border-t border-ink-800 pt-8 flex flex-col md:flex-row justify-between items-center gap-4 text-sm font-serif text-ink-500">
          <p>© 2026 Manpasik Ecosystem. All rights reserved.</p>
          <div className="flex gap-6">
            <span>서울시 강남구 테헤란로 123</span>
            <span>contact@manpasik.io</span>
          </div>
        </div>
      </div>
    </footer>
  );
}
