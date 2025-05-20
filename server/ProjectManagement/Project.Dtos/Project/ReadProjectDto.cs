using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Project.Dtos.Project
{
    public class ReadProjectDto
    {
        public int ProjectId { get; set; }
        public int ManagerId { get; set; }
        public string? Name { get; set; }
        public string? Description { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public String? Status { get; set; }
        public double? Budget { get; set; }
        public double? Progress { get; set; }
        public string? InviteCode { get; set; }
        public bool IsManager { get; set; }
    }
}
