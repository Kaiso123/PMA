using Project.Dtos.Event;
using Project.Dtos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Project.ApplicationService.Event.Abtracts
{
    public interface IEventService
    {
        Task<ProjectResponeDto> CreateEventAsync(CreateEventDto eventDto);
        Task<ProjectResponeDto> GetEventsByProjectAsync(int projectId);
        Task<ProjectResponeDto> DeleteEventAsync(int eventId);
        Task<ProjectResponeDto> UpdateEventAsync(UpdateEventDto eventDto);
    }
}