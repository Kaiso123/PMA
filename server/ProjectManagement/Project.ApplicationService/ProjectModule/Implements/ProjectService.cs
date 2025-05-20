using Project.ApplicationService.ProjectModule.Abtracts;
using Project.Domain.Project;
using Project.Dtos.Project;
using Project.Infrastructure;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Project.ApplicationService.Common;
using Project.Dtos;
using Microsoft.Extensions.Logging;


namespace Project.ApplicationService.ProjectModule.Implements
{
    public class ProjectService : ProjectServiceBase, IProjectService
    {
        public ProjectService(ILogger<IProjectService> logger, ProjectDbContext dbContext) : base(logger, dbContext) { }
        private static string GenerateInviteCode(int length)
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            var random = new Random();
            return new string(Enumerable.Repeat(chars, length)
                .Select(s => s[random.Next(s.Length)]).ToArray());
        }
        public async Task<ProjectResponeDto> CreateProjectAsync(CreatProjectDto projectDto)
        {
            string inviteCode;
            do
            {
                inviteCode = GenerateInviteCode(8);
            } while (await _dbcContext.Projectpros.AnyAsync(p => p.InviteCode == inviteCode));

            var project = new Projectpro
            {
                Name = projectDto.Name,
                Description = projectDto.Description,
                StartDate = projectDto.StartDate,
                EndDate = projectDto.EndDate,
                Status = Enum.TryParse(projectDto.Status, out ProjectStatus status)
                    ? status
                    : ProjectStatus.Pending,
                Budget = projectDto.Budget,
                Progress = projectDto.Progress,
                InviteCode = inviteCode,
            };

            _dbcContext.Projectpros.Add(project);
            await _dbcContext.SaveChangesAsync();

            // Thêm manager vào UserProject
            var userProject = new UserProject
            {
                ProjectId = project.ProjectId,
                UserId = projectDto.ManagerId,
                IsManager = true
            };
            _dbcContext.UserProjects.Add(userProject);

            await _dbcContext.SaveChangesAsync();

            return new ProjectResponeDto
            {
                ErrorCode = 0,
                ErrorMessage = "Creat Project Success!",
                Data = project.ProjectId
            };
        }

        public async Task<ProjectResponeDto> GetProjectsByUserAsync(int userId)
        {
            var userProjects = await _dbcContext.UserProjects
                .Include(up => up.Project)
                .Where(up => up.UserId == userId)
                .ToListAsync();

            if (userProjects == null || !userProjects.Any())
            {
                return new ProjectResponeDto
                {
                    ErrorCode = 1,
                    ErrorMessage = "Người dùng này không có Project nào",
                    Data = ""
                };
            }

            var projectDtos = userProjects.Select(up => new ReadProjectDto
            {
                ProjectId = up.Project!.ProjectId,
                ManagerId = _dbcContext.UserProjects
                    .Where(upm => upm.ProjectId == up.Project.ProjectId && upm.IsManager)
                    .Select(upm => upm.UserId)
                    .FirstOrDefault(),
                Name = up.Project.Name,
                Description = up.Project.Description,
                StartDate = up.Project.StartDate,
                EndDate = up.Project.EndDate,
                Status = up.Project.Status.ToString(),
                Budget = up.Project.Budget,
                Progress = up.Project.Progress,
                InviteCode = up.Project.InviteCode,
                IsManager = up.IsManager
            }).ToList();

            return new ProjectResponeDto
            {
                ErrorCode = 0,
                ErrorMessage = "Success get all Project by User!",
                Data = projectDtos
            };
        }

        public async Task<ProjectResponeDto> DeleteProjectAsync(int projectId)
        {
            var project = await _dbcContext.Projectpros
                .FirstOrDefaultAsync(p => p.ProjectId == projectId);

            if (project == null)
            {
                return new ProjectResponeDto
                {
                    ErrorCode = 1,
                    ErrorMessage = "Project không tồn tại",
                    Data = ""
                };
            }

            // Xóa các UserProject liên quan
            var userProjects = _dbcContext.UserProjects
                .Where(up => up.ProjectId == projectId);
            _dbcContext.UserProjects.RemoveRange(userProjects);

            // Xóa project
            _dbcContext.Projectpros.Remove(project);

            await _dbcContext.SaveChangesAsync();

            return new ProjectResponeDto
            {
                ErrorCode = 0,
                ErrorMessage = "Xóa Project thành công",
                Data = projectId
            };
        }
    }
}
