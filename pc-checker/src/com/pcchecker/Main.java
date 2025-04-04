package com.pcchecker;

import com.pcchecker.constants.ComponentType;
import com.pcchecker.modules.CpuChecker;
import com.pcchecker.modules.GPUChecker;
import com.pcchecker.modules.NetworkChecker;
import com.pcchecker.modules.OSChecker;
import com.pcchecker.modules.RamChecker;
import com.pcchecker.modules.StorageChecker;

import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.println("---------------------------------------------------------------");
        System.out.println("----- PC-CHECKER --- Outil d'analyse des composants de PC -----");
        System.out.println("---------------------------------------------------------------");
        int index = 0;
        for (ComponentType type : ComponentType.values()) {
            System.out.println(index++ + " - " + type.getLabel());
        }

        System.out.print("Choisissez un composant a diagnostiquer : ");
        int choice = scanner.nextInt();

        if (choice == 0) {
            System.out.println("Lancement de l'ensemble des diagnostics...");
            CpuChecker.run();
            RamChecker.run();
            StorageChecker.run();
            System.out.println("Tous les diagnostics ont ete effectues.");
        } else if (choice == 1) {
            CpuChecker.run();
        } else if (choice == 2) {
            RamChecker.run();
        } else if (choice == 3) {
            StorageChecker.run();
        } else if (choice == 4) {
            OSChecker.run();
        } else if (choice == 5) {
            GPUChecker.run();
        } else if (choice == 6) {
            NetworkChecker.run();
        } else {
            System.out.println(
                    "Choix invalide. Veuillez choisir un nombre entre 0 et " + (ComponentType.values().length));
        }
        System.out.println("----------------------------");
        System.out.println("----- Fin de l'analyse -----");
        System.out.println("----------------------------");
        return;
    }
}
