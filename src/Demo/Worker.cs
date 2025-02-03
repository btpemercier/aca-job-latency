using System.Data;
using Microsoft.Data.SqlClient;

namespace Demo;

public class Worker : BackgroundService
{
    private readonly ILogger<Worker> _logger;
    private readonly IHostApplicationLifetime _hostLifetime;
    private readonly IConfiguration _configuration;

    public Worker(ILogger<Worker> logger, IHostApplicationLifetime hostLifetime, IConfiguration configuration)
    {
        _logger = logger;
        _hostLifetime = hostLifetime;
        _configuration = configuration;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        int count = 0;

        while (!stoppingToken.IsCancellationRequested && count < 5)
        {
            try
            {
                DoWork();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "An error occurred");
            }

            await Task.Delay(2000, stoppingToken);

            count++;
        }

        _hostLifetime.StopApplication();
    }

    private void DoWork()
    {
        using SqlConnection sqlConnection = new(_configuration.GetConnectionString("DefaultConnection"));
        using IDbCommand command = sqlConnection.CreateCommand();
        command.CommandText = "SELECT 1";
        command.CommandType = CommandType.Text;

        sqlConnection.Open();
        command.ExecuteNonQuery();
    }
}
