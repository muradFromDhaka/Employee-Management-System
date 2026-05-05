package com.abc.empManagement.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
@Entity
public class Payroll {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Double basicSalary;
    private Double bonus;
    private Double deduction;
    private Double finalSalary;

    private LocalDateTime month;

    @ManyToOne
    @JoinColumn(name = "employee_id")
    private Employee employee;
}
