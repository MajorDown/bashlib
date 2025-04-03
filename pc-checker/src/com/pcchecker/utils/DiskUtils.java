package com.pcchecker.utils;

import oshi.hardware.HWDiskStore;

public class DiskUtils {

    public static String guessDriveType(HWDiskStore disk) {
        String model = (disk.getModel() != null) ? disk.getModel().toLowerCase() : "";
        String name = (disk.getName() != null) ? disk.getName().toLowerCase() : "";
        long size = disk.getSize();
        long transferTime = disk.getTransferTime();

        // Mots-clés NVMe connus
        String[] nvmeKeywords = { "nvme", "sn", "pm981", "970", "980", "evo", "pro", "sk hynix" };
        for (String keyword : nvmeKeywords) {
            if (model.contains(keyword) || name.contains(keyword)) {
                return "NVMe";
            }
        }

        // Mots-clés SSD connus
        String[] ssdKeywords = { "ssd", "solid", "m2", "toshiba", "samsung", "crucial", "kingston" };
        for (String keyword : ssdKeywords) {
            if (model.contains(keyword) || name.contains(keyword)) {
                return "SSD";
            }
        }

        // Mots-clés HDD connus
        String[] hddKeywords = { "hdd", "st", "wd", "seagate", "hitachi" };
        for (String keyword : hddKeywords) {
            if (model.contains(keyword) || name.contains(keyword)) {
                return "HDD";
            }
        }

        // Heuristique de fallback sur le ratio transfert / taille
        if (transferTime > 0 && size > 0) {
            double ratio = (double) transferTime / size;
            if (ratio < 1e-4) {
                return "SSD (estimé)";
            } else if (ratio > 1e-3) {
                return "HDD (estimé)";
            }
        }

        return "Inconnu";
    }
}
