package com.abc.empManagement.service;

import com.abc.empManagement.DTOs.ProjectDtos.PayrollResponseDTO;
import com.abc.empManagement.Mapper.PayrollMapper;
import com.abc.empManagement.entity.Employee;
import com.abc.empManagement.entity.Payroll;
import com.abc.empManagement.repository.AttendanceRepository;
import com.abc.empManagement.repository.EmployeeRepository;
import com.abc.empManagement.repository.LeaveRequestRepository;
import com.abc.empManagement.repository.PayrollRepository;
import com.abc.empManagement.enums.LeaveStatus;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class PayrollService {

    private final PayrollRepository payrollRepository;
    private final EmployeeRepository employeeRepository;
    private final AttendanceRepository attendanceRepository;
    private final LeaveRequestRepository leaveRequestRepository;
    private final PayrollMapper payrollMapper;

    public Payroll generatePayroll(Long employeeId, LocalDateTime month) {

        Employee emp = employeeRepository.findById(employeeId)
                .orElseThrow(() -> new EntityNotFoundException("Employee not found"));

        LocalDateTime normalizedMonth = month.withDayOfMonth(1);

        // prevent duplicate
        if (payrollRepository.findByEmployeeIdAndMonth(employeeId, normalizedMonth).isPresent()) {
            throw new RuntimeException("Payroll already generated for this month");
        }

        double basicSalary = emp.getBasicSalary(); // BEST PRACTICE

        double bonus = calculateBonus(employeeId, normalizedMonth);
        double deduction = calculateDeduction(employeeId, normalizedMonth);

        Payroll payroll = new Payroll();
        payroll.setEmployee(emp);
        payroll.setMonth(normalizedMonth);
        payroll.setBasicSalary(basicSalary);
        payroll.setBonus(bonus);
        payroll.setDeduction(deduction);
        payroll.setFinalSalary(basicSalary + bonus - deduction);

        return payrollRepository.save(payroll);
    }


    private double calculateBonus(Long employeeId, LocalDateTime month) {

        long presentDays = attendanceRepository.countByEmployeeId(employeeId);

        if (presentDays >= 26) return 5000;
        if (presentDays >= 20) return 3000;

        return 1000;
    }


    private double calculateDeduction(Long employeeId, LocalDateTime month) {

        long leaves = leaveRequestRepository
                .countByEmployeeIdAndStatus(employeeId, LeaveStatus.APPROVED);

        return leaves * 500;
    }


    public PayrollResponseDTO getById(Long id) {

        Payroll payroll = payrollRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Payroll not found"));

        return payrollMapper.toDto(payroll);
    }

    public List<PayrollResponseDTO> getPayrollByEmployee(Long employeeId) {

        return payrollRepository.findByEmployeeId(employeeId)
                .stream()
                .map(payrollMapper::toDto)
                .toList();
    }

    public List<PayrollResponseDTO> getMonthlyPayroll(LocalDateTime month) {

        return payrollRepository.findByMonth(month.withDayOfMonth(1))
                .stream()
                .map(payrollMapper::toDto)
                .toList();
    }

    public Double getTotalSalaryExpense(LocalDateTime month) {
        return payrollRepository.getTotalSalaryByMonth(month.withDayOfMonth(1));
    }

    public void deletePayroll(Long id) {

        Payroll payroll = payrollRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Payroll not found"));

        payrollRepository.delete(payroll);
    }

    public PayrollResponseDTO getLatestPayroll(Long employeeId) {

        Payroll payroll = payrollRepository
                .findTopByEmployeeIdOrderByMonthDesc(employeeId);

        if (payroll == null) {
            throw new EntityNotFoundException("No payroll found");
        }

        return payrollMapper.toDto(payroll);
    }
}