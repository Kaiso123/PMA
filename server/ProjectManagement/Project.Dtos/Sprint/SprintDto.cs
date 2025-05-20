using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Project.Dtos.Sprint
{
    public class SprintDto
    {
        public int SprintId { get; set; }
        public int ProjectId { get; set; }
        public string Name { get; set; } = string.Empty;
        public string? Description { get; set; }
        public DateTime Created { get; set; }
        public DateTime? EndTime { get; set; }
        public string Status { get; set; } = "ToDo";
        public string Priority { get; set; } = "Medium";
    }
}
