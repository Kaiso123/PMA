using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Project.Dtos.UserProject
{
    public class CreatUserProjectDto
    {
        public int ProjectId { get; set; }
        public int UserId { get; set; }
        public bool IsManager { get; set; }
    }
}
