package com.abc.empManagement.DTOs.SecurityDtos;

public record RegisterRequest(
        String username,
        String password,
        String email,
        String firstName,
        String lastName
       
) {}
