using Auth.ApplicationService.RoleModule.Abtracts;
using Auth.Dtos.RolePermissionDto;
using Auth.Dtos;
using Microsoft.AspNetCore.DataProtection.AuthenticatedEncryption;
using Microsoft.AspNetCore.Mvc;

namespace SM.WebAPI.Controllers.AuthController
{
    [Route("api/authrolepermission")]
    [ApiController]
    public class AuthRolePermissionController : Controller
    {

        private readonly IRolePermissionService _rolePermissionService;
        public AuthRolePermissionController(IRolePermissionService rolePermissionService)
        {
            _rolePermissionService = rolePermissionService;

        }
        [HttpPost("createrolepermission")]
        public async Task<AuthResponeDto> CreateRolePermission(CreateRolePermissionDto createRolePermissionDto)
        {
            try
            {
                var result = await _rolePermissionService.CreateRolePermission(createRolePermissionDto);
                if (result.EC != 0)
                {
                    return new AuthResponeDto
                    {
                        EC = result.EC,
                        EM = result.EM,
                        DT = result.DT
                    };
                }
                return new AuthResponeDto
                {
                    EC = result.EC,
                    EM = result.EM,
                    DT = result.DT
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
        [HttpPut("updaterolepermission/{roleId}")]
        public async Task<AuthResponeDto> UpdateRolePermission(int roleId, UpdateRolePermissionDto updateRolePermissionDto)
        {
            try
            {
                var result = await _rolePermissionService.UpdateRolePermission(roleId, updateRolePermissionDto);
                if (result.EC != 0)
                {
                    return new AuthResponeDto
                    {
                        EC = result.EC,
                        EM = result.EM,
                        DT = result.DT
                    };
                }
                return new AuthResponeDto
                {
                    EC = result.EC,
                    EM = result.EM,
                    DT = result.DT
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
        [HttpDelete("deleterolepermission/{rolePermissionId}")]
        public async Task<AuthResponeDto> DeleteRolePermission(int rolePermissionId)
        {
            try
            {
                var result = await _rolePermissionService.DeleteRolePermission(rolePermissionId);
                if (result.EC != 0)
                {
                    return new AuthResponeDto
                    {
                        EC = result.EC,
                        EM = result.EM,
                        DT = result.DT
                    };
                }
                return new AuthResponeDto
                {
                    EC = result.EC,
                    EM = result.EM,
                    DT = result.DT
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
        [HttpGet("getrolepermission/{rolePermissionId}")]
        public async Task<AuthResponeDto> GetRolePermission(int rolePermissionId)
        {
            try
            {
                var result = await _rolePermissionService.GetRolePermission(rolePermissionId);
                if (result.EC != 0)
                {
                    return new AuthResponeDto
                    {
                        EC = result.EC,
                        EM = result.EM,
                        DT = result.DT
                    };
                }
                return new AuthResponeDto
                {
                    EC = result.EC,
                    EM = result.EM,
                    DT = result.DT
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
        [HttpGet("getallrolepermission")]
        public async Task<AuthResponeDto> GetAllRolePermission()
        {
            try
            {
                var result = await _rolePermissionService.GetAllRolePermissions();
                if (result.EC != 0)
                {
                    return new AuthResponeDto
                    {
                        EC = result.EC,
                        EM = result.EM,
                        DT = result.DT
                    };
                }
                return new AuthResponeDto
                {
                    EC = result.EC,
                    EM = result.EM,
                    DT = result.DT
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
