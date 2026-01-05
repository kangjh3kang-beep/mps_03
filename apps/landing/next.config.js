/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone',
  images: {
    unoptimized: true, // Docker 환경에서 이미지 최적화 문제 방지
  },
};

module.exports = nextConfig;
