package com.example.docflow.util;

import javax.sql.DataSource;
import java.io.PrintWriter;
import java.sql.*;
import java.util.logging.Logger;

public class SimpleDataSource implements DataSource {
    private final String url, user, pass;

    public SimpleDataSource(String url, String user, String pass) {
        this.url = url; this.user = user; this.pass = pass;
    }

    @Override public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, user, pass);
    }
    @Override public Connection getConnection(String u, String p) throws SQLException {
        return DriverManager.getConnection(url, u, p);
    }

    // Phần dưới không dùng tới – giữ mặc định
    @Override public PrintWriter getLogWriter() { return null; }
    @Override public void setLogWriter(PrintWriter out) {}
    @Override public void setLoginTimeout(int seconds) {}
    @Override public int getLoginTimeout() { return 0; }
    @Override public Logger getParentLogger() { return Logger.getGlobal(); }
    @Override public <T> T unwrap(Class<T> iface) { throw new UnsupportedOperationException(); }
    @Override public boolean isWrapperFor(Class<?> iface) { return false; }
}
