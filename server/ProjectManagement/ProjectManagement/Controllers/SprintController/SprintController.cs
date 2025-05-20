using Microsoft.AspNetCore.Mvc;
using Project.ApplicationService.ProjectModule.Abtracts;
using Project.ApplicationService.SprintModule.Abtracts;
using Project.Dtos.Project;
using Project.Dtos.Sprint;

namespace ProjectManagement.Controllers.ProjectController
{
    [Route("sprint")]
    [ApiController]
    public class SprintController : Controller
    {
        private readonly ISprintService _sprintService;

        public SprintController(ISprintService sprintService)
        {
            _sprintService = sprintService;
        }

        [HttpPost("create")]
        public async Task<IActionResult> CreateSprint([FromBody] CreateSprintDto sprintDto)
        {
            if (sprintDto == null)
            {
                return BadRequest("Invalid sprint data.");
            }

            var result = await _sprintService.CreateSprintAsync(sprintDto);
            return Ok(result);
        }

        [HttpGet("project/{projectId}")]
        public async Task<IActionResult> GetSprintsByProject(int projectId)
        {
            var result = await _sprintService.GetSprintsByProjectAsync(projectId);
            return Ok(result);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateSprint(int id, [FromBody] CreateSprintDto sprintDto)
        {
            if (sprintDto == null)
            {
                return BadRequest("Invalid sprint data.");
            }

            var result = await _sprintService.UpdateSprintAsync(id, sprintDto);
            if (result.ErrorCode != 0)
            {
                return NotFound(result);
            }

            return Ok(result);
        }

        [HttpDelete("delete/{id}")]
        public async Task<IActionResult> DeleteSprint(int id)
        {
            var result = await _sprintService.DeleteSprintAsync(id);
            if (result.ErrorCode != 0)
            {
                return NotFound(result);
            }

            return Ok(result);
        }
    }
}