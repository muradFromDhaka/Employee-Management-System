package com.abc.empManagement.service;

import com.abc.empManagement.DTOs.ProjectDtos.DepartmentRequestDto;
import com.abc.empManagement.DTOs.ProjectDtos.DepartmentResponseDto;
import com.abc.empManagement.Mapper.DepartmentMapper;
import com.abc.empManagement.entity.Department;
import com.abc.empManagement.repository.DepartmentRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@RequiredArgsConstructor
@Service
public class DepartmentService {
    private final DepartmentMapper departmentMapper;
    private final DepartmentRepository departmentRepository;

    public List<DepartmentResponseDto> getAll(){
        List<DepartmentResponseDto> dep = departmentRepository.findAll()
                .stream()
                .map((d)-> departmentMapper.toDto(d))
                .toList();
        return dep;
    }

    public DepartmentResponseDto getById(Long id){
        Department dep = departmentRepository.findById(id)
                .orElseThrow(()-> new EntityNotFoundException("Department not found with id: " + id));

        return departmentMapper.toDto(dep);
    }

    public String create(final DepartmentRequestDto dto) {

        if(departmentRepository.existsByDepNameIgnoreCase(dto.getDepName())){
            throw new RuntimeException("Department already exists with name: " + dto.getDepName());
        }

        Department createDep =
                departmentMapper.toEntity(dto, new Department());

        return departmentRepository.save(createDep).getDepName();
    }


    public String update(final DepartmentRequestDto dto, Long id){
        Department existingDep = departmentRepository.findById(id)
                .orElseThrow(()-> new EntityNotFoundException("Department not found with id: " + id));
        Department updateDep = departmentMapper.toEntity(dto, existingDep);

        return departmentRepository.save(updateDep).getDepName();
    }

    public void delete(Long id){
        Department dep = departmentRepository.findById(id)
                .orElseThrow(()-> new EntityNotFoundException("Department not found with id: " + id));
        departmentRepository.delete(dep);
    }

    public DepartmentResponseDto findByIdWithEmployees(Long id){
        Department dep = departmentRepository.findByIdWithEmployees(id)
                .orElseThrow(()-> new EntityNotFoundException("Department not found with id: " + id));
        return departmentMapper.toDto(dep);
    }

    public Long countEmployeesByDepartment(Long depId){
        return departmentRepository.countEmployeesByDepartment(depId);
    }
}
