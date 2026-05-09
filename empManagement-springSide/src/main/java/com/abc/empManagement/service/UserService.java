package com.abc.empManagement.service;



import com.abc.empManagement.DTOs.SecurityDtos.RegisterRequest;
import com.abc.empManagement.DTOs.SecurityDtos.StatusUpdateRequest;
import com.abc.empManagement.DTOs.SecurityDtos.UserDTO;
import com.abc.empManagement.DTOs.SecurityDtos.UserUpdateRequest;
import com.abc.empManagement.Mapper.UserMapper;
import com.abc.empManagement.Util.NotFoundException;
import com.abc.empManagement.entity.Role;
import com.abc.empManagement.entity.User;
import com.abc.empManagement.repository.RoleRepository;
import com.abc.empManagement.repository.UserRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.List;
import java.util.Set;


@Transactional
@Service
public class UserService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    @Autowired
    private UserMapper userMapper;

    @Autowired
    PasswordEncoder passwordEncoder;

    public UserService(final UserRepository userRepository, final RoleRepository roleRepository) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;

    }


    public void initRoleAndUser() {

        Role adminRole = new Role();
        adminRole.setRoleName("ROLE_ADMIN");
        adminRole.setRoleDescription("Admin role");
        roleRepository.save(adminRole);

        Role managerRole = new Role();
        managerRole.setRoleName("ROLE_MANAGER");
        managerRole.setRoleDescription("manager role");
        roleRepository.save(managerRole);

        Role employeeRole = new Role();
        employeeRole.setRoleName("ROLE_EMPLOYEE");
        employeeRole.setRoleDescription("role employee");
        roleRepository.save(employeeRole);

        Role userRole = new Role();
        userRole.setRoleName("ROLE_USER");
        userRole.setRoleDescription("Default role for newly created record");
        roleRepository.save(userRole);

        User adminUser = new User();
        adminUser.setUserName("murad");
        adminUser.setPassword(getEncodedPassword("murad@pass"));
        adminUser.setUserFirstName("murad");
        adminUser.setUserLastName("murad");
        adminUser.setEmail("murad@gmail.com");


        Set<Role> adminRoles = new HashSet<>();
        adminRoles.add(adminRole);
        adminRoles.add(managerRole);
        adminRoles.add(employeeRole);
        adminRoles.add(userRole);
        adminUser.setRoles(adminRoles);
        userRepository.save(adminUser);

    }


    public List<UserDTO> findAll() {
        final List<User> users = userRepository.findAll(Sort.by("userName"));
        return users.stream()
                .map((user01) -> userMapper.mapToDTO(user01, new UserDTO()))
                .toList();
    }

    public UserDTO findById(final String userName) {
        return userRepository.findById(userName)
                .map(user01 -> userMapper.mapToDTO(user01, new UserDTO()))
                .orElseThrow(NotFoundException::new);
    }

    public String createUser(final RegisterRequest register) {
        final User user = new User();
        user.setUserName(register.username());
        user.setUserFirstName(register.firstName());
        user.setUserLastName(register.lastName());
        user.setPassword(passwordEncoder.encode(register.password()));
        user.setEmail(register.email());
        return userRepository.save(user).getUserName();
    }


    public User updateUser(String username, UserUpdateRequest updateRequest) {
        User existingUser = userRepository.findByUserName(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // Only update specific fields
        if (updateRequest.firstName() != null) {
            existingUser.setUserFirstName(updateRequest.firstName());
        }
        if (updateRequest.lastName() != null) {
            existingUser.setUserLastName(updateRequest.lastName());
        }
        if (updateRequest.email() != null) {
            existingUser.setEmail(updateRequest.email());
        }
         User updateUser = userRepository.save(existingUser);

        return updateUser;
    }

    public User updateUserStatus(String username, StatusUpdateRequest statusUpdate){
        User existingUser = userRepository.findByUserName(username)
                .orElseThrow(()-> new RuntimeException("User not found"));
        existingUser.setEnabled(statusUpdate.enabled());
        User updateUser = userRepository.save(existingUser);
        return updateUser;
    }


    public void deleteById(final String userName) {
       if(!userRepository.existsByUserName(userName)){
           throw new UsernameNotFoundException("User not found.");
       }
       userRepository.deleteById(userName);
    }

    public boolean userNameExists(final String userName) {
        return userRepository.existsByUserNameIgnoreCase(userName);
    }

    public boolean emailExists(final String email) {
        return userRepository.existsByEmailIgnoreCase(email);
    }

    public String getEncodedPassword(String password) {
        return passwordEncoder.encode(password);
    }


    public Page<UserDTO> getAllUsers(int page, int size, String sortBy, String sortDir) {
        Sort sort = Sort.by(Sort.Order.asc(sortBy)); // Default is ascending order
        if ("desc".equalsIgnoreCase(sortDir)) {
            sort = Sort.by(Sort.Order.desc(sortBy));
        }

        Pageable pageable = PageRequest.of(page, size, sort);

        Page<UserDTO> userDTOPage = userRepository.findAll(pageable).map(user -> userMapper.mapToDTO(user, new UserDTO()));
        return userDTOPage;
    }


    public Page<UserDTO> searchUsers(String searchTerm, int page, int size, String sortBy, String sortDir) {
        Sort sort = Sort.by(Sort.Order.asc(sortBy)); // Default to ascending order
        if ("desc".equalsIgnoreCase(sortDir)) {
            sort = Sort.by(Sort.Order.desc(sortBy));
        }
        Pageable pageable = PageRequest.of(page, size, sort);
        Page<User> userPage = userRepository.searchUsers(searchTerm, pageable);

        return userPage.map(user -> userMapper.mapToDTO(user, new UserDTO()));
    }

}
