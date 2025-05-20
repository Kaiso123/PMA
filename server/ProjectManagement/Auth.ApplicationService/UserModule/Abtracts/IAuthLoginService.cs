using Auth.Dtos.LoginModule;
using Auth.Dtos;
using System.Security.Claims;
using System.Threading.Tasks;

namespace Auth.ApplicationService.UserModule.Abtracts
{
    public interface IAuthLoginService
    {
        Task<AuthResponeDto> AuthLogin(AuthLoginUserDto loginUserDto);
    }
}
