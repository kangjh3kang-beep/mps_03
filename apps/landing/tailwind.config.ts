import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        brush: ['"Nanum Brush Script"', "cursive"],
        serif: ['"Noto Serif KR"', "serif"],
      },
      colors: {
        ink: {
          900: "#0a0a0a", // 진한 먹
          800: "#1a1a1a",
          700: "#2b2b2b",
          500: "#555555", // 중먹
          300: "#888888", // 담먹
          100: "#e5e5e5",
        },
        paper: "#f4f3ee", // 한지 색상
        accent: "#b91c1c", // 낙관 색상 (Red)
      },
      backgroundImage: {
        "gradient-radial": "radial-gradient(var(--tw-gradient-stops))",
        "paper-texture": "url('/paper-texture.png')", // 나중에 추가 가능
      },
      animation: {
        "ink-spread": "inkSpread 2s ease-out forwards",
        "float": "float 6s ease-in-out infinite",
      },
      keyframes: {
        inkSpread: {
          "0%": { transform: "scale(0)", opacity: "0" },
          "100%": { transform: "scale(1)", opacity: "1" },
        },
        float: {
          "0%, 100%": { transform: "translateY(0)" },
          "50%": { transform: "translateY(-20px)" },
        },
      },
    },
  },
  plugins: [],
};
export default config;
