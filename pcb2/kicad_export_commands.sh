#!/bin/bash
# KiCad CLI commands used for pcb1 checks and laser-burn exports.
# Run with Git Bash from anywhere; paths are absolute.

KICAD="/c/Program Files/KiCad/10.0/bin/kicad-cli.exe"
DIR="d:/projects/ups_boards/pcb2"
SCH="$DIR/pcb1.kicad_sch"
PCB="$DIR/pcb1.kicad_pcb"

# --- Schematic checks ---

# Electrical rules check
"$KICAD" sch erc --output "$DIR/ERC.rpt" "$SCH"

# Netlist (to inspect actual net connections, e.g. grep for a component/net name)
"$KICAD" sch export netlist --output "$DIR/pcb1.net" "$SCH"

# Schematic as PDF (for viewing/printing)
"$KICAD" sch export pdf --output "$DIR/sch.pdf" "$SCH"

# --- PCB checks ---

# Design rules check
"$KICAD" pcb drc --output "$DIR/DRC.rpt" --format report "$PCB"

# --- Laser-burn SVG exports ---

# Copper layer, NOT mirrored (use if marking the same face you view directly)
"$KICAD" pcb export svg --layers F.Cu --mode-single --page-size-mode 2 --exclude-drawing-sheet \
  --output "$DIR/pcb1_Fcu.svg" "$PCB"

# Copper layer, MIRRORED (use this one: components go in from one face,
# copper/paint you're burning is on the other face, so the board gets flipped)
"$KICAD" pcb export svg --layers F.Cu --mirror --mode-single --page-size-mode 2 --exclude-drawing-sheet \
  --output "$DIR/pcb1_Fcu_mirrored.svg" "$PCB"

# Silkscreen only (component placement guide, component-side view, not mirrored)
"$KICAD" pcb export svg --layers F.SilkS --mode-single --page-size-mode 2 --exclude-drawing-sheet \
  --output "$DIR/pcb1_Silkscreen.svg" "$PCB"

# Silkscreen + Fab layer (adds component values like 10k/760R/8V2), not mirrored
"$KICAD" pcb export svg --layers F.SilkS,F.Fab --mode-single --page-size-mode 2 --exclude-drawing-sheet \
  --output "$DIR/pcb1_Silkscreen_Values.svg" "$PCB"

echo "Done."
