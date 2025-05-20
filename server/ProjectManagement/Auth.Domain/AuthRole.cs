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
    [Table(nameof(AuthRole), Schema = DbSchema.Auth)]
    public class AuthRole
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int roleId { get; set; }

        [MaxLength(50)]
        public string roleName { get; set; }
        [MaxLength(50)]
        public string description { get; set; }
        [MaxLength(50)]
        public string roleType { get; set; }
        public int roleCode { get; set; }
        public DateTime Created { get; set; }
        [MaxLength(50)]
        public string status { get; set; }


    }
}
