using Constant.Database;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;


namespace Project.Domain.Project
{
    public enum ProjectStatus
    {
        Pending,
        InProgress,
        Completed,
        Cancelled
    }
    [Table(nameof(Projectpro), Schema = DbSchema.Project)]
    public class Projectpro
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ProjectId { get; set; }

        [Required]
        [MaxLength(100)]
        public string? Name { get; set; }

        [MaxLength(500)]
        public string? Description { get; set; }

        [Required]
        public DateTime StartDate { get; set; }

        public DateTime? EndDate { get; set; }

        public ProjectStatus Status { get; set; } = ProjectStatus.Pending;

        public double? Budget { get; set; } = 0.0;

        public double? Progress { get; set; } = 0.0;

        [MaxLength(8)]
        public string? InviteCode { get; set; }

        public virtual ICollection<UserProject>? UserProjects { get; set; }
        public virtual ICollection<Sprint>? Sprints { get; set; }
        public virtual ICollection<Issue>? Issues { get; set; }
    }
}
