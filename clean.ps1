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
# Delete Resource Group if exists
# ------------------------

$resourceGroupName = $ProjectName + "-rg"

$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue

if ($resourceGroup -ne $null) {
    Remove-AzResourceGroup -Name $resourceGroupName -Force -AsJob
}