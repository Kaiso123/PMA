using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Project.ApplicationService.SprintModule.Abtracts;
using Project.Domain.Project;
using Project.Dtos.Sprint;
using Project.Dtos;
using Project.Infrastructure;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Project.ApplicationService.Common;

namespace Project.ApplicationService.SprintModule.Implements
{
    public class SprintService : ProjectServiceBase, ISprintService
    {
        public SprintService(ILogger<ISprintService> logger, ProjectDbContext dbContext)
            : base(logger, dbContext)
        {
        }

        public async Task<ProjectResponeDto> CreateSprintAsync(CreateSprintDto sprintDto)
        {

            // Kiểm tra project tồn tại
            var project = await _dbcContext.Projectpros
                .FirstOrDefaultAsync(p => p.ProjectId == sprintDto.ProjectId);
            if (project == null)
            {
                return new ProjectResponeDto
                {
                    ErrorCode = 1,
                    ErrorMessage = "Project không tồn tại",
                    Data = ""
                };
            }

            // Tạo sprint mới
            var sprint = new Sprint
            {
                ProjectId = sprintDto.ProjectId,
                Name = sprintDto.Name,
                Description = sprintDto.Description,
                Created = sprintDto.Created,
                EndTime = sprintDto.EndTime ?? sprintDto.Created.AddMonths(1),
                Status = Enum.TryParse(sprintDto.Status, out SprintStatus status)
                    ? status
                    : SprintStatus.ToDo,
                Priority = Enum.TryParse(sprintDto.Priority, out Priority priority)
                    ? priority
                    : Priority.Medium
            };

            _dbcContext.Sprints.Add(sprint);
            await _dbcContext.SaveChangesAsync();

            return new ProjectResponeDto
            {
                ErrorCode = 0,
                ErrorMessage = "Tạo Sprint thành công!",
                Data = sprint.SprintId
            };


        }


        public async Task<ProjectResponeDto> GetSprintsByProjectAsync(int projectId)
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

            var sprints = await _dbcContext.Sprints
                .Where(s => s.ProjectId == projectId)
                .Select(s => new ReadSprintDto
                {
                    SprintId = s.SprintId,
                    ProjectId = s.ProjectId,
                    Name = s.Name,
                    Description = s.Description,
                    Created = s.Created,
                    EndTime = s.EndTime,
                    Status = s.Status.ToString(),
                    Priority = s.Priority.ToString()
                })
                .ToListAsync();

            if (!sprints.Any())
            {
                return new ProjectResponeDto
                {
                    ErrorCode = 0,
                    ErrorMessage = "Không có Sprint nào trong Project này",
                    Data = new List<ReadSprintDto>()
                };
            }

            _logger.LogInformation($"Retrieved {sprints.Count} sprints for project {projectId}");

            return new ProjectResponeDto
            {
                ErrorCode = 0,
                ErrorMessage = "Lấy danh sách Sprint thành công!",
                Data = sprints
            };
        }



        public async Task<ProjectResponeDto> UpdateSprintAsync(int sprintId, CreateSprintDto sprintDto)
        {

            // Kiểm tra sprint tồn tại
            var sprint = await _dbcContext.Sprints
                .FirstOrDefaultAsync(s => s.SprintId == sprintId);
            if (sprint == null)
            {
                return new ProjectResponeDto
                {
                    ErrorCode = 1,
                    ErrorMessage = "Sprint không tồn tại",
                    Data = ""
                };
            }

            // Kiểm tra project tồn tại
            var project = await _dbcContext.Projectpros
                .FirstOrDefaultAsync(p => p.ProjectId == sprintDto.ProjectId);
            if (project == null)
            {
                return new ProjectResponeDto
                {
                    ErrorCode = 1,
                    ErrorMessage = "Project không tồn tại",
                    Data = ""
                };
            }

            // Cập nhật thông tin sprint
            sprint.ProjectId = sprintDto.ProjectId;
            sprint.Name = sprintDto.Name;
            sprint.Description = sprintDto.Description;
            sprint.Created = sprintDto.Created;
            sprint.EndTime = sprintDto.EndTime;
            sprint.Status = Enum.TryParse(sprintDto.Status, out SprintStatus status)
            ? status
                : SprintStatus.ToDo;
            sprint.Priority = Enum.TryParse(sprintDto.Priority, out Priority priority)
            ? priority
                : Priority.Medium;

            await _dbcContext.SaveChangesAsync();

            _logger.LogInformation($"Updated sprint {sprintId} for project {sprint.ProjectId}");

            return new ProjectResponeDto
            {
                ErrorCode = 0,
                ErrorMessage = "Cập nhật Sprint thành công!",
                Data = sprintId
            };
        }


        public async Task<ProjectResponeDto> DeleteSprintAsync(int sprintId)
        {

            var sprint = await _dbcContext.Sprints
                .FirstOrDefaultAsync(s => s.SprintId == sprintId);

            if (sprint == null)
            {
                return new ProjectResponeDto
                {
                    ErrorCode = 1,
                    ErrorMessage = "Sprint không tồn tại",
                    Data = ""
                };
            }

            // Đặt SprintId của các Issue liên quan thành null
            var issues = await _dbcContext.Issues
                .Where(i => i.SprintId == sprintId)
                .ToListAsync();
            foreach (var issue in issues)
            {
                issue.SprintId = null;
            }

            _dbcContext.Sprints.Remove(sprint);
            await _dbcContext.SaveChangesAsync();

            _logger.LogInformation($"Deleted sprint {sprintId}");

            return new ProjectResponeDto
            {
                ErrorCode = 0,
                ErrorMessage = "Xóa Sprint thành công",
                Data = sprintId
            };

        }
    }
}


