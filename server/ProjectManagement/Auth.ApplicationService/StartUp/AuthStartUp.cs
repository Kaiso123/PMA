using Microsoft.AspNetCore.Builder;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SM.Auth.ApplicationService.UserModule.Abtracts;
using Microsoft.IdentityModel.Tokens;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using SM.Auth.ApplicationService.RoleModule.Implements;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication.Google;
using Microsoft.AspNetCore.Server.HttpSys;
using DotNetEnv;
using Auth.ApplicationService.RoleModule.Abtracts;
using Auth.ApplicationService.UserModule.Abtracts;
using Auth.ApplicationService.UserModule.Implements;
using Auth.Infrastructure;
using Constant.Database;

namespace Auth.ApplicationService.StartUp
{
    public static class AuthStartUp
    {
        public static void ConfigureAuth(this WebApplicationBuilder builder, string? assemblyName)
        {
            //builder.Services.AddScoped<IUserInforSerivce, UserInforService>();

            builder.Services.AddDbContext<AuthDbContext>(
                options =>
                {
                    options.UseSqlServer(
                        builder.Configuration.GetConnectionString("Default"),
                        options =>
                        {
                            options.MigrationsAssembly(assemblyName);
                            options.MigrationsHistoryTable(
                                DbSchema.TableMigrationsHistory,
                                DbSchema.Auth
                            );
                        }
                    );
                },
                ServiceLifetime.Scoped
            );
            builder.Services.AddScoped<IAuthService, AuthService>();
            builder.Services.AddScoped<IAuthLoginService, AuthLoginService>();
            builder.Services.AddScoped<IUserRoleService, UserRoleService>();
            builder.Services.AddScoped<IRolePermissionService, RolePermissionService>();
            builder.Services.AddScoped<IRoleService, RoleSerivce>();


            var secretKey = builder.Configuration["Jwt:SecretKey"] ?? "A_very_long_and_secure_secret_key_1234567890";
            var key = Encoding.UTF8.GetBytes(secretKey);
            // Thay đổi secret key của bạn

            builder.Services.AddAuthentication(options =>
            {
                options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultScheme = CookieAuthenticationDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = GoogleDefaults.AuthenticationScheme;
            })
                .AddCookie()
   
            .AddJwtBearer(options =>
            {
                options.RequireHttpsMetadata = false;
                options.SaveToken = true;
                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(key),
                    ValidateIssuer = false,
                    ValidateAudience = false
                };
            });

        }
    }
}
