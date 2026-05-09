package com.abc.empManagement.DTOs.ProjectDtos;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
@Getter
@Setter
public class LeaveRequestDTO {
    private String reason;

    private LocalDate startDate;

    private LocalDate endDate;
}
