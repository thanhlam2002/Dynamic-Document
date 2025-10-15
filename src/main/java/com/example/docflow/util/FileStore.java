package com.example.docflow.util;

import java.io.IOException;
import java.nio.file.*;
import java.text.Normalizer;
import java.util.UUID;

public final class FileStore {
    private static final String ROOT = System.getProperty("docflow.upload.dir", "uploads");

    public static String save(byte[] data, String originalName) throws IOException {
        Path root = Paths.get(ROOT);
        Files.createDirectories(root);
        String safe = sanitize(originalName);
        String name = UUID.randomUUID().toString() + "_" + safe;
        Path p = root.resolve(name);
        Files.write(p, data, StandardOpenOption.CREATE_NEW);
        return p.toAbsolutePath().toString();
    }

    public static byte[] read(String absolutePath) throws IOException {
        return Files.readAllBytes(Paths.get(absolutePath));
    }

    private static String sanitize(String s) {
        String n = Normalizer.normalize(s, Normalizer.Form.NFD).replaceAll("\\p{M}", "");
        return n.replaceAll("[^a-zA-Z0-9._-]", "_");
    }

    private FileStore() {}
}
