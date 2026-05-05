package com.abc.empManagement.repository;

import com.abc.empManagement.entity.Department;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;

public interface DepartmentRepository extends JpaRepository<Department,Long> {
    boolean existsByDepNameIgnoreCase(String depName);
    Optional<Department> findByDepName(String depName);

    @Query("""
    SELECT COUNT(e)
    FROM Employee e
    WHERE e.department.id = :deptId
    """)
    long countEmployeesByDepartment(Long deptId);

    @Query("""
SELECT d
FROM Department d
LEFT JOIN FETCH d.employees
WHERE d.id = :id
""")
    Optional<Department> findByIdWithEmployees(Long id);
}
