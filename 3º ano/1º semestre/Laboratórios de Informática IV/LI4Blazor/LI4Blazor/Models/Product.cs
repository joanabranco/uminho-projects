namespace LI4Blazor.Models
{
    Table[PRODUTOS]
public class Product
    {
        public String Id { get; set; }
        public String Maker { get; set; }
        public String Image { get; set; }
        public String Url { get; set; }
        public String Title { get; set; }
        public String Description { get; set; }
        public decimal Preço { get; set; }
        // public override tostring(){ }
    }
}