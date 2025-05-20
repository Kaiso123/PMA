using Microsoft.AspNetCore.Mvc;
using Project.ApplicationService.UserProjectModule.Abtracts;
using Project.Dtos.UserProject;
using Project.Dtos;

namespace ProjectManagement.Controllers.ProjectController
{
    [Route("userProject")]
    [ApiController]
    public class UserProjectController : Controller
    {
        private readonly IUserProjectService _userProjectService;
        public UserProjectController(IUserProjectService userProjectService)
        {
            _userProjectService = userProjectService;
        }
        [HttpPost("create")]
        public async Task<IActionResult> CreateUserProject([FromBody] CreatUserProjectDto request)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(new ProjectResponeDto
                {
                    ErrorCode = -1,
                    ErrorMessage = "Dữ liệu không hợp lệ"
                });
            }

            var result = await _userProjectService.CreateUserProjectAsync(request);

            if (result.ErrorCode != 0)
            {
                return BadRequest(result);
            }

            return Ok(result);
        }
        [HttpGet("getall")]
        public async Task<IActionResult> GetAllUserProjects()
        {
            var result = await _userProjectService.GetAllUserProjectsAsync();
            return result.ErrorCode == 0 ? Ok(result) : BadRequest(result);
        }

        [HttpDelete("delete/{id}")]
        public async Task<IActionResult> DeleteUserProject(int id)
        {
            var result = await _userProjectService.DeleteUserProjectAsync(id);
            return result.ErrorCode == 0 ? Ok(result) : BadRequest(result);
        }


        [HttpPost("invite")]
        public async Task<IActionResult> InviteUserToProject([FromBody] InviteUserToProjectDto inviteDto)
        {
            var result = await _userProjectService.InviteUserToProjectAsync(inviteDto);
            return Ok(result);
        }

        [HttpGet("{projectId}/users")]
        public async Task<IActionResult> GetUserProjectByProjectId(int projectId)
        {
            var result = await _userProjectService.GetUserProjectByProjectIdAsync(projectId);
            return Ok(result);
        }
    }
}
