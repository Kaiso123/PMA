using Microsoft.AspNetCore.Mvc;
using Project.ApplicationService.ProjectModule.Abtracts;
using Project.Dtos.Project;

namespace ProjectManagement.Controllers.ProjectController
{

    [Route("project")]
    [ApiController]
    public class ProjectController : Controller
    {
        private readonly IProjectService _projectService;
        public ProjectController(IProjectService projectService)
        {
            _projectService = projectService;
        }

        [HttpPost("create")]
        public async Task<IActionResult> CreateProject([FromBody] CreatProjectDto projectDto)
        {
            if (projectDto == null)
            {
                return BadRequest("Invalid project data.");
            }

            var result = await _projectService.CreateProjectAsync(projectDto);
            return Ok(result);
        }

        // GET: /project/user/{userId}
        [HttpGet("user/{userId}")]
        public async Task<IActionResult> GetProjectsByUser(int userId)
        {
            var result = await _projectService.GetProjectsByUserAsync(userId);
            return Ok(result);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteProject(int id)
        {
            var result = await _projectService.DeleteProjectAsync(id);

            if (result.ErrorCode != 0)
            {
                return NotFound(result);
            }

            return Ok(result);
        }
    }
}
