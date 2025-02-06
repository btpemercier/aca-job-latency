using Azure.Monitor.OpenTelemetry.AspNetCore;
using Microsoft.AspNetCore.Diagnostics.HealthChecks;

var builder = WebApplication.CreateBuilder(args);


builder.Services.AddOpenTelemetry().UseAzureMonitor();
builder.Services.AddHealthChecks().AddCheck<SqlHealthCheck>("sql");

var app = builder.Build();

app.MapGet("/hello", () =>
{
    return "Hello World!";
})
.WithName("Hello");

app.MapHealthChecks("/health/live", new HealthCheckOptions
{
    Predicate = _ => false
});

app.MapHealthChecks("/health/ready");

app.Run();
