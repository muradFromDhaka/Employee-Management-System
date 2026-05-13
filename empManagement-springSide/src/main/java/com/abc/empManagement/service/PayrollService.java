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
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;

@Service
@RequiredArgsConstructor
public class PayrollService {

    private final PayrollRepository payrollRepository;
    private final EmployeeRepository employeeRepository;
    private final AttendanceRepository attendanceRepository;
    private final LeaveRequestRepository leaveRequestRepository;
    private final PayrollMapper payrollMapper;

    @Transactional
    public Payroll generatePayroll(Long employeeId, YearMonth month) {

        Employee emp = employeeRepository.findById(employeeId)
                .orElseThrow(() -> new EntityNotFoundException("Employee not found"));

        // prevent duplicate payroll
        if (payrollRepository.findByEmployeeIdAndMonth(employeeId, month).isPresent()) {
            throw new IllegalStateException("Payroll already generated for this month");
        }

        double basicSalary = emp.getBasicSalary();

        // calculate values for selected month
        double bonus = calculateBonus(employeeId, month);
        double deduction = calculateDeduction(employeeId, month);

        Payroll payroll = new Payroll();

        payroll.setEmployee(emp);

        // store YearMonth directly
        payroll.setMonth(month);

        payroll.setBasicSalary(basicSalary);
        payroll.setBonus(bonus);
        payroll.setDeduction(deduction);

        payroll.setFinalSalary(
                basicSalary + bonus - deduction
        );

        return payrollRepository.save(payroll);
    }



    private double calculateBonus(Long employeeId, YearMonth month) {

        LocalDate start = month.atDay(1);
        LocalDate end = month.atEndOfMonth();

        long presentDays = attendanceRepository
                .countByEmployeeIdAndDateBetween(
                        employeeId,
                        start,
                        end
                );

        if (presentDays >= 26) return 5000;
        if (presentDays >= 20) return 3000;

        return 1000;
    }


    private double calculateDeduction(Long employeeId, YearMonth month) {

        LocalDate start = month.atDay(1);
        LocalDate end = month.atEndOfMonth();

        long leaves = leaveRequestRepository
                .countByEmployeeIdAndStatusAndStartDateBetween(
                        employeeId,
                        LeaveStatus.APPROVED,
                        start,
                        end
                );

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

    public List<PayrollResponseDTO> getMonthlyPayroll(YearMonth month) {

        return payrollRepository.findByMonth(month)
                .stream()
                .map(payrollMapper::toDto)
                .toList();
    }

    public Double getTotalSalaryExpense(YearMonth month) {

        Double total = payrollRepository.getTotalSalaryByMonth(month);

        return total != null ? total : 0.0;
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