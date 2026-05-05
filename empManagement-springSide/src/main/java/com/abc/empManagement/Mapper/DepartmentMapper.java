package com.abc.empManagement.Mapper;

import com.abc.empManagement.DTOs.ProjectDtos.DepartmentRequestDto;
import com.abc.empManagement.DTOs.ProjectDtos.DepartmentResponseDto;
import com.abc.empManagement.entity.Department;
import org.springframework.stereotype.Component;

@Component
public class DepartmentMapper {

    public Department toEntity(final DepartmentRequestDto dto, Department entity){
        entity.setDepName(dto.getDepName());
        entity.setLocation(dto.getLocation());
        return entity;
    }

    public DepartmentResponseDto toDto(final Department entity){
        DepartmentResponseDto dto = new DepartmentResponseDto();
        dto.setId(entity.getId());
        dto.setDepName(entity.getDepName());
        dto.setLocation(entity.getLocation());

        return dto;
    }
}
