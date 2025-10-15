package com.example.docflow.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import javax.sql.DataSource;

public final class Db {
    private static HikariDataSource ds;

    public static DataSource dataSource() {
        if (ds == null) {
            synchronized (Db.class) {
                if (ds == null) {
                    String url  = System.getProperty("db.url",
                        "jdbc:mysql://localhost:3306/docflow?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Bangkok&useSSL=false&allowPublicKeyRetrieval=true");
                    String user = System.getProperty("db.user", "docflow");
                    String pass = System.getProperty("db.pass", "docflow123");

                    HikariConfig cfg = new HikariConfig();
                    cfg.setJdbcUrl(url);
                    cfg.setUsername(user);
                    cfg.setPassword(pass);
                    cfg.setMaximumPoolSize(10);
                    cfg.setMinimumIdle(1);
                    cfg.setConnectionTimeout(10000);
                    cfg.setValidationTimeout(5000);
                    cfg.setPoolName("DocflowHikari");
                    cfg.setDriverClassName("com.mysql.cj.jdbc.Driver");

                    ds = new HikariDataSource(cfg);
                }
            }
        }
        return ds;
    }
}
