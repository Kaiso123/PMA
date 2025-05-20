using Auth.Dtos.CRUDModule;
using Auth.Dtos.LoginModule;
using Auth.Dtos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SM.Auth.ApplicationService.UserModule.Abtracts
{
    public interface IAuthService
    {

        public Task<AuthResponeDto> AuthRegisterAsync(AuthRegisterDto authRegisterDto);
        public Task<AuthResponeDto> AuthRemove(int userId);
        public Task<AuthResponeDto> AuthUpdate(int userId, AuthUpdateDto authUpdateDto);
        public ValueTask<IEnumerable<AuthGetAllUserDto>> AuthGetAll();
        public Task<AuthResponeDto> register(AuthLoginUserDto loginUserDto);

        public Task<AuthResponeDto> getbyID(int userID);


    }

}
