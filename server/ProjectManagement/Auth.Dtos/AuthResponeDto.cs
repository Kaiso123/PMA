using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Auth.Dtos
{
    public class AuthResponeDto
    {
        public string EM { get; set; } // Error Message
        public int EC { get; set; }     // Error Code
        public object DT { get; set; }  // Data (Token or Array)
    }
}
