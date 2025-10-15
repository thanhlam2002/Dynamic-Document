package com.example.docflow.web;

import com.example.docflow.domain.DocumentFile;
import com.example.docflow.service.ServiceFactory;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.*;

public class FileDownloadServlet extends HttpServlet {
    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String pathInfo = req.getPathInfo(); // /{id}
        if (pathInfo == null || pathInfo.length() <= 1) { resp.sendError(400, "missing id"); return; }
        Long fid;
        try { fid = Long.valueOf(pathInfo.substring(1)); }
        catch (NumberFormatException ex) { resp.sendError(400, "invalid id"); return; }

        // kiểm tra đăng nhập tối thiểu
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendError(401); return;
        }

        DocumentFile f = ServiceFactory.documents().getAttachment(fid);
        if (f == null) { resp.sendError(404); return; }

        resp.setContentType(f.getContentType() != null ? f.getContentType() : "application/octet-stream");
        resp.setHeader("Content-Disposition", "attachment; filename=\"" + f.getFilename() + "\"");
        resp.setContentLengthLong(f.getSizeBytes());

        try (InputStream in = new FileInputStream(f.getDiskPath());
             OutputStream out = resp.getOutputStream()) {
            byte[] buf = new byte[8192]; int r;
            while ((r = in.read(buf)) != -1) out.write(buf, 0, r);
        }
    }
}
