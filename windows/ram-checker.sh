#!/bin/bash

# Script : ram-checker.sh
# Description : Récupère de manière robuste les informations détaillées sur la RAM sous Windows
# exemple : 
# bash ram-checker.sh
# -----------------------------
# -- INFORMATIONS SUR LA RAM --
# RAM totale : 16 Go
# RAM utilisée : 6 Go
# RAM disponible : 10 Go
# BankLabel : BANK 0 (DIMM 0)
# Capacity : 8589934592 o
# MemoryType : 24 (DDR4)
# Speed : 2400 mhz
# TypeDetail : 128 (Synchronous)
# -----------------------------

# Informations générales
echo "-----------------------------"
echo "-- INFORMATIONS SUR LA RAM --"
echo "RAM totale : $(wmic ComputerSystem get TotalPhysicalMemory | awk 'NR==2{print $1/1e9" Go"}')"
echo "RAM utilisée : $(wmic OS get FreePhysicalMemory | awk 'NR==2{print $1/1e6" Go"}')"
echo "RAM disponible : $(wmic OS get FreePhysicalMemory | awk 'NR==2{print $1/1e6" Go"}')"
echo "BankLabel : $(wmic MemoryChip get BankLabel | awk 'NR==2{print $1}')"
echo "Capacity : $(wmic MemoryChip get Capacity | awk 'NR==2{print $1" o"}')"
echo "MemoryType : $(wmic MemoryChip get MemoryType | awk 'NR==2{print $1" (DDR4)"}')"
echo "Speed : $(wmic MemoryChip get Speed | awk 'NR==2{print $1" mhz"}')"
echo "TypeDetail : $(wmic MemoryChip get TypeDetail | awk 'NR==2{print $1" (Synchronous)"}')"