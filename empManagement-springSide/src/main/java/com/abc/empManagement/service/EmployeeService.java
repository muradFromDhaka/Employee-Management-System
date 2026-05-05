package com.abc.empManagement.service;

import com.abc.empManagement.DTOs.ProjectDtos.DepartmentRequestDto;
import com.abc.empManagement.DTOs.ProjectDtos.EmployeeRequestDTO;
import com.abc.empManagement.DTOs.ProjectDtos.EmployeeResponseDTO;
import com.abc.empManagement.Mapper.EmployeeMapper;
import com.abc.empManagement.entity.Department;
import com.abc.empManagement.entity.Employee;
import com.abc.empManagement.entity.Role;
import com.abc.empManagement.repository.DepartmentRepository;
import com.abc.empManagement.repository.EmployeeRepository;
import com.abc.empManagement.repository.RoleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@RequiredArgsConstructor
@Service
public class EmployeeService {
    private final EmployeeMapper mapper;
    private final EmployeeRepository employeeRepository;
    private final DepartmentRepository departmentRepository;
    private final RoleRepository roleRepository;

    public List<EmployeeResponseDTO> getAll(){
        List<EmployeeResponseDTO> emps = employeeRepository.findAll()
                .stream()
                .map((e) -> mapper.toDto(e))
                .toList();
        return emps;
    };

    public EmployeeResponseDTO getById(Long id){
        Employee emp = employeeRepository.findById(id)
                .orElseThrow(()-> new RuntimeException("Employee not found with id: " + id));
         return mapper.toDto(emp);
    }

    public String create(EmployeeRequestDTO dto ){
        Department department = departmentRepository.findById(dto.getDepartmentId())
                .orElseThrow(() -> new RuntimeException("Department not found"));

        Role role = roleRepository.findById(dto.getRoleName())
                .orElseThrow(() -> new RuntimeException("Role not found"));

        Employee emp = mapper.toEntity(dto, department, role);
        String saveEmp = employeeRepository.save(emp).getName();

        return saveEmp;
    }

    public String update(Long id, EmployeeRequestDTO dto) {
        Department department = departmentRepository.findById(dto.getDepartmentId())
                .orElseThrow(() -> new RuntimeException("Department not found"));

        Role role = roleRepository.findById(dto.getRoleName())
                .orElseThrow(() -> new RuntimeException("Role not found"));

        Employee existingEmployee = employeeRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException("Employee not found with id: " + id)
                );
         mapper.toUpdateEntity(dto,existingEmployee, department, role);
       return employeeRepository.save(existingEmployee).getName();

    }

    public void delete(Long id){
        Employee emp = employeeRepository.findById(id)
                .orElseThrow(()-> new RuntimeException("Employee not found with id: " +id));

            employeeRepository.delete(emp);
    }

//    ==========================================================================================

    public List<EmployeeResponseDTO> searchByName(String name) {
        return employeeRepository.findByName(name)
                .stream()
                .map(e -> mapper.toDto(e))
                .toList();
    }

    public List<EmployeeResponseDTO> getByDepartment(Long deptId) {
        return employeeRepository.findEmployeesByDepartment(deptId)
                .stream()
                .map(e -> mapper.toDto(e))
                .toList();
    }

    public List<EmployeeResponseDTO> getByRole(String roleName) {
        return employeeRepository.findByRoleRoleName(roleName)
                .stream()
                .map(e -> mapper.toDto(e))
                .toList();
    }

    public void deactivateEmployee(Long id) {
        Employee emp = employeeRepository.findById(id)
                .orElseThrow();

        emp.setActive(false);
        employeeRepository.save(emp);
    }

    public EmployeeResponseDTO updatePhone(Long id, String phone) {
        Employee emp = employeeRepository.findById(id)
                .orElseThrow();

        emp.setPhone(phone);

        return mapper.toDto(employeeRepository.save(emp));
    }


    public long getTotalEmployees() {
        return employeeRepository.count();
    }

    public Page<EmployeeResponseDTO> getAllPaged(Pageable pageable) {
        return employeeRepository.findAll(pageable)
                .map(e -> mapper.toDto(e));
    }

    public boolean existsByEmail(String email) {
        return employeeRepository.existsByEmail(email);
    }


}
