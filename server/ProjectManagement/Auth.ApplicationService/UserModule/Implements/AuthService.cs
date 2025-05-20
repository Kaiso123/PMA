using Auth.ApplicationService.Common;
using Auth.Domain;
using Auth.Dtos.CRUDModule;
using Auth.Dtos.LoginModule;
using Auth.Dtos;
using Auth.Infrastructure;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using SM.Auth.ApplicationService.UserModule.Abtracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Auth.ApplicationService.UserModule.Implements
{
    public class AuthService : AuthServiceBase, IAuthService
    {
        public AuthService(ILogger<AuthService> logger, AuthDbContext dbContext) : base(logger, dbContext)
        {

        }

        public async Task<AuthResponeDto> AuthRegisterAsync(AuthRegisterDto authRegisterDto)
        {
            try
            {
                // Check if username or email already exists
                var existingUser = await _dbContext.AuthUsers
                    .FirstOrDefaultAsync(u => u.username == authRegisterDto.username);

                if (existingUser != null)
                {
                    return new AuthResponeDto
                    {
                        EM = "Username or email already exists",
                        EC = 1,
                        DT = null
                    };
                }

                var user = new AuthUser
                {
                    username = authRegisterDto.username,
                    password = authRegisterDto.password, // Consider hashing the password before saving
                    email = authRegisterDto.email,
                    age = 0,
                    address = "",
                    gender = "",
                    phone = 0,
                    name = authRegisterDto.name
                };

                _dbContext.AuthUsers.Add(user);
                await _dbContext.SaveChangesAsync();

                return new AuthResponeDto
                {
                    EM = "Register success",
                    EC = 0,
                    DT = null // Or an array of strings if needed
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred during registration for user: {Username}", authRegisterDto.username);
                return new AuthResponeDto
                {
                    EM = ex.Message,
                    EC = 1,
                    DT = null
                };
            }
        }
        public async Task<AuthResponeDto> AuthRemove(int userId)
        {
            try
            {
                // Kiểm tra vai trò của người dùng
                var role = await _dbContext.AuthUserRoles.FirstOrDefaultAsync(x => x.userId == userId);
                if (role != null)
                {
                    _dbContext.AuthUserRoles.Remove(role);
                }

                // Kiểm tra người dùng
                var user = await _dbContext.AuthUsers.FirstOrDefaultAsync(x => x.userId == userId);
                if (user == null)
                {
                    throw new Exception("User not found");
                }

                // Xóa người dùng
                _dbContext.AuthUsers.Remove(user);

                // Lưu thay đổi vào cơ sở dữ liệu
                await _dbContext.SaveChangesAsync();

                return new AuthResponeDto
                {
                    EM = "Remove success",
                    EC = 0,
                    DT = null
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while removing user with ID: {UserId}", userId);
                return new AuthResponeDto
                {
                    EM = ex.Message,
                    EC = 1,
                    DT = null
                };
            }
        }

        public async Task<AuthResponeDto> AuthUpdate(int userId, AuthUpdateDto authUpdateDto)
        {
            try
            {
                var existingUser = await _dbContext.AuthUsers.FirstOrDefaultAsync(x => x.userId == userId);
                if (existingUser == null)
                {
                    return new AuthResponeDto
                    {
                        EM = "User not found",
                        EC = 1,
                        DT = null
                    };
                }

                existingUser.username = authUpdateDto.username;
                existingUser.password = authUpdateDto.password;
                existingUser.email = authUpdateDto.email;
                existingUser.age = authUpdateDto.age;
                existingUser.address = authUpdateDto.address;
                existingUser.gender = authUpdateDto.gender;
                existingUser.phone = authUpdateDto.phone;
                existingUser.name = authUpdateDto.name;

                await _dbContext.SaveChangesAsync();

                return new AuthResponeDto
                {
                    EM = "Update success",
                    EC = 0,
                    DT = null
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while updating user with ID: {UserId}", userId);
                return new AuthResponeDto
                {
                    EM = ex.Message,
                    EC = 1,
                    DT = null
                };
            }
        }
        public async ValueTask<IEnumerable<AuthGetAllUserDto>> AuthGetAll()
        {
            try
            {
                // Lấy danh sách người dùng từ cơ sở dữ liệu
                var users = await _dbContext.AuthUsers.ToListAsync();

                // Ánh xạ danh sách người dùng sang DTO
                var userDtos = users.Select(x => new AuthGetAllUserDto
                {
                    userId = x.userId,
                    username = x.username,
                    password = x.password,
                    email = x.email,
                    age = x.age,
                    address = x.address,
                    gender = x.gender,
                    phone = x.phone,
                    name = x.name
                }).ToList();

                return userDtos;
            }
            catch (Exception ex)
            {
                // Ghi log lỗi nếu cần
                throw new Exception("An error occurred while retrieving users.", ex);
            }
        }
        public async Task<AuthResponeDto> register(AuthLoginUserDto loginUserDto)
        {
            try
            {
                var user = await _dbContext.AuthUsers
              .FirstOrDefaultAsync(x => x.username == loginUserDto.username && x.password == loginUserDto.password);
                var userrole = new AuthUserRole
                {
                    roleId = 3,
                    userId = user.userId
                };
                if (user == null)
                {
                    return new AuthResponeDto
                    {
                        EM = "Invalid Username or password ",
                        EC = 1,
                        DT = ""
                    };
                }
                _dbContext.AuthUserRoles.Add(userrole);
                await _dbContext.SaveChangesAsync();
                return new AuthResponeDto
                {
                    EM = "success",
                    EC = 0,
                    DT = null
                };



            }

            catch (Exception ex)
            {

                return new AuthResponeDto
                {
                    EM = ex.Message,
                    EC = 1,
                    DT = null
                };
            }
        }
        public async Task<AuthResponeDto> getbyID(int userID)
        {
            try
            {
                var user = await _dbContext.AuthUsers.FirstOrDefaultAsync(x => x.userId == userID);
                if (user == null)
                {
                    return new AuthResponeDto
                    {
                        EM = "User not found",
                        EC = 1,
                        DT = null
                    };
                }

                return new AuthResponeDto
                {
                    EM = "success",
                    EC = 0,
                    DT = user
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting user with ID: {UserId}", userID);
                return new AuthResponeDto
                {
                    EM = ex.Message,
                    EC = 1,
                    DT = null
                };

            }
        }
    }
}
