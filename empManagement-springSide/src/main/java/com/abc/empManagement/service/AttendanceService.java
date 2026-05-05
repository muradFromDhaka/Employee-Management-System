package com.abc.empManagement.service;

import com.abc.empManagement.DTOs.ProjectDtos.AttendanceResponseDTO;
import com.abc.empManagement.Mapper.AttendanceMapper;
import com.abc.empManagement.entity.Attendance;
import com.abc.empManagement.entity.Employee;
import com.abc.empManagement.repository.AttendanceRepository;
import com.abc.empManagement.repository.EmployeeRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.*;
import java.util.List;

@RequiredArgsConstructor
@Service
public class AttendanceService {

    private final AttendanceRepository attendanceRepository;
    private final EmployeeRepository employeeRepository;
    private final AttendanceMapper attendanceMapper;


    public AttendanceResponseDTO checkIn(Long employeeId) {

        Employee emp = employeeRepository.findById(employeeId)
                .orElseThrow(() -> new EntityNotFoundException("Employee not found"));

        if (hasCheckedInToday(employeeId)) {
            throw new RuntimeException("Already checked in today");
        }

        Attendance attendance = new Attendance();
        attendance.setEmployee(emp);
        attendance.setDate(LocalDate.now());
        attendance.setCheckIn(LocalTime.now());

        return attendanceMapper.toDto(attendanceRepository.save(attendance));
    }


    public AttendanceResponseDTO checkOut(Long employeeId) {

        Attendance attendance = attendanceRepository
                .findTodayAttendance(employeeId, LocalDate.now())
                .orElseThrow(() -> new RuntimeException("No check-in found for today"));

        if (attendance.getCheckOut() != null) {
            throw new RuntimeException("Already checked out today");
        }

        attendance.setCheckOut(LocalTime.now());

        return attendanceMapper.toDto(attendanceRepository.save(attendance));
    }

    public List<AttendanceResponseDTO> getAll() {
        return attendanceRepository.findAll()
                .stream()
                .map(attendanceMapper::toDto)
                .toList();
    }

    public AttendanceResponseDTO getById(Long id) {
        Attendance att = attendanceRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Attendance not found with id: " + id));

        return attendanceMapper.toDto(att);
    }

    public List<AttendanceResponseDTO> getByEmployee(Long employeeId) {
        return attendanceRepository.findByEmployeeId(employeeId)
                .stream()
                .map(attendanceMapper::toDto)
                .toList();
    }

    public List<AttendanceResponseDTO> getByDate(LocalDate date) {
        return attendanceRepository.findByDate(date)
                .stream()
                .map(attendanceMapper::toDto)
                .toList();
    }


    public long countPresentDays(Long employeeId) {
        return attendanceRepository.countByEmployeeId(employeeId);
    }

    public Duration calculateWorkingHours(Long attendanceId) {

        Attendance att = attendanceRepository.findById(attendanceId)
                .orElseThrow(() -> new EntityNotFoundException("Attendance not found"));

        if (att.getCheckIn() == null || att.getCheckOut() == null) {
            return Duration.ZERO;
        }

        return Duration.between(att.getCheckIn(), att.getCheckOut());
    }


    public boolean hasCheckedInToday(Long employeeId) {
        return attendanceRepository.existsByEmployeeIdAndDate(employeeId, LocalDate.now());
    }

    public boolean hasOpenAttendance(Long employeeId) {
        return attendanceRepository.existsByEmployeeIdAndDateAndCheckOutIsNull(
                employeeId, LocalDate.now()
        );
    }


    public void delete(Long id) {
        Attendance att = attendanceRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Attendance not found"));

        attendanceRepository.delete(att);
    }

    public List<AttendanceResponseDTO> getMonthlyAttendance(Long employeeId, YearMonth month) {

        LocalDate start = month.atDay(1);
        LocalDate end = month.atEndOfMonth();

        return attendanceRepository
                .findByEmployeeIdAndDateBetween(employeeId, start, end)
                .stream()
                .map(attendanceMapper::toDto)
                .toList();
    }
}