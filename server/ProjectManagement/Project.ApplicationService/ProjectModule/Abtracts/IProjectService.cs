using Project.Dtos;
using Project.Dtos.Project;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Project.ApplicationService.ProjectModule.Abtracts
{
    public interface IProjectService
    {
        Task<ProjectResponeDto> CreateProjectAsync(CreatProjectDto projectDto);
        Task<ProjectResponeDto> GetProjectsByUserAsync(int userId);
        Task<ProjectResponeDto> DeleteProjectAsync(int projectId);
        //Task AssignTaskToProjectAsync(int projectId, int taskId);
    }
}
