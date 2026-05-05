package com.abc.empManagement.Controller;

import com.abc.empManagement.DTOs.ProjectDtos.AttendanceResponseDTO;
import com.abc.empManagement.service.AttendanceService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;
@RestController
@RequiredArgsConstructor
@RequestMapping("/attendances")
public class AttendanceController {

    private final AttendanceService attendanceService;

    // =========================
    // CHECK-IN (ONLY SELF)
    // =========================
    @PreAuthorize("hasRole('EMPLOYEE') and #employeeId == authentication.principal.id")
    @PostMapping("/check-in/{employeeId}")
    public ResponseEntity<AttendanceResponseDTO> checkIn(@PathVariable Long employeeId) {
        return ResponseEntity.ok(attendanceService.checkIn(employeeId));
    }

    // =========================
    // CHECK-OUT (ONLY SELF)
    // =========================
    @PreAuthorize("hasRole('EMPLOYEE') and #employeeId == authentication.principal.id")
    @PostMapping("/check-out/{employeeId}")
    public ResponseEntity<AttendanceResponseDTO> checkOut(@PathVariable Long employeeId) {
        return ResponseEntity.ok(attendanceService.checkOut(employeeId));
    }

    // =========================
    // GET ALL (ADMIN ONLY)
    // =========================
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping
    public ResponseEntity<List<AttendanceResponseDTO>> getAll() {
        return ResponseEntity.ok(attendanceService.getAll());
    }

    // =========================
    // GET BY ID (ADMIN ONLY)
    // =========================
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/{id}")
    public ResponseEntity<AttendanceResponseDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(attendanceService.getById(id));
    }

    // =========================
    // GET BY EMPLOYEE (SELF OR ADMIN)
    // =========================
    @PreAuthorize("hasRole('ADMIN') or #employeeId == authentication.principal.id")
    @GetMapping("/employee/{employeeId}")
    public ResponseEntity<List<AttendanceResponseDTO>> getByEmployee(@PathVariable Long employeeId) {
        return ResponseEntity.ok(attendanceService.getByEmployee(employeeId));
    }

    // =========================
    // GET BY DATE (ADMIN ONLY)
    // =========================
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/date")
    public ResponseEntity<List<AttendanceResponseDTO>> getByDate(@RequestParam LocalDate date) {
        return ResponseEntity.ok(attendanceService.getByDate(date));
    }

    // =========================
    // DELETE (ADMIN ONLY)
    // =========================
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        attendanceService.delete(id);
        return ResponseEntity.noContent().build();
    }

    // =========================
    // COUNT PRESENT DAYS
    // =========================
    @PreAuthorize("hasRole('ADMIN') or #employeeId == authentication.principal.id")
    @GetMapping("/count/{employeeId}")
    public ResponseEntity<Long> countPresentDays(@PathVariable Long employeeId) {
        return ResponseEntity.ok(attendanceService.countPresentDays(employeeId));
    }

    // =========================
    // WORKING HOURS
    // =========================
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/working-hours/{attendanceId}")
    public ResponseEntity<String> workingHours(@PathVariable Long attendanceId) {
        return ResponseEntity.ok(
                attendanceService.calculateWorkingHours(attendanceId).toString()
        );
    }

    // =========================
    // MONTHLY REPORT
    // =========================
    @PreAuthorize("hasRole('ADMIN') or #employeeId == authentication.principal.id")
    @GetMapping("/monthly")
    public ResponseEntity<List<AttendanceResponseDTO>> monthly(
            @RequestParam Long employeeId,
            @RequestParam String month
    ) {
        YearMonth ym = YearMonth.parse(month);

        return ResponseEntity.ok(
                attendanceService.getMonthlyAttendance(employeeId, ym)
        );
    }

    @PreAuthorize("hasRole('ADMIN') or #employeeId == authentication.principal.id")
    @GetMapping("/employees/{employeeId}/open")
    public ResponseEntity<Boolean> hasOpenAttendance(@PathVariable Long employeeId) {
        return ResponseEntity.ok(attendanceService.hasOpenAttendance(employeeId));
    }

}