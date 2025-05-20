using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.IdentityModel.Tokens;
using SM.Auth.ApplicationService.UserModule.Abtracts;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Security.Claims;
using Google.Apis.Auth;
using System.Net.Http;
using System.Text.Json;
using Auth.ApplicationService.UserModule.Abtracts;
using Auth.Dtos;
using Auth.Infrastructure;
using Auth.Dtos.LoginModule;

namespace Auth.ApplicationService.UserModule.Implements
{
    public class AuthLoginService : IAuthLoginService
    {
        private readonly ILogger<AuthLoginService> _logger;
        private readonly AuthDbContext _dbContext;
        private readonly IConfiguration _configuration;

        public AuthLoginService(ILogger<AuthLoginService> logger, AuthDbContext dbContext, IConfiguration configuration)
        {
            _logger = logger;
            _dbContext = dbContext;
            _configuration = configuration;
        }

        // Đăng nhập bằng tên người dùng và mật khẩu
        public async Task<AuthResponeDto> AuthLogin(AuthLoginUserDto loginUserDto)
        {
            _logger.LogInformation("AuthLoginService.AuthLogin");

            var user = await _dbContext.AuthUsers
                .FirstOrDefaultAsync(x => x.username == loginUserDto.username && x.password == loginUserDto.password);

            if (user == null)
            {
                return new AuthResponeDto
                {
                    EM = "Invalid Username or Password",
                    EC = 1,
                    DT = ""
                };
            }

            return new AuthResponeDto
            {
                EM = "Success",
                EC = 0,
                DT = user.userId
            };
        }

        private string SecretKey => _configuration["Jwt:SecretKey"];

        private string GenerateToken(string name, int userId)
        {
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(SecretKey));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
            var claims = new List<Claim>
            {
                new Claim("name", name),
                new Claim("userId", userId.ToString())
            };

            var token = new JwtSecurityToken(
                issuer: null,
                audience: null,
                claims: claims,
                expires: DateTime.Now.AddMinutes(30),
                signingCredentials: creds);

            return new JwtSecurityTokenHandler().WriteToken(token);
        }

    }




}
