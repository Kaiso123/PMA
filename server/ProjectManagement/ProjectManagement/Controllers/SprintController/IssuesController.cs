using Microsoft.AspNetCore.Mvc;
using Project.ApplicationService.IssueModeul.Abtracts;
using Project.ApplicationService.ProjectModule.Abtracts;
using Project.Dtos.Issue;
using Project.Dtos.Project;

namespace ProjectManagement.Controllers.ProjectController
{
    [Route("issue")]
    [ApiController]
    public class IssuesController : Controller
    {
        private readonly IIssueService _issueService;

        public IssuesController(IIssueService issueService)
        {
            _issueService = issueService;
        }

        [HttpPost("create")]
        public async Task<IActionResult> CreateIssue([FromBody] CreateIssueDto issueDto)
        {
            if (issueDto == null)
            {
                return BadRequest("Invalid issue data.");
            }

            var result = await _issueService.CreateIssueAsync(issueDto);
            return Ok(result);
        }

        [HttpGet("project/{projectId}")]
        public async Task<IActionResult> GetIssuesByProject(int projectId)
        {
            var result = await _issueService.GetIssuesByProjectAsync(projectId);
            return Ok(result);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateIssue(int id, [FromBody] CreateIssueDto issueDto)
        {
            if (issueDto == null)
            {
                return BadRequest("Invalid issue data.");
            }

            var result = await _issueService.UpdateIssueAsync(id, issueDto);
            if (result.ErrorCode != 0)
            {
                return NotFound(result);
            }

            return Ok(result);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteIssue(int id)
        {
            var result = await _issueService.DeleteIssueAsync(id);
            if (result.ErrorCode != 0)
            {
                return NotFound(result);
            }

            return Ok(result);
        }
    }
}