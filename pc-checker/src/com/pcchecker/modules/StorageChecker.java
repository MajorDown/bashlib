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

        System.out.println("-------------------------------");
        System.out.println("----- ANALYSE DU STOCKAGE -----");
        System.out.println("-------------------------------");

        // Appel direct à la commande PowerShell (avec affichage intégré)
        Map<String, String> diskTypes = PhysicalDiskInspector.getDiskTypesFromSystem();

        // Disques physiques (via OSHI)
        List<HWDiskStore> diskStores = hal.getDiskStores();
        if (!diskStores.isEmpty()) {
            System.out.println("----------------------");
            System.out.println("--> Analyse via OSHI :");
            for (HWDiskStore disk : diskStores) {
                System.out.println("Modele : " + disk.getModel());
                System.out.printf("Taille : %.2f Go%n", disk.getSize() / 1e9);
                System.out.println("Partitions : " + disk.getPartitions().size());
                String estimated = DiskUtils.guessDriveType(disk);
                System.out.println("Type estime via heuristique : " + estimated + " " + getEmoji(estimated));
            }
        } else {
            System.out.println("Aucun disque detecte via OSHI.");
        }

        // Volumes montés
        List<OSFileStore> fileStores = fs.getFileStores();
        System.out.println("-------------------------");
        if (!fileStores.isEmpty()) {
            System.out.println("--> Partitions détectes :");
            for (OSFileStore store : fileStores) {
                System.out.println("> Nom : " + store.getName());
                System.out.println("Volume : " + store.getVolume());
                System.out.println("Description : " + store.getDescription());
                System.out.println("Monte sur : " + store.getMount());
                System.out.printf("Capacite totale : %.2f Go%n", store.getTotalSpace() / 1e9);
                System.out.printf("Espace utilise : %.2f Go%n", (store.getTotalSpace() - store.getUsableSpace()) / 1e9);
                System.out.printf("Espace libre : %.2f Go%n", store.getUsableSpace() / 1e9);
            }
        } else {
            System.out.println("Aucune partition detecte.");
        }
    }

    private static String getEmoji(String type) {
        type = type.toLowerCase();
        if (type.contains("nvme"))
            return "🧠";
        if (type.contains("ssd"))
            return "⚡";
        if (type.contains("hdd"))
            return "💾";
        return "❓";
    }
}
