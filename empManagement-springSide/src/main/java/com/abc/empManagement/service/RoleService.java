package com.abc.empManagement.service;


import com.abc.empManagement.DTOs.SecurityDtos.RoleDTO;
import com.abc.empManagement.Mapper.RoleMapper;
import com.abc.empManagement.Util.NotFoundException;
import com.abc.empManagement.entity.Role;
import com.abc.empManagement.repository.RoleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
public class RoleService {

    private final RoleRepository roleRepository;
    @Autowired
    private RoleMapper roleMapper;

    public RoleService(final RoleRepository roleRepository) {
        this.roleRepository = roleRepository;
    }

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

    public void delete(final String roleName) {
        roleRepository.deleteById(roleName);
    }

    public boolean roleNameExists(final String roleName) {
        return roleRepository.existsByRoleNameIgnoreCase(roleName);
    }

}
