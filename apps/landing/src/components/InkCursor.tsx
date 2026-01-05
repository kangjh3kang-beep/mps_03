"use client";

import { useEffect, useState } from "react";
import { motion, useSpring } from "framer-motion";

export default function InkCursor() {
  const [isHovering, setIsHovering] = useState(false);
  
  // Smooth mouse movement
  const cursorX = useSpring(0, { damping: 25, stiffness: 150 });
  const cursorY = useSpring(0, { damping: 25, stiffness: 150 });

  useEffect(() => {
    const moveCursor = (e: MouseEvent) => {
      cursorX.set(e.clientX - 16);
      cursorY.set(e.clientY - 16);
    };

    const handleMouseOver = (e: MouseEvent) => {
      const target = e.target as HTMLElement;
      if (target.tagName === "A" || target.tagName === "BUTTON" || target.closest("a") || target.closest("button")) {
        setIsHovering(true);
      } else {
        setIsHovering(false);
      }
    };

    window.addEventListener("mousemove", moveCursor);
    window.addEventListener("mouseover", handleMouseOver);

    return () => {
      window.removeEventListener("mousemove", moveCursor);
      window.removeEventListener("mouseover", handleMouseOver);
    };
  }, [cursorX, cursorY]);

  return (
    <>
      {/* Main Brush Tip */}
      <motion.div
        className="fixed top-0 left-0 w-8 h-8 pointer-events-none z-[9999] mix-blend-difference"
        style={{
          x: cursorX,
          y: cursorY,
        }}
      >
        <div 
          className={`w-full h-full bg-white rounded-full transition-all duration-300 ${
            isHovering ? "scale-150 opacity-50 blur-sm" : "scale-100 opacity-80"
          }`} 
        />
      </motion.div>
      
      {/* Trailing Ink Effect (Simplified) */}
      <motion.div
        className="fixed top-0 left-0 w-4 h-4 pointer-events-none z-[9998] mix-blend-multiply"
        style={{
          x: cursorX,
          y: cursorY,
          translateX: 8,
          translateY: 8,
        }}
      >
         <div className={`w-full h-full bg-ink-500 rounded-full blur-md transition-all duration-500 ${isHovering ? "scale-[3]" : "scale-100"}`} />
      </motion.div>
    </>
  );
}
