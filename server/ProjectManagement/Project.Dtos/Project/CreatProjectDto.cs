using Project.Domain.Project;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Project.Dtos.Project
{
    public class CreatProjectDto
    {
        public int ManagerId { get; set; }
        public string Name { get; set; }
        public string? Description { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string? Status { get; set; } = "Pending";
        public double? Budget { get; set; }
        public double? Progress { get; set; }
    }
}
