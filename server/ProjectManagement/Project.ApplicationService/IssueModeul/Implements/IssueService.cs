using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Project.ApplicationService.Common;
using Project.ApplicationService.IssueModeul.Abtracts;
using Project.ApplicationService.ProjectModule.Abtracts;
using Project.Domain.Project;
using Project.Dtos;
using Project.Dtos.Issue;
using Project.Dtos.Project;
using Project.Dtos.Sprint;
using Project.Infrastructure;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Project.ApplicationService.ProjectModule.Implements
{
    public class IssueService : ProjectServiceBase, IIssueService
    {
        public IssueService(ILogger<IIssueService> logger, ProjectDbContext dbContext)
            : base(logger, dbContext)
        {
        }

        public async Task<ProjectResponeDto> CreateIssueAsync(CreateIssueDto issueDto)
        {

            // Kiểm tra project tồn tại
            var project = await _dbcContext.Projectpros
                .FirstOrDefaultAsync(p => p.ProjectId == issueDto.ProjectId);
            if (project == null)
            {
                return new ProjectResponeDto
                {
                    ErrorCode = 1,
                    ErrorMessage = $"Project với ID {issueDto.ProjectId} không tồn tại",
                    Data = ""
                };
            }

            // Kiểm tra sprint nếu có (không phải 0)
            if (issueDto.SprintId.HasValue && issueDto.SprintId > 0)
            {
                var sprint = await _dbcContext.Sprints
                    .FirstOrDefaultAsync(s => s.SprintId == issueDto.SprintId);
                if (sprint == null)
                {
                    return new ProjectResponeDto
                    {
                        ErrorCode = 1,
                        ErrorMessage = "Sprint không tồn tại",
                        Data = ""
                    };
                }
            }

            // Tạo issue mới
            var issue = new Issue
            {
                ProjectId = issueDto.ProjectId,
                SprintId = issueDto.SprintId > 0 ? issueDto.SprintId : null, // Đặt SprintId = null nếu SprintId <= 0
                Title = issueDto.Title,
                Description = issueDto.Description,
                Status = Enum.TryParse(issueDto.Status, out IssueStatus status)
                    ? status
                    : IssueStatus.ToDo,
                Priority = Enum.TryParse(issueDto.Priority, out Priority priority)
                    ? priority
                    : Priority.Medium,
                AssigneeId = issueDto.AssigneeId,
                Created = issueDto.Created,
                EndTime = issueDto.EndTime ?? issueDto.Created.AddMonths(1),
            };

            _dbcContext.Issues.Add(issue);
            await _dbcContext.SaveChangesAsync();

            return new ProjectResponeDto
            {
                ErrorCode = 0,
                ErrorMessage = "Tạo Issue thành công!",
                Data = issue.IssueId
            };

        }



        public async Task<ProjectResponeDto> GetIssuesByProjectAsync(int projectId)
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

            var issues = await _dbcContext.Issues
                .Where(i => i.ProjectId == projectId)
                .Select(i => new ReadIssueDto
                {
                    IssueId = i.IssueId,
                    ProjectId = i.ProjectId,
                    SprintId = i.SprintId,
                    Title = i.Title,
                    Description = i.Description,
                    Status = i.Status.ToString(),
                    Priority = i.Priority.ToString(),
                    AssigneeId = i.AssigneeId,
                    Created = i.Created,
                    EndTime = i.EndTime
                })
                .ToListAsync();

            if (!issues.Any())
            {
                return new ProjectResponeDto
                {
                    ErrorCode = 0,
                    ErrorMessage = "Không có Issue nào trong Project này",
                    Data = new List<ReadIssueDto>()
                };
            }


            return new ProjectResponeDto
            {
                ErrorCode = 0,
                ErrorMessage = "Lấy danh sách Issue thành công!",
                Data = issues
            };

        }

        public async Task<ProjectResponeDto> UpdateIssueAsync(int issueId, CreateIssueDto issueDto)
        {

            // Kiểm tra issue tồn tại
            var issue = await _dbcContext.Issues
                .FirstOrDefaultAsync(i => i.IssueId == issueId);
            if (issue == null)
            {
                return new ProjectResponeDto
                {
                    ErrorCode = 1,
                    ErrorMessage = "Issue không tồn tại",
                    Data = ""
                };
            }

            // Kiểm tra project tồn tại
            var project = await _dbcContext.Projectpros
                .FirstOrDefaultAsync(p => p.ProjectId == issueDto.ProjectId);
            if (project == null)
            {
                return new ProjectResponeDto
                {
                    ErrorCode = 1,
                    ErrorMessage = "Project không tồn tại",
                    Data = ""
                };
            }

            // Kiểm tra sprint nếu có
            if (issueDto.SprintId.HasValue)
            {
                var sprint = await _dbcContext.Sprints
                    .FirstOrDefaultAsync(s => s.SprintId == issueDto.SprintId);
                if (sprint == null)
                {
                    return new ProjectResponeDto
                    {
                        ErrorCode = 1,
                        ErrorMessage = "Sprint không tồn tại",
                        Data = ""
                    };
                }
            }

            // Cập nhật thông tin issue
            issue.ProjectId = issueDto.ProjectId;
            issue.SprintId = issueDto.SprintId;
            issue.Title = issueDto.Title;
            issue.Description = issueDto.Description;
            issue.Status = Enum.TryParse(issueDto.Status, out IssueStatus status)
                ? status
                : IssueStatus.ToDo;
            issue.Priority = Enum.TryParse(issueDto.Priority, out Priority priority)
                ? priority
                : Priority.Medium;
            issue.AssigneeId = issueDto.AssigneeId;
            issue.Created = issueDto.Created;
            issue.EndTime = issueDto.EndTime;

            await _dbcContext.SaveChangesAsync();

            _logger.LogInformation($"Updated issue {issueId} for project {issue.ProjectId}");

            return new ProjectResponeDto
            {
                ErrorCode = 0,
                ErrorMessage = "Cập nhật Issue thành công!",
                Data = issueId
            };
        }



        public async Task<ProjectResponeDto> DeleteIssueAsync(int issueId)
        {

            var issue = await _dbcContext.Issues
                .FirstOrDefaultAsync(i => i.IssueId == issueId);
            if (issue == null)
            {
                return new ProjectResponeDto
                {
                    ErrorCode = 1,
                    ErrorMessage = "Issue không tồn tại",
                    Data = ""
                };
            }

            _dbcContext.Issues.Remove(issue);
            await _dbcContext.SaveChangesAsync();

            _logger.LogInformation($"Deleted issue {issueId}");

            return new ProjectResponeDto
            {
                ErrorCode = 0,
                ErrorMessage = "Xóa Issue thành công",
                Data = issueId
            };
        }


    }
}
