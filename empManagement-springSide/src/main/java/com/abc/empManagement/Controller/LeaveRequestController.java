package com.abc.empManagement.Controller;

import com.abc.empManagement.DTOs.ProjectDtos.LeaveRequestDTO;
import com.abc.empManagement.DTOs.ProjectDtos.LeaveResponseDTO;
import com.abc.empManagement.enums.LeaveStatus;
import com.abc.empManagement.service.LeaveRequestService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/leaves")
public class LeaveRequestController {

    private final LeaveRequestService leaveRequestService;

    // =========================
    // APPLY LEAVE (EMPLOYEE)
    // =========================
    @PreAuthorize("hasRole('EMPLOYEE')")
    @PostMapping
    public ResponseEntity<LeaveResponseDTO> applyLeave(
            @RequestBody LeaveRequestDTO dto
    ) {
        return ResponseEntity.ok(leaveRequestService.applyLeave(dto));
    }

    // =========================
    // GET ALL LEAVES (ADMIN)
    // =========================
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping
    public ResponseEntity<List<LeaveResponseDTO>> getAll() {
        return ResponseEntity.ok(leaveRequestService.getAll());
    }

    // =========================
    // GET BY ID (ADMIN)
    // =========================
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/{id}")
    public ResponseEntity<LeaveResponseDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(leaveRequestService.getById(id));
    }

    // =========================
    // EMPLOYEE OWN LEAVES
    // =========================
    @PreAuthorize("hasRole('EMPLOYEE') or hasRole('ADMIN')")
    @GetMapping("/employee/{employeeId}")
    public ResponseEntity<List<LeaveResponseDTO>> getByEmployee(
            @PathVariable Long employeeId
    ) {
        return ResponseEntity.ok(leaveRequestService.getByEmployee(employeeId));
    }

    // =========================
    // APPROVE LEAVE (ADMIN)
    // =========================
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{id}/approve")
    public ResponseEntity<LeaveResponseDTO> approve(@PathVariable Long id) {
        return ResponseEntity.ok(leaveRequestService.approveLeave(id));
    }

    // =========================
    // REJECT LEAVE (ADMIN)
    // =========================
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{id}/reject")
    public ResponseEntity<LeaveResponseDTO> reject(@PathVariable Long id) {
        return ResponseEntity.ok(leaveRequestService.rejectLeave(id));
    }

    // =========================
    // PENDING LEAVES (ADMIN DASHBOARD)
    // =========================
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/pending")
    public ResponseEntity<List<LeaveResponseDTO>> pending() {
        return ResponseEntity.ok(leaveRequestService.getPendingLeaves());
    }

    // =========================
    // DATE RANGE REPORT (ADMIN)
    // =========================
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/report")
    public ResponseEntity<List<LeaveResponseDTO>> report(
            @RequestParam LocalDate from,
            @RequestParam LocalDate to
    ) {
        return ResponseEntity.ok(
                leaveRequestService.getLeavesByDateRange(from, to)
        );
    }

    // =========================
    // COUNT LEAVES
    // =========================
    @PreAuthorize("hasRole('ADMIN') or hasRole('EMPLOYEE')")
    @GetMapping("/count")
    public ResponseEntity<Long> count(
            @RequestParam Long employeeId,
            @RequestParam LeaveStatus status
    ) {
        return ResponseEntity.ok(
                leaveRequestService.countLeaves(employeeId, status)
        );
    }

    // =========================
    // DELETE LEAVE (ADMIN)
    // =========================
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        leaveRequestService.delete(id);
        return ResponseEntity.noContent().build();
    }
}