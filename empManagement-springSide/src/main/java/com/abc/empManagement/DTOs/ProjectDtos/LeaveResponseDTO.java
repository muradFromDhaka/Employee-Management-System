package com.abc.empManagement.DTOs.ProjectDtos;

import com.abc.empManagement.enums.LeaveStatus;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
@Getter
@Setter
public class LeaveResponseDTO {

    private Long id;

    private String reason;

    private LocalDate startDate;

    private LocalDate endDate;

    private LeaveStatus status;

    private Long employeeId;
    private String employeeName;
}
