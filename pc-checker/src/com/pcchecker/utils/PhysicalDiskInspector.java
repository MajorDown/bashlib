package com.pcchecker.utils;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.LinkedHashMap;
import java.util.Map;

public class PhysicalDiskInspector {

    public static Map<String, String> getDiskTypesFromSystem() {
        Map<String, String> diskTypes = new LinkedHashMap<>();

        System.out.println("--> Analyse via Get-PhysicalDisk :");

        try {
            ProcessBuilder pb = new ProcessBuilder("powershell", "-Command",
                    "Get-PhysicalDisk | Select-Object FriendlyName, MediaType | Format-Table -AutoSize");
            pb.redirectErrorStream(true);
            Process process = pb.start();

            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;

            while ((line = reader.readLine()) != null) {

                // On garde la logique Map pour la suite
                line = line.trim();
                if (line.isEmpty() || !line.contains(" "))
                    continue;

                System.out.println(line); // 🔍 Affichage brut de chaque ligne PowerShell

                String[] parts = line.split("\\s{2,}");
                if (parts.length >= 2) {
                    String model = parts[0].trim();
                    String type = parts[1].trim().toUpperCase();
                    diskTypes.put(model, type);
                }
            }

            process.waitFor();
        } catch (Exception e) {
            System.err.println("Erreur PowerShell (Get-PhysicalDisk) : " + e.getMessage());
        }

        return diskTypes;
    }
}
