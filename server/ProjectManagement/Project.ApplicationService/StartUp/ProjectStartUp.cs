using Microsoft.Extensions.DependencyInjection;
using Project.Infrastructure;
using Microsoft.AspNetCore.Builder;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Constant.Database;
using Project.ApplicationService.ProjectModule.Abtracts;
using Project.ApplicationService.ProjectModule.Implements;
using Project.ApplicationService.UserProjectModule.Abtracts;
using Project.ApplicationService.UserProjectModule.Implements;
using Project.ApplicationService.SprintModule.Abtracts;
using Project.ApplicationService.SprintModule.Implements;
using Project.ApplicationService.IssueModeul.Abtracts;
using Project.ApplicationService.Event.Abtracts;
using Project.ApplicationService.Event.Implements;

namespace Project.ApplicationService.StartUp
{
    public static class ProjectStartUp
    {
        public static void ConfigureProject(this WebApplicationBuilder builder, string? assemblyName)
        {
            //builder.Services.AddScoped<IUserInforSerivce, UserInforService>();
            builder.Services.AddDbContext<ProjectDbContext>(
                options =>
                {
                    options.UseSqlServer(
                        builder.Configuration.GetConnectionString("Default"),
                        options =>
                        {
                            options.MigrationsAssembly(assemblyName);
                            options.MigrationsHistoryTable(
                                DbSchema.TableMigrationsHistory,
                                DbSchema.Project
                            );
                        }
                    );
                },
                ServiceLifetime.Scoped
            );
            builder.Services.AddScoped<IProjectService, ProjectService>();
            builder.Services.AddScoped<IUserProjectService, UserProjectService>();
            builder.Services.AddScoped<ISprintService, SprintService>();
            builder.Services.AddScoped<IIssueService, IssueService>();
            builder.Services.AddScoped<IEventService, EventService>();
        }
    }
}
