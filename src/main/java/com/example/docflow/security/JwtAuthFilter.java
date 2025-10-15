package com.example.docflow.security;

import com.auth0.jwt.interfaces.DecodedJWT;
import com.example.docflow.domain.User;
import com.example.docflow.service.AuthService;
import com.example.docflow.service.ServiceFactory;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class JwtAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // nếu cần đọc tham số từ web.xml, làm ở đây
        // ví dụ: String allowlist = filterConfig.getInitParameter("allowlist");
    }

    private boolean isPublic(HttpServletRequest req) {
        String ctx = req.getContextPath();
        String p = req.getRequestURI();
        if (p == null) return true;
        return p.equals(ctx + "/")
            || p.endsWith("/index.zul")
            || p.endsWith("/login.zul")
            || p.startsWith(ctx + "/zkau")      // ZK engine
            || p.startsWith(ctx + "/assets")
            || p.startsWith(ctx + "/static")
            || p.startsWith(ctx + "/public");
    }

    private static String bearer(HttpServletRequest req) {
        String h = req.getHeader("Authorization");
        if (h != null && h.startsWith("Bearer ")) return h.substring(7);
        if (req.getCookies() != null) {
            for (Cookie c: req.getCookies()) {
                if ("AUTH".equals(c.getName())) return c.getValue();
            }
        }
        return null;
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest  req  = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        if (isPublic(req)) { chain.doFilter(request, response); return; }

        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            chain.doFilter(request, response); return;
        }

        String token = bearer(req);
        if (token != null && !token.isEmpty()) {
            try {
                DecodedJWT jwt = JwtUtil.verify(token);
                Long uid = JwtUtil.uid(jwt);
                AuthService auth = ServiceFactory.auth();
                User u = auth.findById(uid);
                if (u != null) {
                    HttpSession s = req.getSession(true);
                    s.setAttribute("user", u);
                    s.setAttribute("role", auth.roleOf(u));
                    chain.doFilter(request, response);
                    return;
                }
            } catch (Exception ignore) {}
        }

        String accept = req.getHeader("Accept");
        if (accept != null && accept.contains("application/json")) {
            resp.setStatus(401);
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write("{\"error\":\"unauthorized\"}");
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/login.zul");
    }

    @Override
    public void destroy() {
        // clean up tài nguyên nếu có
    }
}
