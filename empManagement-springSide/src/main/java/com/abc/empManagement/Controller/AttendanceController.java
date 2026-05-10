package com.abc.empManagement.Controller;

import com.abc.empManagement.DTOs.ProjectDtos.AttendanceResponseDTO;
import com.abc.empManagement.service.AttendanceService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/attendances")
public class AttendanceController {

    private final AttendanceService attendanceService;

    // =========================
    // CHECK-IN (ONLY SELF)
    // =========================
    @PreAuthorize("hasRole('EMPLOYEE')")
    @PostMapping("/check-in")
    public ResponseEntity<AttendanceResponseDTO> checkIn(Authentication auth) {
       try {
           String username = auth.getName();
           return ResponseEntity.ok(attendanceService.checkIn(username));
       }catch (Exception e){
           System.out.println("Exception: " + e.getMessage());

           return ResponseEntity
                   .status(HttpStatus.BAD_REQUEST)
                   .body(null);
       }
    }

    // =========================
    // CHECK-OUT (ONLY SELF)
    // =========================
    @PreAuthorize("hasRole('EMPLOYEE')")
    @PostMapping("/check-out")
    public ResponseEntity<AttendanceResponseDTO> checkOut(Authentication auth) {
        try {
            String username = auth.getName();
            return ResponseEntity.ok(attendanceService.checkOut(username));
        }catch (Exception e){
            System.out.println("Exception: " + e.getMessage());

            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(null);
        }
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
    @PreAuthorize("hasAnyRole('EMPLOYEE')")
    @GetMapping("/employee")
    public ResponseEntity<List<AttendanceResponseDTO>> getByCurrentEmployee(Authentication auth) {
        return ResponseEntity.ok(attendanceService.getByCurrentEmployee(auth.getName()));
    }

    // =========================
    // GET BY DATE (ADMIN ONLY)
    // =========================
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/selectedDate")
    public ResponseEntity<List<AttendanceResponseDTO>> getBySelectedDate(@RequestParam LocalDate date) {
        return ResponseEntity.ok(attendanceService.getBySelectedDate(date));
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
    @PreAuthorize("hasAnyRole('EMPLOYEE')")
    @GetMapping("/count")
    public ResponseEntity<Long> countPresentDays(Authentication auth) {
        return ResponseEntity.ok(attendanceService.countPresentDays(auth.getName()));
    }


    // =========================
    // MONTHLY REPORT
    // =========================
    @PreAuthorize("hasRole('EMPLOYEE')")
    @GetMapping("/monthly")
    public ResponseEntity<List<AttendanceResponseDTO>> monthly(
           Authentication auth,
            @RequestParam String month
    ) {
        YearMonth ym = YearMonth.parse(month);

        return ResponseEntity.ok(
                attendanceService.getMonthlyAttendance(auth.getName(), ym)
        );
    }

    @PreAuthorize("hasAnyRole('EMPLOYEE')")
    @GetMapping("/employees/open")
    public ResponseEntity<Boolean> hasOpenAttendance(Authentication auth) {
        return ResponseEntity.ok(attendanceService.hasOpenAttendance(auth.getName()));
    }

}