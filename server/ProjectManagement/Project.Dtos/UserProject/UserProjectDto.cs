using Project.Domain.Project;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Project.Dtos.UserProject
{
    public class UserProjectDto
    {
        public int UserProjectId { get; set; }
        public int ProjectId { get; set; }
        public int UserId { get; set; }
        public bool IsManager { get; set; }
    }
}
