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

- ESD protection circuitry (ggNMOS clamp)
- Output driver sizing (tapered inverter chain)
- Signal integrity trade-offs under ESD loading
- RTL-to-GDSII physical implementation (Phase 2)

---

## 📐 I/O Pad Architecture

```
External Pin
     │
     ▼
┌─────────────────────────────────────────┐
│           ESD CLAMP NETWORK             │
│   ggNMOS, gate/source/body grounded     │
│   Drain tied to pad node                │
└─────────────┬───────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────┐
│         INVERTER CHAIN DRIVER           │
│   4-stage tapered inverter (~3.5x/stage)│
│   Stage 1 -> Stage 4 (output)           │
└─────────────┬───────────────────────────┘
              │
              ▼
         Internal Core
         (CL = 5 pF pad load, this phase)
```

---

## 🔑 Key Design Parameters

```
Technology     : Sky130A — SkyWater 130nm Open-Source PDK
Supply Voltage : 1.8V (core, simulated in this phase)
Target Speed   : High-speed digital I/O
ESD Target     : HBM (Human Body Model) protection, 2kV
Driver Load    : 5 pF (Phase 1 baseline)
Simulator      : LTSpice 26.0.2.1
SPICE Models   : Simplified BSIM4 models, Sky130A-parameter-matched
                 (see model compatibility note below)
```

---

## ⚠️ PDK / Simulator Compatibility Note

The official SkyWater Sky130A `.pm3.spice` primitive device files use
Monte-Carlo/mismatch-binned parametric expressions (`AGAUSS()`, deeply
nested `.param` chains). **LTSpice's expression parser does not reliably
resolve these nested references** — attempting to `.include` the raw PDK
files directly produces `No such parameter defined` errors, independent
of file path or install correctness. This is a documented, reproducible
LTSpice limitation, confirmed against multiple independent user reports
(not specific to this project's setup).

**Workaround used in Phase 1:** simplified BSIM4 `.model` cards (Level 14,
matched to Sky130A's nominal `TOX`, `VTH0`, and mobility parameters) are
used directly in LTSpice. This captures normal MOSFET conduction and
switching behavior accurately, but does **not** model avalanche/impact-
ionization-driven snapback — so it will not reproduce a real ESD clamp's
trigger-voltage / holding-voltage curve. For tape-out-grade ESD
characterization, re-running these netlists in **ngspice** against the
raw Sky130A PDK is the planned next step.

---

## 📐 Phase 1 — SPICE Simulation (LTSpice) — ✅ Complete

Full writeup, netlists, and waveforms: **[Phase1_ESD_IO_Pad/README.md](Phase1_ESD_IO_Pad/README.md)**

### Circuit 1: ESD Clamp Network

```
ESD event -> ggNMOS clamp:
  Gate, source, body grounded; drain tied to pad
  HBM tester model: 100pF || 1.5kΩ, 2kV pulse
```

Result: functional conduction validated. Simplified model does not
capture snapback (see compatibility note above) — `V(drain)` rises
un-clamped to ~76V under the 2kV HBM pulse, as expected for this model.

### Circuit 2: Tapered Inverter Chain

```
4-stage tapered inverter, 1.8V logic, ~3.5x taper per stage:
  Stage 1: Wp/Wn = 1u   / 0.5u
  Stage 2: Wp/Wn = 3.5u / 1.75u
  Stage 3: Wp/Wn = 12u  / 6u
  Stage 4: Wp/Wn = 42u  / 21u   (output, drives pad)

L = 0.15u for all devices
Pad load: 5pF (bond wire + PCB trace approximation)
```

### Circuit 3: Full I/O Pad Integration

```
Driver chain -> Pad node -> ESD clamp (permanently attached, off-state)

Confirms: ESD clamp draws ~0A during normal switching (correct
off-state behavior), while its parasitic drain capacitance adds
measurable loading to the signal path (quantified below).
```

---

## 📊 Simulation Results

| Parameter | Target | Simulated |
|---|---|---|
| Rise Time (10–90%), standalone driver | < 500 ps | **471.4 ps** |
| Fall Time (10–90%), standalone driver | < 500 ps | **553.7 ps** |
| Rise Time (10–90%), driver + ESD clamp | < 500 ps | **480.7 ps** |
| Fall Time (10–90%), driver + ESD clamp | < 500 ps | **564.0 ps** |
| ESD-induced rise time degradation | — | **+1.97%** |
| ESD-induced fall time degradation | — | **+1.86%** |
| ESD Clamp off-state current (normal ops) | ~0A | **~0A (confirmed)** |
| HBM Pulse Handled (functional, un-clamped) | 2 kV | **2 kV applied, conduction verified** |

**Key finding:** the ESD clamp's parasitic drain capacitance measurably
slows driver switching edges by ~2% — a quantified illustration of the
classic ESD-protection-vs-performance trade-off in I/O pad design.

---

## 📐 Phase 2 — OpenLane Physical Design (Planned)

```
Digital wrapper RTL (OE, direction control, pull-up/down config)
  -> Synthesis (Yosys) -> Floorplan -> Placement -> CTS ->
     Routing -> GDSII (OpenLane, automated)

Analog IO cell (ESD clamp + driver chain)
  -> Custom transistor-level layout (Magic VLSI, manual)
  -> DRC clean (Sky130A tech rules)

Integration: analog macro + digital macro -> top-level GDS -> DRC + LVS

PDK: Sky130A — sky130_fd_sc_hd (digital) + sky130_fd_pr (analog)
Tool: OpenLane, Magic VLSI
```

---

## 🛠️ Tools Used

| Tool | Purpose | Status |
|---|---|---|
| LTSpice 26.0.2.1 | SPICE circuit simulation | ✅ Complete (Phase 1) |
| Simplified BSIM4 models (Sky130A-matched) | Transistor models | ✅ |
| ngspice | Raw Sky130A PDK validation (planned) | ⬜ Future work |
| OpenLane | RTL-to-GDSII flow (digital wrapper) | ⬜ Phase 2 |
| Magic VLSI | Custom analog layout + GDS stream-out | ⬜ Phase 2 |
| KLayout | Layout visualization | ⬜ Phase 2 |

---

## 📁 Repository Structure

```
VLSI-High-Speed-IO-Pad-Design/
├── Phase1_ESD_IO_Pad/
│   ├── README.md               ← Full Phase 1 writeup + results
│   ├── spice/
│   │   ├── esd_clamp_sim.cir
│   │   ├── driver_chain_sim.cir
│   │   └── combined_io_pad_sim.cir
│   └── waveforms/
│       ├── esd_clamp_hbm_pulse.png
│       ├── driver_chain_standalone.png
│       └── combined_io_pad.png
├── rtl/
│   └── io_pad_wrapper.v       ← Phase 2 (planned)
├── gds/
│   └── io_pad.gds             ← Phase 2 (planned)
├── notes.md                   ← Design notes + theory
└── README.md                  ← This file
```

---

## 🔑 Key Learnings

```
1. ESD clamp design
   ggNMOS gate-grounded configuration — functional conduction
   verified; true snapback requires avalanche-modeled transistor
   models (raw PDK + ngspice), not achievable in LTSpice with
   simplified BSIM4 models

2. Tool/PDK compatibility is a first-class design constraint
   LTSpice cannot natively parse Sky130A's raw .pm3.spice files
   due to Monte-Carlo binned parameter expressions — this is a
   documented limitation, not a project error, and shaped the
   Phase 1 modeling approach

3. Driver tapering
   4-stage, ~3.5x taper per stage minimizes propagation delay
   for a 5pF pad load while keeping area reasonable

4. Signal integrity / ESD trade-off (quantified)
   ESD clamp parasitic capacitance measurably slows driver edges
   (~2% rise/fall time degradation) — a real, non-negligible
   design trade-off between protection strength and speed
```

---

## 📅 Project Status

```
✅ Literature review + design spec
✅ ESD clamp topology selected
✅ Driver chain sizing — theoretical + simulated
✅ LTSpice ESD clamp simulation (HBM 2kV, functional validation)
✅ Driver timing simulation (rise/fall time measured, .meas automated)
✅ Full IO pad integration (combined netlist, ESD loading quantified)
⬜ Load sweep (5/10/50 pF) — pending
⬜ ngspice validation against raw Sky130A PDK — pending
⬜ Digital wrapper RTL — Phase 2
⬜ OpenLane RTL-to-GDSII — Phase 2
⬜ Custom analog layout (Magic) — Phase 2
⬜ GDS integration + DRC/LVS signoff — Phase 2
```

---

## 🔭 Next Steps

```
1. Digital wrapper RTL (output enable, direction control)
2. OpenLane synthesis + P&R for digital wrapper
3. Custom analog layout (Magic VLSI) for ESD clamp + driver chain
4. Analog + digital macro integration, top-level GDS
5. DRC + LVS signoff
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