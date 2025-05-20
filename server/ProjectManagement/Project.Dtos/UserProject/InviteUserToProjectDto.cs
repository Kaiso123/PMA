using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Project.Dtos.UserProject
{
    public class InviteUserToProjectDto
    {
        public string InviteCode { get; set; } = string.Empty;
        public int UserId { get; set; }
        public bool IsManager { get; set; } = false;
    }
}
