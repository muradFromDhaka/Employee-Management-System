package com.abc.empManagement.RestController;


import com.abc.empManagement.DTOs.SecurityDtos.StatusUpdateRequest;
import com.abc.empManagement.DTOs.SecurityDtos.UserDTO;
import com.abc.empManagement.DTOs.SecurityDtos.UserUpdateRequest;
import com.abc.empManagement.entity.User;
import com.abc.empManagement.service.UserService;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*", maxAge = 3600)
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @PostConstruct
    public void initRoleAndUser() {
        userService.initRoleAndUser();
    }

    // GET ALL USERS - Only accessible by ADMIN
    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<UserDTO>> getAllUsers(){
        List<UserDTO> users = userService.findAll();
        return ResponseEntity.ok(users);
    };

    // GET USER BY USERNAME - Accessible by ADMIN or the user themselves
    @GetMapping("/{username}")
    @PreAuthorize("hasRole('ADMIN') or #username == authentication.principal.username")
    public ResponseEntity<UserDTO> getUserByUsername(@PathVariable String username) {
        UserDTO userDto = userService.findById(username);
        return ResponseEntity.ok(userDto);
    }

    // UPDATE USER - Accessible by ADMIN or the user themselves
    @PutMapping("/{username}")
    @PreAuthorize("hasRole('ADMIN') or #username == authentication.principal.username")
    public ResponseEntity<User> updateUser(
            @PathVariable String username,
            @RequestBody UserUpdateRequest updateRequest) {

     User user = userService.updateUser(username, updateRequest);

     return ResponseEntity.ok(user);
    }

    // DELETE USER - Only accessible by ADMIN
    @DeleteMapping("/{username}")
    @PreAuthorize("hasRole('ADMIN') or #username == authentication.principal.username")
    public ResponseEntity<Void> deleteUser(@PathVariable String username) {
        try {
            userService.deleteById(username);
            return ResponseEntity.noContent().build(); // 204 No Content
        } catch (UsernameNotFoundException e) {
            return ResponseEntity.notFound().build(); // 404 Not Found
        }
    }

    // ENABLE/DISABLE USER - Only accessible by ADMIN
    @PatchMapping("/{username}/status")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<User> updateUserStatus(
            @PathVariable String username,
            @RequestBody StatusUpdateRequest statusRequest) {

          User userStatus = userService.updateUserStatus(username, statusRequest);
         return ResponseEntity.ok(userStatus);
    }
}

