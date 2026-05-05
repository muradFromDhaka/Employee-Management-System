package com.abc.empManagement.DTOs.SecurityDtos;

import java.util.Set;

public record RoleUpdateRequest(Set<String> roles) {
}
