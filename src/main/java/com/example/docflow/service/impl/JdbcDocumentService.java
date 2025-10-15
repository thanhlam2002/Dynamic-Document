package com.example.docflow.service.impl;

import com.example.docflow.domain.Document;
import com.example.docflow.domain.DocumentHistory;
import com.example.docflow.domain.enums.ActionType;
import com.example.docflow.domain.enums.DocumentStatus;
import com.example.docflow.domain.enums.DocumentType;
import com.example.docflow.service.DocumentService;

import javax.sql.DataSource;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class JdbcDocumentService implements DocumentService {
    private final DataSource ds;

    public JdbcDocumentService(DataSource ds) {
        this.ds = ds;
    }

    // ===== helpers =====
    private static Timestamp ts(LocalDateTime t) {
        return t == null ? null : Timestamp.valueOf(t);
    }

    private static LocalDateTime toLdt(Timestamp ts) {
        return ts == null ? null : ts.toLocalDateTime();
    }

    private Document mapDoc(ResultSet rs) throws SQLException {
        Document d = new Document();
        d.setId(rs.getLong("id"));
        d.setDocNo(rs.getString("doc_no"));
        d.setTitle(rs.getString("title"));
        d.setContent(rs.getString("content"));
        d.setType(DocumentType.valueOf(rs.getString("type")));
        d.setStatus(DocumentStatus.valueOf(rs.getString("status")));
        d.setIssueDate(toLdt(rs.getTimestamp("issue_date")));
        d.setReceiveDate(toLdt(rs.getTimestamp("receive_date")));
        d.setReceiverOrg(rs.getString("receiver_org"));
        d.setSenderOrg(rs.getString("sender_org"));
        d.setCreatedBy(rs.getLong("created_by"));
        d.setCreatedAt(toLdt(rs.getTimestamp("created_at")));
        d.setUpdatedAt(toLdt(rs.getTimestamp("updated_at")));
        d.setCurrentAssignee((Long) rs.getObject("current_assignee"));
        return d;
    }

    @Override
    public List<Document> search(String keyword, DocumentType type, DocumentStatus status,
            LocalDate from, LocalDate to, int offset, int limit) {
        StringBuilder sql = new StringBuilder(
                "SELECT * FROM document WHERE 1=1");
        List<Object> args = new ArrayList<>();

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (LOWER(doc_no) LIKE ? OR LOWER(title) LIKE ? OR LOWER(content) LIKE ?)");
            String k = "%" + keyword.toLowerCase() + "%";
            args.add(k);
            args.add(k);
            args.add(k);
        }
        if (type != null) {
            sql.append(" AND type=?");
            args.add(type.name());
        }
        if (status != null) {
            sql.append(" AND status=?");
            args.add(status.name());
        }
        if (from != null) {
            sql.append(
                    " AND ( (issue_date IS NOT NULL AND DATE(issue_date)>=?) OR (receive_date IS NOT NULL AND DATE(receive_date)>=?) )");
            args.add(Date.valueOf(from));
            args.add(Date.valueOf(from));
        }
        if (to != null) {
            sql.append(
                    " AND ( (issue_date IS NOT NULL AND DATE(issue_date)<=?) OR (receive_date IS NOT NULL AND DATE(receive_date)<=?) )");
            args.add(Date.valueOf(to));
            args.add(Date.valueOf(to));
        }

        sql.append(" ORDER BY created_at DESC LIMIT ? OFFSET ?");
        args.add(limit);
        args.add(offset);

        try (Connection c = ds.getConnection();
                PreparedStatement ps = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < args.size(); i++)
                ps.setObject(i + 1, args.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                List<Document> out = new ArrayList<>();
                while (rs.next())
                    out.add(mapDoc(rs));
                return out;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public int count(String keyword, DocumentType type, DocumentStatus status, LocalDate from, LocalDate to) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM document WHERE 1=1");
        List<Object> args = new ArrayList<>();

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND (LOWER(doc_no) LIKE ? OR LOWER(title) LIKE ? OR LOWER(content) LIKE ?)");
            String k = "%" + keyword.toLowerCase() + "%";
            args.add(k);
            args.add(k);
            args.add(k);
        }
        if (type != null) {
            sql.append(" AND type=?");
            args.add(type.name());
        }
        if (status != null) {
            sql.append(" AND status=?");
            args.add(status.name());
        }
        if (from != null) {
            sql.append(
                    " AND ( (issue_date IS NOT NULL AND DATE(issue_date)>=?) OR (receive_date IS NOT NULL AND DATE(receive_date)>=?) )");
            args.add(Date.valueOf(from));
            args.add(Date.valueOf(from));
        }
        if (to != null) {
            sql.append(
                    " AND ( (issue_date IS NOT NULL AND DATE(issue_date)<=?) OR (receive_date IS NOT NULL AND DATE(receive_date)<=?) )");
            args.add(Date.valueOf(to));
            args.add(Date.valueOf(to));
        }

        try (Connection c = ds.getConnection();
                PreparedStatement ps = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < args.size(); i++)
                ps.setObject(i + 1, args.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public Document getById(Long id) {
        try (Connection c = ds.getConnection();
                PreparedStatement ps = c.prepareStatement("SELECT * FROM document WHERE id=?")) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return mapDoc(rs);
                return null;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void create(Document d) {
        // 13 cột (đã có current_assignee), 13 dấu ?
        final String sql = "INSERT INTO document (" +
                " doc_no,title,content,type,status," + // 1..5
                " issue_date,receive_date," + // 6..7
                " receiver_org,sender_org," + // 8..9
                " created_by,created_at,updated_at," + // 10..12
                " current_assignee" + // 13
                ") VALUES (?,?,?,?,?, ?,?, ?,?, ?,?, ?,?)";

        try (Connection c = ds.getConnection();
                PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, d.getDocNo());
            ps.setString(2, d.getTitle());
            ps.setString(3, d.getContent());
            ps.setString(4, d.getType().name());
            ps.setString(5, d.getStatus().name());

            ps.setTimestamp(6, ts(d.getIssueDate()));
            ps.setTimestamp(7, ts(d.getReceiveDate()));

            // OUTGOING chỉ có receiver_org; INCOMING chỉ có sender_org
            if (d.getType() == DocumentType.OUTGOING) {
                ps.setString(8, d.getReceiverOrg());
                ps.setNull(9, Types.VARCHAR);
            } else {
                ps.setNull(8, Types.VARCHAR);
                ps.setString(9, d.getSenderOrg());
            }

            if (d.getCreatedBy() == null)
                ps.setNull(10, Types.BIGINT);
            else
                ps.setLong(10, d.getCreatedBy());
            ps.setTimestamp(11, ts(d.getCreatedAt()));
            ps.setTimestamp(12, ts(d.getUpdatedAt()));

            // current_assignee: nếu không set thì mặc định = created_by
            if (d.getCurrentAssignee() == null && d.getCreatedBy() == null) {
                ps.setNull(13, Types.BIGINT);
            } else {
                Long assignee = (d.getCurrentAssignee() != null) ? d.getCurrentAssignee() : d.getCreatedBy();
                ps.setObject(13, assignee);
            }

            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next())
                    d.setId(keys.getLong(1));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public List<DocumentHistory> historiesOf(Long docId) {
        String sql = "SELECT * FROM document_history WHERE document_id=? ORDER BY at_time DESC, id DESC";
        try (Connection c = ds.getConnection();
                PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, docId);
            try (ResultSet rs = ps.executeQuery()) {
                List<DocumentHistory> out = new ArrayList<>();
                while (rs.next()) {
                    DocumentHistory h = new DocumentHistory();
                    h.setId(rs.getLong("id"));
                    h.setDocumentId(rs.getLong("document_id"));
                    h.setActorId(rs.getLong("actor_id"));
                    h.setAction(ActionType.valueOf(rs.getString("action")));
                    h.setComment(rs.getString("comment"));
                    long toUser = rs.getLong("to_user_id");
                    h.setToUserId(rs.wasNull() ? null : toUser);
                    h.setStatusAfter(DocumentStatus.valueOf(rs.getString("status_after")));
                    h.setAtTime(toLdt(rs.getTimestamp("at_time")));
                    out.add(h);
                }
                return out;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private void addHistory(Connection c, Long docId, Long actorId, ActionType action,
            String comment, Long toUserId, DocumentStatus after) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement(
                "INSERT INTO document_history (document_id,actor_id,action,comment,to_user_id,status_after,at_time) VALUES (?,?,?,?,?,?,?)")) {
            ps.setLong(1, docId);
            ps.setObject(2, actorId);
            ps.setString(3, action.name());
            ps.setString(4, comment);
            if (toUserId == null)
                ps.setNull(5, Types.BIGINT);
            else
                ps.setLong(5, toUserId);
            ps.setString(6, after.name());
            ps.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));
            ps.executeUpdate();
        }
    }

    @Override
    public void approve(Long docId, Long actorId, String comment) {
        try (Connection c = ds.getConnection()) {
            c.setAutoCommit(false);
            int updated;
            try (PreparedStatement ps = c.prepareStatement(
                    "UPDATE document SET status=?, updated_at=? WHERE id=? AND status IN ('PENDING','IN_PROGRESS')")) {
                ps.setString(1, DocumentStatus.APPROVED.name());
                ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
                ps.setLong(3, docId);
                updated = ps.executeUpdate();
            }
            if (updated == 0) {
                c.rollback();
                throw new IllegalStateException("Trạng thái không hợp lệ để phê duyệt");
            }
            addHistory(c, docId, actorId, ActionType.APPROVE, comment, null, DocumentStatus.APPROVED);
            c.commit();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void reject(Long docId, Long actorId, String comment) {
        try (Connection c = ds.getConnection()) {
            c.setAutoCommit(false);
            int updated;
            try (PreparedStatement ps = c.prepareStatement(
                    "UPDATE document SET status=?, updated_at=? WHERE id=? AND status IN ('PENDING','IN_PROGRESS')")) {
                ps.setString(1, DocumentStatus.REJECTED.name());
                ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
                ps.setLong(3, docId);
                updated = ps.executeUpdate();
            }
            if (updated == 0) {
                c.rollback();
                throw new IllegalStateException("Trạng thái không hợp lệ để từ chối");
            }
            addHistory(c, docId, actorId, ActionType.REJECT, comment, null, DocumentStatus.REJECTED);
            c.commit();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void forward(Long docId, Long actorId, Long toUserId, String comment) {
        try (Connection c = ds.getConnection()) {
            c.setAutoCommit(false);
            int updated;
            try (PreparedStatement ps = c.prepareStatement(
                    "UPDATE document SET status=?, current_assignee=?, updated_at=? WHERE id=? AND status IN ('PENDING','IN_PROGRESS')")) {
                ps.setString(1, DocumentStatus.IN_PROGRESS.name());
                ps.setObject(2, toUserId);
                ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
                ps.setLong(4, docId);
                updated = ps.executeUpdate();
            }
            if (updated == 0) {
                c.rollback();
                throw new IllegalStateException("Trạng thái không hợp lệ để chuyển tiếp");
            }
            addHistory(c, docId, actorId, ActionType.FORWARD, comment, toUserId, DocumentStatus.IN_PROGRESS);
            c.commit();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public Long addAttachment(Long docId, String filename, String contentType, long sizeBytes, String diskPath,
            Long uploadedBy) {
        String sql = "INSERT INTO document_file (document_id,filename,content_type,size_bytes,disk_path,uploaded_by,uploaded_at) VALUES (?,?,?,?,?,?,?)";
        try (java.sql.Connection c = ds.getConnection();
                java.sql.PreparedStatement ps = c.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, docId);
            ps.setString(2, filename);
            ps.setString(3, contentType);
            ps.setLong(4, sizeBytes);
            ps.setString(5, diskPath);
            if (uploadedBy == null)
                ps.setNull(6, java.sql.Types.BIGINT);
            else
                ps.setLong(6, uploadedBy);
            ps.setTimestamp(7, java.sql.Timestamp.valueOf(java.time.LocalDateTime.now()));
            ps.executeUpdate();
            try (java.sql.ResultSet rs = ps.getGeneratedKeys()) {
                return rs.next() ? rs.getLong(1) : null;
            }
        } catch (java.sql.SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public java.util.List<com.example.docflow.domain.DocumentFile> listAttachments(Long docId) {
        String sql = "SELECT * FROM document_file WHERE document_id=? ORDER BY uploaded_at DESC, id DESC";
        try (java.sql.Connection c = ds.getConnection();
                java.sql.PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, docId);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                java.util.List<com.example.docflow.domain.DocumentFile> out = new java.util.ArrayList<>();
                while (rs.next()) {
                    com.example.docflow.domain.DocumentFile f = new com.example.docflow.domain.DocumentFile();
                    f.setId(rs.getLong("id"));
                    f.setDocumentId(rs.getLong("document_id"));
                    f.setFilename(rs.getString("filename"));
                    f.setContentType(rs.getString("content_type"));
                    f.setSizeBytes(rs.getLong("size_bytes"));
                    f.setDiskPath(rs.getString("disk_path"));
                    long up = rs.getLong("uploaded_by");
                    f.setUploadedBy(rs.wasNull() ? null : up);
                    java.sql.Timestamp t = rs.getTimestamp("uploaded_at");
                    f.setUploadedAt(t == null ? null : t.toLocalDateTime());
                    out.add(f);
                }
                return out;
            }
        } catch (java.sql.SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public com.example.docflow.domain.DocumentFile getAttachment(Long fileId) {
        String sql = "SELECT * FROM document_file WHERE id=?";
        try (java.sql.Connection c = ds.getConnection();
                java.sql.PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, fileId);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                if (!rs.next())
                    return null;
                com.example.docflow.domain.DocumentFile f = new com.example.docflow.domain.DocumentFile();
                f.setId(rs.getLong("id"));
                f.setDocumentId(rs.getLong("document_id"));
                f.setFilename(rs.getString("filename"));
                f.setContentType(rs.getString("content_type"));
                f.setSizeBytes(rs.getLong("size_bytes"));
                f.setDiskPath(rs.getString("disk_path"));
                long up = rs.getLong("uploaded_by");
                f.setUploadedBy(rs.wasNull() ? null : up);
                java.sql.Timestamp t = rs.getTimestamp("uploaded_at");
                f.setUploadedAt(t == null ? null : t.toLocalDateTime());
                return f;
            }
        } catch (java.sql.SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void deleteAttachment(Long fileId) {
        try (java.sql.Connection c = ds.getConnection();
                java.sql.PreparedStatement ps = c.prepareStatement("DELETE FROM document_file WHERE id=?")) {
            ps.setLong(1, fileId);
            ps.executeUpdate();
        } catch (java.sql.SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
