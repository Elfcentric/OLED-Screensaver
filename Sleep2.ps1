Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- Configuration ---
$idleTimeMinutes = 5

# --- Setup for Screen 1 (Primary) ---
$screen1 = [System.Windows.Forms.Screen]::AllScreens[0]
$bounds1 = $screen1.Bounds
$overlay1 = New-Object Windows.Forms.Form
$overlay1.FormBorderStyle = 'None'
$overlay1.WindowState = 'Normal'
$overlay1.TopMost = $true
$overlay1.BackColor = 'Black'
$overlay1.Opacity = 1
$overlay1.StartPosition = 'Manual'
$overlay1.Location = $bounds1.Location
$overlay1.Size = $bounds1.Size
$overlay1.ShowInTaskbar = $false
$lastSeenOnScreen1 = Get-Date

# --- Setup for Screen 2 (Secondary) ---
$screen2 = [System.Windows.Forms.Screen]::AllScreens[1]
$bounds2 = $screen2.Bounds
$overlay2 = New-Object Windows.Forms.Form
$overlay2.FormBorderStyle = 'None'
$overlay2.WindowState = 'Normal'
$overlay2.TopMost = $true
$overlay2.BackColor = 'Black'
$overlay2.Opacity = 1
$overlay2.StartPosition = 'Manual'
$overlay2.Location = $bounds2.Location
$overlay2.Size = $bounds2.Size
$overlay2.ShowInTaskbar = $false
$lastSeenOnScreen2 = Get-Date

# --- Main Loop ---
while ($true) {
    [System.Windows.Forms.Application]::DoEvents()
    $cursorPos = [System.Windows.Forms.Cursor]::Position

    # Check cursor position for Screen 1
    if ($cursorPos.X -ge $bounds1.X -and $cursorPos.X -lt ($bounds1.X + $bounds1.Width) -and
        $cursorPos.Y -ge $bounds1.Y -and $cursorPos.Y -lt ($bounds1.Y + $bounds1.Height)) {
        $lastSeenOnScreen1 = Get-Date
        if ($overlay1.Visible) {
            $overlay1.Hide()
        }
    }
    # Check cursor position for Screen 2
    elseif ($cursorPos.X -ge $bounds2.X -and $cursorPos.X -lt ($bounds2.X + $bounds2.Width) -and
            $cursorPos.Y -ge $bounds2.Y -and $cursorPos.Y -lt ($bounds2.Y + $bounds2.Height)) {
        $lastSeenOnScreen2 = Get-Date
        if ($overlay2.Visible) {
            $overlay2.Hide()
        }
    }

    # Check idle time for Screen 1
    if (([DateTime]::Now - $lastSeenOnScreen1).TotalMinutes -ge $idleTimeMinutes) {
        if (-not $overlay1.Visible) {
            $overlay1.Show()
        }
    }

    # Check idle time for Screen 2
    if (([DateTime]::Now - $lastSeenOnScreen2).TotalMinutes -ge $idleTimeMinutes) {
        if (-not $overlay2.Visible) {
            $overlay2.Show()
        }
    }

    Start-Sleep -Seconds 1
}