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
# Build and push container image
# ------------------------

Write-Host "Building and pushing container image..."

$sourcePath = "src/Demo"

$containerImageName = $ProjectName.ToLower()
$containerImageTag = "latest"

$acrName = "$($ProjectName.ToLower())acr".Replace("-", "")

$fullImageName = "$acrName.azurecr.io/$($containerImageName):$($containerImageTag)"

docker build -t $fullImageName $sourcePath --platform linux/amd64

az acr login --name $acrName

docker push $fullImageName

# ------------------------
# Deploy Container Bicep Template
# ------------------------

Write-Host "Deploying container to Azure..."

$resourceGroupName = $ProjectName + "-rg"

New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile .\container.bicep -TemplateParameterObject @{ projectName = $ProjectName }