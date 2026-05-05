package com.abc.empManagement.Mapper;

import com.abc.empManagement.DTOs.ProjectDtos.AttendanceRequestDTO;
import com.abc.empManagement.DTOs.ProjectDtos.AttendanceResponseDTO;
import com.abc.empManagement.entity.Attendance;
import com.abc.empManagement.entity.Employee;
import org.springframework.stereotype.Component;

@Component
public class AttendanceMapper {

    public Attendance toEntity(AttendanceRequestDTO dto, Employee employee) {

        Attendance attendance = new Attendance();

        attendance.setDate(dto.getDate());
        attendance.setStatus(dto.getStatus());
        attendance.setCheckIn(dto.getCheckIn());
        attendance.setCheckOut(dto.getCheckOut());

        attendance.setEmployee(employee);

        return attendance;
    }

    public AttendanceResponseDTO toDto(Attendance entity) {

        AttendanceResponseDTO dto = new AttendanceResponseDTO();

        dto.setId(entity.getId());
        dto.setDate(entity.getDate());
        dto.setStatus(entity.getStatus());
        dto.setCheckIn(entity.getCheckIn());
        dto.setCheckOut(entity.getCheckOut());

        if (entity.getEmployee() != null) {
            dto.setEmployeeId(entity.getEmployee().getId());
            dto.setEmployeeName(entity.getEmployee().getName());
        }

        return dto;
    }
}