using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Project.Dtos.Issue
{
    public class CreateIssueDto
    {
        public int ProjectId { get; set; }
        public int? SprintId { get; set; }
        public string Title { get; set; } = string.Empty;
        public string? Description { get; set; }
        public string Status { get; set; } = "ToDo";
        public string Priority { get; set; } = "Medium";
        public int? AssigneeId { get; set; }
        public DateTime Created { get; set; }
        public DateTime? EndTime { get; set; }
    }
}
