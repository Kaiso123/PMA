using Microsoft.EntityFrameworkCore;
using Project.Domain.Project;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Project.Infrastructure
{
    public class ProjectDbContext : DbContext
    {
        public DbSet<Projectpro> Projectpros { get; set; }
        public DbSet<UserProject> UserProjects { get; set; }
        public DbSet<Sprint> Sprints { get; set; }
        public DbSet<Issue> Issues { get; set; }
        public DbSet<Eventpro> Events { get; set; }
        public DbSet<EventUser> EventUsers { get; set; }
        public ProjectDbContext(DbContextOptions<ProjectDbContext> options)
            : base(options)
        {
        }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // Cấu hình cho Projectpro
            modelBuilder.Entity<Projectpro>()
                .Property(p => p.InviteCode)
                .HasMaxLength(8);

            modelBuilder.Entity<Projectpro>()
                .HasIndex(p => p.InviteCode)
                .IsUnique()
                .HasFilter("[InviteCode] IS NOT NULL");

            // Cấu hình mối quan hệ UserProject - Projectpro
            modelBuilder.Entity<UserProject>()
                .HasOne(up => up.Project)
                .WithMany(p => p.UserProjects)
                .HasForeignKey(up => up.ProjectId)
                .OnDelete(DeleteBehavior.Restrict);

            // Cấu hình mối quan hệ Projectpro - Sprint
            modelBuilder.Entity<Sprint>()
                .HasOne(s => s.Project)
                .WithMany(p => p.Sprints)
                .HasForeignKey(s => s.ProjectId)
                .OnDelete(DeleteBehavior.Cascade);

            // Cấu hình mối quan hệ Projectpro - Issue
            modelBuilder.Entity<Issue>()
                .HasOne(i => i.Project)
                .WithMany(p => p.Issues)
                .HasForeignKey(i => i.ProjectId)
                .OnDelete(DeleteBehavior.Cascade);

            // Cấu hình mối quan hệ Sprint - Issue
            modelBuilder.Entity<Issue>()
                .HasOne(i => i.Sprint)
                .WithMany(s => s.Issues)
                .HasForeignKey(i => i.SprintId)
                .OnDelete(DeleteBehavior.Restrict); 

            // Đảm bảo SprintId là tùy chọn
            modelBuilder.Entity<Issue>()
                .Property(i => i.SprintId)
                .IsRequired(false);

            // Cấu hình mối quan hệ Projectpro - Event
            modelBuilder.Entity<Eventpro>()
                .HasOne(e => e.Project)
                .WithMany() 
                .HasForeignKey(e => e.ProjectId)
                .OnDelete(DeleteBehavior.Cascade);

            // Cấu hình mối quan hệ Event - EventUser
            modelBuilder.Entity<EventUser>()
                .HasOne(eu => eu.Event)
                .WithMany(e => e.EventUsers)
                .HasForeignKey(eu => eu.EventId)
                .OnDelete(DeleteBehavior.Cascade);
        }

    }
}
