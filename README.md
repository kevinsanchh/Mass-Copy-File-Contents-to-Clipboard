## Copy File Contents to Clipboard (for Windows)

This utility adds a "Copy Contents" option to the Windows "Send to" context menu. It allows you to select one or more files, and it will copy the text content of each file to your clipboard, formatted with clear headers and footers for each file.

## Features

-   **Multi-File Support**: Works seamlessly whether you select one file or multiple files.
-   **Clear Formatting**: Each file's content is wrapped in a formatted block that includes the full file path.
-   **Error Handling**: If a file cannot be read (e.g., it's a binary file like a `.exe`, is locked, or you lack permissions), it will insert an error message in its place without halting the entire process.
-   **Silent Operation**: The script runs quickly and silently in the background without any visible terminal windows.

## Setup Instructions

Follow these two steps to set up the functionality.

### 1. Create the PowerShell Script

First, you need to create the PowerShell script that will read the files and copy their contents.

A) Create a new folder on your computer to store the script. A simple and reliable location is `C:\Scripts`.

B) Inside that folder, create a new file named `copy_contents.ps1`.

C) Open `copy_contents.ps1` in any text editor and paste the entire code block below into it:

```powershell
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
```

D) Save and close the file.

### 2. Create the "Send To" Shortcut

Next, create a shortcut in the special `SendTo` folder that points to your script.

A) Open File Explorer.

B) In the address bar, type `shell:sendto` and press **Enter**.



C) Inside this folder, right-click on an empty space and select **New** -> **Shortcut**.

D) In the location box, paste the following command. (If you saved your script somewhere other than `C:\Scripts`, be sure to update the path).

```
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File "C:\Scripts\copy_contents.ps1"
```

E) Click **Next**.

F) Name the shortcut `Copy Contents` and click **Finish**.

## How to Use

1.  Select one or more files in File Explorer.
2.  Right-click on the selected file(s).
3.  Navigate to the **Send to** sub-menu.
4.  Click on **Copy Contents**.

The formatted text from all selected files will be silently copied to your clipboard, ready to be pasted.

## Output Format

The content copied to your clipboard will look like this:

```
=============================
**File:** C:\path\to\first\file.txt
=============================

[CONTENTS OF FILE HERE]

=============================
End of C:\path\to\first\file.txt
=============================

=============================
**File:** C:\path\to\second\file.log
=============================

[CONTENTS OF FILE HERE]

=============================
End of C:\path\to\second\file.log
=============================

```
