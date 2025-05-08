# 🔢 Davinci Code - Digital Counting Game System

 🎓 This project was completed as part of my digital system design coursework at NTUST.

This Verilog project implements a **two-phase number guessing game system**, inspired by the concept of "Davinci Code." The game allows a user to set a secret number in the first phase and try to guess it using limited button operations in the second phase. It is designed for FPGA deployment and uses FSM-based logic with seven-segment display output and LED indicators.

---

## 🧠 Game Concept

### Phase 1 – Initial Counting
- Set a number between **0–99** using the following buttons:
  - `add1`, `add10`, `sub1`, `sub10`
- Press `clear` to enter guessing phase.
- The selected number is stored in `memory`.

### Phase 2 – Guessing Phase (Match Mode)
- Use the following buttons to increment your guess:
  - `add_1`, `add2`, `add3`, `add5`, `add10`
- When the guess (`count_new`) reaches or exceeds the target (`memory`), an **LED lights up**.
- Both phases use `se1` and `se2` to show numbers on two 7-segment displays.

---

## 🧩 Module Summary

- `Guassnumber` (main module):
  - FSM with internal register control
  - Handles button inputs and transitions between phases
  - Displays current value using `se1` and `se2`
  - Turns on `light` when match is successful

---

## 🛠️ Required Hardware (Simulated or Real)

- 🧮 2x 7-segment displays (`se1`, `se2`)
- 🔘 8 buttons:
  - `add1`, `add10`, `sub1`, `sub10`, `add_1`, `add2`, `add3`, `clear`
- 💡 1 LED (`light`) for match success indicator
- ⏱️ 1 Clock signal
- 🔁 1 Reset signal (`rst`)

---

## ▶️ Simulation Instructions

You can simulate using **ModelSim**, **Vivado**, or **Quartus**.

```bash
# Compile
vlog davinci_code.v
# Run
vsim Guassnumber
```
---

## 📁 Folder Structure
davinci-counting-game/
├── davinci_code.v        # Main Verilog logic
└── README.md             # Project documentation

---
## 👨‍💻 Author

**Kuan-Yu (Eric) Liao**  
B.Sc. in Electrical Engineering, NTUST  
[LinkedIn Profile](https://www.linkedin.com/in/kuan-yu-liao-a58452235)

---

## 📜 License

MIT License – free to use, modify, and distribute with attribution.
