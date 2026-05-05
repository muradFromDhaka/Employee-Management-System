package com.abc.empManagement.DTOs.ProjectDtos;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
public class EmployeeResponseDTO {

    private Long id;

    private String name;
    private String email;
    private String phone;
    private String address;

    private Double basicSalary;
    private LocalDate joiningDate;
    private boolean isActive;

    private Long departmentId;
    private String departmentName;

    private String roleName;
}
