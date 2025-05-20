using Constant.Database;
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
    [Table(nameof(AuthRolePermission), Schema = DbSchema.Auth)]
    public class AuthRolePermission
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int rolePermissionId { get; set; }
        public int roleId { get; set; }
        [MaxLength(50)]
        public string permissionKey { get; set; }
    }
}
