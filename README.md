# 🕹️ Number Guessing Game 

This is a simple **Number Guessing Game** written in **x86 Assembly** using the **NASM assembler**.  
It was built and run on **Windows 10/11** using **WSL (Windows Subsystem for Linux)** with **Ubuntu** as the Linux environment.  

The game generates a random number between **0–100** and lets the player guess until they find the correct number.  

---

## 📖 Features
- ✅ Unlimited guesses until correct
- ✅ Input restricted to **0–100 only**
- ❌ Rejects negative numbers (e.g., `-5`)
- ❌ Rejects positive signs (e.g., `+42`)
- ❌ Rejects numbers greater than 100
- 🎮 After a correct guess, asks if you want to **Play Again (Y/N)**
- 👋 Exits cleanly with a goodbye message if you choose not to play again

---

## ⚙️ Prerequisites

### 1. Install WSL + Ubuntu
Make sure you have **WSL** enabled on Windows and **Ubuntu** installed.  
To check:
```powershell
wsl -l -v
