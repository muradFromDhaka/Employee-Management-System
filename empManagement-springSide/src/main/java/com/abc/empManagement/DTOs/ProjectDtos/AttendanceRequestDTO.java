package com.abc.empManagement.DTOs.ProjectDtos;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalTime;
@Getter
@Setter
public class AttendanceRequestDTO {
    private LocalDate date;
    private String status;
    private LocalTime checkIn;
    private LocalTime checkOut;

    private Long employeeId;
}
