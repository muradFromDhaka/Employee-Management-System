package com.abc.empManagement.Controller;

import com.abc.empManagement.DTOs.ProjectDtos.DepartmentRequestDto;
import com.abc.empManagement.DTOs.ProjectDtos.DepartmentResponseDto;
import com.abc.empManagement.service.DepartmentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/departments")
public class DepartmentController {

    private final DepartmentService departmentService;

    @GetMapping
    public ResponseEntity<List<DepartmentResponseDto>> getAll() {
        return ResponseEntity.ok(departmentService.getAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<DepartmentResponseDto> getById(@PathVariable Long id) {
        return ResponseEntity.ok(departmentService.getById(id));
    }

    @PostMapping
    public ResponseEntity<String> create(@RequestBody DepartmentRequestDto dto) {
        return ResponseEntity.ok(departmentService.create(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<String> update(
            @PathVariable Long id,
            @RequestBody DepartmentRequestDto dto
    ) {
        return ResponseEntity.ok(departmentService.update(dto, id));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        departmentService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}/employees")
    public ResponseEntity<DepartmentResponseDto> getDepartmentWithEmployees(@PathVariable Long id) {
        return ResponseEntity.ok(departmentService.findByIdWithEmployees(id));
    }

    @GetMapping("/{id}/employee-count")
    public ResponseEntity<Long> countEmployees(@PathVariable Long id) {
        return ResponseEntity.ok(departmentService.countEmployeesByDepartment(id));
    }
}