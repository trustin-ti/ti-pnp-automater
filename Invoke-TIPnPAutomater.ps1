[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]
    $JsonFile
)

function Get-TimeStamp {
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
}

function Write-Log($Level, $Message) {
    Write-Host "$(Get-TimeStamp)[$Level] $Message"
}

function Invoke-PnPCommand {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$commandName,
        [Parameter()][hashtable]$constNamedArguments = @{},
        [Parameter()][array]$calculatedNamedArguments
    )

    $calculatedNamedArguments | ForEach-Object {
        $attributeName = $_.name
        $command = $_.command

        if ($null -ne $command.commandName -and "" -ne $command.commandName) {
            $constNamedArguments.Add($attributeName, $(Invoke-PnPCommand @command))
        }
    }

    try {
        if (Get-Command -Name $commandName -Module PnP.PowerShell) {
            Write-Log -Level "INFO" -Message "Running command $commandName"
        }
    }
    catch {
        Write-Log -Level "ERROR" -Message "Command $commandName is not part of the PnP.PowerShell module!"
    }

    &$commandName @constNamedArguments
}

Clear-Host # Clear the screen

Write-Host "========== PnP: JSON Commands =========="
Write-Host

# Read the JSON file
Write-Log -Level "INFO" -Message "Reading commands from $JsonFile..."
$JSONCommands = Get-Content -Path $JsonFile -Raw | ConvertFrom-Json -AsHashtable

$JSONCommands.commands | ForEach-Object {
    Invoke-PnPCommand @_
}
