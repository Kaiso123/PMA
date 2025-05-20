using Auth.Dtos.RolePermissionDto;
using Auth.Dtos;
using Auth.Dtos.RolePermissionDto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Auth.ApplicationService.RoleModule.Abtracts
{
    public interface IRolePermissionService
    {

        public Task<AuthResponeDto> CreateRolePermission(CreateRolePermissionDto createRolePermissionDto);
        public Task<AuthResponeDto> UpdateRolePermission(int rolepermissionId, UpdateRolePermissionDto updateRolePermissionDto);
        public Task<AuthResponeDto> DeleteRolePermission(int rolePermissionId);
        public Task<AuthResponeDto> GetRolePermission(int rolePermissionId);
        public Task<AuthResponeDto> GetAllRolePermissions();

    }
}
