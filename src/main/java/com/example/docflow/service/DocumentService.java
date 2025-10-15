package com.example.docflow.service;

import com.example.docflow.domain.Document;
import com.example.docflow.domain.enums.DocumentStatus;
import com.example.docflow.domain.enums.DocumentType;
import com.example.docflow.domain.DocumentFile;

import java.time.LocalDate;
import java.util.List;

public interface DocumentService {
    List<Document> search(String keyword, DocumentType type, DocumentStatus status,
            LocalDate from, LocalDate to, int offset, int limit);

    int count(String keyword, DocumentType type, DocumentStatus status, LocalDate from, LocalDate to);

    Document getById(Long id);

    java.util.List<com.example.docflow.domain.DocumentHistory> historiesOf(Long docId);

    void approve(Long docId, Long actorId, String comment);

    void reject(Long docId, Long actorId, String comment);

    void forward(Long docId, Long actorId, Long toUserId, String comment);

    void create(Document d);

    Long addAttachment(Long docId, String filename, String contentType, long sizeBytes, String diskPath,
            Long uploadedBy);

    java.util.List<DocumentFile> listAttachments(Long docId);

    DocumentFile getAttachment(Long fileId);

    void deleteAttachment(Long fileId);

}
