using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Auth.ApplicationService.RoleModule.Abtracts;
using Auth.Domain;
using Auth.Dtos.RolePermissionDto;
using Auth.Dtos;
using Auth.Infrastructure;
using Auth.ApplicationService.Common;

namespace SM.Auth.ApplicationService.RoleModule.Implements
{
    public class RolePermissionService : AuthServiceBase, IRolePermissionService
    {
        public RolePermissionService(ILogger<RolePermissionService> logger, AuthDbContext dbContext) : base(logger, dbContext)
        {

        }
        public async Task<AuthResponeDto> CreateRolePermission(CreateRolePermissionDto createRolePermissionDto)
        {
            try
            {
                if (createRolePermissionDto == null)
                {
                    return new AuthResponeDto
                    {
                        EC = 1,
                        EM = "CreateRolePermissionDto is null",
                        DT = ""
                    };
                }
                var rolePermission = new AuthRolePermission
                {
                    roleId = createRolePermissionDto.roleId,
                    permissionKey = createRolePermissionDto.permissionKey
                };
                _dbContext.RolePermissions.Add(rolePermission);
                await _dbContext.SaveChangesAsync();
                return new AuthResponeDto
                {
                    EC = 0,
                    EM = "Create Role Permission success",
                    DT = null
                };
            }
            catch
            {
                return new AuthResponeDto
                {
                    EC = -1,
                    EM = "Create Role Permission fail",
                    DT = null
                };
            }
        }
        public async Task<AuthResponeDto> UpdateRolePermission(int rolepermissionId, UpdateRolePermissionDto updateRolePermissionDto)
        {
            try
            {
                var rolePermission = _dbContext.RolePermissions.FirstOrDefault(x => x.rolePermissionId == rolepermissionId);
                if (rolePermission == null)
                {
                    return new AuthResponeDto
                    {
                        EC = 1,
                        EM = "RolePermission not found",
                        DT = null
                    };
                }
                rolePermission.roleId = updateRolePermissionDto.roleId;
                rolePermission.permissionKey = updateRolePermissionDto.permissionKey;
                await _dbContext.SaveChangesAsync();
                return new AuthResponeDto
                {
                    EC = 0,
                    EM = "Update Role Permission success",
                    DT = null
                };
            }
            catch (Exception ex)
            {
                return new AuthResponeDto
                {
                    EC = -1,
                    EM = ex.Message,
                    DT = null
                };
            }
        }
        public async Task<AuthResponeDto> DeleteRolePermission(int rolePermissionId)
        {
            try
            {
                var rolePermission = _dbContext.RolePermissions.FirstOrDefault(x => x.rolePermissionId == rolePermissionId);
                if (rolePermission == null)
                {
                    return new AuthResponeDto
                    {
                        EC = 1,
                        EM = "RolePermission not found",
                        DT = null
                    };
                }
                _dbContext.RolePermissions.Remove(rolePermission);
                await _dbContext.SaveChangesAsync();
                return new AuthResponeDto
                {
                    EC = 0,
                    EM = "Delete Role Permission success",
                    DT = null
                };
            }
            catch (Exception e)
            {
                return new AuthResponeDto
                {
                    EC = -1,
                    EM = e.Message,
                    DT = null
                };
            }

        }
        public async Task<AuthResponeDto> GetRolePermission(int rolePermissionId)
        {
            try
            {
                var rolePermission = _dbContext.RolePermissions.FirstOrDefault(x => x.rolePermissionId == rolePermissionId);
                if (rolePermission == null)
                {
                    return new AuthResponeDto
                    {
                        EC = 1,
                        EM = "RolePermission not found",
                        DT = null
                    };
                }
                var respone = new ReadRolePermissionDto
                {
                    rolePermissionId = rolePermission.rolePermissionId,
                    roleId = rolePermission.roleId,
                    permissionKey = rolePermission.permissionKey
                };
                return new AuthResponeDto
                {
                    EC = 0,
                    EM = "Get Role Permission success",
                    DT = respone
                };
            }
            catch (Exception e)
            {
                return new AuthResponeDto
                {
                    EC = -1,
                    EM = e.Message,
                    DT = null
                };
            }
        }
        public async Task<AuthResponeDto> GetAllRolePermissions()
        {
            try
            {
                var rolePermissions = _dbContext.RolePermissions.ToList();
                if (rolePermissions == null)
                {
                    return new AuthResponeDto
                    {
                        EC = 1,
                        EM = "RolePermissions not found",
                        DT = null
                    };
                }
                var respone = new List<ReadRolePermissionDto>();
                foreach (var rolePermission in rolePermissions)
                {
                    respone.Add(new ReadRolePermissionDto
                    {
                        rolePermissionId = rolePermission.rolePermissionId,
                        roleId = rolePermission.roleId,
                        permissionKey = rolePermission.permissionKey
                    });
                }
                return new AuthResponeDto
                {
                    EC = 0,
                    EM = "Get all Role Permissions success",
                    DT = respone
                };
            }
            catch (Exception e)
            {
                return new AuthResponeDto
                {
                    EC = -1,
                    EM = e.Message,
                    DT = null
                };
            }
        }
    }

}