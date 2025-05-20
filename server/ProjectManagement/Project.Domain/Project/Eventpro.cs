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
    [Table(nameof(Eventpro), Schema = DbSchema.Project)]
    public class Eventpro
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int EventId { get; set; }

        [Required]
        [MaxLength(100)]
        public string? Title { get; set; }

        [MaxLength(500)]
        public string? Description { get; set; }

        [Required]
        public DateTime StartTime { get; set; }

        [Required]
        public DateTime EndTime { get; set; }

        [MaxLength(100)]
        public string? Location { get; set; }

        public bool IsAllDay { get; set; }

        public string? Color { get; set; } 

        [Required]
        public int ProjectId { get; set; }

        [Required]
        public int CreatedBy { get; set; }

        public DateTime CreatedAt { get; set; }

        // Navigation properties
        [ForeignKey("ProjectId")]
        public Projectpro? Project { get; set; }

        public virtual ICollection<EventUser>? EventUsers { get; set; }
    }
}
