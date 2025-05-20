using Microsoft.EntityFrameworkCore;
using Auth.Domain;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Emit;
using System.Text;
using System.Threading.Tasks;

namespace Auth.Infrastructure
{
    public class AuthDbContext : DbContext

    {
        public DbSet<AuthUser> AuthUsers { get; set; }
        public DbSet<AuthRole> AuthRoles { get; set; }
        public DbSet<AuthUserRole> AuthUserRoles { get; set; }
        public DbSet<AuthRolePermission> RolePermissions { get; set; }

        public AuthDbContext(DbContextOptions<AuthDbContext> options) : base(options)
        {
        }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder
                .Entity<AuthUserRole>()
                .HasOne<AuthUser>()
                .WithMany() // Nếu AuthUser có nhiều AuthUserRole
                .HasForeignKey(e => e.userId) // Sử dụng userId cho AuthUserRole
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder
                .Entity<AuthUserRole>()
                .HasOne<AuthRole>()
                .WithMany() // Nếu AuthRole có nhiều AuthUserRole
                .HasForeignKey(e => e.roleId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder
                .Entity<AuthRolePermission>()
                .HasOne<AuthRole>()
                .WithMany() // Nếu AuthRole có nhiều AuthRolePermission
                .HasForeignKey(e => e.roleId)
                .OnDelete(DeleteBehavior.Restrict);

            base.OnModelCreating(modelBuilder);
        }


    }

}

