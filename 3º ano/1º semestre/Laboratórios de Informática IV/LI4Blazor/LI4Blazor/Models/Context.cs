namespace Microsoft.EntityFrameworkCore;
namespace LI4Blazor.Models
{
    public class Context : DbContext
    {
        public Context(DbContextOptions<ProdutoContexto> option) : base(optins)
        {

        }
        public DbSet<Client> Client { get; set; }
    }
}
