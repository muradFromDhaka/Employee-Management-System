package com.abc.empManagement.entity;



import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.OffsetDateTime;


@Entity
@Table(name = "role")
//@EntityListeners(AuditingEntityListener.class)
@Getter
@Setter
public class Role {

    @Id
    @Column(nullable = false, updatable = false)
    private String roleName;

    @Column
    private String roleDescription;

//    @CreatedDate
    @Column(nullable = false, updatable = false)
    private OffsetDateTime dateCreated;

//    @LastModifiedDate
    @Column(nullable = false)
    private OffsetDateTime lastUpdated;

    @PrePersist
    void createdAt() {
        this.dateCreated = this.lastUpdated = OffsetDateTime.now();
    }

    @PreUpdate
    void updatedAt() {
        this.lastUpdated = OffsetDateTime.now();
    }

}