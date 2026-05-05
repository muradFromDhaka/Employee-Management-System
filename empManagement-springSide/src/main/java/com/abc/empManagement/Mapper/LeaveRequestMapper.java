package com.abc.empManagement.Mapper;

import com.abc.empManagement.DTOs.ProjectDtos.LeaveRequestDTO;
import com.abc.empManagement.DTOs.ProjectDtos.LeaveResponseDTO;
import com.abc.empManagement.entity.Employee;
import com.abc.empManagement.entity.LeaveRequest;
import com.abc.empManagement.enums.LeaveStatus;
import com.abc.empManagement.repository.EmployeeRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
public class LeaveRequestMapper {
    public LeaveRequest toEntity(LeaveRequestDTO dto, Employee emp){
        LeaveRequest entity = new LeaveRequest();
        entity.setReason(dto.getReason());
        entity.setStartDate(dto.getStartDate());
        entity.setEndDate(dto.getEndDate());
        entity.setStatus(LeaveStatus.PENDING);
        entity.setEmployee(emp);
        return entity;
    }

    public LeaveResponseDTO toDto(LeaveRequest leave){
        LeaveResponseDTO dto = new LeaveResponseDTO();
        dto.setId(leave.getId());
        dto.setReason(leave.getReason());
        dto.setStartDate(leave.getStartDate());
        dto.setEndDate(leave.getEndDate());
        dto.setStatus(leave.getStatus());
        if(leave.getEmployee() != null){
            dto.setEmployeeId(leave.getEmployee().getId());
            dto.setEmployeeName(leave.getEmployee().getName());
        }

        return dto;
    }
}
