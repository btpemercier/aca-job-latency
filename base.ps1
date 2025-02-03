# ------------------------
# Parameters
# ------------------------

param(
    [Parameter(Position=0,mandatory=$true)]
    [string]$ProjectName,
    [Parameter(Position=1,mandatory=$true)]
    [string]$Location,
    [Parameter(Position=3,mandatory=$true)]
    [string]$TenantId,
    [Parameter(Position=4,mandatory=$true)]
    [string]$SusbcriptionId
)

write-host "ProjectName: $ProjectName"
write-host "Location: $Location"

# ------------------------
# Login to Azure
# ------------------------

Update-AzConfig -LoginExperienceV2 Off

Connect-AzAccount -Tenant $TenantId -Subscription $SusbcriptionId

# ------------------------
# Create Resource Group if not exists
# ------------------------

$resourceGroupName = $ProjectName + "-rg"

$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue

if ($resourceGroup -eq $null) {
    New-AzResourceGroup -Name $resourceGroupName -Location $Location
}