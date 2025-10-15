package com.example.docflow.vm;

import com.example.docflow.domain.Document;
import com.example.docflow.domain.DocumentFile;
import com.example.docflow.domain.DocumentHistory;
import com.example.docflow.domain.User;
import com.example.docflow.domain.enums.DocumentStatus;
import com.example.docflow.domain.enums.DocumentType;
import com.example.docflow.service.AuthService;
import com.example.docflow.service.DocumentService;
import com.example.docflow.service.ServiceFactory;
import com.example.docflow.service.impl.InMemoryAuthService;
import org.zkoss.bind.annotation.*;
import org.zkoss.zk.ui.Executions;
import org.zkoss.zk.ui.Sessions;
import org.zkoss.zk.ui.util.Clients;
import org.zkoss.zul.ListModelList;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class DocumentDetailVM {

    // Dùng JDBC qua ServiceFactory
    private final DocumentService docSvc = ServiceFactory.documents();
    // TODO: thay bằng JdbcAuthService khi đã có
    private final AuthService authSvc = new InMemoryAuthService();

    private Long id;
    private Document doc;
    private final ListModelList<DocumentHistory> histories = new ListModelList<>();
    private final ListModelList<User> users = new ListModelList<>();

    private String comment;
    private User selectedUser; // người nhận khi forward
    private boolean working = false; // chặn double-click/đúp lệnh

    @Init
    @NotifyChange({ "doc", "histories", "users" })
    public void init() {
        String sid = Executions.getCurrent().getParameter("id");
        if (sid != null && !sid.isEmpty()) {
            this.id = Long.valueOf(sid);
            load();
            users.clear();
            users.addAll(authSvc.listUsers());
        }
    }

    private void load() {
        doc = docSvc.getById(id);
        histories.clear();
        histories.addAll(docSvc.historiesOf(id));
    }

    // =================== Quyền & điều kiện UI ===================
    private boolean isLeader() {
        Object role = Sessions.getCurrent().getAttribute("role");
        return role != null && "LEADER".equalsIgnoreCase(role.toString());
    }

    private boolean statusAllowsAction() {
        if (doc == null || doc.getStatus() == null)
            return false;
        DocumentStatus s = doc.getStatus();
        return s == DocumentStatus.PENDING || s == DocumentStatus.IN_PROGRESS;
    }

    public boolean getCanApprove() {
        return isLeader() && statusAllowsAction() && !working;
    }

    public boolean getCanReject() {
        return isLeader() && statusAllowsAction() && !working;
    }

    public boolean getCanForward() {
        return isLeader() && statusAllowsAction() && !working;
    }

    public boolean isWorking() {
        return working;
    }

    // =================== Actions ===================
    @Command
    @NotifyChange({ "doc", "histories", "comment", "selectedUser", "working" })
    public void approve() {
        if (!getCanApprove()) {
            Clients.showNotification("Không thể duyệt ở trạng thái hiện tại.", "warning", null, "top_center", 1300);
            return;
        }
        try {
            com.example.docflow.security.Authz.requireRole("LEADER");
            User u = (User) Sessions.getCurrent().getAttribute("user");
            if (u == null) {
                Clients.showNotification("Chưa đăng nhập.", "warning", null, "top_center", 1200);
                return;
            }
            working = true;
            docSvc.approve(id, u.getId(), comment);
            Clients.showNotification("Đã duyệt văn bản.", "info", null, "top_center", 1000);
            comment = null;
            selectedUser = null;
            load(); // reload để nút tự khóa do trạng thái mới
        } catch (IllegalStateException ex) {
            Clients.showNotification(ex.getMessage(), "warning", null, "top_center", 1500);
            load();
        } catch (SecurityException ex) {
            Clients.showNotification("Bạn không có quyền phê duyệt.", "warning", null, "top_center", 1500);
        } catch (Throwable t) {
            Clients.showNotification("Lỗi khi duyệt: " + t.getMessage(), "error", null, "top_center", 2000);
            t.printStackTrace();
        } finally {
            working = false;
        }
    }

    @Command
    @NotifyChange({ "doc", "histories", "comment", "working" })
    public void reject() {
        if (!getCanReject()) {
            Clients.showNotification("Không thể từ chối ở trạng thái hiện tại.", "warning", null, "top_center", 1300);
            return;
        }
        try {
            com.example.docflow.security.Authz.requireRole("LEADER");
            User u = (User) Sessions.getCurrent().getAttribute("user");
            if (u == null) {
                Clients.showNotification("Chưa đăng nhập.", "warning", null, "top_center", 1200);
                return;
            }
            working = true;
            docSvc.reject(id, u.getId(), comment);
            Clients.showNotification("Đã từ chối văn bản.", "info", null, "top_center", 1000);
            comment = null;
            load();
        } catch (IllegalStateException ex) {
            Clients.showNotification(ex.getMessage(), "warning", null, "top_center", 1500);
            load();
        } catch (SecurityException ex) {
            Clients.showNotification("Bạn không có quyền từ chối.", "warning", null, "top_center", 1500);
        } catch (Throwable t) {
            Clients.showNotification("Lỗi khi từ chối: " + t.getMessage(), "error", null, "top_center", 2000);
            t.printStackTrace();
        } finally {
            working = false;
        }
    }

    @Command
    @NotifyChange({ "doc", "histories", "comment", "selectedUser", "working" })
    public void forward() {
        if (!getCanForward()) {
            Clients.showNotification("Không thể chuyển tiếp ở trạng thái hiện tại.", "warning", null, "top_center",
                    1300);
            return;
        }
        User u = (User) Sessions.getCurrent().getAttribute("user");
        if (u == null) {
            Clients.showNotification("Chưa đăng nhập.", "warning", null, "top_center", 1200);
            return;
        }
        if (selectedUser == null) {
            Clients.showNotification("Chọn người nhận.", "warning", null, "top_center", 1200);
            return;
        }
        try {
            working = true;
            docSvc.forward(id, u.getId(), selectedUser.getId(), comment);
            Clients.showNotification("Đã chuyển tiếp cho " + selectedUser.getFullName(), "info", null, "top_center",
                    1200);
            comment = null;
            selectedUser = null;
            load();
        } catch (IllegalStateException ex) {
            Clients.showNotification(ex.getMessage(), "warning", null, "top_center", 1500);
            load();
        } catch (Throwable t) {
            Clients.showNotification("Lỗi khi chuyển tiếp: " + t.getMessage(), "error", null, "top_center", 2000);
            t.printStackTrace();
        } finally {
            working = false;
        }
    }

    @Command
    public void closeWindow() {
        Executions.sendRedirect("documents.zul");
    }

    // =================== Helpers ===================
    public List<DocumentFile> getAttachments() {
        if (id == null)
            return java.util.Collections.emptyList();
        return docSvc.listAttachments(id);
    }

    public String fileUrl(Long fid) {
        return fid == null ? "#" : ("/files/" + fid);
    }

    public String formatSize(long bytes) {
        if (bytes < 1024)
            return bytes + " bytes";
        double kb = bytes / 1024.0;
        if (kb < 1024)
            return String.format(java.util.Locale.US, "%.1f KB", kb);
        double mb = kb / 1024.0;
        if (mb < 1024)
            return String.format(java.util.Locale.US, "%.1f MB", mb);
        double gb = mb / 1024.0;
        return String.format(java.util.Locale.US, "%.1f GB", gb);
    }

    public String userName(Long uid) {
        if (uid == null)
            return "";
        User u = authSvc.findById(uid);
        return u != null ? u.getFullName() : String.valueOf(uid);
    }

    public String userLabel(User u) {
        if (u == null)
            return "";
        String fn = u.getFullName();
        return (fn != null && !fn.isEmpty()) ? fn : u.getUsername();
    }

    // (giữ lại nếu ZUL đang bind)
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

    // =================== Getters/Setters ===================
    public Document getDoc() {
        return doc;
    }

    public ListModelList<DocumentHistory> getHistories() {
        return histories;
    }

    public ListModelList<User> getUsers() {
        return users;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public User getSelectedUser() {
        return selectedUser;
    }

    public void setSelectedUser(User selectedUser) {
        this.selectedUser = selectedUser;
    }

    public boolean getLeader() {
        return isLeader();
    }

    public boolean getWorking() {
        return working;
    }

}
