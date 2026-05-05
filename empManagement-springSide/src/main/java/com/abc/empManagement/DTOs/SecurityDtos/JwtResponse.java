package com.abc.empManagement.DTOs.SecurityDtos;


import com.abc.empManagement.entity.User;

public record JwtResponse(
        String jwtToken,
        User user
) {}