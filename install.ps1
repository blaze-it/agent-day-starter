# Agent Day starter — instalator pro Windows
# https://github.com/blaze-it/agent-day-starter
#
# Pouziti:
#   irm https://get.blaze.codes/agent-day.ps1 | iex
#
# Idempotentni — muzete spustit vicekrat.

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"   # rychlejsi Invoke-WebRequest

function Section($title) {
    Write-Host ""
    Write-Host "— $title" -ForegroundColor Cyan
}
function Info($msg)  { Write-Host "▸ $msg" }
function OK($msg)    { Write-Host "✓ $msg" -ForegroundColor Green }
function Warn($msg)  { Write-Host "⚠ $msg" -ForegroundColor Yellow }
function Fail($msg)  { Write-Host "✗ $msg" -ForegroundColor Red; exit 1 }

function Has($cmd) {
    return [bool](Get-Command $cmd -ErrorAction SilentlyContinue)
}

# ===== Banner =====
Write-Host @"

  +---------------------------------------------------+
  |          Agent Day starter — instalace            |
  |                Blaze · Ostrava                    |
  +---------------------------------------------------+

"@

# ===== Detekce =====
Section "1/6 · Detekce systemu"
$winVer = [Environment]::OSVersion.Version
OK "Windows $($winVer.Major).$($winVer.Build) / $env:PROCESSOR_ARCHITECTURE"

$hasWinget = Has "winget"
if (-not $hasWinget) {
    Warn "winget neni dostupny — pouzijeme primy stahovani instalatoru."
    Warn "Pokud mate Windows 10 starsi nez 1809, nektere kroky mohou selhat."
}

# ===== Node.js =====
Section "2/6 · Node.js"
if (Has "node") {
    $nodeVer = (node --version)
    $nodeMajor = [int]($nodeVer -replace 'v([0-9]+)\..*', '$1')
    if ($nodeMajor -ge 20) {
        OK "Node.js $nodeVer — OK"
    } else {
        Warn "Node.js $nodeVer starsi nez LTS, instaluji novejsi"
        $installNode = $true
    }
} else {
    Info "Node.js neni, instaluji…"
    $installNode = $true
}

if ($installNode) {
    if ($hasWinget) {
        winget install --id OpenJS.NodeJS.LTS --silent --accept-source-agreements --accept-package-agreements
    } else {
        # Stahnout primo z nodejs.org
        $url = "https://nodejs.org/dist/latest-v20.x/node-v20.18.0-x64.msi"
        $msi = Join-Path $env:TEMP "node-lts.msi"
        Invoke-WebRequest -Uri $url -OutFile $msi
        Start-Process msiexec.exe -ArgumentList "/i `"$msi`" /quiet /norestart" -Wait
        Remove-Item $msi -ErrorAction SilentlyContinue
    }
    # Refresh PATH for this session
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    OK "Node.js nainstalovan"
}

# ===== Git =====
Section "3/6 · Git"
if (Has "git") {
    OK "Git $((git --version) -replace 'git version ','') — OK"
} else {
    Info "Git neni, instaluji…"
    if ($hasWinget) {
        winget install --id Git.Git --silent --accept-source-agreements --accept-package-agreements
    } else {
        $url = "https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/Git-2.43.0-64-bit.exe"
        $exe = Join-Path $env:TEMP "git-installer.exe"
        Invoke-WebRequest -Uri $url -OutFile $exe
        Start-Process $exe -ArgumentList "/VERYSILENT /NORESTART" -Wait
        Remove-Item $exe -ErrorAction SilentlyContinue
    }
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    OK "Git nainstalovan"
}

# ===== GitHub CLI =====
Section "4/6 · GitHub CLI"
if (Has "gh") {
    $ghVer = ((gh --version) -split "`n")[0]
    OK "$ghVer — OK"
} else {
    Info "Instaluji GitHub CLI…"
    if ($hasWinget) {
        winget install --id GitHub.cli --silent --accept-source-agreements --accept-package-agreements
    } else {
        Warn "Bez wingetu preskakuji GitHub CLI — nainstalujte rucne z https://cli.github.com/"
    }
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    if (Has "gh") { OK "GitHub CLI nainstalovan" }
}

# ===== Claude Code =====
Section "5/6 · Claude Code"
if (Has "claude") {
    OK "Claude Code je nainstalovany"
} else {
    Info "Instaluji Claude Code…"
    npm install -g "@anthropic-ai/claude-code"
    OK "Claude Code nainstalovan"
}

# ===== Klonovani =====
Section "6/6 · Starter agent"
$dest = if ($env:AGENT_DAY_DEST) { $env:AGENT_DAY_DEST } else { Join-Path $HOME "agent-day-starter" }

if (Test-Path (Join-Path $dest ".git")) {
    OK "Starter uz existuje v $dest — preskakuji klonovani"
    Info "Pro aktualizaci spustte:  cd '$dest'; git pull"
} else {
    if (Test-Path $dest) {
        Fail "Cesta $dest existuje, ale neni to git repo. Smazte ji a spustte znovu."
    }
    Info "Klonuji starter do $dest…"
    git clone --depth 1 https://github.com/blaze-it/agent-day-starter.git $dest
    OK "Starter naklonovan"
}

# ===== Hotovo =====
Write-Host @"

  +---------------------------------------------------+
  |                    Hotovo! ✓                      |
  +---------------------------------------------------+

  Dalsi krok:

      cd $dest
      claude

  Pri prvnim spusteni Claude Code:
    1. Otevre prohlizec k prihlaseni Anthropic uctem
       (nebo Claude Max — pokud ho mate)
    2. Po prihlaseni napiste v Claude Code:  /denni-report

  Plna dokumentace:
    https://github.com/blaze-it/agent-day-starter

  Pomoc behem 14denni podpory:
    team@blaze.codes  ·  predmet "Agent Day support — <vase firma>"

"@
