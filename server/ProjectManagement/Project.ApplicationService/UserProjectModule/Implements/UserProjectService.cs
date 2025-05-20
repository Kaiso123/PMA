using Microsoft.Extensions.Logging;
using Project.ApplicationService.Common;
using Project.ApplicationService.ProjectModule.Abtracts;
using Project.ApplicationService.UserProjectModule.Abtracts;
using Project.Dtos.Project;
using Project.Dtos;
using Project.Infrastructure;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Project.Dtos.UserProject;
using Microsoft.EntityFrameworkCore;
using Project.Domain.Project;

namespace Project.ApplicationService.UserProjectModule.Implements
{
    public class UserProjectService : ProjectServiceBase, IUserProjectService
    {
        public UserProjectService(ILogger<IProjectService> logger, ProjectDbContext dbContext) : base(logger, dbContext) { }

        public async Task<ProjectResponeDto> CreateUserProjectAsync(CreatUserProjectDto userprojectDto)
        {
            // Kiểm tra xem Project và User đã tồn tại hay chưa 
            var project = await _dbcContext.Projectpros.FindAsync(userprojectDto.ProjectId);
            if (project == null)
            {
                return new ProjectResponeDto
                {
                    ErrorCode = 1,
                    ErrorMessage = "Không tìm thấy dự án!",
                    Data = ""
                };
            }

            // Kiểm tra xem User đã được gán chưa
            var existing = await _dbcContext.UserProjects
                .FirstOrDefaultAsync(up => up.UserId == userprojectDto.UserId && up.ProjectId == userprojectDto.ProjectId);

            if (existing != null)
            {
                return new ProjectResponeDto
                {
                    ErrorCode = 1,
                    ErrorMessage = "User đã được gán vào dự án này!",
                    Data = ""
                };
            }

            var userProject = new UserProject
            {
                UserId = userprojectDto.UserId,
                ProjectId = userprojectDto.ProjectId,
                IsManager = userprojectDto.IsManager
            };

            _dbcContext.UserProjects.Add(userProject);
            await _dbcContext.SaveChangesAsync();

            return new ProjectResponeDto
            {
                ErrorCode = 0,
                ErrorMessage = "Gán Project cho user thành công",
                Data = userProject.UserProjectId
            };
        }

        public async Task<ProjectResponeDto> GetAllUserProjectsAsync()
        {
            var userProjects = await _dbcContext.UserProjects
                .Include(up => up.Project)
                .Select(up => new ReadUserProjectDto
                {
                    UserProjectId = up.UserProjectId,
                    UserId = up.UserId,
                    IsManager = up.IsManager,
                    ProjectId = up.ProjectId,
                    ProjectName = up.Project.Name,
                    ProjectDescription = up.Project.Description,
                    ProjectStartDate = up.Project.StartDate,
                    ProjectEndDate = up.Project.EndDate,
                    ProjectStatus = up.Project.Status.ToString()
                })
                .ToListAsync();

            if (!userProjects.Any())
            {
                return new ProjectResponeDto
                {
                    ErrorCode = 0,
                    ErrorMessage = "Không có UserProject nào",
                    Data = new List<ReadUserProjectDto>()
                };
            }

            return new ProjectResponeDto
            {
                ErrorCode = 0,
                ErrorMessage = "Lấy danh sách UserProject thành công",
                Data = userProjects
            };

        }

        public async Task<ProjectResponeDto> DeleteUserProjectAsync(int userProjectId)
        {
            var userProject = await _dbcContext.UserProjects.FindAsync(userProjectId);
            if (userProject == null)
            {
                return new ProjectResponeDto
                {
                    ErrorCode = 1,
                    ErrorMessage = "Không tìm thấy bản ghi UserProject",
                    Data = null
                };
            }

            _dbcContext.UserProjects.Remove(userProject);
            await _dbcContext.SaveChangesAsync();

            return new ProjectResponeDto
            {
                ErrorCode = 0,
                ErrorMessage = "Xóa UserProject thành công",
                Data = userProjectId
            };
        }
        public async Task<ProjectResponeDto> InviteUserToProjectAsync(InviteUserToProjectDto inviteDto)
        {
            // Kiểm tra mã mời
            var project = await _dbcContext.Projectpros
                .FirstOrDefaultAsync(p => p.InviteCode == inviteDto.InviteCode);
            if (project == null)
            {
                return new ProjectResponeDto
                {
                    ErrorCode = 1,
                    ErrorMessage = "Mã mời không hợp lệ hoặc không tồn tại",
                    Data = ""
                };
            }

            // Kiểm tra xem user đã được gán vào project chưa
            var existing = await _dbcContext.UserProjects
                .FirstOrDefaultAsync(up => up.UserId == inviteDto.UserId && up.ProjectId == project.ProjectId);
            if (existing != null)
            {
                return new ProjectResponeDto
                {
                    ErrorCode = 1,
                    ErrorMessage = "User đã được gán vào dự án này!",
                    Data = ""
                };
            }

            var userProject = new UserProject
            {
                UserId = inviteDto.UserId,
                ProjectId = project.ProjectId,
                IsManager = inviteDto.IsManager
            };

            _dbcContext.UserProjects.Add(userProject);
            await _dbcContext.SaveChangesAsync();

            return new ProjectResponeDto
            {
                ErrorCode = 0,
                ErrorMessage = "Gia nhập dự án thành công",
                Data = userProject.UserProjectId
            };
        }
        public async Task<ProjectResponeDto> GetUserProjectByProjectIdAsync(int projectId)
        {
            // Kiểm tra project tồn tại
            var project = await _dbcContext.Projectpros.FindAsync(projectId);
            if (project == null)
            {
                return new ProjectResponeDto
                {
                    ErrorCode = 1,
                    ErrorMessage = "Không tìm thấy dự án!",
                    Data = ""
                };
            }

            var userProjects = await _dbcContext.UserProjects
                .Where(up => up.ProjectId == projectId)
                .Include(up => up.Project)
                .Select(up => new ReadUserProjectDto
                {
                    UserProjectId = up.UserProjectId,
                    UserId = up.UserId,
                    IsManager = up.IsManager,
                    ProjectId = up.ProjectId,
                    ProjectName = up.Project.Name,
                    ProjectDescription = up.Project.Description,
                    ProjectStartDate = up.Project.StartDate,
                    ProjectEndDate = up.Project.EndDate,
                    ProjectStatus = up.Project.Status.ToString()
                })
                .ToListAsync();

            if (!userProjects.Any())
            {
                return new ProjectResponeDto
                {
                    ErrorCode = 0,
                    ErrorMessage = "Không có user nào trong dự án này",
                    Data = new List<ReadUserProjectDto>()
                };
            }

            return new ProjectResponeDto
            {
                ErrorCode = 0,
                ErrorMessage = "Lấy danh sách user trong dự án thành công",
                Data = userProjects
            };
        }
    }
}



