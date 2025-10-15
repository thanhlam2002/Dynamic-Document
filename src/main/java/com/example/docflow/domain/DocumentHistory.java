package com.example.docflow.domain;

import com.example.docflow.domain.enums.ActionType;
import com.example.docflow.domain.enums.DocumentStatus;
import java.time.LocalDateTime;

public class DocumentHistory {
  private Long id;
  private Long documentId;
  private Long actorId;
  private ActionType action;
  private String comment;
  private Long toUserId;
  private DocumentStatus statusAfter;
  private LocalDateTime atTime;

  public Long getId() { return id; }
  public void setId(Long id) { this.id = id; }
  public Long getDocumentId() { return documentId; }
  public void setDocumentId(Long documentId) { this.documentId = documentId; }
  public Long getActorId() { return actorId; }
  public void setActorId(Long actorId) { this.actorId = actorId; }
  public ActionType getAction() { return action; }
  public void setAction(ActionType action) { this.action = action; }
  public String getComment() { return comment; }
  public void setComment(String comment) { this.comment = comment; }
  public Long getToUserId() { return toUserId; }
  public void setToUserId(Long toUserId) { this.toUserId = toUserId; }
  public DocumentStatus getStatusAfter() { return statusAfter; }
  public void setStatusAfter(DocumentStatus statusAfter) { this.statusAfter = statusAfter; }
  public LocalDateTime getAtTime() { return atTime; }
  public void setAtTime(LocalDateTime atTime) { this.atTime = atTime; }
}
