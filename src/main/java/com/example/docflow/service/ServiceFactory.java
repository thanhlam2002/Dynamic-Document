// src/main/java/com/example/docflow/service/ServiceFactory.java
package com.example.docflow.service;

import com.example.docflow.service.impl.JdbcDocumentService;
import com.example.docflow.service.impl.InMemoryAuthService; // hoặc JdbcAuthService nếu bạn đã có
import com.example.docflow.util.SimpleDataSource;
import org.zkoss.zk.ui.WebApps;

import javax.sql.DataSource;
import javax.servlet.ServletContext;
import java.util.Objects;

public class ServiceFactory {

    // ====== AUTH ======
    private static final AuthService AUTH = new InMemoryAuthService(); // TODO: thay bằng JdbcAuthService sau

    // ====== DOCS (JDBC) LAZY-INIT ======
    private static volatile DocumentService DOCS;
    private static volatile DataSource DS;

    public static AuthService auth() { return AUTH; }

    public static DocumentService documents() {
        if (DOCS == null) {
            synchronized (ServiceFactory.class) {
                if (DOCS == null) {
                    ensureDataSource();
                    DOCS = new JdbcDocumentService(DS);
                }
            }
        }
        return DOCS;
    }

    public static DataSource dataSource() {
        if (DS == null) {
            synchronized (ServiceFactory.class) {
                if (DS == null) ensureDataSource();
            }
        }
        return DS;
    }

    // ====== CORE: lấy cấu hình từ System props HOẶC web.xml context-param ======
    private static void ensureDataSource() {
        // 1) Ưu tiên System properties
        String url  = System.getProperty("db.url");
        String user = System.getProperty("db.user");
        String pass = System.getProperty("db.pass");

        // 2) Nếu thiếu, thử lấy từ web.xml (context-param)
        if (isBlank(url) || isBlank(user) || pass == null) {
            ServletContext sc = WebApps.getCurrent() != null ? WebApps.getCurrent().getServletContext() : null;
            if (sc != null) {
                if (isBlank(url))  url  = sc.getInitParameter("db.url");
                if (isBlank(user)) user = sc.getInitParameter("db.user");
                if (pass == null)  pass = sc.getInitParameter("db.pass");
            }
        }

        // 3) Kiểm tra & báo lỗi rõ ràng
        StringBuilder miss = new StringBuilder();
        if (isBlank(url))  miss.append("db.url ");
        if (isBlank(user)) miss.append("db.user ");
        if (pass == null)  miss.append("db.pass ");
        if (miss.length() > 0) {
            String where = "System properties (-Ddb.*) hoặc web.xml <context-param>";
            throw new IllegalStateException("Thiếu cấu hình DB: " + miss.toString().trim()
                    + ". Hãy set tại " + where + ".");
        }

        // 4) Log nhẹ để bạn thấy đã nạp được (log ra console)
        System.out.println("[ServiceFactory] DB URL = " + url);
        System.out.println("[ServiceFactory] DB USER = " + user);

        DS = new SimpleDataSource(url, user, pass);
    }

    private static boolean isBlank(String s) { return s == null || s.trim().isEmpty(); }
}
