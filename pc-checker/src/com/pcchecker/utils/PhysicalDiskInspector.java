package com.pcchecker.utils;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;

public class PhysicalDiskInspector {

    /**
     * Récupère une map modèle -> type depuis Get-PhysicalDisk
     */
    public static Map<String, String> getDiskTypesFromSystem() {
        Map<String, String> diskTypes = new HashMap<>();

        try {
            ProcessBuilder pb = new ProcessBuilder("powershell", "-Command",
                "Get-PhysicalDisk | Select-Object FriendlyName, MediaType | Format-Table -HideTableHeaders");
            pb.redirectErrorStream(true);
            Process process = pb.start();

            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;

            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty() || !line.contains(" ")) continue;

                // Split la ligne en deux : Nom + Type
                String[] parts = line.split("\s{2,}");
                if (parts.length == 2) {
                    String model = parts[0].trim();
                    String mediaType = parts[1].trim();
                    diskTypes.put(model.toLowerCase(), mediaType.toUpperCase());
                }
            }

            process.waitFor();
        } catch (Exception e) {
            System.err.println("Erreur lors de la récupération des types de disque : " + e.getMessage());
        }

        return diskTypes;
    }
}
