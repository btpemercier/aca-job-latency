using Azure.Monitor.OpenTelemetry.AspNetCore;
using Demo;

var builder = Host.CreateApplicationBuilder(args);
builder.Services.AddHostedService<Worker>();
builder.Services.AddOpenTelemetry().UseAzureMonitor();

var host = builder.Build();
host.Run();
