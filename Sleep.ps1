Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$screen = [System.Windows.Forms.Screen]::AllScreens[1]  # Second monitor
$bounds = $screen.Bounds
$overlay = New-Object Windows.Forms.Form
$overlay.FormBorderStyle = 'None'
$overlay.WindowState = 'Normal'
$overlay.TopMost = $true
$overlay.BackColor = 'Black'
$overlay.Opacity = 1
$overlay.StartPosition = 'Manual'
$overlay.Location = $bounds.Location
$overlay.Size = $bounds.Size
$overlay.ShowInTaskbar = $false

$lastSeenOnSecondMonitor = Get-Date

while ($true) {
    [System.Windows.Forms.Application]::DoEvents()
    $cursorPos = [System.Windows.Forms.Cursor]::Position
    if ($cursorPos.X -ge $bounds.X -and $cursorPos.X -le ($bounds.X + $bounds.Width) -and
        $cursorPos.Y -ge $bounds.Y -and $cursorPos.Y -le ($bounds.Y + $bounds.Height)) {
        $lastSeenOnSecondMonitor = Get-Date
        if ($overlay.Visible) {
            $overlay.Hide()
        }
    }
    elseif (([DateTime]::Now - $lastSeenOnSecondMonitor).TotalMinutes -ge 5) {
        if (-not $overlay.Visible) {
            $overlay.Show()
        }
    }

    Start-Sleep -Seconds 1
}
