# PowerShell script to set RTF content to Windows clipboard
# Used with pandoc to preserve markdown formatting for Outlook

Add-Type -AssemblyName System.Windows.Forms

# Read all input from stdin
$rtfContent = $input | Out-String

if ($rtfContent -and $rtfContent.Trim().Length -gt 0) {
    # Create a DataObject with RTF format
    $dataObject = New-Object System.Windows.Forms.DataObject
    $dataObject.SetData([System.Windows.Forms.DataFormats]::Rtf, $rtfContent)

    # Also set as plain text for compatibility
    $plainText = $rtfContent -replace '\\[^\\s]+\s?', '' -replace '[{}]', ''
    $dataObject.SetText($plainText)

    # Set to clipboard
    [System.Windows.Forms.Clipboard]::SetDataObject($dataObject, $true)

    Write-Output "✓ Content copied to clipboard (RTF format preserved)"
} else {
    Write-Error "No content received to copy"
    exit 1
}
