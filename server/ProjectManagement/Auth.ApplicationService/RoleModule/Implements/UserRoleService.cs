using Auth.ApplicationService.Common;
using Auth.ApplicationService.RoleModule.Abtracts;
using Auth.Domain;
using Auth.Dtos.UserRoleDto;
using Auth.Dtos;
using Auth.Infrastructure;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SM.Auth.ApplicationService.RoleModule.Implements
{
    public class UserRoleService : AuthServiceBase, IUserRoleService
    {
        public UserRoleService(ILogger<UserRoleService> logger, AuthDbContext dbContext) : base(logger, dbContext)
        {

        }
        public async Task<AuthResponeDto> CreateRole(CreateUserRoleDto createUserRoleDto)
        {
            try
            {
                var userRole = new AuthUserRole
                {
                    roleId = createUserRoleDto.roleId,
                    userId = createUserRoleDto.userId

                };
                if (userRole == null)
                {
                    return new AuthResponeDto
                    {
                        EC = 1,
                        EM = "CreateUserRoleDto is null",
                        DT = ""
                    };
                }
                _dbContext.AuthUserRoles.Add(userRole);
                await _dbContext.SaveChangesAsync();
                return new AuthResponeDto
                {
                    EC = 0,
                    EM = "Create User Role success",
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
        public async Task<AuthResponeDto> UpdateRole(int userRoleId, UpdateUserRoleDto updateUserRoleDto)
        {
            try
            {
                var userRole = _dbContext.AuthUserRoles.FirstOrDefault(x => x.userRoleId == userRoleId);
                if (userRole == null)
                {
                    return new AuthResponeDto
                    {
                        EC = 1,
                        EM = "User Role not found",
                        DT = null
                    };
                }
                userRole.roleId = updateUserRoleDto.roleId;
                userRole.userId = updateUserRoleDto.userId;
                await _dbContext.SaveChangesAsync();
                return new AuthResponeDto
                {
                    EC = 0,
                    EM = "Update User Role success",
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
        public async Task<AuthResponeDto> DeleteRole(int roleId)
        {
            try
            {
                var userRole = _dbContext.AuthUserRoles.FirstOrDefault(x => x.userRoleId == roleId);
                if (userRole == null)
                {
                    return new AuthResponeDto
                    {
                        EC = 1,
                        EM = "User Role not found",
                        DT = null
                    };
                }
                _dbContext.AuthUserRoles.Remove(userRole);
                await _dbContext.SaveChangesAsync();
                return new AuthResponeDto
                {
                    EC = 0,
                    EM = "Delete User Role success",
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
        public async Task<AuthResponeDto> GetRole(int roleId)
        {
            try
            {
                var userRole = _dbContext.AuthUserRoles.FirstOrDefault(x => x.userRoleId == roleId);
                if (userRole == null)
                {
                    return new AuthResponeDto
                    {
                        EC = 1,
                        EM = "User Role not found",
                        DT = null
                    };
                }
                return new AuthResponeDto
                {
                    EC = 0,
                    EM = "Get User Role success",
                    DT = userRole
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
        public async Task<AuthResponeDto> GetAllRoles()
        {
            try
            {
                var userRoles = _dbContext.AuthUserRoles.ToList();
                if (userRoles == null)
                {
                    return new AuthResponeDto
                    {
                        EC = 1,
                        EM = "User Roles not found",
                        DT = null
                    };
                }
                return new AuthResponeDto
                {
                    EC = 0,
                    EM = "Get All User Roles success",
                    DT = userRoles
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
        public async Task<AuthResponeDto> GetRolebyUser(int userID)
        {
            var role = _dbContext.AuthUserRoles.FirstOrDefault(x => x.userId == userID);
            if (role == null)
            {
                return new AuthResponeDto
                {
                    EC = 1,
                    EM = "Role not found",
                    DT = null
                };
            }
            return new AuthResponeDto
            {
                EC = 0,
                EM = "Get Role success",
                DT = role
            };
        }
    }
}
