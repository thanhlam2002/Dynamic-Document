package com.example.docflow.vm;

import com.example.docflow.domain.Document;
import com.example.docflow.domain.enums.DocumentStatus;
import com.example.docflow.domain.enums.DocumentType;
import com.example.docflow.service.DocumentService;
import com.example.docflow.service.ServiceFactory;
import org.zkoss.bind.annotation.*;
import org.zkoss.util.media.Media;
import org.zkoss.zk.ui.Sessions;
import org.zkoss.zk.ui.util.Clients;
import org.zkoss.zul.ListModelList;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.concurrent.atomic.AtomicLong;

public class NewDocumentVM {
    private final DocumentService docSvc = ServiceFactory.documents();

    // ====== Form fields ======
    private DocumentType type = DocumentType.OUTGOING; // mặc định: Đi
    private int typeIndex = 0;                         // 0: OUTGOING, 1: INCOMING
    private String docNo;
    private String title;
    private String content;
    private String receiverOrg; // cho Đi
    private String senderOrg;   // cho Đến

    // ====== Tạm giữ file upload (hiển thị + lưu DB sau khi Save) ======
    public static class TempFile {
        private final long id;            // phục vụ removeTempFile(tid=...)
        private final String filename;
        private final String contentType;
        private final long sizeBytes;
        private final File diskFile;      // file tạm đã ghi ra ổ

        public TempFile(long id, String filename, String contentType, long sizeBytes, File diskFile) {
            this.id = id;
            this.filename = filename;
            this.contentType = contentType;
            this.sizeBytes = sizeBytes;
            this.diskFile = diskFile;
        }
        // ===== Getters khớp với ZUL =====
        public long   getId()         { return id; }
        public String getFilename()   { return filename; }
        public String getContentType(){ return contentType; }
        public long   getSizeBytes()  { return sizeBytes; }
        public String getDiskPath()   { return diskFile != null ? diskFile.getAbsolutePath() : null; }
    }
    private final ListModelList<TempFile> tempFiles = new ListModelList<>();
    private static final AtomicLong TEMP_ID = new AtomicLong(1);

    // ====== Radio Loại ======
    public int getTypeIndex() { return typeIndex; }
    public void setTypeIndex(int i) {
        this.typeIndex = i;
        this.type = (i == 0) ? DocumentType.OUTGOING : DocumentType.INCOMING;
    }

    @Command
    public void changeType(@BindingParam("val") String val) {
        if ("OUTGOING".equals(val)) { type = DocumentType.OUTGOING; typeIndex = 0; }
        else                        { type = DocumentType.INCOMING; typeIndex = 1; }
    }

    // ====== Upload nhiều file (đúng tên lệnh trong ZUL: uploadFiles) ======
    @Command
    @NotifyChange("tempFiles")
    public void uploadFiles(@ContextParam(ContextType.TRIGGER_EVENT) org.zkoss.zk.ui.event.UploadEvent evt) {
        if (evt == null || evt.getMedias() == null) return;
        int cnt = 0;
        for (Media m : evt.getMedias()) {
            try {
                TempFile tf = saveToTemp(m);
                tempFiles.add(0, tf);
                cnt++;
            } catch (IOException ex) {
                Clients.showNotification("Upload lỗi: " + ex.getMessage(), "error", null, "top_center", 2000);
            }
        }
        if (cnt > 0) {
            Clients.showNotification("Đã thêm " + cnt + " tệp", "info", null, "top_center", 1000);
        }
    }

    private TempFile saveToTemp(Media m) throws IOException {
        File dir = new File(System.getProperty("java.io.tmpdir"), "docflow_uploads");
        if (!dir.exists()) dir.mkdirs();
        File out = File.createTempFile("doc_", "_" + m.getName(), dir);

        try (FileOutputStream fos = new FileOutputStream(out)) {
            if (m.isBinary()) {
                fos.write(m.getByteData());
            } else {
                fos.write(m.getStringData().getBytes(java.nio.charset.StandardCharsets.UTF_8));
            }
        }
        long id = TEMP_ID.getAndIncrement();
        long size = out.length();
        String ctype = m.getContentType();
        return new TempFile(id, m.getName(), ctype, size, out);
    }

    // ====== Xoá file tạm (đúng tên lệnh + tham số trong ZUL: removeTempFile, tid=f.id) ======
    @Command
    @NotifyChange("tempFiles")
    public void removeTempFile(@BindingParam("tid") long tid) {
        TempFile found = null;
        for (TempFile tf : tempFiles) {
            if (tf.getId() == tid) { found = tf; break; }
        }
        if (found != null) {
            tempFiles.remove(found);
            String p = found.getDiskPath();
            if (p != null) try { new File(p).delete(); } catch (Throwable ignore) {}
        }
    }

    // ====== Lưu văn bản + đính kèm vào DB ======
    @Command
    public void save() {
        com.example.docflow.domain.User u =
                (com.example.docflow.domain.User) Sessions.getCurrent().getAttribute("user");
        Long uid = (u != null ? u.getId() : null);

        Document d = new Document();
        d.setDocNo(docNo);
        d.setTitle(title);
        d.setContent(content);
        d.setType(type);
        d.setStatus(DocumentStatus.PENDING);
        d.setIssueDate(LocalDateTime.now());
        d.setReceiveDate(LocalDateTime.now());
        d.setReceiverOrg(type == DocumentType.OUTGOING ? receiverOrg : null);
        d.setSenderOrg(type == DocumentType.INCOMING ? senderOrg : null);
        d.setCreatedBy(uid);
        d.setCreatedAt(LocalDateTime.now());
        d.setUpdatedAt(LocalDateTime.now());

        // insert document
        docSvc.create(d);

        // insert các file đính kèm
        for (TempFile f : tempFiles) {
            docSvc.addAttachment(
                    d.getId(),
                    f.getFilename(),
                    f.getContentType(),
                    f.getSizeBytes(),
                    f.getDiskPath(),
                    uid
            );
        }

        Clients.showNotification("Đã tạo văn bản: " + d.getDocNo(), "info", null, "top_center", 1200);
        org.zkoss.zk.ui.Executions.sendRedirect("documents.zul");
    }

    // ====== Helpers cho ZUL ======
    public String formatSize(long bytes) {
        if (bytes < 1024) return bytes + " bytes";
        double kb = bytes / 1024.0;
        if (kb < 1024) return String.format(java.util.Locale.US, "%.1f KB", kb);
        double mb = kb / 1024.0;
        if (mb < 1024) return String.format(java.util.Locale.US, "%.1f MB", mb);
        double gb = mb / 1024.0;
        return String.format(java.util.Locale.US, "%.1f GB", gb);
    }

    // ====== Getters/Setters bind từ ZUL ======
    public DocumentType getType() { return type; }
    public void setType(DocumentType t) { this.type = t; }
    public String getDocNo() { return docNo; }
    public void setDocNo(String s) { this.docNo = s; }
    public String getTitle() { return title; }
    public void setTitle(String s) { this.title = s; }
    public String getContent() { return content; }
    public void setContent(String s) { this.content = s; }
    public String getReceiverOrg() { return receiverOrg; }
    public void setReceiverOrg(String s) { this.receiverOrg = s; }
    public String getSenderOrg() { return senderOrg; }
    public void setSenderOrg(String s) { this.senderOrg = s; }

    public ListModelList<TempFile> getTempFiles() { return tempFiles; }
}
