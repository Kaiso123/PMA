using Microsoft.AspNetCore.Mvc;
using Project.ApplicationService.Event.Abtracts;
using Project.ApplicationService.ProjectModule.Abtracts;
using Project.Dtos.Event;
using Project.Dtos.Project;

namespace ProjectManagement.Controllers.ProjectController
{
    [Route("events")]
    [ApiController]
    public class EventController : Controller
    {
        private readonly IEventService _eventService;

        public EventController(IEventService eventService)
        {
            _eventService = eventService;
        }

        // POST: /events/create
        [HttpPost("create")]
        public async Task<IActionResult> CreateEvent([FromBody] CreateEventDto eventDto)
        {
            if (eventDto == null)
            {
                return BadRequest("Invalid event data.");
            }

            var result = await _eventService.CreateEventAsync(eventDto);
            return Ok(result);
        }

        // GET: /events/project/{projectId}
        [HttpGet("project/{projectId}")]
        public async Task<IActionResult> GetEventsByProject(int projectId)
        {
            var result = await _eventService.GetEventsByProjectAsync(projectId);
            return Ok(result);
        }

        // PUT: /events/update
        [HttpPut("update")]
        public async Task<IActionResult> UpdateEvent([FromBody] UpdateEventDto eventDto)
        {
            if (eventDto == null)
            {
                return BadRequest("Invalid event data.");
            }

            var result = await _eventService.UpdateEventAsync(eventDto);

            if (result.ErrorCode != 0)
            {
                return NotFound(result);
            }

            return Ok(result);
        }

        // DELETE: /events/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteEvent(int id)
        {
            var result = await _eventService.DeleteEventAsync(id);

            if (result.ErrorCode != 0)
            {
                return NotFound(result);
            }

            return Ok(result);
        }
    }
}