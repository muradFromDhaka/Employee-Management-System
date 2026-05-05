package com.abc.empManagement.Mapper;


import com.abc.empManagement.DTOs.SecurityDtos.UserDTO;
import com.abc.empManagement.Util.NotFoundException;
import com.abc.empManagement.entity.Role;
import com.abc.empManagement.entity.User;
import com.abc.empManagement.repository.RoleRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Component
public class UserMapper {

    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;

    public UserMapper(RoleRepository roleRepository, PasswordEncoder passwordEncoder){
        this.roleRepository = roleRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public User mapToEntity(final UserDTO userDTO, final User user) {
        user.setUserName(userDTO.getUserName());
        user.setUserFirstName(userDTO.getUserFirstName());
        user.setUserLastName(userDTO.getUserLastName());
        user.setEmail(userDTO.getEmail());
        user.setEnabled(userDTO.getEnabled());
        user.setAccountNonLocked(userDTO.getAccountNonLocked());
        final List<Role> roles = roleRepository.findAllById(
                userDTO.getRoles() == null ? Collections.emptyList() : userDTO.getRoles());
        if (roles.size() != (userDTO.getRoles() == null ? 0 : userDTO.getRoles().size())) {
            throw new NotFoundException("one of roles not found");
        }
        user.setRoles(roles.stream().collect(Collectors.toSet()));

        return user;
    }


    public UserDTO mapToDTO(final User user, final UserDTO userDTO) {
        userDTO.setUserName(user.getUserName());
        userDTO.setUserFirstName(user.getUserFirstName());
        userDTO.setUserLastName(user.getUserLastName());
        userDTO.setEmail(user.getEmail());
        userDTO.setEnabled(user.getEnabled());
        userDTO.setAccountNonLocked(user.getAccountNonLocked());
        userDTO.setRoles(user.getRoles() == null ? null : user.getRoles().stream()
                .map(role01 -> role01.getRoleName())
                .toList());
        return userDTO;
    }

}
