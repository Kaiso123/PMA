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
    [Table(nameof(AuthUser), Schema = DbSchema.Auth)]
    public class AuthUser
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int userId { get; set; }

        [MaxLength(50)]
        public string username { get; set; }

        [MaxLength(256)]
        public string password { get; set; }

        [MaxLength(256)]
        public string email { get; set; }

        public int age { get; set; }

        [MaxLength(256)]
        public string address { get; set; }

        [MaxLength(50)]
        public string gender { get; set; }

        [MaxLength(50)]
        public int phone { get; set; }

        [MaxLength(50)]
        public string name { get; set; }
    }
}
