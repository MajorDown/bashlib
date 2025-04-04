package com.pcchecker.modules;

import oshi.SystemInfo;
import oshi.hardware.CentralProcessor;
import oshi.hardware.HardwareAbstractionLayer;

public class CpuChecker {

    public static void run() {
        SystemInfo systemInfo = new SystemInfo();
        HardwareAbstractionLayer hal = systemInfo.getHardware();
        CentralProcessor processor = hal.getProcessor();

        System.out.println("---------------------------------");
        System.out.println("----- ANALYSE DU PROCESSEUR -----");
        System.out.println("---------------------------------");
        System.out.println("Nom : " + processor.getProcessorIdentifier().getName());
        System.out.println("Fabricant : " + processor.getProcessorIdentifier().getVendor());
        System.out.println("Architecture : " + processor.getProcessorIdentifier().getMicroarchitecture());
        System.out.println("Nombre de coeurs physiques : " + processor.getPhysicalProcessorCount());
        System.out.println("Nombre de coeurs logiques : " + processor.getLogicalProcessorCount());
        System.out.printf("Frequence : %.2f GHz%n", processor.getProcessorIdentifier().getVendorFreq() / 1.0e9);

        double[] load = processor.getSystemLoadAverage(3);
        if (load[0] >= 0) {
            System.out.printf("Charge systeme (1min) : %.2f%%%n", load[0] * 100);
        } else {
            System.out.println("Charge systeme : non disponible.");
        }
    }
}
