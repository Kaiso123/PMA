using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Auth.ApplicationService.Common;
using Auth.ApplicationService.RoleModule.Abtracts;
using Auth.Domain;
using Auth.Dtos.AuthRoleDto;
using Auth.Dtos;
using Auth.Infrastructure;
using Microsoft.EntityFrameworkCore;
using SM.Auth.ApplicationService.UserModule.Abtracts;

namespace SM.Auth.ApplicationService.RoleModule.Implements
{
    public class RoleSerivce : AuthServiceBase, IRoleService
    {
        public RoleSerivce(ILogger<RoleSerivce> logger, AuthDbContext dbContext) : base(logger, dbContext)
        {

        }
        public async Task<AuthResponeDto> CreateRole(CreateRoleDto createroleDto)
        {
            if (createroleDto == null)
            {
                return new AuthResponeDto
                {
                    EC = -1,
                    EM = "CreateRoleDto is null",
                    DT = ""
                };
            }
            var role = new AuthRole
            {
                roleName = createroleDto.roleName,
                description = createroleDto.description,
                status = "Active",
                roleCode = createroleDto.roleCode,
                roleType = createroleDto.roleType,
                Created = DateTime.Now,

            };
            try
            {
                _dbContext.AuthRoles.Add(role);
                await _dbContext.SaveChangesAsync();
                return new AuthResponeDto
                {
                    EC = 0,
                    EM = "Create Role success",
                    DT = null
                };
            }
            catch
            {
                return new AuthResponeDto
                {
                    EC = 1,
                    EM = "Create Role fail",
                    DT = null
                };

            }

        }
        public async Task<AuthResponeDto> UpdateRole(int roleId, UpdateRoleDto updateRoleDto)
        {
            try
            {
                var role = await _dbContext.AuthRoles.FindAsync(roleId);
                if (role == null)
                {
                    return new AuthResponeDto
                    {
                        DT = null,
                        EC = 1,
                        EM = "Role not found"
                    };
                }
                role.roleName = updateRoleDto.roleName;
                role.description = updateRoleDto.description;
                role.roleType = updateRoleDto.roleType;
                role.roleCode = updateRoleDto.roleCode;
                role.Created = updateRoleDto.Created;
                role.status = updateRoleDto.status;
                await _dbContext.SaveChangesAsync();
                return new AuthResponeDto
                {
                    EC = 0,
                    EM = "Update Role success",
                    DT = null
                };

            }
            catch (Exception e)
            {
                return new AuthResponeDto
                {
                    EC = 1,
                    EM = "Update Role fail",
                    DT = null
                };
            }
        }
        public async Task<AuthResponeDto> DeleteRole(int roleId)
        {
            try
            {
                var role = await _dbContext.AuthRoles.FindAsync(roleId);
                if (role == null)
                {
                    return new AuthResponeDto
                    {
                        EC = 1,
                        EM = "Role not found",
                        DT = null
                    };
                }
                _dbContext.AuthRoles.Remove(role);
                await _dbContext.SaveChangesAsync();
                return new AuthResponeDto
                {
                    EC = 0,
                    EM = "Delete Role success",
                    DT = null
                };
            }
            catch (Exception e)
            {
                return new AuthResponeDto
                {
                    EC = 1,
                    EM = e.Message,
                    DT = null
                };
            }

        }
        public async Task<AuthResponeDto> GetRole(int roleId)
        {
            try
            {
                var role = await _dbContext.AuthRoles.FindAsync(roleId);
                if (role == null)
                {
                    return new AuthResponeDto
                    {
                        EC = 1,
                        EM = "Role not found",
                        DT = null
                    };
                }
                var respone = new ReadRoleDto
                {
                    roleCode = role.roleCode,
                    roleName = role.roleName,
                    description = role.description,
                    roleType = role.roleType,
                    Created = role.Created,
                    status = role.status
                };
                return new AuthResponeDto
                {
                    EC = 0,
                    EM = "Get Role success",
                    DT = respone

                };

            }
            catch (Exception e)
            {
                return new AuthResponeDto
                {
                    EC = 1,
                    EM = e.Message,
                    DT = null
                };
            }
        }
        public async Task<AuthResponeDto> GetAllRoles()
        {
            var roles = _dbContext.AuthRoles.ToList();
            foreach (var role in roles)
            {
                role.roleCode = role.roleCode;
                role.roleName = role.roleName;
                role.description = role.description;
                role.roleType = role.roleType;
                role.Created = role.Created;
                role.status = role.status;
                role.roleId = role.roleId;
            }
            return new AuthResponeDto
            {
                EC = 0,
                EM = "Get all roles success",
                DT = roles
            };
        }
    }
}
