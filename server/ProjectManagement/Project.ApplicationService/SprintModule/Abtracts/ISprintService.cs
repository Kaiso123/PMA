using Project.Dtos;
using Project.Dtos.Sprint;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Project.ApplicationService.SprintModule.Abtracts
{
    public interface ISprintService
    {
        Task<ProjectResponeDto> CreateSprintAsync(CreateSprintDto sprintDto);
        Task<ProjectResponeDto> GetSprintsByProjectAsync(int projectId);
        Task<ProjectResponeDto> UpdateSprintAsync(int sprintId, CreateSprintDto sprintDto);
        Task<ProjectResponeDto> DeleteSprintAsync(int sprintId);
    }
}
