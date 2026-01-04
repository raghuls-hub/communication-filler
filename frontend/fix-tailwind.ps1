Write-Host "Fixing Tailwind CSS setup..." -ForegroundColor Cyan

# -----------------------------
# 1. Ensure Tailwind packages are installed
# -----------------------------
npm install -D tailwindcss postcss autoprefixer | Out-Null

# -----------------------------
# 2. Create tailwind.config.js (Vite compatible)
# -----------------------------
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

# -----------------------------
# 3. Create postcss.config.js
# -----------------------------
@'
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};
'@ | Set-Content postcss.config.js

# -----------------------------
# 4. Fix src/index.css
# -----------------------------
@'
@tailwind base;
@tailwind components;
@tailwind utilities;
'@ | Set-Content src/index.css

# -----------------------------
# 5. Ensure src/main.jsx imports index.css
# -----------------------------
$mainPath = "src/main.jsx"

if (Test-Path $mainPath) {
  $content = Get-Content $mainPath -Raw

  if ($content -notmatch "index.css") {
    Write-Host "Injecting index.css import into main.jsx" -ForegroundColor Yellow

    $lines = Get-Content $mainPath
    $newLines = @()

    $importInserted = $false
    foreach ($line in $lines) {
      $newLines += $line
      if ($line -match "^import .*['""]react") {
        $newLines += "import './index.css';"
        $importInserted = $true
      }
    }

    if (-not $importInserted) {
      $newLines = @("import './index.css';") + $lines
    }

    $newLines | Set-Content $mainPath
  }
}
else {
  Write-Host "WARNING: src/main.jsx not found!" -ForegroundColor Red
}

# -----------------------------
# 6. Final confirmation
# -----------------------------
Write-Host "----------------------------------------"
Write-Host "Tailwind CSS FIX APPLIED SUCCESSFULLY" -ForegroundColor Green
Write-Host "Next steps:"
Write-Host "1. Restart dev server: npm run dev"
Write-Host "2. Hard refresh browser (Ctrl + Shift + R)"
Write-Host "3. Test Tailwind class (bg-red-500)"
