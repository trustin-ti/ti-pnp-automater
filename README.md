# ti-pnp-automater
The purpose of this PowerShell script is to faciliate the creation of SharePoint sites and the execution of every command part of the PnP.PowerShell module.

With simple modifications, you can make run a series any PowerShell commands

## How it works ?
It's simples, all you have to do is to create a ``json`` file as described
```json
{
    "$schema": "<url>/ti-pnp.schema.json",
    "commands": [
        {
            "commandName": "Add-PnPField",
            "constNamedArguments": {
                "id": "af273bc4-3188-4179-b350-995be148cfcd",
                "displayName": "First Name",
                "internalName": "FirstName",
                "group": "My Site Column",
                "required": true
            }
        },
        {
            "commandName": "Add-PnPField",
            "constNamedArguments": {
                "id": "cdd4657f-e8a3-44d8-a37b-76a3c6ff780a",
                "displayName": "Last Name",
                "internalName": "LastName",
                "group": "My Site Column",
                "required": true
            }
        }
    ]
}
```

Once you have created this JSON file, all you have to do is to run the script as below:
```powershell
Invoke-TIPnPAutomater -JsonFile <path_to_json>
```

### How to deal with calculated arguments?
I faced this problem when I used ``Add-PnPContentType`` where ``parentContentType`` is an object you get by performing ``Get-PnPContentType``. The solution is to use ``calculatedNamedArguments``

```json
{
    "$schema": "<url>/ti-pnp.schema.json",
    "commands": [
        {
            "commandName": "Add-PnPContentType",
            "constNamedArguments": {
                "name": "My Contact",
                "group": "My Content Type"
            },
            "calculatedNamedArguments": {
                "name": "parentContentType",
                "command": {
                    "commandName": "Get-PnPContentType",
                    "constNamedArguments": {
                        "identity": "Document"
                    }
                }
            }
        }
    ]
}
```
