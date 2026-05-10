package com.abc.empManagement.repository;

import com.abc.empManagement.entity.Attendance;
import com.abc.empManagement.entity.Employee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface AttendanceRepository extends JpaRepository<Attendance, Long> {
    List<Attendance> findByEmployeeId(Long employeeId);
    List<Attendance> findByDate(LocalDate date);

    boolean existsByEmployeeIdAndDate(Long employeeId, LocalDate date);

    boolean existsByEmployeeIdAndDateAndCheckOutIsNull(Long employeeId, LocalDate date);

    @Query("""
    SELECT a FROM Attendance a
    WHERE a.employee.id = :employeeId
    AND a.date = :date
""")
    Optional<Attendance> findTodayAttendance(Long employeeId, LocalDate date);

    long countByEmployeeId(Long employeeId);

    List<Attendance> findByEmployeeIdAndDateBetween(Long employeeId, LocalDate start, LocalDate end);
}
