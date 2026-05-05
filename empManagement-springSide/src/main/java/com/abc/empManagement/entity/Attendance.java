package com.abc.empManagement.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalTime;
@Getter
@Setter
@Entity
public class Attendance {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private LocalDate date;
    private String status; // PRESENT / ABSENT / LATE

    private LocalTime checkIn;

    private LocalTime checkOut;

    @ManyToOne
    @JoinColumn(name = "employee_id")
    private Employee employee;
}
