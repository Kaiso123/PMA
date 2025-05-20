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
    public enum IssueStatus
    {
        ToDo,
        InProgress,
        Done
    }

    [Table(nameof(Issue), Schema = DbSchema.Project)]
    public class Issue
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int IssueId { get; set; }

        [Required]
        public int ProjectId { get; set; }

        public int? SprintId { get; set; }

        [Required]
        [MaxLength(100)]
        public string Title { get; set; } = string.Empty;

        [MaxLength(500)]
        public string? Description { get; set; }

        public IssueStatus Status { get; set; } = IssueStatus.ToDo;

        public Priority Priority { get; set; } = Priority.Medium;

        public int? AssigneeId { get; set; }

        [Required]
        public DateTime Created { get; set; }

        public DateTime? EndTime { get; set; }

        // Navigation properties
        [ForeignKey("ProjectId")]
        public Projectpro? Project { get; set; }

        [ForeignKey("SprintId")]
        public Sprint? Sprint { get; set; }
    }
}
