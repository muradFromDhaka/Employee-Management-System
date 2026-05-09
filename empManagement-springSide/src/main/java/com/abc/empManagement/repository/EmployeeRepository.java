package com.abc.empManagement.repository;

import com.abc.empManagement.entity.Employee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface EmployeeRepository extends JpaRepository<Employee, Long> {

    boolean existsByEmail(String email);
    Optional<Employee> findByEmail(String email);
    Optional<Employee> findByUser_UserName(String userName);
    // =========================
    // Find by Role Name
    // =========================
    @Query("SELECT e FROM Employee e WHERE e.role.roleName = :roleName")
    List<Employee> findByRoleRoleName(@Param("roleName") String roleName);

    // =========================
    // Find by Department Id
    // =========================
    @Query("SELECT e FROM Employee e WHERE e.department.id = :deptId")
    List<Employee> findEmployeesByDepartment(@Param("deptId") Long deptId);

    // =========================
    // Search by Name (LIKE)
    // =========================
    @Query("SELECT e FROM Employee e WHERE LOWER(e.name) LIKE LOWER(CONCAT('%', :name, '%'))")
    List<Employee> findByName(@Param("name") String name);
}