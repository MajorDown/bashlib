package com.pcchecker.constants;

public enum ComponentType {
    ALL("Tous les composants"),
    CPU("Processeur"),
    RAM("Mémoire vive (RAM)"),
    STORAGE("Stockage (HDD / SSD / NVMe)"),
    OS("Système d'exploitation"),
    GPU("Carte graphique"),
    NETWORK("Carte réseau");

    private final String label;

    ComponentType(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }
}
