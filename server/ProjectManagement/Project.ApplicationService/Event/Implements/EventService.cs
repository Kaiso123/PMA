using Microsoft.Extensions.Logging;
using Project.ApplicationService.Event.Abtracts;
using Project.Domain.Project;
using Project.Dtos.Event;
using Project.Dtos;
using Project.Infrastructure;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Project.ApplicationService.Common;
using Project.ApplicationService.ProjectModule.Abtracts;
using Microsoft.EntityFrameworkCore;

namespace Project.ApplicationService.Event.Implements
{
    public class EventService : ProjectServiceBase, IEventService
    {

        public EventService(ILogger<IProjectService> logger, ProjectDbContext dbContext) : base(logger, dbContext) { }
        public async Task<ProjectResponeDto> CreateEventAsync(CreateEventDto eventDto)
        {
            // Kiểm tra Project có tồn tại không
            var project = await _dbcContext.Projectpros
                .FirstOrDefaultAsync(p => p.ProjectId == eventDto.ProjectId);
            if (project == null)
            {
                return new ProjectResponeDto
                {
                    ErrorCode = 1,
                    ErrorMessage = "Project không tồn tại",
                    Data = ""
                };
            }

            // Tạo Event
            var eventEntity = new Eventpro
            {
                Title = eventDto.Title,
                Description = eventDto.Description,
                StartTime = eventDto.StartTime,
                EndTime = eventDto.EndTime,
                Location = eventDto.Location,
                IsAllDay = eventDto.IsAllDay,
                Color = eventDto.Color,
                ProjectId = eventDto.ProjectId,
                CreatedBy = eventDto.CreatedBy,
                CreatedAt = DateTime.UtcNow,
            };

            _dbcContext.Events.Add(eventEntity);
            await _dbcContext.SaveChangesAsync();

            // Thêm người tham gia vào EventUser
            if (eventDto.UserIds != null && eventDto.UserIds.Any())
            {
                var eventUsers = eventDto.UserIds
                    .Where(userId => userId != 0)
                    .Select(userId => new EventUser
                    {
                        EventId = eventEntity.EventId,
                        UserId = userId
                    })
                    .ToList();

                if (eventUsers.Any())
                {
                    _dbcContext.EventUsers.AddRange(eventUsers);
                    await _dbcContext.SaveChangesAsync();
                }
            }

            return new ProjectResponeDto
            {
                ErrorCode = 0,
                ErrorMessage = "Tạo Event thành công",
                Data = eventEntity.EventId
            };

        }

        public async Task<ProjectResponeDto> GetEventsByProjectAsync(int projectId)
        {
            var events = await _dbcContext.Events
                .Where(e => e.ProjectId == projectId)
                .Include(e => e.EventUsers)
                .ToListAsync();

            if (!events.Any())
            {
                return new ProjectResponeDto
                {
                    ErrorCode = 1,
                    ErrorMessage = "Không có sự kiện nào cho Project này",
                    Data = ""
                };
            }

            var eventDtos = events.Select(e => new ReadEventDto
            {
                EventId = e.EventId,
                Title = e.Title,
                Description = e.Description,
                StartTime = e.StartTime,
                EndTime = e.EndTime,
                Location = e.Location,
                IsAllDay = e.IsAllDay,
                Color = e.Color,
                ProjectId = e.ProjectId,
                CreatedBy = e.CreatedBy,
                CreatedAt = e.CreatedAt,
                UserIds = e.EventUsers.Select(eu => eu.UserId).ToList()
            }).ToList();

            return new ProjectResponeDto
            {
                ErrorCode = 0,
                ErrorMessage = "Lấy danh sách sự kiện thành công",
                Data = eventDtos
            };
        }

        public async Task<ProjectResponeDto> UpdateEventAsync(UpdateEventDto eventDto)
        {
            // Tìm sự kiện theo ID
            var eventEntity = await _dbcContext.Events
                .Include(e => e.EventUsers)
                .FirstOrDefaultAsync(e => e.EventId == eventDto.EventId);

            if (eventEntity == null)
            {
                return new ProjectResponeDto
                {
                    ErrorCode = 1,
                    ErrorMessage = "Sự kiện không tồn tại",
                    Data = ""
                };
            }

            // Kiểm tra Project có tồn tại không
            var project = await _dbcContext.Projectpros
                .FirstOrDefaultAsync(p => p.ProjectId == eventDto.ProjectId);
            if (project == null)
            {
                return new ProjectResponeDto
                {
                    ErrorCode = 1,
                    ErrorMessage = "Project không tồn tại",
                    Data = ""
                };
            }

            // Cập nhật thông tin sự kiện
            eventEntity.Title = eventDto.Title;
            eventEntity.Description = eventDto.Description;
            eventEntity.StartTime = eventDto.StartTime;
            eventEntity.EndTime = eventDto.EndTime;
            eventEntity.Location = eventDto.Location;
            eventEntity.IsAllDay = eventDto.IsAllDay;
            eventEntity.Color = eventDto.Color;
            eventEntity.ProjectId = eventDto.ProjectId;
            eventEntity.CreatedBy = eventDto.CreatedBy;

            // Xóa các EventUser cũ
            _dbcContext.EventUsers.RemoveRange(eventEntity.EventUsers);

            // Thêm lại danh sách người tham gia mới
            if (eventDto.UserIds != null && eventDto.UserIds.Any())
            {
                var eventUsers = eventDto.UserIds
                    .Where(userId => userId != 0)
                    .Select(userId => new EventUser
                    {
                        EventId = eventEntity.EventId,
                        UserId = userId
                    })
                    .ToList();

                if (eventUsers.Any())
                {
                    _dbcContext.EventUsers.AddRange(eventUsers);
                    await _dbcContext.SaveChangesAsync();
                }
            }

            await _dbcContext.SaveChangesAsync();

            return new ProjectResponeDto
            {
                ErrorCode = 0,
                ErrorMessage = "Cập nhật sự kiện thành công",
                Data = eventEntity.EventId
            };
        }

        public async Task<ProjectResponeDto> DeleteEventAsync(int eventId)
        {
            var eventEntity = await _dbcContext.Events
                .FirstOrDefaultAsync(e => e.EventId == eventId);

            if (eventEntity == null)
            {
                return new ProjectResponeDto
                {
                    ErrorCode = 1,
                    ErrorMessage = "Sự kiện không tồn tại",
                    Data = ""
                };
            }

            // Xóa các EventUser liên quan
            var eventUsers = _dbcContext.EventUsers
                .Where(eu => eu.EventId == eventId);
            _dbcContext.EventUsers.RemoveRange(eventUsers);

            // Xóa Event
            _dbcContext.Events.Remove(eventEntity);

            await _dbcContext.SaveChangesAsync();

            return new ProjectResponeDto
            {
                ErrorCode = 0,
                ErrorMessage = "Xóa sự kiện thành công",
                Data = eventId
            };
        }
    }
}
