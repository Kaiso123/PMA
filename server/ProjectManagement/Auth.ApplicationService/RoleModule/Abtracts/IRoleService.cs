using Auth.Dtos.AuthRoleDto;
using Auth.Dtos;
using Auth.Dtos.LoginModule;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Auth.ApplicationService.RoleModule.Abtracts
{
    public interface IRoleService
    {
        public Task<AuthResponeDto> CreateRole(CreateRoleDto createroleDto);
        public Task<AuthResponeDto> UpdateRole(int roleId, UpdateRoleDto updateRoleDto);
        public Task<AuthResponeDto> DeleteRole(int roleId);
        public Task<AuthResponeDto> GetRole(int roleId);
        public Task<AuthResponeDto> GetAllRoles();
    }
}
