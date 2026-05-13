package com.abc.empManagement.Controller;

import com.abc.empManagement.DTOs.ProjectDtos.PayrollResponseDTO;
import com.abc.empManagement.entity.Payroll;
import com.abc.empManagement.service.PayrollService;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.YearMonth;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/payrolls")
@RequiredArgsConstructor
public class PayrollController {

    private final PayrollService payrollService;

    @PreAuthorize("hasAnyRole('ADMIN','HR','PAYROLL','MANAGER')")
    @PostMapping
    public ResponseEntity<?> generatePayroll(
            @RequestParam @NotNull Long employeeId,
            @RequestParam @NotNull YearMonth month
    ) {
      try {
          Payroll payroll = payrollService.generatePayroll(employeeId, month);
          return ResponseEntity.ok(
                  payrollService.getById(payroll.getId())
          );
      }catch (Exception e){
          Map<String, Object> error = new HashMap<>();

          error.put("message", e.getMessage());
          error.put("status", 400);

          return ResponseEntity.badRequest().body(error);
      }
    }

    @PreAuthorize("hasAnyRole('ADMIN','MANAGER','HR','PAYROLL')")
    @GetMapping("/{id}")
    public ResponseEntity<PayrollResponseDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(payrollService.getById(id));
    }


    @PreAuthorize("hasRole('ADMIN') or #employeeId == authentication.principal.employeeId")
    @GetMapping("/employee/{employeeId}")
    public ResponseEntity<List<PayrollResponseDTO>> getByEmployee(
            @PathVariable Long employeeId
    ) {
        return ResponseEntity.ok(
                payrollService.getPayrollByEmployee(employeeId)
        );
    }


    @PreAuthorize("hasAnyRole('ADMIN','HR','PAYROLL','MANAGER')")
    @GetMapping("/monthly")
    public ResponseEntity<List<PayrollResponseDTO>> getMonthlyPayroll(
            @RequestParam YearMonth month
    ) {
        return ResponseEntity.ok(
                payrollService.getMonthlyPayroll(month)
        );
    }

    @PreAuthorize("hasAnyRole('ADMIN','MANAGER','HR','PAYROLL')")
    @GetMapping("/total-expense")
    public ResponseEntity<Double> getTotalExpense(
            @RequestParam YearMonth month
    ) {
        return ResponseEntity.ok(
                payrollService.getTotalSalaryExpense(month)
        );
    }

    @PreAuthorize("hasRole('ADMIN') or #employeeId == authentication.principal.employeeId")
    @GetMapping("/employee/{employeeId}/latest")
    public ResponseEntity<PayrollResponseDTO> getLatest(
            @PathVariable Long employeeId
    ) {
        return ResponseEntity.ok(
                payrollService.getLatestPayroll(employeeId)
        );
    }
}