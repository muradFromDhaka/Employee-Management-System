package com.abc.empManagement.DTOs.SecurityDtos;



import com.abc.empManagement.entity.Role;

import java.util.List;

public record AdminStatistics(long totalUsers, long enabledUsers, List<Role> roles) {
}
