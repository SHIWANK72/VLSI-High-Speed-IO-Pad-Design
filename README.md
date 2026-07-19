# VLSI High-Speed Digital I/O Pad Design
 
**Nik-Coronics | Independent R&D Initiative**
**Engineer:** Shiwank Gupta
**Date:** 2024 – 2026 (Ongoing)
**Tools:** LTSpice 26.0.2.1 · Sky130A SPICE Models · OpenLane · Sky130A PDK
 
---
 
## 🎯 Project Overview
 
Design and verification of a **high-speed, bidirectional digital I/O pad** — a critical
interface component in ICs that connects the internal chip core to the external world.
 
This project covers the complete flow from **transistor-level SPICE simulation** to
**physical layout via OpenLane + Sky130A PDK**, with focus on:
 
- ESD protection circuitry (ggNMOS clamp + diode network)
- Output driver sizing (tapered inverter chain)
- Signal integrity under varying capacitive loads
- RTL-to-GDSII physical implementation
---
 
## 📐 I/O Pad Architecture
 
```
External Pin
     │
     ▼
┌─────────────────────────────────────────┐
│           ESD CLAMP NETWORK             │
│   Primary:  ggNMOS + diode-to-VDD       │
│   Secondary: series resistor + clamp    │
└─────────────┬───────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────┐
│         INVERTER CHAIN DRIVER           │
│   Stage 1: x1  (min size)              │
│   Stage 2: x4                          │
│   Stage 3: x16                         │
│   Stage 4: x64  (output driver)        │
└─────────────┬───────────────────────────┘
              │
              ▼
         Internal Core
         (CL = 5–50 pF)
```
 
---
 
## 🔑 Key Design Parameters
 
```
Technology     : Sky130A — SkyWater 130nm Open-Source PDK
Supply Voltage : 1.8V (core) / 3.3V (I/O)
Target Speed   : High-speed digital I/O
ESD Target     : HBM (Human Body Model) protection
Driver Load    : 5 pF / 10 pF / 50 pF sweep
Simulator      : LTSpice 26.0.2.1
SPICE Models   : sky130_fd_pr (Google SkyWater PDK)
```
 
---
 
## 📐 Phase 1 — SPICE Simulation (LTSpice)
 
### Circuit 1: ESD Clamp Network
 
```
ESD event → Primary clamp (ggNMOS):
  Gate grounded, drain to pad, source to VSS
  Triggers at V_t1 (snapback voltage)
  Discharges HBM current safely to ground
 
Secondary protection:
  Series resistor (50–100 Ω) to limit current
  Diode to VDD for positive ESD events
  Diode to VSS for negative ESD events
```
 
**Simulation:** 2 kV HBM pulse (100 pF || 1.5 kΩ) applied to pad
 
### Circuit 2: Tapered Inverter Chain
 
```
Driver sizing formula:
  Optimal tapering ratio f = (C_load / C_in)^(1/N)
  N = number of stages
 
Stage sizing:
  Stage 1: W_p/W_n = 4/2  μm
  Stage 2: W_p/W_n = 16/8 μm
  Stage 3: W_p/W_n = 64/32 μm
  Stage 4: W_p/W_n = 256/128 μm (output)
```
 
### Circuit 3: Full I/O Pad Integration
 
```
ESD clamp → Series R → Driver chain → External CL
 
Simulation sweeps:
  CL = 5 pF   (light load)
  CL = 10 pF  (nominal)
  CL = 50 pF  (heavy load)
```
 
---
 
## 📊 Simulation Results
 
> ⚠️ Results being updated as simulation progresses.
 
| Parameter | Target | Simulated |
|---|---|---|
| Rise Time (10–90%) | < 500 ps | TBD |
| Fall Time (10–90%) | < 500 ps | TBD |
| Propagation Delay (tp) | < 1 ns | TBD |
| ESD Clamp V_trigger | ~1.6V | TBD |
| HBM Current Handled | 2 kV | TBD |
 
---
 
## 📐 Phase 2 — OpenLane Physical Design (In Progress)
 
```
RTL Wrapper → Synthesis (Yosys) →
Floorplan → Placement → CTS → 
Routing → GDSII (Magic VLSI)
 
PDK: Sky130A — sky130_fd_sc_hd
Tool: OpenLane 2023.11.03
Platform: Google Colab
```
 
---
 
## 🛠️ Tools Used
 
| Tool | Purpose | Status |
|---|---|---|
| LTSpice 26.0.2.1 | SPICE circuit simulation | ✅ Active |
| Sky130A SPICE models | Transistor models (sky130_fd_pr) | ✅ |
| OpenLane 2023.11.03 | RTL-to-GDSII flow | ⬜ Phase 2 |
| Magic VLSI | GDS stream-out | ⬜ Phase 2 |
| KLayout | Layout visualization | ⬜ Phase 2 |
 
---
 
## 📁 Repository Structure
 
```
VLSI-High-Speed-IO-Pad-Design/
├── spice/
│   ├── esd_clamp.asc          ← LTSpice ESD clamp circuit
│   ├── driver_chain.asc       ← Tapered inverter chain
│   ├── io_pad_full.asc        ← Integrated IO pad
│   └── sky130_models/         ← Sky130A SPICE models
├── rtl/
│   └── io_pad_wrapper.v       ← Verilog wrapper for OpenLane
├── results/
│   ├── esd_waveform.png       ← ESD simulation output
│   ├── driver_timing.png      ← Driver timing waveforms
│   └── load_sweep.png         ← CL sweep results
├── gds/
│   └── io_pad.gds             ← Final GDSII (Phase 2)
├── notes.md                   ← Design notes + theory
└── README.md                  ← This file
```
 
---
 
## 🔑 Key Learnings
 
```
1. ESD clamp design
   ggNMOS gate-grounded configuration —
   triggers in snapback mode at V_t1
   without any gate bias circuit needed
 
2. Driver tapering
   Optimal N stages minimizes total delay
   Trade-off: more stages = more area but
   better drive strength for large CL
 
3. Signal integrity
   Parasitic R and C from ESD network
   directly impact edge rates —
   series R must be minimized while
   maintaining ESD effectiveness
 
4. Sky130A models
   Free, open-source, industry-comparable
   SPICE models from Google/SkyWater
   Compatible with LTSpice via .include
```
 
---
 
## 📅 Project Status
 
```
✅ Literature review + design spec
✅ ESD clamp topology selected
✅ Driver chain sizing — theoretical
⬜ LTSpice ESD simulation — in progress
⬜ Driver timing simulation — in progress
⬜ Load sweep (5/10/50 pF) — pending
⬜ Full IO pad integration — pending
⬜ OpenLane RTL-to-GDSII — Phase 2
⬜ GDS layout complete — Phase 2
```
 
---
 
## 🔭 Next Steps
 
```
1. LTSpice ESD clamp simulation — HBM 2kV event
2. Driver chain sizing verification
3. Full IO pad timing analysis
4. OpenLane physical implementation
5. GDSII generation + DRC signoff
```
 
---
 
## 📬 Connect
 
Open to RTL/DV/Physical Design opportunities,
research collaborations, and mentoring.
 
**Email:** gupta.shiwank09@gmail.com
**GitHub:** github.com/SHIWANK72
**LinkedIn:** linkedin.com/in/guptashiwank
 
---
 
*Shiwank Gupta | Nik-Coronics | VLSI R&D*
