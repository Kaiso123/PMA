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
    public enum SprintStatus
    {
        ToDo,
        InProgress,
        Done
    }

    public enum Priority
    {
        Low,
        Medium,
        High
    }
    [Table(nameof(Sprint), Schema = DbSchema.Project)]
    public class Sprint
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int SprintId { get; set; }

        [Required]
        public int ProjectId { get; set; }

        [Required]
        [MaxLength(100)]
        public string Name { get; set; } = string.Empty;

        [MaxLength(500)]
        public string? Description { get; set; }

        [Required]
        public DateTime Created { get; set; }

        public DateTime? EndTime { get; set; }

        public SprintStatus Status { get; set; } = SprintStatus.ToDo;

        public Priority Priority { get; set; } = Priority.Medium;

        // Navigation property
        [ForeignKey("ProjectId")]
        public Projectpro? Project { get; set; }
        public virtual ICollection<Issue>? Issues { get; set; }
    }
}
