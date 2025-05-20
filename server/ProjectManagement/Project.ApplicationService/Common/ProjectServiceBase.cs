using Microsoft.Extensions.Logging;
using Project.Infrastructure;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;

namespace Project.ApplicationService.Common
{
    public class ProjectServiceBase
    {
        protected readonly ILogger _logger;
        protected readonly ProjectDbContext _dbcContext;
        protected ProjectServiceBase(ILogger logger, ProjectDbContext dbcContext)
        {
            _logger = logger;
            _dbcContext = dbcContext;
        }
    }
}
