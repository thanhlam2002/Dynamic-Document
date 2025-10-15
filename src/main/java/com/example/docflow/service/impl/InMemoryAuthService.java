package com.example.docflow.service.impl;

import com.example.docflow.domain.User;
import com.example.docflow.service.AuthService;

import java.util.*;
import java.util.stream.Collectors;

/**
 * AuthService in-memory cho demo:
 * - Đăng nhập (username/password)
 * - Lấy vai trò người dùng
 * - Liệt kê toàn bộ người dùng (phục vụ combobox Forward)
 * - Tìm user theo id
 */
public class InMemoryAuthService implements AuthService {
    // Dữ liệu demo
    private final Map<String, User> usersByUsername = new HashMap<>();
    private final Map<Long,   User> usersById       = new HashMap<>();
    private final Map<String, String> rolesByUsername = new HashMap<>(); // username -> role

    public InMemoryAuthService() {
        // Seed user
        addUser(new User(1L, "employee", "123", "Nhân viên A"), "EMPLOYEE");
        addUser(new User(2L, "leader",   "123", "Lãnh đạo B"),  "LEADER");
        // Thêm vài user để demo chuyển tiếp
        addUser(new User(3L, "thu-ky",       "123", "Thư ký C"),       "EMPLOYEE");
        addUser(new User(4L, "chuyen-vien",  "123", "Chuyên viên D"),  "EMPLOYEE");
    }

    private void addUser(User u, String role) {
        usersByUsername.put(u.getUsername(), u);
        usersById.put(u.getId(), u);
        rolesByUsername.put(u.getUsername(), role);
    }

    @Override
    public User login(String username, String password) {
        User u = usersByUsername.get(username);
        if (u == null) return null;
        // Ở domain User đang dùng trường "passwordHash" cho demo,
        // kiểm tra đơn giản chuỗi "password" == "passwordHash"
        if (!Objects.equals(u.getPasswordHash(), password)) return null;
        // Nếu User có cờ active
        try {
            if (!u.isActive()) return null;
        } catch (NoSuchMethodError | Exception ignore) {
            // Nếu domain chưa có isActive(), bỏ qua
        }
        return u;
    }

    @Override
    public String roleOf(User user) {
        if (user == null) return null;
        return rolesByUsername.get(user.getUsername());
    }

    // ====== Các API thêm để phục vụ UI chuyển tiếp ======

    @Override
    public List<User> listUsers() {
        // Trả về bản copy không chỉnh sửa được
        return Collections.unmodifiableList(
                usersById.values().stream()
                        .sorted(Comparator.comparing(User::getId))
                        .collect(Collectors.toList())
        );
    }

    @Override
    public User findById(Long id) {
        return usersById.get(id);
    }
}
