# Git & GitHub — Step-by-Step Tutorial

> Everything you need to go from zero to managing code on GitHub.
> Follow each step exactly as written. Commands are shown in `code blocks`.

---

## Prerequisites

Before you begin, install these two tools on your Windows machine:

### Install Git

```
winget install --id Git.Git -e
```

### Install GitHub CLI

```
winget install --id GitHub.cli -e
```

After installing, **close and reopen your terminal** so the new commands are available.

### Verify Installation

```
git --version
gh --version
```

You should see version numbers for both tools. If not, restart your terminal.

---

## Part 1 — Create a New Repository

### Step 1: Authenticate with GitHub

This connects your terminal to your GitHub account. You only need to do this once.

```
gh auth login -p https -w
```

**What happens:**
1. The terminal shows a one-time code (e.g., `A1B2-C3D4`)
2. Your browser opens to `https://github.com/login/device`
3. Enter the code in the browser
4. Click "Authorize" to approve

**Verify it worked:**

```
gh auth status
```

You should see: `Logged in to github.com as YOUR_USERNAME`

### Step 2: Configure Your Git Identity

Git needs to know your name and email for commits. Set this once globally:

```
git config --global user.name "Your Full Name"
git config --global user.email "your.email@example.com"
```

**Verify:**

```
git config --global user.name
git config --global user.email
```

### Step 3: Create Your Project Folder

Pick a location and create a new folder for your project:

```
mkdir my-website
cd my-website
```

### Step 4: Create Your Website Files

Create these three files inside the `my-website` folder:

**index.html:**

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Website</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <header>
        <h1>Welcome to My Website</h1>
    </header>
    <main>
        <p>Hello! This is my first website managed with Git and GitHub.</p>
    </main>
    <script src="script.js"></script>
</body>
</html>
```

**style.css:**

```css
body {
    font-family: Arial, sans-serif;
    max-width: 800px;
    margin: 0 auto;
    padding: 20px;
}

header {
    background: #0366d6;
    color: white;
    padding: 20px;
    border-radius: 8px;
}
```

**script.js:**

```javascript
document.addEventListener('DOMContentLoaded', () => {
    console.log('Website loaded successfully!');
});
```

### Step 5: Initialize a Git Repository

This tells Git to start tracking changes in this folder:

```
git init
```

**What happens:** Git creates a hidden `.git` folder that stores all version history.

### Step 6: Stage and Commit Your Files

**Staging** = selecting which files to include in your next snapshot.
**Committing** = saving that snapshot with a description.

```
git add .
git commit -m "Initial commit: simple website with HTML, CSS, and JS"
```

- `git add .` — stages ALL files in the current folder
- `git commit -m "message"` — saves the snapshot with your message

### Step 7: Create a GitHub Repository and Push

This single command creates a repo on GitHub AND uploads your code:

```
gh repo create my-website --public --source=. --push
```

**What each flag means:**
- `my-website` — the name of your new GitHub repo
- `--public` — anyone can see it (use `--private` for private)
- `--source=.` — use the current folder as the source
- `--push` — immediately upload your commits

**After this, your code is live at:** `https://github.com/YOUR_USERNAME/my-website`

---

## Part 2 — Make Changes Using a Pull Request

Pull Requests (PRs) are how teams review and approve changes before merging them into the main codebase. Even for solo projects, they're a good habit.

### Step 8: Create a Feature Branch

A **branch** is a separate line of development. The `main` or `master` branch is your stable code. Feature branches are where you experiment.

```
git checkout -b add-dark-mode
```

**What this does:**
- Creates a new branch called `add-dark-mode`
- Switches you to that branch immediately

**Verify which branch you're on:**

```
git branch
```

The `*` shows your current branch.

### Step 9: Make Your Changes

Edit your files. For example, add a dark mode button to `index.html`, add dark mode CSS to `style.css`, and add toggle logic to `script.js`.

The key thing: make your changes while on the feature branch, not on `main`/`master`.

### Step 10: Commit and Push Your Branch

```
git add .
git commit -m "Add dark mode toggle feature"
git push -u origin add-dark-mode
```

- `git push -u origin add-dark-mode` — uploads your branch to GitHub
- `-u` sets up tracking so future `git push` commands know where to go

### Step 11: Open a Pull Request

```
gh pr create --title "Add dark mode toggle" --body "Adds a dark mode button that toggles between light and dark themes."
```

**What happens:**
- A PR is created on GitHub
- The terminal shows the PR URL (e.g., `https://github.com/YOU/my-website/pull/1`)
- You (or a teammate) can review the changes on GitHub before merging

### Step 12: Merge the Pull Request

Once you're happy with the changes:

```
gh pr merge 1 --merge --delete-branch
```

**What each flag means:**
- `1` — the PR number
- `--merge` — use a merge commit (keeps history)
- `--delete-branch` — deletes the feature branch after merging (cleanup)

**What happens:**
- Your changes are merged into `master`/`main`
- The `add-dark-mode` branch is deleted (both locally and on GitHub)
- You're switched back to the `master` branch automatically

---

## Part 3 — Work with Existing Repositories

### Step 13: List All Your GitHub Repositories

```
gh repo list
```

This shows all repos in your GitHub account with their names, visibility (public/private), and last update time.

### Step 14: Clone a Repository

**Cloning** = downloading a GitHub repo to your local machine.

```
gh repo clone YOUR_USERNAME/REPO_NAME
```

For example:

```
gh repo clone snchande/testgit
cd testgit
```

**What happens:**
- Downloads all the code and full history
- Sets up `origin` as the remote pointing to GitHub
- You're ready to work

### Step 15: Create a Branch and Make Changes

Same workflow as before:

```
git checkout -b update-homepage
```

Edit your files, then:

```
git add .
git commit -m "Modernize homepage with proper HTML5 structure"
git push -u origin update-homepage
```

### Step 16: Create and Merge the PR

```
gh pr create --title "Modernize homepage" --body "Updates index.html with proper HTML5 structure."
gh pr merge 1 --merge --delete-branch
```

### Step 17: Clean Up the Local Clone

Once you're done and the PR is merged, your code is safe on GitHub. You can delete the local folder:

**Verify GitHub is in sync first:**

```
git log --oneline -3
```

**Then delete the local clone (Windows PowerShell):**

```
cd ..
Remove-Item -Recurse -Force .\testgit
```

> ⚠️ **Important:** This only deletes the folder on YOUR computer. The repository and all its history remain safe on GitHub. You can always clone it again later.

---

## Quick Reference — The Full Workflow

```
# ONE-TIME SETUP
gh auth login -p https -w
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# CREATE A NEW REPO
mkdir my-project && cd my-project
git init
# ... create your files ...
git add .
git commit -m "Initial commit"
gh repo create my-project --public --source=. --push

# MAKE CHANGES VIA PR
git checkout -b feature-name
# ... edit files ...
git add .
git commit -m "Describe your changes"
git push -u origin feature-name
gh pr create --title "Title" --body "Description"
gh pr merge NUMBER --merge --delete-branch

# WORK WITH EXISTING REPO
gh repo list
gh repo clone USERNAME/REPO
cd REPO
git checkout -b branch-name
# ... edit files ...
git add . && git commit -m "Changes" && git push -u origin branch-name
gh pr create --title "Title" --body "Description"
gh pr merge NUMBER --merge --delete-branch

# CLEANUP
cd ..
Remove-Item -Recurse -Force .\REPO
```

---

## Glossary

| Term | Meaning |
|------|---------|
| **Repository (Repo)** | A folder tracked by Git, containing your code and its full history |
| **Commit** | A saved snapshot of your code at a point in time |
| **Branch** | A separate line of development (like a parallel universe for your code) |
| **Main / Master** | The default, stable branch |
| **Remote** | The copy of your repo on GitHub (called `origin`) |
| **Clone** | Download a GitHub repo to your local machine |
| **Push** | Upload your local commits to GitHub |
| **Pull** | Download the latest changes from GitHub to your local machine |
| **Pull Request (PR)** | A request to merge your branch into the main branch, with review |
| **Merge** | Combine changes from one branch into another |
| **Stage (git add)** | Select files to include in your next commit |
| **HEAD** | A pointer to your current commit/branch |
