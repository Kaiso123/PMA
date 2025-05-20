using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Project.Dtos
{
    public class ProjectResponeDto
    {
        public string ErrorMessage { get; set; } // Error Message
        public int ErrorCode { get; set; }     // Error Code
        public object Data { get; set; }  // Data (Token or Array)
    }
}
