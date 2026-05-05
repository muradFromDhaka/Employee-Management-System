package com.abc.empManagement.Mapper;


import com.abc.empManagement.DTOs.SecurityDtos.RoleDTO;
import com.abc.empManagement.entity.Role;
import org.springframework.stereotype.Component;

@Component
public class RoleMapper {

    public Role mapToEntity(final RoleDTO roleDTO, final Role role) {
        role.setRoleDescription(roleDTO.getRoleDescription());
        return role;
    }

    public RoleDTO mapToDTO(final Role role, final RoleDTO roleDTO) {
        roleDTO.setRoleName(role.getRoleName());
        roleDTO.setRoleDescription(role.getRoleDescription());
        return roleDTO;
    }


}
