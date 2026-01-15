# Developer Environment Setup

ThePrimeagen-style tmux + neovim setup for fast navigation and editing.

## Philosophy: The Two-Layer Workflow

```
┌─────────────────────────────────────────────────────────────┐
│  TMUX (Project Layer)                                       │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │ Session:    │ │ Session:    │ │ Session:    │           │
│  │ heyo        │ │ mvm-ctrl    │ │ personal    │           │
│  │             │ │             │ │             │           │
│  │ ┌─────────┐ │ │ ┌─────────┐ │ │ ┌─────────┐ │           │
│  │ │ neovim  │ │ │ │ neovim  │ │ │ │ neovim  │ │           │
│  │ └─────────┘ │ │ └─────────┘ │ │ └─────────┘ │           │
│  │ ┌─────────┐ │ │             │ │             │           │
│  │ │terminal │ │ │             │ │             │           │
│  │ └─────────┘ │ │             │ │             │           │
│  └─────────────┘ └─────────────┘ └─────────────┘           │
│                                                             │
│  C-a f = fuzzy switch    C-a H/M/P = direct jump           │
└─────────────────────────────────────────────────────────────┘
```

### tmux = Project Manager
- Each **project** gets its own **tmux session**
- Sessions persist even if you disconnect
- `tmux-sessionizer` fuzzy-finds projects and creates/switches sessions
- Use `C-a f` to switch projects, `C-a p/n` to switch windows within a project

### neovim = Code Editor
- One neovim instance per project
- Use telescope to find files (`<leader>pf`) and grep (`<leader>ps`)
- Use harpoon to bookmark hot files (`<leader>a`, then `<leader>1-4`)

### Terminal for a Project
Within a tmux session, you have options:

1. **New window**: `C-a c` creates a new window, `C-a p/n` to switch
2. **Split pane**: `C-a |` vertical, `C-a -` horizontal, `C-a h/j/k/l` to navigate
3. **From neovim**: `C-f` opens sessionizer, `:terminal` opens terminal in neovim

**Typical workflow:**
```
Window 1: neovim (editing)
Window 2: terminal (running server, tests, etc.)
C-a n/p to switch between them
```

---

## Quick Start

### Prerequisites

**macOS:**
```bash
brew install tmux fzf neovim ripgrep fd
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install tmux fzf neovim ripgrep fd-find xclip
```

**Linux (Arch):**
```bash
sudo pacman -S tmux fzf neovim ripgrep fd xclip
```

### 1. Neovim Config
```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.bak

# Clone this repo
git clone https://github.com/gator1/init.lua.git ~/.config/nvim
```

### 2. tmux Config
```bash
# macOS
ln -sf ~/.config/nvim/.tmux.conf ~/.tmux.conf

# Linux: copy and fix clipboard
cp ~/.config/nvim/.tmux.conf ~/.tmux.conf
sed -i 's/pbcopy/xclip -in -selection clipboard/' ~/.tmux.conf
```

### 3. tmux-sessionizer
```bash
mkdir -p ~/.local/bin
curl -o ~/.local/bin/tmux-sessionizer \
  https://raw.githubusercontent.com/ThePrimeagen/tmux-sessionizer/master/tmux-sessionizer
chmod +x ~/.local/bin/tmux-sessionizer

# Add to PATH (add to ~/.zshrc or ~/.bashrc)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
```

### 4. Sessionizer Config
```bash
mkdir -p ~/.config/tmux-sessionizer
cat > ~/.config/tmux-sessionizer/tmux-sessionizer.conf << 'EOF'
TS_SEARCH_PATHS=(
    ~/dev
    ~/projects
    ~/personal
)
TS_MAX_DEPTH=2
EOF
```

### 5. First Launch
1. Start tmux: `tmux`
2. Open neovim: `nvim`
3. Wait for plugins to auto-install
4. Restart neovim
5. Run `:Mason` to install LSP servers

---

## Key Bindings

### tmux (prefix = Ctrl+a)

| Key | Action |
|-----|--------|
| `C-a r` | Reload config |
| `C-a f` | Fuzzy find projects (sessionizer) |
| `C-a ^` | Last window |
| `C-a h/j/k/l` | Navigate panes |
| `C-a p/n` | Previous/next window |
| `C-a \|` | Vertical split |
| `C-a -` | Horizontal split |
| `C-a D` | Open TODO.md |

### Neovim (leader = Space)

| Key | Action |
|-----|--------|
| `<leader>pv` | File explorer |
| `<leader>pf` | Find files |
| `<leader>ps` | Grep search |
| `C-p` | Git files |
| `C-f` | Open sessionizer |
| `<leader>y` | Yank to clipboard |
| `<leader>s` | Search/replace word |
| `C-d/C-u` | Half-page down/up (centered) |

---

---

## Plugins Guide

### Core Navigation

#### **telescope** - Fuzzy Finder
Find files, grep text, search anything.
```
<leader>pf  → Find files in project
<leader>ps  → Grep text (searches hidden dirs too)
<leader>pws → Grep word under cursor
C-p         → Git files only
<leader>vh  → Search help tags
```

#### **harpoon** - File Bookmarks
Quick jump between your 4 most-used files in a project.
```
<leader>a   → Add current file to harpoon
C-e         → Open harpoon menu
<leader>1-4 → Jump to bookmarked file 1-4
```

#### **undotree** - Undo History
Visual undo tree - never lose changes.
```
<leader>u   → Toggle undotree panel
```

### Git

#### **fugitive** - Git Integration
Full git workflow without leaving neovim.
```
<leader>gs  → Git status (interactive)
<leader>p   → Git pull
<leader>P   → Git push
```
In status view: `s` to stage, `u` to unstage, `cc` to commit

### Code Intelligence

#### **lsp** - Language Server Protocol
Auto-completion, go-to-definition, diagnostics.
```
gd          → Go to definition
K           → Hover documentation
<leader>vd  → Show diagnostic float
<leader>vca → Code actions
<leader>vrn → Rename symbol
<leader>vrr → Find references
[d / ]d     → Previous/next diagnostic
```

#### **treesitter** - Syntax Highlighting
Better syntax highlighting and code understanding. Auto-installed.

#### **conform** - Formatting
Auto-format on save. Configure formatters in `lua/theprimeagen/lazy/conform.lua`.
```
<leader>f   → Format current file
```

#### **trouble** - Diagnostics List
Pretty list of all errors/warnings.
```
:Trouble    → Open trouble window
```

### Debugging & Testing

#### **dap** - Debug Adapter Protocol
Debugging support for multiple languages.
```
<leader>b   → Toggle breakpoint
<leader>B   → Conditional breakpoint
<leader>dr  → Toggle REPL
<leader>ds  → Toggle stack trace
<leader>dw  → Toggle watches
```

#### **neotest** - Test Runner
Run tests from within neovim.
```
<leader>tr  → Run nearest test
<leader>tv  → Run tests in file
<leader>td  → Debug nearest test
<leader>to  → Show test output
<leader>ts  → Toggle test summary
```

### Editing

#### **snippets** (LuaSnip) - Code Snippets
Expandable code templates.
```
C-s e       → Expand snippet
C-s ;       → Jump to next placeholder
C-s ,       → Jump to previous placeholder
```

#### **whichkey** - Keybinding Help
Press leader and wait - shows available keybindings.

### Focus

#### **zenmode** - Distraction-Free Writing
Center the buffer, hide distractions.
```
<leader>zz  → Toggle zen mode
<leader>zZ  → Toggle zen mode (narrower)
```

#### **cloak** - Hide Secrets
Automatically hides API keys and secrets in `.env` files.

### AI

#### **amp** - AI Assistant
Sourcegraph Amp integration.

**Install:**
```bash
curl -fsSL https://ampcode.com/install.sh | bash
```

**Run:** In a tmux window alongside neovim:
```bash
amp --ide
```
The `--ide` flag connects to neovim (via amp.nvim) to see your open files and cursor.

**Keybindings:**
```
<leader>Aa  → Start Amp
<leader>As  → Amp status
<leader>Am  → Send message to Amp
<leader>Ab  → Send buffer to Amp
```

#### **supermaven** - AI Completion
AI-powered code completion (like Copilot).

### Fun

#### **vimbegood** - Practice Vim Motions
`:VimBeGood` to practice vim movements.

#### **golf** - Code Golf
`:Golf` to play code golf challenges.

---

## Troubleshooting

**Clipboard not working (Linux):** Install `xclip`

**Colors look wrong:** Add to shell rc: `export TERM=xterm-256color`

**Sessionizer not finding projects:** Edit `~/.config/tmux-sessionizer/tmux-sessionizer.conf`

---

## Original README

<details>
<summary>Click to expand ThePrimeagen's original README</summary>

### ThePrimeagen's init.lua
Prerequisite: install [ripgrep](https://github.com/BurntSushi/ripgrep).

[The full video of me setting up this repo](https://www.youtube.com/watch?v=w7i4amO_zaE)

For anyone that is interested in my vimrc, i will have a commit log below
documenting each one of my commits (easy to C-f the change you want to know
about though i would just suggest `git log -S`).

### Change Log
* [33eee9ad](https://github.com/ThePrimeagen/init.lua/commit/33eee9ad0c035a92137d99dae06a2396be4c892e) initial commits
* [cb210006](https://github.com/ThePrimeagen/init.lua/commit/cb210006356b4b613b71c345cb2b02eefa961fc0) netrw, autogroups for yank highlighting, and auto remove whitespace
* [c8c0bf4a](https://github.com/ThePrimeagen/init.lua/commit/c8c0bf4aeacd0bd77136d9c5ee490680515a106b) zenmode.  i really like this plugin
* [81c770d2](https://github.com/ThePrimeagen/init.lua/commit/81c770d2d2e32e59916b39c7f5babbc8560f7a82) copilot testing
* [4a96e645](https://github.com/ThePrimeagen/init.lua/commit/4a96e6457b0a0241ca7361ce62177aa6b9a33a38) fugitive mappings for push and pull
* [a3bad06a](https://github.com/ThePrimeagen/init.lua/commit/a3bad06a4681c322538d609aa1c0bd18880f77c6) disabled eslint.  driving me crazy

* [06dd49e](https://github.com/ThePrimeagen/init.lua/commit/06dd49ec0986f918b6ceb927a2b8e27163ed8df6) fixed, remove personal plugins, now on lazy.
* [f639396](https://github.com/ThePrimeagen/init.lua/commit/f639396ffcb7901ff8ba7387df5e78bc3226ead3) tmux
* [e911c5e](https://github.com/ThePrimeagen/init.lua/commit/e911c5e0bc19250a6c40b48ea9d106b96157d0b2) tmux

</details>



