package com.abc.empManagement.DTOs.ProjectDtos;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class EmployeeRequestDTO {

    private String name;
    private String email;
    private String phone;
    private String address;
    private Double basicSalary;

    private Long departmentId;
    private String roleName;
}
