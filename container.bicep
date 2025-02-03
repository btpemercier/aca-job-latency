// ******************
// ** Parameters
// ******************

param location string = resourceGroup().location
param projectName string

// ******************
// ** Variables
// ******************

var ContainerAppEnvironmentName = toLower('${projectName}-cae')
var AppInsightsName = toLower('${projectName}-appi')
var JobName = toLower('${projectName}-job')
var ManagedIdentityName = toLower('${projectName}-id')
var AcrName = replace(('${projectName}-acr'), '-', '')
var SqlServerName = toLower('${projectName}-sql')
var DatabaseName = toLower('${projectName}-sqldb')

// ******************
// ** Resources
// ******************

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: AppInsightsName
}

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' existing = {
  name: AcrName
}

resource cae 'Microsoft.App/managedEnvironments@2024-03-01' existing = {
  name: ContainerAppEnvironmentName
}

resource sqlServer 'Microsoft.Sql/servers@2024-05-01-preview' existing = {
  name: SqlServerName
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: ManagedIdentityName
}

resource job 'Microsoft.App/jobs@2024-10-02-preview' = {
  name: JobName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    environmentId: cae.id
    configuration: {
      triggerType: 'Manual'
      replicaTimeout: 180
      replicaRetryLimit: 0
      registries: [
        {
          server: acr.properties.loginServer
          identity: managedIdentity.id
        }
      ]
    }
    template: {
      containers: [
        {
          name: 'main'
          image: '${acr.properties.loginServer}/${projectName}:latest'
          env: [
            {
              name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
              value: appInsights.properties.ConnectionString
            }
            {
              name: 'SQLCONNSTR_DefaultConnection'
              value:  'Server=tcp:${sqlServer.properties.fullyQualifiedDomainName};Database=${DatabaseName};Authentication=Active Directory Default;User Id=${managedIdentity.properties.clientId};Connection Timeout=30;'
            }
          ]
          resources: {
            cpu: 1
            memory: '2Gi'
          }
        }
      ]
    }
  }
}
