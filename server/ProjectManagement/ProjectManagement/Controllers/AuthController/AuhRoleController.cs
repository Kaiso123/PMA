using Auth.ApplicationService.RoleModule.Abtracts;
using Auth.Dtos.AuthRoleDto;
using Auth.Dtos;
using Microsoft.AspNetCore.Mvc;


namespace WebAPI.Controllers.AuthController
{
    [Route("api/authrole")]
    [ApiController]
    public class AuhRoleController : Controller
    {
        private readonly IRoleService _roleService;
        public AuhRoleController(IRoleService roleService)
        {
            _roleService = roleService;
        }
        [HttpPost("createrole")]
        public async Task<AuthResponeDto> CreateRole(CreateRoleDto createroleDto)
        {
            try
            {
                var result = await _roleService.CreateRole(createroleDto);
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
        [HttpPut("updaterole/{roleId}")]
        public async Task<AuthResponeDto> UpdateRole(int roleId, UpdateRoleDto updateRoleDto)
        {
            try
            {
                var result = await _roleService.UpdateRole(roleId, updateRoleDto);
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
        [HttpDelete("deleterole/{roleId}")]
        public async Task<AuthResponeDto> DeleteRole(int roleId)
        {
            try
            {
                var respone = await _roleService.DeleteRole(roleId);
                if (respone.EC != 0)
                {
                    return new AuthResponeDto
                    {
                        EC = respone.EC,
                        EM = respone.EM,
                        DT = respone.DT
                    };
                }
                return new AuthResponeDto
                {
                    EC = respone.EC,
                    EM = respone.EM,
                    DT = respone.DT
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
        [HttpGet("getrole/{roleId}")]
        public async Task<AuthResponeDto> GetRole(int roleId)
        {
            try
            {
                var respone = await _roleService.GetRole(roleId);
                if (respone.EC != 0)
                {
                    return new AuthResponeDto
                    {
                        EC = respone.EC,
                        EM = respone.EM,
                        DT = respone.DT
                    };
                }
                return new AuthResponeDto
                {
                    EC = respone.EC,
                    EM = respone.EM,
                    DT = respone.DT
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
        [HttpGet("getallroles")]
        public async Task<AuthResponeDto> GetAllRoles()
        {
            try
            {
                var respone = await _roleService.GetAllRoles();
                if (respone.EC != 0)
                {
                    return new AuthResponeDto
                    {
                        EC = respone.EC,
                        EM = respone.EM,
                        DT = respone.DT
                    };
                }
                return new AuthResponeDto
                {
                    EC = respone.EC,
                    EM = respone.EM,
                    DT = respone.DT
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
