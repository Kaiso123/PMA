using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Project.Dtos.UserProject
{
    public class ReadUserProjectDto
    {
        public int UserProjectId { get; set; }
        public int UserId { get; set; }
        public bool IsManager { get; set; }
        public int ProjectId { get; set; }
        public string ProjectName { get; set; } = string.Empty;
        public string? ProjectDescription { get; set; }
        public DateTime ProjectStartDate { get; set; }
        public DateTime? ProjectEndDate { get; set; }
        public string ProjectStatus { get; set; } = "Pending";
    }
}
