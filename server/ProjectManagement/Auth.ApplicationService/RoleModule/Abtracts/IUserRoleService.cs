using Auth.Dtos.UserRoleDto;
using Auth.Dtos;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Auth.ApplicationService.RoleModule.Abtracts
{
    public interface IUserRoleService
    {
        public Task<AuthResponeDto> CreateRole(CreateUserRoleDto createroleDto);
        public Task<AuthResponeDto> UpdateRole(int userRoleId, UpdateUserRoleDto updateUserRoleDto);
        public Task<AuthResponeDto> DeleteRole(int roleId);
        public Task<AuthResponeDto> GetRole(int roleId);
        public Task<AuthResponeDto> GetAllRoles();
        public Task<AuthResponeDto> GetRolebyUser(int userID);
    }
}
