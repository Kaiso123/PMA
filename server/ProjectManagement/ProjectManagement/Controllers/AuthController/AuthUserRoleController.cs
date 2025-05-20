using Auth.ApplicationService.RoleModule.Abtracts;
using Auth.Dtos.UserRoleDto;
using Auth.Dtos;
using Microsoft.AspNetCore.Mvc;


namespace WebAPI.Controllers.AuthController
{
    [Route("api/authuserrole")]
    [ApiController]
    public class AuthUserRoleController : Controller
    {
        private readonly IUserRoleService _userRoleService;
        public AuthUserRoleController(IUserRoleService userRoleService)
        {
            _userRoleService = userRoleService;
        }
        [HttpPost("createuserrole")]
        public async Task<AuthResponeDto> CreateUserRoles(CreateUserRoleDto createUserRoleDto)
        {
            try
            {
                var result = await _userRoleService.CreateRole(createUserRoleDto);
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
        [HttpPut("updateuserrole/{roleId}")]
        public async Task<AuthResponeDto> UpdateUserRole(int roleId, UpdateUserRoleDto updateUserRoleDto)
        {
            try
            {
                var result = await _userRoleService.UpdateRole(roleId, updateUserRoleDto);
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
        [HttpDelete("deleteuserrole/{roleId}")]
        public async Task<AuthResponeDto> DeleteUserRole(int roleId)
        {
            try
            {
                var result = await _userRoleService.DeleteRole(roleId);
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
        [HttpGet("getuserrole/{roleId}")]
        public async Task<AuthResponeDto> GetUserRole(int roleId)
        {
            try
            {
                var result = await _userRoleService.GetRole(roleId);
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
        [HttpGet("getalluserrole")]
        public async Task<AuthResponeDto> GetAllUserRole()
        {
            try
            {
                var result = await _userRoleService.GetAllRoles();
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
        [HttpGet("getRolebyUser/{userID}")]
        public async Task<AuthResponeDto> GetRoleByUser(int userID)
        {
            try
            {
                var result = await _userRoleService.GetRolebyUser(userID);
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
