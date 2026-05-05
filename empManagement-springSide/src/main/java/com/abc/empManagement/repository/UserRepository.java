package com.abc.empManagement.repository;

import com.abc.empManagement.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, String> {

    // 🔹 Exact match (case-sensitive)
    Optional<User> findByUserName(String userName);
    Optional<User> findByEmail(String email);
    boolean existsByUserName(String userName);
    boolean existsByEmail(String email);

    // 🔹 Case-insensitive versions
    boolean existsByUserNameIgnoreCase(String userName);
    boolean existsByEmailIgnoreCase(String email);

    // 🔹 Search (improve readability)
    @Query("SELECT u FROM User u WHERE " +
            "LOWER(u.userName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
            "LOWER(u.userFirstName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
            "LOWER(u.userLastName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
            "LOWER(u.email) LIKE LOWER(CONCAT('%', :search, '%'))")
    Page<User> searchUsers(@Param("search") String searchTerm, Pageable pageable);

    // 🔹 Admin dashboard
    Page<User> findAllByOrderByDateCreatedDesc(Pageable pageable);
}




//import com.abc.SpringSecurityExample.entity.User;
//import org.springframework.data.domain.Page;
//import org.springframework.data.domain.Pageable;
//import org.springframework.data.jpa.repository.JpaRepository;
//
//import java.util.Optional;
//
//public interface UserRepository extends JpaRepository<User, String> {
//
//    Optional<User> findByUserName(String userName);
//    Optional<User> findByEmail(String email);
//    Boolean existsByUserName(String userName);
//    Boolean existsByEmail(String email);
//
//    Page<User> findByUserNameContainingIgnoreCaseOrUserFirstNameContainingIgnoreCaseOrUserLastNameContainingIgnoreCaseOrEmailContainingIgnoreCase(String searchTerm, String searchTerm1, String searchTerm2, String searchTerm3, Pageable pageable);
//
//    boolean existsByUserNameIgnoreCase(String userName);
//
//    boolean existsByEmailIgnoreCase(String email);
//
//}
