package com.example.docflow.domain;

import com.example.docflow.domain.enums.DocumentStatus;
import com.example.docflow.domain.enums.DocumentType;
import java.time.LocalDateTime;
import java.util.List;

public class Document {
  private Long id;
  private String docNo;
  private String title;
  private String content;
  private DocumentType type;
  private LocalDateTime issueDate; // nếu Đi
  private LocalDateTime receiveDate; // nếu Đến
  private String receiverOrg; // nếu Đi
  private String senderOrg; // nếu Đến
  private Long createdBy;
  private DocumentStatus status;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;
  private List<String> attachments;
  private Long currentAssignee;

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public String getDocNo() {
    return docNo;
  }

  public void setDocNo(String docNo) {
    this.docNo = docNo;
  }

  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public String getContent() {
    return content;
  }

  public void setContent(String content) {
    this.content = content;
  }

  public DocumentType getType() {
    return type;
  }

  public void setType(DocumentType type) {
    this.type = type;
  }

  public LocalDateTime getIssueDate() {
    return issueDate;
  }

  public void setIssueDate(LocalDateTime issueDate) {
    this.issueDate = issueDate;
  }

  public LocalDateTime getReceiveDate() {
    return receiveDate;
  }

  public void setReceiveDate(LocalDateTime receiveDate) {
    this.receiveDate = receiveDate;
  }

  public String getReceiverOrg() {
    return receiverOrg;
  }

  public void setReceiverOrg(String receiverOrg) {
    this.receiverOrg = receiverOrg;
  }

  public String getSenderOrg() {
    return senderOrg;
  }

  public void setSenderOrg(String senderOrg) {
    this.senderOrg = senderOrg;
  }

  public Long getCreatedBy() {
    return createdBy;
  }

  public void setCreatedBy(Long createdBy) {
    this.createdBy = createdBy;
  }

  public DocumentStatus getStatus() {
    return status;
  }

  public void setStatus(DocumentStatus status) {
    this.status = status;
  }

  public LocalDateTime getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(LocalDateTime createdAt) {
    this.createdAt = createdAt;
  }

  public LocalDateTime getUpdatedAt() {
    return updatedAt;
  }

  public void setUpdatedAt(LocalDateTime updatedAt) {
    this.updatedAt = updatedAt;
  }

  public List<String> getAttachments() {
    return attachments;
  }

  public void setAttachments(List<String> attachments) {
    this.attachments = attachments;
  }

  public java.time.LocalDateTime getDisplayDate() {
    return (type == com.example.docflow.domain.enums.DocumentType.OUTGOING) ? issueDate : receiveDate;
  }

  public Long getCurrentAssignee() {
    return currentAssignee;
  }

  public void setCurrentAssignee(Long currentAssignee) {
    this.currentAssignee = currentAssignee;
  }

}
