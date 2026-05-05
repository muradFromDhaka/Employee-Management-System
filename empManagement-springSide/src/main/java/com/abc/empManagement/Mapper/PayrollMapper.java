package com.abc.empManagement.Mapper;

import com.abc.empManagement.DTOs.ProjectDtos.PayrollRequestDTO;
import com.abc.empManagement.DTOs.ProjectDtos.PayrollResponseDTO;
import com.abc.empManagement.entity.Employee;
import com.abc.empManagement.entity.Payroll;
import com.abc.empManagement.repository.EmployeeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class PayrollMapper {

    private final EmployeeRepository employeeRepository;

    // =========================
    // DTO -> ENTITY
    // =========================
    public Payroll toEntity(PayrollRequestDTO dto, Employee emp) {

        Payroll payroll = new Payroll();

        payroll.setBasicSalary(dto.getBasicSalary());
        payroll.setBonus(dto.getBonus());
        payroll.setDeduction(dto.getDeduction());
        payroll.setMonth(dto.getMonth());

        // business logic (safe default)
        double finalSalary =
                dto.getBasicSalary() + dto.getBonus() - dto.getDeduction();

        payroll.setFinalSalary(finalSalary);

        payroll.setEmployee(emp);

        return payroll;
    }

    // =========================
    // ENTITY -> DTO
    // =========================
    public PayrollResponseDTO toDto(Payroll payroll) {

        PayrollResponseDTO dto = new PayrollResponseDTO();

        dto.setId(payroll.getId());
        dto.setBasicSalary(payroll.getBasicSalary());
        dto.setBonus(payroll.getBonus());
        dto.setDeduction(payroll.getDeduction());
        dto.setFinalSalary(payroll.getFinalSalary());
        dto.setMonth(payroll.getMonth());

        if (payroll.getEmployee() != null) {
            dto.setEmployeeId(payroll.getEmployee().getId());
            dto.setEmployeeName(payroll.getEmployee().getName());
        }

        return dto;
    }
}
