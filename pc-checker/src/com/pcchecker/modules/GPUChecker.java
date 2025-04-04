package com.pcchecker.modules;

import oshi.SystemInfo;
import oshi.hardware.GraphicsCard;
import oshi.hardware.HardwareAbstractionLayer;

import java.util.List;

public class GPUChecker {

    public static void run() {
        SystemInfo si = new SystemInfo();
        HardwareAbstractionLayer hal = si.getHardware();

        List<GraphicsCard> gpus = hal.getGraphicsCards();

        System.out.println("-----------------------------------------");
        System.out.println("----- Analyse des Cartes Graphiques -----");
        System.out.println("-----------------------------------------");

        if (gpus.isEmpty()) {
            System.out.println("Aucune carte graphique detectee.");
            return;
        }

        for (GraphicsCard gpu : gpus) {
            System.out.println("Nom : " + gpu.getName());
            System.out.println("Fabricant : " + gpu.getVendor());
            System.out.println("Memoire video : " + formatBytes(gpu.getVRam()));
            System.out.println("Device ID : " + gpu.getDeviceId());
            System.out.println("Version pilote : " + gpu.getVersionInfo());
        }
    }

    private static String formatBytes(long bytes) {
        double gb = bytes / 1e9;
        return String.format("%.2f Go", gb);
    }
}
