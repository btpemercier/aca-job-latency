using System.Data;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Diagnostics.HealthChecks;

public class SqlHealthCheck : IHealthCheck
{
    private readonly IConfiguration configuration;
    private readonly ILogger<SqlHealthCheck> logger;

    public SqlHealthCheck(IConfiguration configuration, ILogger<SqlHealthCheck> logger)
    {
        this.configuration = configuration;
        this.logger = logger;
    }

    public Task<HealthCheckResult> CheckHealthAsync(HealthCheckContext context, CancellationToken cancellationToken = default)
    {
        try
        {
            using SqlConnection sqlConnection = new(configuration.GetConnectionString("DefaultConnection"));
            using IDbCommand command = sqlConnection.CreateCommand();
            command.CommandText = "SELECT 1";
            command.CommandType = CommandType.Text;

            sqlConnection.Open();
            command.ExecuteNonQuery();

            return Task.FromResult(HealthCheckResult.Healthy());
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "An error occurred");
            return Task.FromResult(HealthCheckResult.Unhealthy());
        }
    }
}