package com.example.docflow.vm;

import com.example.docflow.domain.Document;
import com.example.docflow.domain.enums.DocumentStatus;
import com.example.docflow.domain.enums.DocumentType;
import com.example.docflow.service.DocumentService;
import org.zkoss.bind.annotation.*;
import org.zkoss.zul.ListModelList;
import org.zkoss.zk.ui.Executions;

import java.util.ArrayList;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;

import java.util.Date;
import java.time.ZoneId;

// +++ imports thêm cho logout/dashboard +++
import org.zkoss.zk.ui.Sessions;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;

public class DocumentListVM {

    // filter
    private String keyword;
    private DocumentType type;
    private DocumentStatus status;
    // --- fields
    private Date fromDate;
    private Date toDate;

    // paging
    private int pageSize = 10;
    private int totalSize = 0;
    private int activePage = 0;

    private ListModelList<Document> documents = new ListModelList<>();
    private final DocumentService docSvc = com.example.docflow.service.ServiceFactory.documents();

    @Init
    public void init() {
        loadPage();
    }

    @Command
    @NotifyChange({ "documents", "totalSize", "activePage" })
    public void search() {
        activePage = 0; // reset về trang đầu
        loadPage();
    }

    @Command
    @NotifyChange("documents")
    public void gotoPage(@BindingParam("page") int page) {
        activePage = page;
        loadPage();
    }

    @Command
    public void openDetail(@BindingParam("id") Long id) {
        Executions.sendRedirect("document_detail.zul?id=" + id);
    }

    @Command
    @NotifyChange({ "documents", "totalSize", "activePage", "status" })
    public void clearStatus() {
        status = null;
        activePage = 0;
        loadPage();
    }

    @Command
    @NotifyChange({ "documents", "totalSize", "activePage", "type" })
    public void clearType() {
        type = null;
        activePage = 0;
        loadPage();
    }

    private LocalDate toLD(Date d) {
        return d == null ? null : d.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
    }

    private void loadPage() {
        int offset = activePage * pageSize;
        List<Document> page = docSvc.search(keyword, type, status, toLD(fromDate), toLD(toDate), offset, pageSize);
        totalSize = docSvc.count(keyword, type, status, toLD(fromDate), toLD(toDate));
        documents.clear();
        documents.addAll(page);
    }

    // ====== Dashboard & Logout ======

    @Command
    public void goDashboard() {
        Executions.sendRedirect("dashboard.zul");
    }

    @Command
    public void logout() {
        // huỷ session
        Sessions.getCurrent().invalidate();

        // nếu có dùng JWT qua cookie tên "JWT", xoá luôn
        try {
            HttpServletResponse resp = (HttpServletResponse) Executions.getCurrent().getNativeResponse();
            Cookie c = new Cookie("JWT", "");
            c.setPath("/");
            c.setMaxAge(0);
            resp.addCookie(c);
        } catch (Throwable ignore) {}

        Executions.sendRedirect("login.zul");
    }

    // Hiển thị chào user góc phải (tuỳ chọn)
    public String getCurrentUserLabel() {
        Object u = Sessions.getCurrent().getAttribute("user");
        Object role = Sessions.getCurrent().getAttribute("role");
        if (u instanceof com.example.docflow.domain.User) {
            com.example.docflow.domain.User uu = (com.example.docflow.domain.User) u;
            String name = (uu.getFullName() != null && !uu.getFullName().isEmpty())
                    ? uu.getFullName() : uu.getUsername();
            return role != null ? (name + " (" + role + ")") : name;
        }
        return "";
    }

    // ===== getters/setters =====
    public ListModelList<Document> getDocuments() { return documents; }
    public int getPageSize() { return pageSize; }
    public int getTotalSize() { return totalSize; }
    public int getActivePage() { return activePage; }
    public void setActivePage(int activePage) { this.activePage = activePage; }
    public String getKeyword() { return keyword; }
    public void setKeyword(String k) { this.keyword = k; }
    public DocumentType getType() { return type; }
    public void setType(DocumentType t) { this.type = t; }
    public DocumentStatus getStatus() { return status; }
    public void setStatus(DocumentStatus s) { this.status = s; }
    public Date getFromDate() { return fromDate; }
    public void setFromDate(Date d) { this.fromDate = d; }
    public Date getToDate() { return toDate; }
    public void setToDate(Date d) { this.toDate = d; }

    public String labelOfType(Object t) { return t == null ? "(Tất cả)" : t.toString(); }
    public String labelOfStatus(Object s) { return s == null ? "(Tất cả)" : s.toString(); }

    public List<DocumentType> getTypeOptions() { return Arrays.asList(DocumentType.values()); }
    public List<DocumentStatus> getStatusOptions() { return Arrays.asList(DocumentStatus.values()); }

    public List<Object> getTypeOptionsAll() {
        List<Object> list = new ArrayList<>();
        list.add(null);
        list.addAll(Arrays.asList(DocumentType.values()));
        return list;
    }

    public List<Object> getStatusOptionsAll() {
        List<Object> list = new ArrayList<>();
        list.add(null);
        list.addAll(Arrays.asList(DocumentStatus.values()));
        return list;
    }
}
