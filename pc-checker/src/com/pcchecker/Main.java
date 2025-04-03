package com.pcchecker;

import com.pcchecker.constants.ComponentType;
import com.pcchecker.modules.CpuChecker;
import com.pcchecker.modules.RamChecker;
import com.pcchecker.modules.StorageChecker;

import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.println("------------------");
        System.out.println("--- PC-CHECKER ---");
        System.out.println("------------------");
        int index = 0;
        for (ComponentType type : ComponentType.values()) {
            System.out.println(index++ + " - " + type.getLabel());
        }

        System.out.print("Choisissez un composant à diagnostiquer : ");
        int choice = scanner.nextInt();

        if (choice == 0) {
            System.out.println("Lancement de l'ensemble des diagnostics...");
            CpuChecker.run();
            RamChecker.run();
            StorageChecker.run();
            System.out.println("Tous les diagnostics ont été effectués.");
            return;
        } else if (choice == 1) {
            CpuChecker.run();
        } else if (choice == 2) {
            RamChecker.run();
        } else if (choice == 3) {
            StorageChecker.run();
        } else {
            System.out.println(
                    "Choix invalide. Veuillez choisir un nombre entre 0 et " + (ComponentType.values().length));
        }
    }
}
