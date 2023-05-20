using System;

namespace PrimeiroMapeamentoObjetoRelacional
{
    class Program
    {
        static void Main(string[] args)
        {
            Cliente cli = new Cliente
            {
                id= 3,
                email= "joel@"
                Nome = "Joel",
                username = "kk",
                password= "kkk",
                morada= "kkkk",
            };

            Context db = new Context();

            db.Client.Add(cli);

            db.SaveChanges();

            Console.WriteLine("Cliente salvo com sucesso.");

            Console.ReadKey();
        }
    }
}/*
using LI4Blazor.Data;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;

public class Program
{
    public Startup(IHostingEnvironment env){
        var builer = new ConfigurationBuilder()
        .SetBasePath(env.ContentRootPath)
        .AddJsonFile("appConfig.json", optional: false, reloadOnChange: true)
        .AddJsonFile($"appConfigs.{env.Environment}.json",optional:true)
        .AddEnviromentVariables();
        Configuration = builer.Build();
    }

public IConfigurationRoot Configuration{get;}

public void ConfigureServices(IServiceCollection services){
    services.AddDbContext<Context>(options =>
        options.UseSqlServer(Configuration.GetConnectionString("ConexaoSqlServer")));


services.AddMvc();

}

public void Configure(IApplicationBuiler app, IHostingEnvironment env, ILoggerFactory loggerFactory){
    loggerFactory.AddConsole(Configuration.GetSection("Logging"));
    loggerFactory.AddDebug();

    if(env.IsDevelopment()){
        app.UseDeveloperExpeptionPage();
        app.UseBrowserLink();
    }
    else{
        app.UseExceptionHandler("Home/Error");
    }

}

// Add services to the container.
builder.Services.AddRazorPages();
builder.Services.AddServerSideBlazor();
builder.Services.AddSingleton<WeatherForecastService>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}
app.UseHttpsRedirection();

app.UseStaticFiles();

app.UseRouting();

app.MapBlazorHub();
app.MapFallbackToPage("/_Host");

app.Run();
}
*/
