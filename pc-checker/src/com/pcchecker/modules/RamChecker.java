package com.pcchecker.modules;

import oshi.SystemInfo;
import oshi.hardware.GlobalMemory;
import oshi.hardware.HardwareAbstractionLayer;
import oshi.hardware.PhysicalMemory;

import java.util.List;

public class RamChecker {

    public static void run() {
        SystemInfo systemInfo = new SystemInfo();
        HardwareAbstractionLayer hal = systemInfo.getHardware();
        GlobalMemory memory = hal.getMemory();

        System.out.println("----------------------------------");
        System.out.println("--- Analyse de la Mémoire Vive ---");

        long total = memory.getTotal();
        long available = memory.getAvailable();
        long used = total - available;

        System.out.printf("Capacité totale : %.2f Go%n", total / 1e9);
        System.out.printf("Utilisée : %.2f Go%n", used / 1e9);
        System.out.printf("Disponible : %.2f Go%n", available / 1e9);

        List<PhysicalMemory> physicalMemoryList = memory.getPhysicalMemory();
        System.out.println("Nombre de barrettes détectées : " + physicalMemoryList.size());

        int i = 1;
        for (PhysicalMemory stick : physicalMemoryList) {
            System.out.println("  ▸ Barrette #" + i++);
            System.out.printf("    - Capacité : %.2f Go%n", stick.getCapacity() / 1e9);
            System.out.println("    - Type : " + stick.getMemoryType());
            System.out.println("    - Fréquence : " + stick.getClockSpeed() / 1e6 + " MHz");
            System.out.println("    - Emplacement : " + stick.getBankLabel());
        }
    }
}
