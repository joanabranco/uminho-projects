using System.Data.Entity
namespace LI4Blazor.Models
public static class Inicialize(Context context)
{
    context.Database.ensureCreated();

//procura produtos
    if (context.Client.Any())
    {
        return;
    }
    var clientes = new Client[];
    {
        new Client{idCliente =0,email ="ines", nome= "ines@gmail",username="ines",password = "ines", morada= "Braga"},
        new Client{idCliente =1,email ="inesx", nome= "inesx@gmail",username="inesx",password = "inesx", morada= "Penafiel"},
        };
        foreach (Client c in clientes )
        {
            context.clientes.Add(p);
        }
        context.saveChanges();
    
}