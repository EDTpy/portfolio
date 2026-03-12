#!/bin/bash
# ============================================================
#  Ogunkanmi Taiwo — Portfolio Deploy Script
#  Run from inside your portfolio folder:  bash setup.sh
# ============================================================
set -e

GREEN='\033[0;32m'; ORANGE='\033[0;33m'; CYAN='\033[0;36m'
BOLD='\033[1m'; RED='\033[0;31m'; NC='\033[0m'

step()  { echo -e "\n${CYAN}${BOLD}▶  $1${NC}"; }
ok()    { echo -e "${GREEN}✔  $1${NC}"; }
warn()  { echo -e "${ORANGE}⚠  $1${NC}"; }
err()   { echo -e "${RED}✘  $1${NC}"; exit 1; }

echo -e "\n${BOLD}╔══════════════════════════════════════╗${NC}"
echo -e "${BOLD}║  Taiwo Portfolio — Setup & Deploy    ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════╝${NC}"

# ── 1. Sanity check ──────────────────────────────────────
step "Checking project files..."
[ -f "index.html" ] || err "index.html not found. Run this script from the portfolio folder."
ok "index.html found."

# ── 2. Git init ──────────────────────────────────────────
step "Setting up Git..."
if [ ! -d ".git" ]; then
  git init
  ok "Git repository initialised."
else
  warn "Git already initialised — skipping."
fi

# ── 3. Support files ─────────────────────────────────────
step "Creating support files..."

cat > .gitignore << 'EOF'
.DS_Store
Thumbs.db
.env
.env.local
.vercel
node_modules/
EOF

cat > vercel.json << 'EOF'
{
  "version": 2,
  "builds": [{ "src": "index.html", "use": "@vercel/static" }],
  "routes": [{ "src": "/(.*)", "dest": "/$1" }]
}
EOF

cat > README.md << 'EOF'
# Ogunkanmi Taiwo — Portfolio

Personal portfolio for **Ogunkanmi Taiwo**, Software Engineer & Aspiring Full Stack Developer — Lagos, Nigeria.

## Stack
- Pure HTML, CSS, JavaScript (no framework)
- Deployed on Vercel

## Projects
1. RS-Abimbola ERP System *(In Progress)*
2. EDT Bet Prediction & Analysis App
3. Danfo Bus Scheduling System
4. CGPA Calculator (Java)

## Deploy
```bash
bash setup.sh
# or manually:
vercel --prod
```

## Contact
📧 damilareogunkanmi19@gmail.com
EOF

ok ".gitignore, vercel.json and README.md created."

# ── 4. Commit ────────────────────────────────────────────
step "Staging and committing files..."
git add .
git commit -m "🚀 Initial commit — Ogunkanmi Taiwo portfolio" 2>/dev/null \
  || warn "Nothing new to commit (already up to date)."
ok "Commit done."

# ── 5. GitHub remote ─────────────────────────────────────
step "GitHub remote setup..."
echo -e "${ORANGE}Paste your GitHub repo URL and press Enter${NC}"
echo -e "  (e.g. https://github.com/yourusername/portfolio.git)"
echo -e "  Leave blank to skip:"
read -r REMOTE_URL

if [ -n "$REMOTE_URL" ]; then
  git remote remove origin 2>/dev/null || true
  git remote add origin "$REMOTE_URL"
  git branch -M main
  git push -u origin main
  ok "Pushed to GitHub ✓"
else
  warn "Skipped. Add remote later with:"
  echo -e "  ${CYAN}git remote add origin <your-repo-url>${NC}"
  echo -e "  ${CYAN}git branch -M main && git push -u origin main${NC}"
fi

# ── 6. Vercel deploy ─────────────────────────────────────
step "Vercel deploy..."
if ! command -v vercel &>/dev/null; then
  warn "Vercel CLI not found — installing..."
  npm install -g vercel
  ok "Vercel CLI installed."
else
  ok "Vercel CLI found ($(vercel --version))."
fi

echo -e "\n${ORANGE}Deploy to Vercel now? (y/n)${NC}"
read -r GO

if [[ "$GO" =~ ^[Yy]$ ]]; then
  vercel --prod
  ok "Deployed! Your live URL is shown above."
else
  warn "Skipped. Deploy any time with:  ${CYAN}vercel --prod${NC}"
fi

# ── Done ─────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${GREEN}╔══════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║  All done! Portfolio is live.        ║${NC}"
echo -e "${BOLD}${GREEN}╚══════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${BOLD}Still to do:${NC}"
echo -e "  • Update GitHub / LinkedIn / Twitter links in index.html"
echo -e "  • Link your CV PDF to the Download CV button"
echo -e "  • Add project screenshots in the browser"
echo -e "  • Push updates with:  ${CYAN}git add . && git commit -m 'update' && git push${NC}"
echo -e "  • Redeploy with:      ${CYAN}vercel --prod${NC}"
echo ""
