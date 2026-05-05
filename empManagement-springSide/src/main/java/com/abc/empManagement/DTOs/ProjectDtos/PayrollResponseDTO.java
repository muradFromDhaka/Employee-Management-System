package com.abc.empManagement.DTOs.ProjectDtos;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class PayrollResponseDTO {

    private Long id;

    private Double basicSalary;
    private Double bonus;
    private Double deduction;
    private Double finalSalary;

    private LocalDateTime month;

    private Long employeeId;
    private String employeeName;
}