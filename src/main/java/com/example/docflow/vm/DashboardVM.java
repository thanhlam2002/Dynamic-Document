// src/main/java/com/example/docflow/vm/DashboardVM.java
package com.example.docflow.vm;

import com.example.docflow.domain.Document;
import com.example.docflow.domain.enums.DocumentStatus;
import com.example.docflow.domain.enums.DocumentType;
import com.example.docflow.service.DocumentService;
import com.example.docflow.service.ServiceFactory;
import com.example.docflow.service.impl.InMemoryDocumentService;
import org.zkoss.bind.annotation.*;

import java.util.EnumMap;
import java.util.List;
import java.util.Map;

public class DashboardVM {
  private final DocumentService docSvc = ServiceFactory.documents();

  private int total;
  private final Map<DocumentStatus, Integer> byStatus = new EnumMap<>(DocumentStatus.class);
  private final Map<DocumentType, Integer> byType = new EnumMap<>(DocumentType.class);

  @Init @NotifyChange({"total","byStatus","byType"})
  public void init() { refresh(); }

  @Command @NotifyChange({"total","byStatus","byType"})
  public void refresh() {
    List<Document> all = docSvc.search(null, null, null, null, null, 0, Integer.MAX_VALUE);
    total = all.size();

    for (DocumentStatus s: DocumentStatus.values()) byStatus.put(s, 0);
    for (DocumentType t: DocumentType.values())   byType.put(t, 0);

    for (Document d: all) {
      if (d.getStatus() != null) byStatus.put(d.getStatus(), byStatus.get(d.getStatus()) + 1);
      if (d.getType()   != null) byType.put(d.getType(),   byType.get(d.getType())   + 1);
    }
  }

  public int getTotal() { return total; }
  public Map<DocumentStatus, Integer> getByStatus() { return byStatus; }
  public Map<DocumentType, Integer> getByType() { return byType; }

  public int pct(int part) { return total == 0 ? 0 : Math.round(part * 100f / total); }

  // === Helpers cho ZUL: lookup bằng chuỗi, null-safe ===
  public int status(String name) {
    if (name == null) return 0;
    try {
      DocumentStatus s = DocumentStatus.valueOf(name);
      Integer v = byStatus.get(s);
      return v == null ? 0 : v;
    } catch (IllegalArgumentException e) {
      return 0;
    }
  }
  public int type(String name) {
    if (name == null) return 0;
    try {
      DocumentType t = DocumentType.valueOf(name);
      Integer v = byType.get(t);
      return v == null ? 0 : v;
    } catch (IllegalArgumentException e) {
      return 0;
    }
  }
}
