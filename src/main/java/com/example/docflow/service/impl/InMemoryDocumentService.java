package com.example.docflow.service.impl;

import com.example.docflow.domain.Document;
import com.example.docflow.domain.DocumentHistory;
import com.example.docflow.domain.enums.ActionType;
import com.example.docflow.domain.enums.DocumentStatus;
import com.example.docflow.domain.enums.DocumentType;
import com.example.docflow.service.DocumentService;

import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.atomic.AtomicLong;
import java.util.stream.Collectors;

public class InMemoryDocumentService implements DocumentService {

    // ===== Singleton gọn gàng qua Holder =====
    private static class Holder {
        private static final InMemoryDocumentService INSTANCE = new InMemoryDocumentService();
    }

    public static InMemoryDocumentService getInstance() {
        return Holder.INSTANCE;
    }

    // ===== State trong instance (KHÔNG static để tránh NPE) =====
    private final List<Document> store = new ArrayList<>();
    private final Map<Long, List<DocumentHistory>> histories = new HashMap<>();
    private final AtomicLong idGen = new AtomicLong(1000);

    private final java.util.Map<Long, java.util.List<com.example.docflow.domain.DocumentFile>> files = new java.util.HashMap<>();
    private final java.util.concurrent.atomic.AtomicLong fileIdGen = new java.util.concurrent.atomic.AtomicLong(1);

    // ===== Ctor private: seed data một lần =====
    private InMemoryDocumentService() {
        seed();
    }

    private void seed() {
        if (!store.isEmpty())
            return;
        for (int i = 1; i <= 40; i++) {
            Document d = new Document();
            d.setId((long) i);
            d.setDocNo("CV-" + String.format("%03d", i));
            d.setTitle((i % 2 == 0 ? "Công văn Đi " : "Công văn Đến ") + i);
            d.setContent("Nội dung văn bản #" + i);
            d.setType(i % 2 == 0 ? DocumentType.OUTGOING : DocumentType.INCOMING);
            d.setStatus(i % 5 == 0 ? DocumentStatus.APPROVED : DocumentStatus.PENDING);
            d.setIssueDate(LocalDateTime.now().minusDays(i));
            d.setReceiveDate(LocalDateTime.now().minusDays(i + 1));
            d.setReceiverOrg(d.getType() == DocumentType.OUTGOING ? "Sở ABC" : null);
            d.setSenderOrg(d.getType() == DocumentType.INCOMING ? "Phòng XYZ" : null);
            d.setCreatedBy(1L);
            d.setCreatedAt(LocalDateTime.now().minusDays(i));
            d.setUpdatedAt(LocalDateTime.now().minusDays(i / 2));
            store.add(d);
        }
        // lịch sử trống ban đầu là ok
    }

    // ===== API tìm kiếm/phân trang =====
    @Override
    public List<Document> search(String keyword, DocumentType type, DocumentStatus status,
            java.time.LocalDate from, java.time.LocalDate to,
            int offset, int limit) {
        return filter(keyword, type, status, from, to)
                .stream()
                .sorted(Comparator.comparing(Document::getCreatedAt).reversed())
                .skip(Math.max(0, offset))
                .limit(Math.max(0, limit))
                .collect(Collectors.toList());
    }

    @Override
    public int count(String keyword, DocumentType type, DocumentStatus status,
            java.time.LocalDate from, java.time.LocalDate to) {
        return filter(keyword, type, status, from, to).size();
    }

    private List<Document> filter(String keyword, DocumentType type, DocumentStatus status,
            java.time.LocalDate from, java.time.LocalDate to) {
        return store.stream().filter(d -> {
            boolean ok = true;
            if (keyword != null && !keyword.isEmpty()) {
                String k = keyword.toLowerCase();
                ok &= (d.getDocNo() != null && d.getDocNo().toLowerCase().contains(k))
                        || (d.getTitle() != null && d.getTitle().toLowerCase().contains(k))
                        || (d.getContent() != null && d.getContent().toLowerCase().contains(k));
            }
            if (type != null)
                ok &= d.getType() == type;
            if (status != null)
                ok &= d.getStatus() == status;
            if (from != null) {
                boolean issueOk = d.getIssueDate() != null && !d.getIssueDate().toLocalDate().isBefore(from);
                boolean recvOk = d.getReceiveDate() != null && !d.getReceiveDate().toLocalDate().isBefore(from);
                ok &= issueOk || recvOk;
            }
            if (to != null) {
                boolean issueOk = d.getIssueDate() != null && !d.getIssueDate().toLocalDate().isAfter(to);
                boolean recvOk = d.getReceiveDate() != null && !d.getReceiveDate().toLocalDate().isAfter(to);
                ok &= issueOk || recvOk;
            }
            return ok;
        }).collect(Collectors.toList());
    }

    // ===== CRUD đơn giản =====
    @Override
    public void create(Document d) {
        if (d.getId() == null)
            d.setId(idGen.incrementAndGet());
        store.add(0, d);
    }

    @Override
    public Document getById(Long id) {
        return store.stream().filter(x -> Objects.equals(x.getId(), id)).findFirst().orElse(null);
    }

    // ===== Lịch sử & xử lý =====
    @Override
    public List<DocumentHistory> historiesOf(Long docId) {
        return histories.getOrDefault(docId, new ArrayList<>());
    }

    private void addHistory(Long docId, Long actorId, ActionType action,
            String comment, Long toUserId, DocumentStatus after) {
        DocumentHistory h = new DocumentHistory();
        h.setId(UUID.randomUUID().getMostSignificantBits() & Long.MAX_VALUE);
        h.setDocumentId(docId);
        h.setActorId(actorId);
        h.setAction(action);
        h.setComment(comment);
        h.setToUserId(toUserId);
        h.setStatusAfter(after);
        h.setAtTime(LocalDateTime.now());
        histories.computeIfAbsent(docId, k -> new ArrayList<>()).add(0, h);
    }

    @Override
    public void approve(Long docId, Long actorId, String comment) {
        Document d = getById(docId);
        if (d == null)
            return;
        d.setStatus(DocumentStatus.APPROVED);
        d.setUpdatedAt(LocalDateTime.now());
        addHistory(docId, actorId, ActionType.APPROVE, comment, null, DocumentStatus.APPROVED);
    }

    @Override
    public void reject(Long docId, Long actorId, String comment) {
        Document d = getById(docId);
        if (d == null)
            return;
        d.setStatus(DocumentStatus.REJECTED);
        d.setUpdatedAt(LocalDateTime.now());
        addHistory(docId, actorId, ActionType.REJECT, comment, null, DocumentStatus.REJECTED);
    }

    @Override
    public void forward(Long docId, Long actorId, Long toUserId, String comment) {
        Document d = getById(docId);
        if (d == null)
            return;
        d.setStatus(DocumentStatus.IN_PROGRESS);
        d.setUpdatedAt(LocalDateTime.now());
        addHistory(docId, actorId, ActionType.FORWARD, comment, toUserId, DocumentStatus.IN_PROGRESS);
    }

    @Override
    public Long addAttachment(Long docId, String filename, String contentType, long sizeBytes, String diskPath,
            Long uploadedBy) {
        com.example.docflow.domain.DocumentFile f = new com.example.docflow.domain.DocumentFile();
        f.setId(fileIdGen.getAndIncrement());
        f.setDocumentId(docId);
        f.setFilename(filename);
        f.setContentType(contentType);
        f.setSizeBytes(sizeBytes);
        f.setDiskPath(diskPath);
        f.setUploadedBy(uploadedBy);
        f.setUploadedAt(java.time.LocalDateTime.now());
        files.computeIfAbsent(docId, k -> new java.util.ArrayList<>()).add(0, f);
        return f.getId();
    }

    @Override
    public java.util.List<com.example.docflow.domain.DocumentFile> listAttachments(Long docId) {
        return files.getOrDefault(docId, new java.util.ArrayList<>());
    }

    @Override
    public com.example.docflow.domain.DocumentFile getAttachment(Long fileId) {
        for (java.util.List<com.example.docflow.domain.DocumentFile> lst : files.values()) {
            for (com.example.docflow.domain.DocumentFile f : lst) {
                if (java.util.Objects.equals(f.getId(), fileId))
                    return f;
            }
        }
        return null;
    }

@Override
public void deleteAttachment(Long fileId) {
    for (java.util.List<com.example.docflow.domain.DocumentFile> lst : files.values()) {
        lst.removeIf(f -> java.util.Objects.equals(f.getId(), fileId));
    }
}
}