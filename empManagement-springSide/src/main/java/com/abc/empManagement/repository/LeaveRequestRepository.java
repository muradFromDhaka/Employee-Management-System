package com.abc.empManagement.repository;

import com.abc.empManagement.entity.LeaveRequest;
import com.abc.empManagement.enums.LeaveStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.time.LocalDate;
import java.util.List;

public interface LeaveRequestRepository extends JpaRepository<LeaveRequest, Long> {

    // 1. Employee-wise leaves
    List<LeaveRequest> findByEmployeeId(Long employeeId);

    // 2. Status-based filtering
    List<LeaveRequest> findByStatus(LeaveStatus status);

    // 3. Employee + Status
    List<LeaveRequest> findByEmployeeIdAndStatus(Long employeeId, LeaveStatus status);

    // 4. Date range search (reporting)
    List<LeaveRequest> findByStartDateBetween(LocalDate from, LocalDate to);

    // 5. Overlapping leave check (VERY IMPORTANT)
    @Query("""
    SELECT l FROM LeaveRequest l
    WHERE l.employee.id = :employeeId
    AND l.status = com.abc.empManagement.enums.LeaveStatus.APPROVED
    AND (
        l.startDate <= :endDate
        AND l.endDate >= :startDate
    )
""")
    List<LeaveRequest> findOverlappingLeaves(
            Long employeeId,
            LocalDate startDate,
            LocalDate endDate
    );

    // 6. Pending leaves for admin approval
    List<LeaveRequest> findByStatusOrderByStartDateAsc(LeaveStatus status);

    // 7. Count leaves by employee + status
    long countByEmployeeIdAndStatus(Long employeeId, LeaveStatus status);

    // 8. Monthly leave report
    @Query("""
        SELECT l FROM LeaveRequest l
        WHERE l.employee.id = :employeeId
        AND MONTH(l.startDate) = :month
        AND YEAR(l.startDate) = :year
    """)
    List<LeaveRequest> findMonthlyLeaves(Long employeeId, int month, int year);

    // 9. Existence check (validation / safety)
    boolean existsByIdAndStatus(Long id, LeaveStatus status);

    // 10. TOTAL leaves
    long countByEmployeeId(Long employeeId);

    long countByEmployeeIdAndStatusAndStartDateBetween(
            Long employeeId,
            LeaveStatus status,
            LocalDate start,
            LocalDate end
    );
}