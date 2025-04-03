package com.pcchecker.modules;

import oshi.SystemInfo;
import oshi.hardware.HWDiskStore;
import oshi.hardware.HardwareAbstractionLayer;
import oshi.software.os.FileSystem;
import oshi.software.os.OSFileStore;
import oshi.software.os.OperatingSystem;
import com.pcchecker.utils.DiskUtils;
import com.pcchecker.utils.PhysicalDiskInspector;

import java.util.List;
import java.util.Map;

public class StorageChecker {

    public static void run() {
        SystemInfo si = new SystemInfo();
        OperatingSystem os = si.getOperatingSystem();
        HardwareAbstractionLayer hal = si.getHardware();
        FileSystem fs = os.getFileSystem();

        System.out.println("-----------------------------------------------------");
        System.out.println("--- Diagnostic du Stockage (Disques / Partitions) ---");

        // Volumes montés
        List<OSFileStore> fileStores = fs.getFileStores();
        if (!fileStores.isEmpty()) {
            System.out.println("\n>>> Volumes montés détectés :");
            for (OSFileStore store : fileStores) {
                System.out.println("--------------------------------------------------");
                System.out.println("Nom : " + store.getName());
                System.out.println("Volume : " + store.getVolume());
                System.out.println("Description : " + store.getDescription());
                System.out.println("Monté sur : " + store.getMount());
                System.out.printf("Capacité totale : %.2f Go%n", store.getTotalSpace() / 1e9);
                System.out.printf("Espace utilisé : %.2f Go%n", (store.getTotalSpace() - store.getUsableSpace()) / 1e9);
                System.out.printf("Espace libre : %.2f Go%n", store.getUsableSpace() / 1e9);
            }
        } else {
            System.out.println("Aucun volume monté détecté.");
        }

        // Disques physiques
        List<HWDiskStore> diskStores = hal.getDiskStores();
        if (!diskStores.isEmpty()) {
            System.out.println("\n>>> Disques physiques détectés :");

            Map<String, String> diskTypes = PhysicalDiskInspector.getDiskTypesFromSystem();

            for (HWDiskStore disk : diskStores) {
                System.out.println("--------------------------------------------------");
                System.out.println("Nom du disque : " + disk.getName());
                System.out.println("Modèle : " + disk.getModel());
                System.out.printf("Taille : %.2f Go%n", disk.getSize() / 1e9);
                System.out.println("Nombre de partitions : " + disk.getPartitions().size());
                System.out.println("Temps d'activité : " + disk.getTransferTime() + " ms");

                String model = disk.getModel().toLowerCase();
                String detectedType = diskTypes.entrySet().stream()
                        .filter(e -> model.contains(e.getKey()))
                        .map(Map.Entry::getValue)
                        .findFirst()
                        .orElse(null);

                if (detectedType != null) {
                    System.out.println("Type réel détecté (WMI) : " + detectedType);
                } else {
                    System.out.println("Type estimé (heuristique) : " + DiskUtils.guessDriveType(disk));
                }
            }
        } else {
            System.out.println("Aucun disque physique détecté.");
        }
    }
}
