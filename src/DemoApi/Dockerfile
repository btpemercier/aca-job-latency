FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

WORKDIR /src
COPY . .

RUN dotnet publish "DemoApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

ENV DOTNET_ENVIRONMENT=Production

USER $APP_UID

CMD ["dotnet", "DemoApi.dll"]