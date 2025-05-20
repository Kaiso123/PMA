using Project.Dtos.Issue;
using Project.Dtos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Project.ApplicationService.IssueModeul.Abtracts
{
    public interface IIssueService
    {
        Task<ProjectResponeDto> CreateIssueAsync(CreateIssueDto issueDto);
        Task<ProjectResponeDto> GetIssuesByProjectAsync(int projectId);
        Task<ProjectResponeDto> UpdateIssueAsync(int issueId, CreateIssueDto issueDto);
        Task<ProjectResponeDto> DeleteIssueAsync(int issueId);
    }
}
