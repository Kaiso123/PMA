using Constant.Database;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Project.Domain.Project
{
    [Table(nameof(EventUser), Schema = DbSchema.Project)]
    public class EventUser
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int EventUserId { get; set; }

        [Required]
        public int EventId { get; set; }

        [Required]
        public int UserId { get; set; }

        // Navigation properties
        [ForeignKey("EventId")]
        public Eventpro? Event { get; set; }
    }
}
