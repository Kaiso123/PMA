using Constant.Database;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Auth.Domain
{
    [Table(nameof(AuthUserRole), Schema = DbSchema.Auth)]
    public class AuthUserRole
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int userRoleId { get; set; }
        public int userId { get; set; }
        public int roleId { get; set; }
    }
}
