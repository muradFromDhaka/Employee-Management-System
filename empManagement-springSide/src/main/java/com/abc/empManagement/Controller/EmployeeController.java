package com.abc.empManagement.Controller;

import com.abc.empManagement.DTOs.ProjectDtos.EmployeeRequestDTO;
import com.abc.empManagement.DTOs.ProjectDtos.EmployeeResponseDTO;
import com.abc.empManagement.service.EmployeeService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/employees")
@RequiredArgsConstructor
public class EmployeeController {

    private final EmployeeService employeeService;

    // =========================
    // GET ALL
    // =========================
    @GetMapping
    public ResponseEntity<List<EmployeeResponseDTO>> getAll() {
        return ResponseEntity.ok(employeeService.getAll());
    }

    // =========================
    // GET BY ID
    // =========================
    @GetMapping("/{id}")
    public ResponseEntity<EmployeeResponseDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(employeeService.getById(id));
    }

    @PostMapping
    public ResponseEntity<String> create(@RequestBody EmployeeRequestDTO dto) {
        return ResponseEntity.ok(employeeService.create(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<String> update(
            @PathVariable Long id,
            @RequestBody EmployeeRequestDTO dto) {

        return ResponseEntity.ok(employeeService.update(id, dto));
    }

    // =========================
    // DELETE
    // =========================
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        employeeService.delete(id);
        return ResponseEntity.noContent().build();
    }

    // =========================
    // SEARCH BY NAME
    // =========================
    @GetMapping("/search")
    public ResponseEntity<List<EmployeeResponseDTO>> searchByEmployeeName(
            @RequestParam String name) {

        return ResponseEntity.ok(employeeService.searchByName(name));
    }

    // =========================
    // GET BY DEPARTMENT
    // =========================
    @GetMapping("/department/{deptId}")
    public ResponseEntity<List<EmployeeResponseDTO>> getByDepartment(
            @PathVariable Long deptId) {

        return ResponseEntity.ok(employeeService.getByDepartment(deptId));
    }

    // =========================
    // GET BY ROLE
    // =========================
    @GetMapping("/role")
    public ResponseEntity<List<EmployeeResponseDTO>> getByRole(
            @RequestParam String roleName) {

        return ResponseEntity.ok(employeeService.getByRole(roleName));
    }

    // =========================
    // DEACTIVATE EMPLOYEE (SOFT DELETE)
    // =========================
    @PatchMapping("/{id}/deactivate")
    public ResponseEntity<Void> deactivateEmployee(@PathVariable Long id) {
        employeeService.deactivateEmployee(id);
        return ResponseEntity.noContent().build();
    }

    // =========================
    // UPDATE PHONE ONLY
    // =========================
    @PatchMapping("/{id}/phone")
    public ResponseEntity<EmployeeResponseDTO> updatePhone(
            @PathVariable Long id,
            @RequestParam String phone) {

        return ResponseEntity.ok(employeeService.updatePhone(id, phone));
    }

    // =========================
    // TOTAL EMPLOYEES
    // =========================
    @GetMapping("/count")
    public ResponseEntity<Long> getCount() {
        return ResponseEntity.ok(employeeService.getTotalEmployees());
    }



    // =========================
    // PAGINATION
    // =========================
    @GetMapping("/paged")
    public ResponseEntity<Page<EmployeeResponseDTO>> getPaged(Pageable pageable) {
        return ResponseEntity.ok(employeeService.getAllPaged(pageable));
    }

    // =========================
    // CHECK EMAIL EXISTS
    // =========================
    @GetMapping("/exists")
    public ResponseEntity<Boolean> existsByEmail(@RequestParam String email) {
        return ResponseEntity.ok(employeeService.existsByEmail(email));
    }
}