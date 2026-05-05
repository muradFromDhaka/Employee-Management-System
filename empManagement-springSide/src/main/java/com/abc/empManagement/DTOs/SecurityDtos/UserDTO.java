package com.abc.empManagement.DTOs.SecurityDtos;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

import java.util.List;


@Getter
@Setter
public class UserDTO {

    @Size(max = 255)
    private String userName;

    @Size(max = 255)
    private String userFirstName;

    @Size(max = 255)
    private String userLastName;

    @NotNull
    @Size(max = 255)
    private String email;

    private Boolean enabled;

    private Boolean accountNonLocked;

    private List<String> roles;

}
