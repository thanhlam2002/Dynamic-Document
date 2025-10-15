package com.example.docflow.service;

import java.util.List;

import com.example.docflow.domain.User;

public interface AuthService {
    User login(String username, String password);

    String roleOf(User user); // "EMPLOYEE" | "LEADER"

    List<User> listUsers();

    User findById(Long id);
}
