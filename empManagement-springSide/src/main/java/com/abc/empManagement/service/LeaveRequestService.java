package com.abc.empManagement.service;

import com.abc.empManagement.DTOs.ProjectDtos.LeaveRequestDTO;
import com.abc.empManagement.DTOs.ProjectDtos.LeaveResponseDTO;
import com.abc.empManagement.Mapper.LeaveRequestMapper;
import com.abc.empManagement.entity.LeaveRequest;
import com.abc.empManagement.enums.LeaveStatus;
import com.abc.empManagement.repository.LeaveRequestRepository;
import com.abc.empManagement.repository.EmployeeRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class LeaveRequestService {

    private final LeaveRequestRepository leaveRequestRepository;
    private final LeaveRequestMapper leaveRequestMapper;
    private final EmployeeRepository employeeRepository;

    public LeaveResponseDTO applyLeave(LeaveRequestDTO dto) {

        var employee = employeeRepository.findById(dto.getEmployeeId())
                .orElseThrow(() -> new EntityNotFoundException("Employee not found"));

        // check overlapping leave
        boolean hasOverlap = !leaveRequestRepository
                .findOverlappingLeaves(
                        employee.getId(),
                        dto.getStartDate(),
                        dto.getEndDate()
                ).isEmpty();

        if (hasOverlap) {
            throw new RuntimeException("Leave already exists in this date range");
        }

        LeaveRequest leave = leaveRequestMapper.toEntity(dto, employee);

        return leaveRequestMapper.toDto(
                leaveRequestRepository.save(leave)
        );
    }

    public List<LeaveResponseDTO> getAll() {
        return leaveRequestRepository.findAll()
                .stream()
                .map(leaveRequestMapper::toDto)
                .toList();
    }


    public LeaveResponseDTO getById(Long id) {
        LeaveRequest leave = leaveRequestRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Leave not found"));

        return leaveRequestMapper.toDto(leave);
    }

    public List<LeaveResponseDTO> getByEmployee(Long employeeId) {
        return leaveRequestRepository.findByEmployeeId(employeeId)
                .stream()
                .map(leaveRequestMapper::toDto)
                .toList();
    }

    public LeaveResponseDTO approveLeave(Long id) {
        LeaveRequest leave = leaveRequestRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Leave not found"));

        leave.setStatus(LeaveStatus.APPROVED);

        return leaveRequestMapper.toDto(
                leaveRequestRepository.save(leave)
        );
    }

    public LeaveResponseDTO rejectLeave(Long id) {
        LeaveRequest leave = leaveRequestRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Leave not found"));

        leave.setStatus(LeaveStatus.REJECTED);

        return leaveRequestMapper.toDto(
                leaveRequestRepository.save(leave)
        );
    }

    public List<LeaveResponseDTO> getPendingLeaves() {
        return leaveRequestRepository.findByStatus(LeaveStatus.PENDING)
                .stream()
                .map(leaveRequestMapper::toDto)
                .toList();
    }


    public List<LeaveResponseDTO> getLeavesByDateRange(LocalDate from, LocalDate to) {
        return leaveRequestRepository.findByStartDateBetween(from, to)
                .stream()
                .map(leaveRequestMapper::toDto)
                .toList();
    }

    public long countLeaves(Long employeeId, LeaveStatus status) {
        return leaveRequestRepository.countByEmployeeIdAndStatus(employeeId, status);
    }

    public void delete(Long id) {
        LeaveRequest leave = leaveRequestRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Leave not found"));

        leaveRequestRepository.delete(leave);
    }
}