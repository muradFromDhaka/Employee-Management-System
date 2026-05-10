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

    private static final LocalTime START_TIME = LocalTime.of(9, 0);

    // For internal use;
    private Employee getEmployee(String username) {
        return employeeRepository.findByUser_UserName(username)
                .orElseThrow(() -> new EntityNotFoundException("Employee not found"));
    }

    public List<AttendanceResponseDTO> getAll(){
        List<AttendanceResponseDTO> dto = attendanceRepository.findAll()
                .stream()
                .map((a) -> attendanceMapper.toDto(a))
                .toList();

        return dto;
    }


    public AttendanceResponseDTO checkIn(String username) {

         Employee emp = getEmployee(username);

        if (hasCheckedInToday(emp.getId())) {
            throw new RuntimeException("Already checked in today");
        }

        Attendance attendance = new Attendance();
        attendance.setEmployee(emp);
        attendance.setDate(LocalDate.now());

        LocalTime now = LocalTime.now();

        attendance.setCheckIn(now);

        attendance.setStatus(
                now.isAfter(START_TIME) ? "LATE" : "PRESENT"
        );


        return attendanceMapper.toDto(attendanceRepository.save(attendance));
    }


    public AttendanceResponseDTO checkOut(String username) {

        Employee emp = getEmployee(username);

        Attendance attendance = attendanceRepository
                .findTodayAttendance(emp.getId(), LocalDate.now())
                .orElseThrow(() -> new RuntimeException("No check-in found for today"));

        if (attendance.getCheckOut() != null) {
            throw new RuntimeException("Already checked out today");
        }

        LocalTime checkOutTime = LocalTime.now();
        attendance.setCheckOut(checkOutTime);

        Attendance saved = attendanceRepository.save(attendance);

        AttendanceResponseDTO dto = attendanceMapper.toDto(saved);

        dto.setWorkingHours(
                calculateWorkingHours(saved.getCheckIn(), saved.getCheckOut())
        );

        return dto;
    }

    public AttendanceResponseDTO getById(Long id) {
        Attendance att = attendanceRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Attendance not found with id: " + id));

        return attendanceMapper.toDto(att);
    }

    public List<AttendanceResponseDTO> getByCurrentEmployee(String username) {

        Employee emp = employeeRepository.findByUser_UserName(username)
                .orElseThrow(()-> new EntityNotFoundException("Employee not found with username: " + username));

        return attendanceRepository.findByEmployeeId(emp.getId())
                .stream()
                .map((a)-> attendanceMapper.toDto(a))
                .toList();
    }

    public List<AttendanceResponseDTO> getBySelectedDate(LocalDate date) {
        return attendanceRepository.findByDate(date)
                .stream()
                .map((a)-> attendanceMapper.toDto(a))
                .toList();
    }


    public long countPresentDays(String username) {
        Employee emp = employeeRepository.findByUser_UserName(username)
                .orElseThrow(()-> new EntityNotFoundException("Employee not found with username: " +username));

        return attendanceRepository.countByEmployeeId(emp.getId());
    }

    private String calculateWorkingHours(LocalTime checkIn, LocalTime checkOut) {

        if (checkIn == null || checkOut == null) {
            return null;
        }

        Duration duration = Duration.between(checkIn, checkOut);

        long hours = duration.toHours();
        long minutes = duration.toMinutes() % 60;

        return hours + "h " + minutes + "m";
    }


    public boolean hasCheckedInToday(Long employeeId) {
        return attendanceRepository.existsByEmployeeIdAndDate(employeeId, LocalDate.now());
    }

    public boolean hasOpenAttendance(String username) {
        Employee emp = employeeRepository.findByUser_UserName(username)
                .orElseThrow(()-> new EntityNotFoundException("Employee not found with username: " + username));
        return attendanceRepository.existsByEmployeeIdAndDateAndCheckOutIsNull(
                emp.getId(), LocalDate.now()
        );
    }


    public void delete(Long id) {
        Attendance att = attendanceRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Attendance not found"));

        attendanceRepository.delete(att);
    }

    public List<AttendanceResponseDTO> getMonthlyAttendance(String username, YearMonth month) {
        Employee emp = employeeRepository.findByUser_UserName(username)
                .orElseThrow(()-> new EntityNotFoundException("Employee not found with username:"+ username));

        LocalDate start = month.atDay(1);
        LocalDate end = month.atEndOfMonth();

        return attendanceRepository
                .findByEmployeeIdAndDateBetween(emp.getId(), start, end)
                .stream()
                .map((a)-> attendanceMapper.toDto(a))
                .toList();
    }
}