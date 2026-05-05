package com.abc.empManagement.repository;

import com.abc.empManagement.entity.Payroll;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface PayrollRepository extends JpaRepository<Payroll, Long> {

    // =========================
    // 1. Employee wise payroll history
    // =========================
    List<Payroll> findByEmployeeId(Long employeeId);

    // =========================
    // 2. Employee + Month (VERY IMPORTANT)
    // =========================
    Optional<Payroll> findByEmployeeIdAndMonth(Long employeeId, LocalDateTime month);

    // =========================
    // 3. All payrolls of a month (company report)
    // =========================
    List<Payroll> findByMonth(LocalDateTime month);

    // =========================
    // 4. High salary employees (reporting)
    // =========================
    List<Payroll> findByFinalSalaryGreaterThan(Double salary);

    // =========================
    // 5. Salary range filter (HR analytics)
    // =========================
    List<Payroll> findByFinalSalaryBetween(Double min, Double max);

    // =========================
    // 6. Total salary expense of company (IMPORTANT)
    // =========================
    @Query("""
        SELECT SUM(p.finalSalary)
        FROM Payroll p
        WHERE p.month = :month
    """)
    Double getTotalSalaryByMonth(LocalDateTime month);

    // =========================
    // 7. Employee salary count (how many payroll entries)
    // =========================
    long countByEmployeeId(Long employeeId);

    // =========================
    // 8. Latest payroll of employee
    // =========================
    Payroll findTopByEmployeeIdOrderByMonthDesc(Long employeeId);
}
