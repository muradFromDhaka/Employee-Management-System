package com.abc.empManagement.DTOs.ProjectDtos;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DepartmentResponseDto {

    private Long id;
    private String depName;
    private String location;

    private int totalEmployees;

}
