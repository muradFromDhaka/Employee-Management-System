package com.abc.empManagement.service;


import com.abc.empManagement.DTOs.SecurityDtos.RoleDTO;
import com.abc.empManagement.Mapper.RoleMapper;
import com.abc.empManagement.Util.NotFoundException;
import com.abc.empManagement.entity.Role;
import com.abc.empManagement.entity.User;
import com.abc.empManagement.repository.RoleRepository;
import com.abc.empManagement.repository.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import javax.swing.text.Style;
import java.util.List;

@RequiredArgsConstructor
@Service
public class RoleService {

    private final RoleRepository roleRepository;
    private final UserRepository userRepository;
    private final RoleMapper roleMapper;

//    public RoleService(final RoleRepository roleRepository) {
//        this.roleRepository = roleRepository;
//    }

    public List<RoleDTO> findAll() {
        final List<Role> roles = roleRepository.findAll(Sort.by("roleName"));
        return roles.stream()
                .map((role01) -> roleMapper.mapToDTO(role01, new RoleDTO()))
                .toList();
    }

    public RoleDTO findById(final String roleName) {
        return roleRepository.findById(roleName)
                .map(role01 -> roleMapper.mapToDTO(role01, new RoleDTO()))
                .orElseThrow(NotFoundException::new);
    }

    public String create(final RoleDTO roleDTO) {
        final Role role = new Role();
        roleMapper.mapToEntity(roleDTO, role);
        role.setRoleName(roleDTO.getRoleName());
        return roleRepository.save(role).getRoleName();
    }

    public void update(final String roleName, final RoleDTO roleDTO) {
        final Role role = roleRepository.findById(roleName)
                .orElseThrow(NotFoundException::new);
        roleMapper.mapToEntity(roleDTO, role);
        roleRepository.save(role);
    }

//    public void delete(final String roleName) {
//        Role role = roleRepository.findByRoleName(roleName)
//                        .orElseThrow(()-> new EntityNotFoundException("Role not found with roleName: " + roleName));
//        roleRepository.delete(role);
//    }

    @Transactional
    public void delete(String roleName) {

        Role role = roleRepository.findById(roleName)
                .orElseThrow(() -> new RuntimeException("Role not found"+ roleName));
        // remove role from all users
        List<User> users = userRepository.findAll();

        for (User user : users) {
            user.getRoles().remove(role);
        }

        userRepository.saveAll(users);
        System.out.print("Role--------------------------------"+ role);
        // now delete role
        roleRepository.delete(role);
    }





    public boolean roleNameExists(final String roleName) {
        return roleRepository.existsByRoleNameIgnoreCase(roleName);
    }

}
