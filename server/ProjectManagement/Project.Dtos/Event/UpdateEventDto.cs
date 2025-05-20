using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Project.Dtos.Event
{
    public class UpdateEventDto
    {
        public int EventId { get; set; }
        public string? Title { get; set; }
        public string? Description { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public string? Location { get; set; }
        public bool IsAllDay { get; set; }
        public string? Color { get; set; }
        public int ProjectId { get; set; }
        public int CreatedBy { get; set; }
        public List<int>? UserIds { get; set; } 
    }
}
