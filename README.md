# 👻 ghostab

Open your projects instantly — launch a full set of Ghostty tabs, each rooted in the right directory, with a single command.

If you use [Ghostty](https://ghostty.org) on macOS and juggle multiple projects, tab presets eliminate the repetitive `cd`-ing every time you sit down to work. Define your workspace once, then spin it up in seconds.

---

## ✨ Features

- Generate tab-preset scripts from any directory of projects
- Each preset opens a dedicated Ghostty window with named, pre-navigated tabs
- Manage presets with simple CLI commands (list, delete, overwrite)
- Scripts live on your PATH — call any preset from anywhere

---

## 🗂️ Example

Say you have a `~/projects` directory with three subdirectories:

```
~/projects/
├── backend/
├── frontend/
└── infra/
```

Running `create-ghostty-tabs ~/projects` prompts you for a title for each folder:

```
Title for 'backend'  [backend]: API
Title for 'frontend' [frontend]: UI
Title for 'infra'    [infra]: Infra
Script name: myapp
```

This generates a script called `myapp`. The next time you want to start work, just run:

```bash
myapp
```

Ghostty opens a new window with three tabs — **API**, **UI**, and **Infra** — each already `cd`'d into the right directory.

---

## 🚀 Usage

**Create a preset** from a directory of projects:

```bash
create-ghostty-tabs /path/to/your/projects
```

You'll be prompted to enter a tab title for each subdirectory. The generated script is saved to this repo and becomes immediately available on your PATH.

**Launch a preset** — just call it by name from any terminal:

```bash
my-preset-name
```

**List all presets:**

```bash
create-ghostty-tabs -l
```

**Delete a preset:**

```bash
create-ghostty-tabs -d <name>
```

**Show all options:**

```bash
create-ghostty-tabs -h
```

---

## 📦 Installation

**1. Clone the repo**

```bash
git clone https://github.com/ljellevo/ghostab.git
cd ghostab
```

**2. Make the tool executable**

```bash
chmod +x create-ghostty-tabs
```

**3. Add the repo to your PATH**

Append the following to your `~/.zprofile` (use `pwd` inside the repo to get the correct path):

```bash
export PATH="$PATH:/path/to/ghostab"
```

Then reload your shell:

```bash
source ~/.zprofile
```

---

## 📋 Requirements

- macOS
- [Ghostty](https://ghostty.org) terminal emulator
- `zsh` (default on macOS)

---

## 🤝 Contributing

Contributions are welcome. Open an issue or submit a pull request.
