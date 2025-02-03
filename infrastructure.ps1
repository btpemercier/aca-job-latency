# ------------------------
# Parameters
# ------------------------

param(
    [Parameter(Position=0,mandatory=$true)]
    [string]$ProjectName,
    [Parameter(Position=1,mandatory=$true)]
    [string]$Location
)

# ------------------------
# Deploy Infrastructure Bicep Template
# ------------------------

$resourceGroupName = $ProjectName + "-rg"

New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile .\infrastructure.bicep -TemplateParameterObject @{ projectName = $ProjectName } -AsJob