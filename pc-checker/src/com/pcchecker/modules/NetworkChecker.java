package com.pcchecker.modules;

import oshi.SystemInfo;
import oshi.hardware.HardwareAbstractionLayer;
import oshi.hardware.NetworkIF;

import java.util.List;

public class NetworkChecker {

    public static void run() {
        SystemInfo si = new SystemInfo();
        HardwareAbstractionLayer hal = si.getHardware();
        List<NetworkIF> interfaces = hal.getNetworkIFs();

        System.out.println("---------------------------------------------------");
        System.out.println("----- Analyse des Interfaces Réseau (actives) -----");
        System.out.println("---------------------------------------------------");

        boolean hasDisplayedAny = false;

        for (NetworkIF net : interfaces) {
            net.updateAttributes();

            // On filtre : interface active avec au moins une IPv4
            if (!net.getIfOperStatus().toString().equals("UP"))
                continue;
            if (net.getIPv4addr().length == 0)
                continue;
            if (net.getDisplayName().toLowerCase().contains("virtual")
                    || net.getName().toLowerCase().contains("loopback"))
                continue;

            hasDisplayedAny = true;

            System.out.println("Nom : " + net.getName());
            System.out.println("Interface : " + net.getDisplayName());
            System.out.println("Adresse MAC : " + net.getMacaddr());
            System.out.println("Adresse IP : " + net.getIPv4addr()[0]);
            System.out.printf("Vitesse : %.0f Mbit/s%n", net.getSpeed() / 1e6);
        }

        if (!hasDisplayedAny) {
            System.out.println("Aucune interface reseau active avec IP detectee.");
        }
    }
}
