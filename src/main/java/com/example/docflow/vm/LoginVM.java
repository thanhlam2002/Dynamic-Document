package com.example.docflow.vm;

import com.example.docflow.domain.User;
import com.example.docflow.service.AuthService;
import com.example.docflow.service.impl.InMemoryAuthService;
import org.zkoss.bind.annotation.Command;
import org.zkoss.bind.annotation.Init;
import org.zkoss.bind.annotation.NotifyChange;
import org.zkoss.zk.ui.Executions;
import org.zkoss.zk.ui.Session;
import org.zkoss.zk.ui.Sessions;
import org.zkoss.zk.ui.util.Clients;

public class LoginVM {
    private String username;
    private String password;
    private String message;
    private AuthService auth = new InMemoryAuthService();

    @Init
    public void init() {
        message = "Đăng nhập: employee/123 hoặc leader/123";
    }

    @Command
    @NotifyChange("message")
    public void doLogin() {
        Clients.showNotification("Đang xử lý đăng nhập...", "info", null, "top_center", 800);

        User u = auth.login(username, password); // auth là JdbcAuthService/ServiceFactory.auth()
        if (u == null) {
            message = "Sai tài khoản hoặc mật khẩu!";
            Clients.showNotification("Đăng nhập thất bại", "error", null, "top_center", 1500);
            return;
        }

        // tạo JWT
        String role = auth.roleOf(u);
        String jwt = com.example.docflow.security.JwtUtil.generateToken(u.getId(), u.getUsername(), role);

        // set cookie AUTH
        javax.servlet.http.HttpServletResponse resp = (javax.servlet.http.HttpServletResponse) org.zkoss.zk.ui.Executions
                .getCurrent().getNativeResponse();
        javax.servlet.http.Cookie c = new javax.servlet.http.Cookie("AUTH", jwt);
        c.setHttpOnly(true);
        c.setPath("/");
        // c.setSecure(true); // bật khi dùng HTTPS
        // SameSite=Lax
        c.setMaxAge(7 * 24 * 60 * 60); // 7 ngày
        resp.addCookie(c);

        // đồng thời hydrate session cho ZK hiện tại
        org.zkoss.zk.ui.Session s = org.zkoss.zk.ui.Sessions.getCurrent();
        s.setAttribute("user", u);
        s.setAttribute("role", role);

        Clients.showNotification("Xin chào " + u.getFullName(), "info", null, "top_center", 1000);
        org.zkoss.zk.ui.Executions.sendRedirect("documents.zul");
    }

    // getters/setters
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getMessage() {
        return message;
    }
}
