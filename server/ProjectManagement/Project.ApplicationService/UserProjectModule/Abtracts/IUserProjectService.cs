using Project.Dtos.Project;
using Project.Dtos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Project.Dtos.UserProject;

namespace Project.ApplicationService.UserProjectModule.Abtracts
{
    public interface IUserProjectService
    {
        Task<ProjectResponeDto> CreateUserProjectAsync(CreatUserProjectDto userprojectDto);
        Task<ProjectResponeDto> GetAllUserProjectsAsync();
        Task<ProjectResponeDto> DeleteUserProjectAsync(int userProjectId);
        Task<ProjectResponeDto> InviteUserToProjectAsync(InviteUserToProjectDto inviteDto);
        Task<ProjectResponeDto> GetUserProjectByProjectIdAsync(int projectId);
    }
}
