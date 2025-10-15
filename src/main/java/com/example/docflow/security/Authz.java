package com.example.docflow.security;

import org.zkoss.zk.ui.Sessions;

public class Authz {
    public static boolean hasRole(String role) {
        Object r = Sessions.getCurrent().getAttribute("role");
        return r != null && r.toString().equals(role);
    }
    public static void requireRole(String role) {
        if (!hasRole(role)) throw new SecurityException("forbidden");
    }
}
