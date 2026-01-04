Write-Host "Fixing Tailwind CSS v4 + PostCSS setup..." -ForegroundColor Cyan

# ------------------------------------
# 1. Install correct Tailwind v4 plugins
# ------------------------------------
npm install -D tailwindcss @tailwindcss/postcss autoprefixer | Out-Null

# ------------------------------------
# 2. Fix postcss.config.js (Tailwind v4)
# ------------------------------------
@'
export default {
  plugins: {
    "@tailwindcss/postcss": {},
    autoprefixer: {},
  },
};
'@ | Set-Content postcss.config.js

# ------------------------------------
# 3. Ensure tailwind.config.js exists
# ------------------------------------
if (!(Test-Path "tailwind.config.js")) {
@'
/** @type {import("tailwindcss").Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,jsx,ts,tsx}"
  ],
  theme: {
    extend: {},
  },
  plugins: [],
};
'@ | Set-Content tailwind.config.js
}

# ------------------------------------
# 4. Ensure src/index.css is correct
# ------------------------------------
@'
@tailwind base;
@tailwind components;
@tailwind utilities;
'@ | Set-Content src/index.css

# ------------------------------------
# 5. Final message
# ------------------------------------
Write-Host "----------------------------------------"
Write-Host "Tailwind v4 PostCSS FIX APPLIED" -ForegroundColor Green
Write-Host "Now run:"
Write-Host "  npm run dev"
Write-Host "Then hard refresh browser (Ctrl + Shift + R)"
