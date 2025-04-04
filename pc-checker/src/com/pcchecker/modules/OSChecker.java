package com.pcchecker.modules;

import oshi.SystemInfo;
import oshi.software.os.OperatingSystem;

public class OSChecker {

    public static void run() {
        SystemInfo si = new SystemInfo();
        OperatingSystem os = si.getOperatingSystem();

        System.out.println("---------------------------------------------");
        System.out.println("----- Analyse du Systeme d'exploitation -----");

        System.out.println("Nom : " + os.toString());
        System.out.println("Version : " + os.getVersionInfo().getVersion());
        System.out.println("Fabricant : " + os.getManufacturer());
        System.out.println("Architecture : " + System.getProperty("os.arch"));
        System.out.println("Utilisateur connecte : " + System.getProperty("user.name"));
        System.out.println("Repertoire utilisateur : " + System.getProperty("user.home"));
    }
}
