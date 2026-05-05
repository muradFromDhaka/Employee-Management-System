package com.abc.empManagement.Mapper;

import com.abc.empManagement.DTOs.ProjectDtos.EmployeeRequestDTO;
import com.abc.empManagement.DTOs.ProjectDtos.EmployeeResponseDTO;
import com.abc.empManagement.entity.Department;
import com.abc.empManagement.entity.Employee;
import com.abc.empManagement.entity.Role;
import org.springframework.stereotype.Component;

@Component
public class EmployeeMapper {

    // =========================
    // DTO -> ENTITY
    // =========================
    public Employee toEntity(EmployeeRequestDTO dto, Department department, Role role) {

        Employee employee = new Employee();

        employee.setName(dto.getName());
        employee.setEmail(dto.getEmail());
        employee.setPhone(dto.getPhone());
        employee.setAddress(dto.getAddress());
        employee.setBasicSalary(dto.getBasicSalary());

        employee.setDepartment(department);
        employee.setRole(role);

        // default system value
        employee.setActive(true);

        return employee;
    }

    public Employee toUpdateEntity(EmployeeRequestDTO dto,Employee emp, Department department, Role role) {

        emp.setName(dto.getName());
        emp.setEmail(dto.getEmail());
        emp.setPhone(dto.getPhone());
        emp.setAddress(dto.getAddress());
        emp.setBasicSalary(dto.getBasicSalary());

        emp.setDepartment(department);
        emp.setRole(role);

        // default system value
        emp.setActive(true);

        return emp;
    }


    // =========================
    // ENTITY -> DTO
    // =========================
    public EmployeeResponseDTO toDto(Employee employee) {

        EmployeeResponseDTO dto = new EmployeeResponseDTO();

        dto.setId(employee.getId());
        dto.setName(employee.getName());
        dto.setEmail(employee.getEmail());
        dto.setPhone(employee.getPhone());
        dto.setAddress(employee.getAddress());

        dto.setBasicSalary(employee.getBasicSalary());
        dto.setJoiningDate(employee.getJoiningDate());
        dto.setActive(employee.isActive());

        if (employee.getDepartment() != null) {
            dto.setDepartmentId(employee.getDepartment().getId());
            dto.setDepartmentName(employee.getDepartment().getDepName());
        }

        if (employee.getRole() != null) {
            dto.setRoleName(employee.getRole().getRoleName());
            dto.setRoleName(employee.getRole().getRoleName());
        }

        return dto;
    }
}