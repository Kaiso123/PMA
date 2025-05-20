using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Constant.Database;

namespace Project.Domain.Project
{
    [Table(nameof(UserProject), Schema = DbSchema.Project)]
    public class UserProject
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int UserProjectId { get; set; }
        public int ProjectId { get; set; }
        public int UserId { get; set; }
        public bool IsManager { get; set; }

        // Navigation properties
        [ForeignKey("ProjectId")]
        public Projectpro? Project { get; set; }
    }
}
