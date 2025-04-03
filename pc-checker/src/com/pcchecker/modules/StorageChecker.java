package com.pcchecker.modules;

import oshi.SystemInfo;
import oshi.hardware.HWDiskStore;
import oshi.hardware.HardwareAbstractionLayer;
import oshi.software.os.FileSystem;
import oshi.software.os.OSFileStore;
import oshi.software.os.OperatingSystem;

import java.util.List;

public class StorageChecker {

    public static void run() {
        SystemInfo si = new SystemInfo();
        OperatingSystem os = si.getOperatingSystem();
        HardwareAbstractionLayer hal = si.getHardware();
        FileSystem fs = os.getFileSystem();

        System.out.println("-----------------------------------------------------");
        System.out.println("--- Diagnostic du Stockage (Disques / Partitions) ---");

        List<OSFileStore> fileStores = fs.getFileStores();
        if (!fileStores.isEmpty()) {
            for (OSFileStore store : fileStores) {
                System.out.println("--- Nom : " + store.getName());
                System.out.println("Volume : " + store.getVolume());
                System.out.println("Description : " + store.getDescription());
                System.out.println("Monté sur : " + store.getMount());
                System.out.printf("Capacité totale : %.2f Go%n", store.getTotalSpace() / 1e9);
                System.out.printf("Espace utilisé : %.2f Go%n", (store.getTotalSpace() - store.getUsableSpace()) / 1e9);
                System.out.printf("Espace libre : %.2f Go%n", store.getUsableSpace() / 1e9);
            }
        } else {
            System.out.println("Aucune partition montée détectée. Analyse des disques physiques...");
            List<HWDiskStore> diskStores = hal.getDiskStores();
            if (diskStores.isEmpty()) {
                System.out.println("Aucun disque physique détecté.");
                return;
            }
            for (HWDiskStore disk : diskStores) {
                System.out.println("--------------------------------------------------");
                System.out.println("Nom du disque : " + disk.getName());
                System.out.println("Modèle : " + disk.getModel());
                System.out.printf("Taille : %.2f Go%n", disk.getSize() / 1e9);
                System.out.println("Nombre de partitions : " + disk.getPartitions().size());
                System.out.println("Temps d'activité : " + disk.getTransferTime() + " ms");
            }
        }
    }
}
