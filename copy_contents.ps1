# This script reads file paths from the $Args automatic variable,
# which is how files from the "Send To" menu are passed to the script.

if ($Args.Count -eq 0) {
    # If the script is run directly with no files, do nothing.
    exit
}

$allContents = ""

foreach ($file in $Args) {
    if (Test-Path $file -PathType Leaf) {
        $fullPath = (Resolve-Path -LiteralPath $file).ProviderPath
        $content = ""
        
        try {
            # Attempt to read the file as plain text
            $content = Get-Content -LiteralPath $fullPath -Raw
        }
        catch {
            # If reading fails, create a placeholder message
            $content = "ERROR: Could not read file content. It might be binary, locked, or an issue with permissions."
        }

        $allContents += "=============================" + [Environment]::NewLine
        $allContents += "**File:** $($fullPath)" + [Environment]::NewLine
        $allContents += "=============================" + [Environment]::NewLine
        $allContents += [Environment]::NewLine
        $allContents += '```' + [Environment]::NewLine
        $allContents += $content + [Environment]::NewLine
        $allContents += '```' + [Environment]::NewLine
        $allContents += "=============================" + [Environment]::NewLine
        $allContents += "End of $($fullPath)" + [Environment]::NewLine
        $allContents += "=============================" + [Environment]::NewLine
        $allContents += [Environment]::NewLine
    }
}

if ($allContents) {
    Set-Clipboard -Value $allContents
}