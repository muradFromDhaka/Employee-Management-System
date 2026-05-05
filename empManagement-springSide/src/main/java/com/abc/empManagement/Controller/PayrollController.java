package com.abc.empManagement.Controller;

import com.abc.empManagement.DTOs.ProjectDtos.PayrollResponseDTO;
import com.abc.empManagement.entity.Payroll;
import com.abc.empManagement.service.PayrollService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/payrolls")
@RequiredArgsConstructor
public class PayrollController {

    private final PayrollService payrollService;

    // =========================
    // 1. GENERATE PAYROLL
    // =========================
    @PostMapping("/generate")
    public ResponseEntity<PayrollResponseDTO> generatePayroll(
            @RequestParam Long employeeId,
            @RequestParam LocalDateTime month
    ) {
        Payroll payroll = payrollService.generatePayroll(employeeId, month);
        return ResponseEntity.ok(
                payrollService.getById(payroll.getId())
        );
    }

    // =========================
    // 2. GET BY ID
    // =========================
    @GetMapping("/{id}")
    public ResponseEntity<PayrollResponseDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(payrollService.getById(id));
    }

    // =========================
    // 3. EMPLOYEE PAYROLL HISTORY
    // =========================
    @GetMapping("/employee/{employeeId}")
    public ResponseEntity<List<PayrollResponseDTO>> getByEmployee(
            @PathVariable Long employeeId
    ) {
        return ResponseEntity.ok(
                payrollService.getPayrollByEmployee(employeeId)
        );
    }

    // =========================
    // 4. MONTHLY PAYROLL REPORT
    // =========================
    @GetMapping("/monthly")
    public ResponseEntity<List<PayrollResponseDTO>> getMonthlyPayroll(
            @RequestParam LocalDateTime month
    ) {
        return ResponseEntity.ok(
                payrollService.getMonthlyPayroll(month)
        );
    }

    // =========================
    // 5. TOTAL EXPENSE
    // =========================
    @GetMapping("/total-expense")
    public ResponseEntity<Double> getTotalExpense(
            @RequestParam LocalDateTime month
    ) {
        return ResponseEntity.ok(
                payrollService.getTotalSalaryExpense(month)
        );
    }

    // =========================
    // 6. DELETE PAYROLL
    // =========================
    @DeleteMapping("/{id}")
    public ResponseEntity<String> delete(@PathVariable Long id) {
        payrollService.deletePayroll(id);
        return ResponseEntity.ok("Payroll deleted successfully");
    }

    // =========================
    // 7. LATEST PAYROLL
    // =========================
    @GetMapping("/employee/{employeeId}/latest")
    public ResponseEntity<PayrollResponseDTO> getLatest(
            @PathVariable Long employeeId
    ) {
        return ResponseEntity.ok(
                payrollService.getLatestPayroll(employeeId)
        );
    }
}