package com.example.docflow.domain;

public class Role {
  private Long id;
  private String code; // EMPLOYEE, LEADER

  public Role() {}
  public Role(Long id, String code) { this.id = id; this.code = code; }

  public Long getId() { return id; }
  public void setId(Long id) { this.id = id; }
  public String getCode() { return code; }
  public void setCode(String code) { this.code = code; }
}
