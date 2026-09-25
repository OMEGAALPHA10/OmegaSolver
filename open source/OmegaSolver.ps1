# OmegaSolver - Suite de diagnóstico, mantenimiento y optimización para Windows.
# Copyright (C) 2026 OMEGA_ALPHA
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://gnu.org>.

# Solicitar elevaciÃ³n de privilegios de Administrador
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- VENTANA PRINCIPAL ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "OmegaSolver v2.5 - Centro de Mantenimiento"
$form.Size = New-Object System.Drawing.Size(650, 630)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(25, 25, 25)
$form.ForeColor = [System.Drawing.Color]::White
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false

# Variables de ConfiguraciÃ³n Avanzada (Multidisco)
$global:AdvCleanSecondaryRecycle = $false
$global:AdvCleanSecondaryTemp = $false
$global:SelectedDrives = @()

# Encabezado
$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "OmegaSolver: OptimizaciÃ³n y ReparaciÃ³n"
$lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$lblTitle.Location = New-Object System.Drawing.Point(15, 12)
$lblTitle.Size = New-Object System.Drawing.Size(410, 25)
$form.Controls.Add($lblTitle)

# BotÃ³n PresentaciÃ³n / Ayuda
$btnHelp = New-Object System.Windows.Forms.Button
$btnHelp.Text = "â“ PresentaciÃ³n / Ayuda"
$btnHelp.Location = New-Object System.Drawing.Point(435, 10)
$btnHelp.Size = New-Object System.Drawing.Size(185, 28)
$btnHelp.FlatStyle = "Flat"
$btnHelp.BackColor = [System.Drawing.Color]::FromArgb(60, 60, 65)
$btnHelp.ForeColor = [System.Drawing.Color]::Cyan
$form.Controls.Add($btnHelp)

# Consola de Registros (Log)
$txtLog = New-Object System.Windows.Forms.TextBox
$txtLog.Multiline = $true
$txtLog.ScrollBars = "Vertical"
$txtLog.ReadOnly = $true
$txtLog.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
$txtLog.ForeColor = [System.Drawing.Color]::FromArgb(0, 255, 128)
$txtLog.Font = New-Object System.Drawing.Font("Consolas", 9)
$txtLog.Location = New-Object System.Drawing.Point(15, 380)
$txtLog.Size = New-Object System.Drawing.Size(605, 185)
$form.Controls.Add($txtLog)

function Write-Log($msg) {
    $txtLog.AppendText("[$((Get-Date).ToString('HH:mm:ss'))] $msg`r`n")
    $txtLog.SelectionStart = $txtLog.Text.Length
    $txtLog.ScrollToCaret()
    $form.Refresh()
}

# --- SECCIÃ“N OMEGAOPTI (LIMPIEZA) ---
$groupClean = New-Object System.Windows.Forms.GroupBox
$groupClean.Text = " OmegaOpti: MÃ³dulo de Limpieza "
$groupClean.ForeColor = [System.Drawing.Color]::Cyan
$groupClean.Location = New-Object System.Drawing.Point(15, 45)
$groupClean.Size = New-Object System.Drawing.Size(295, 320)
$form.Controls.Add($groupClean)

$chkTemp = New-Object System.Windows.Forms.CheckBox
$chkTemp.Text = "Archivos Temporales y CachÃ© (C:)"
$chkTemp.Location = New-Object System.Drawing.Point(15, 30)
$chkTemp.AutoSize = $true
$chkTemp.Checked = $true
$chkTemp.ForeColor = [System.Drawing.Color]::White
$groupClean.Controls.Add($chkTemp)

$chkPrefetch = New-Object System.Windows.Forms.CheckBox
$chkPrefetch.Text = "Limpiar Prefetch de Windows"
$chkPrefetch.Location = New-Object System.Drawing.Point(15, 60)
$chkPrefetch.AutoSize = $true
$chkPrefetch.Checked = $true
$chkPrefetch.ForeColor = [System.Drawing.Color]::White
$groupClean.Controls.Add($chkPrefetch)

$chkDNS = New-Object System.Windows.Forms.CheckBox
$chkDNS.Text = "Vaciar CachÃ© DNS"
$chkDNS.Location = New-Object System.Drawing.Point(15, 90)
$chkDNS.AutoSize = $true
$chkDNS.Checked = $true
$chkDNS.ForeColor = [System.Drawing.Color]::White
$groupClean.Controls.Add($chkDNS)

$chkRecycle = New-Object System.Windows.Forms.CheckBox
$chkRecycle.Text = "Vaciar Papelera de Reciclaje (C:)"
$chkRecycle.Location = New-Object System.Drawing.Point(15, 120)
$chkRecycle.AutoSize = $true
$chkRecycle.Checked = $false
$chkRecycle.ForeColor = [System.Drawing.Color]::White
$groupClean.Controls.Add($chkRecycle)

# BotÃ³n Opciones Avanzadas (Multidisco)
$btnAdvClean = New-Object System.Windows.Forms.Button
$btnAdvClean.Text = "âš™ï¸ Opciones Avanzadas (Multidisco)"
$btnAdvClean.Location = New-Object System.Drawing.Point(15, 175)
$btnAdvClean.Size = New-Object System.Drawing.Size(265, 32)
$btnAdvClean.FlatStyle = "Flat"
$btnAdvClean.BackColor = [System.Drawing.Color]::FromArgb(40, 60, 80)
$btnAdvClean.ForeColor = [System.Drawing.Color]::LightCyan
$groupClean.Controls.Add($btnAdvClean)

$btnClean = New-Object System.Windows.Forms.Button
$btnClean.Text = "Ejecutar Limpieza"
$btnClean.Location = New-Object System.Drawing.Point(15, 260)
$btnClean.Size = New-Object System.Drawing.Size(265, 38)
$btnClean.FlatStyle = "Flat"
$btnClean.BackColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
$btnClean.ForeColor = [System.Drawing.Color]::White
$groupClean.Controls.Add($btnClean)

# --- SECCIÃ“N OMEGAFIX (REPARACIÃ“N) ---
$groupFix = New-Object System.Windows.Forms.GroupBox
$groupFix.Text = " OmegaFix: MÃ³dulo de ReparaciÃ³n "
$groupFix.ForeColor = [System.Drawing.Color]::Orange
$groupFix.Location = New-Object System.Drawing.Point(325, 45)
$groupFix.Size = New-Object System.Drawing.Size(295, 320)
$form.Controls.Add($groupFix)

$btnSFC = New-Object System.Windows.Forms.Button
$btnSFC.Text = "Escanear Archivos (SFC)"
$btnSFC.Location = New-Object System.Drawing.Point(15, 30)
$btnSFC.Size = New-Object System.Drawing.Size(265, 32)
$btnSFC.FlatStyle = "Flat"
$btnSFC.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)
$btnSFC.ForeColor = [System.Drawing.Color]::White
$groupFix.Controls.Add($btnSFC)

$btnDISM = New-Object System.Windows.Forms.Button
$btnDISM.Text = "Reparar Imagen (DISM)"
$btnDISM.Location = New-Object System.Drawing.Point(15, 70)
$btnDISM.Size = New-Object System.Drawing.Size(265, 32)
$btnDISM.FlatStyle = "Flat"
$btnDISM.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)
$btnDISM.ForeColor = [System.Drawing.Color]::White
$groupFix.Controls.Add($btnDISM)

$btnCHKDSK = New-Object System.Windows.Forms.Button
$btnCHKDSK.Text = "Examen de Disco (CHKDSK /R /F)"
$btnCHKDSK.Location = New-Object System.Drawing.Point(15, 110)
$btnCHKDSK.Size = New-Object System.Drawing.Size(265, 32)
$btnCHKDSK.FlatStyle = "Flat"
$btnCHKDSK.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)
$btnCHKDSK.ForeColor = [System.Drawing.Color]::White
$groupFix.Controls.Add($btnCHKDSK)

$btnNetReset = New-Object System.Windows.Forms.Button
$btnNetReset.Text = "Reiniciar Red (Winsock/IP)"
$btnNetReset.Location = New-Object System.Drawing.Point(15, 150)
$btnNetReset.Size = New-Object System.Drawing.Size(265, 32)
$btnNetReset.FlatStyle = "Flat"
$btnNetReset.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)
$btnNetReset.ForeColor = [System.Drawing.Color]::White
$groupFix.Controls.Add($btnNetReset)

$btnFullFix = New-Object System.Windows.Forms.Button
$btnFullFix.Text = "ReparaciÃ³n Completa (1-Clic)"
$btnFullFix.Location = New-Object System.Drawing.Point(15, 260)
$btnFullFix.Size = New-Object System.Drawing.Size(265, 38)
$btnFullFix.FlatStyle = "Flat"
$btnFullFix.BackColor = [System.Drawing.Color]::FromArgb(204, 102, 0)
$btnFullFix.ForeColor = [System.Drawing.Color]::White
$groupFix.Controls.Add($btnFullFix)

# --- VENTANA DE OPICIONES AVANZADAS MULTIDISCO ---
$btnAdvClean.Add_Click({
    $advForm = New-Object System.Windows.Forms.Form
    $advForm.Text = "Opciones Avanzadas - SelecciÃ³n de Discos"
    $advForm.Size = New-Object System.Drawing.Size(420, 380)
    $advForm.StartPosition = "CenterParent"
    $advForm.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
    $advForm.ForeColor = [System.Drawing.Color]::White
    $advForm.FormBorderStyle = "FixedDialog"

    $lblAdvDrive = New-Object System.Windows.Forms.Label
    $lblAdvDrive.Text = "Selecciona las unidades secundarias a incluir:"
    $lblAdvDrive.Location = New-Object System.Drawing.Point(15, 15)
    $lblAdvDrive.AutoSize = $true
    $advForm.Controls.Add($lblAdvDrive)

    $chkListDrives = New-Object System.Windows.Forms.CheckedListBox
    $chkListDrives.Location = New-Object System.Drawing.Point(15, 40)
    $chkListDrives.Size = New-Object System.Drawing.Size(370, 120)
    $chkListDrives.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)
    $chkListDrives.ForeColor = [System.Drawing.Color]::White

    # Buscar unidades conectadas excluyendo C:
    $drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Name -ne "C" -and $_.Free -ne $null }
    foreach ($d in $drives) {
        $isAlreadyChecked = $global:SelectedDrives -contains $d.Name
        $chkListDrives.Items.Add("$($d.Name): [$($d.DisplayRoot)]", $isAlreadyChecked) | Out-Null
    }
    if ($drives.Count -eq 0) {
        $chkListDrives.Items.Add("No se detectaron unidades secundarias") | Out-Null
        $chkListDrives.Enabled = $false
    }
    $advForm.Controls.Add($chkListDrives)

    $chkSecRecycle = New-Object System.Windows.Forms.CheckBox
    $chkSecRecycle.Text = "Vaciar $Recycle.Bin en las unidades seleccionadas"
    $chkSecRecycle.Location = New-Object System.Drawing.Point(15, 175)
    $chkSecRecycle.AutoSize = $true
    $chkSecRecycle.Checked = $global:AdvCleanSecondaryRecycle
    $advForm.Controls.Add($chkSecRecycle)

    $chkSecTemp = New-Object System.Windows.Forms.CheckBox
    $chkSecTemp.Text = "Limpiar carpetas Temp/Recicled en discos secundarios"
    $chkSecTemp.Location = New-Object System.Drawing.Point(15, 205)
    $chkSecTemp.AutoSize = $true
    $chkSecTemp.Checked = $global:AdvCleanSecondaryTemp
    $advForm.Controls.Add($chkSecTemp)

    $btnSaveAdv = New-Object System.Windows.Forms.Button
    $btnSaveAdv.Text = "Guardar Preferencias"
    $btnSaveAdv.Location = New-Object System.Drawing.Point(120, 270)
    $btnSaveAdv.Size = New-Object System.Drawing.Size(160, 35)
    $btnSaveAdv.FlatStyle = "Flat"
    $btnSaveAdv.BackColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
    $advForm.Controls.Add($btnSaveAdv)

    $btnSaveAdv.Add_Click({
        $global:SelectedDrives = @()
        foreach ($item in $chkListDrives.CheckedItems) {
            $driveLetter = $item.Substring(0, 1)
            $global:SelectedDrives += $driveLetter
        }
        $global:AdvCleanSecondaryRecycle = $chkSecRecycle.Checked
        $global:AdvCleanSecondaryTemp = $chkSecTemp.Checked
        
        Write-Log "ConfiguraciÃ³n avanzada guardada. Discos seleccionados: $($global:SelectedDrives -join ', ')"
        $advForm.Close()
    })

    $advForm.ShowDialog() | Out-Null
})

# --- VENTANA DE AYUDA Y ADVERTENCIAS ---
$btnHelp.Add_Click({
    $helpForm = New-Object System.Windows.Forms.Form
    $helpForm.Text = "GuÃ­a de Uso, Advertencias y Funciones"
    $helpForm.Size = New-Object System.Drawing.Size(600, 520)
    $helpForm.StartPosition = "CenterParent"
    $helpForm.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
    $helpForm.ForeColor = [System.Drawing.Color]::White

    $txtHelp = New-Object System.Windows.Forms.RichTextBox
    $txtHelp.Dock = "Fill"
    $txtHelp.ReadOnly = $true
    $txtHelp.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)
    $txtHelp.ForeColor = [System.Drawing.Color]::Gainsboro
    $txtHelp.Font = New-Object System.Drawing.Font("Segoe UI", 9.5)
    
    $helpText = @"
=====================================================
          OMEGASOLVER v2.5 - GUÃA Y ADVERTENCIAS
=====================================================

Â¿PARA QUÃ‰ SIRVE CADA FUNCIÃ“N?

â€¢ Archivos Temporales / Prefetch / DNS / Papelera:
  Eliminan archivos innecesarios de almacenamiento rÃ¡pido para liberar espacio en C:.

â€¢ Opciones Avanzadas (Multidisco):
  Permite seleccionar otros discos duros o unidades (D:, E:, etc.) para vaciar carpetas `$Recycle.Bin y temporales de raÃ­z.

â€¢ Escanear Archivos (SFC /scannow):
  Comprueba si la estructura del sistema operativo tiene componentes corruptos y los reemplaza.

â€¢ Reparar Imagen (DISM):
  Descarga componentes originales desde los servidores de Microsoft para corregir errores graves del sistema.
  âš ï¸ ADVERTENCIA DE VELOCIDAD DISM:
  Este proceso variarÃ¡ en velocidad segÃºn el disco duro (SSD = rÃ¡pido, HDD = mÃ¡s lento).

â€¢ Examen de Disco (CHKDSK /R /F):
  Repara errores lÃ³gicos del sistema de archivos (/F) y busca sectores fÃ­sicos defectuosos recuperando informaciÃ³n (/R).

â€¢ Reiniciar Red (Winsock/IP):
  Limpia la configuraciÃ³n de red y sockets cuando hay fallas de conexiÃ³n a Internet.
=====================================================
"@
    $txtHelp.Text = $helpText
    $helpForm.Controls.Add($txtHelp)
    $helpForm.ShowDialog() | Out-Null
})

# LÃ“GICA DE ACCIONES
$btnClean.Add_Click({
    Write-Log "Iniciando proceso de limpieza..."
    
    # 1. Limpieza estÃ¡ndar (Unidad C:)
    if ($chkTemp.Checked) {
        Write-Log "Borrando temporales de usuario y sistema (C:)..."
        Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    }
    if ($chkPrefetch.Checked) {
        Write-Log "Limpiando directorio Prefetch..."
        Remove-Item -Path "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
    }
    if ($chkDNS.Checked) {
        Write-Log "Vaciando cachÃ© DNS..."
        Clear-DnsClientCache
    }
    if ($chkRecycle.Checked) {
        Write-Log "Vaciando Papelera de Reciclaje principal..."
        Clear-RecycleBin -DriveLetter C -Force -ErrorAction SilentlyContinue
    }

    # 2. Limpieza de Discos Secundarios (Opciones Avanzadas)
    if ($global:SelectedDrives.Count -gt 0) {
        foreach ($drive in $global:SelectedDrives) {
            Write-Log "Procesando unidad secundaria $drive`:..."
            
            if ($global:AdvCleanSecondaryRecycle) {
                Write-Log " Vaciando `$Recycle.Bin en $drive`:..."
                Remove-Item -Path "$drive`:\`$Recycle.Bin\*" -Recurse -Force -ErrorAction SilentlyContinue
                Clear-RecycleBin -DriveLetter $drive -Force -ErrorAction SilentlyContinue
            }
            if ($global:AdvCleanSecondaryTemp) {
                Write-Log " Limpiando datos temporales en $drive`:..."
                Remove-Item -Path "$drive`:\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
                Remove-Item -Path "$drive`:\`$RECYCLE.BIN\*" -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
    }
    
    Write-Log "Limpieza completada con Ã©xito."
})

$btnSFC.Add_Click({
    Write-Log "Ejecutando SFC /Scannow..."
    Start-Process "sfc.exe" -ArgumentList "/scannow" -Wait -NoNewWindow
    Write-Log "VerificaciÃ³n SFC finalizada."
})

$btnDISM.Add_Click({
    Write-Log "âš ï¸ AVISO: DISM dependerÃ¡ de la velocidad del disco (SSD = rÃ¡pido, HDD = mÃ¡s lento)."
    Write-Log "Ejecutando DISM /Online /Cleanup-Image /RestoreHealth..."
    Start-Process "dism.exe" -ArgumentList "/Online /Cleanup-Image /RestoreHealth" -Wait -NoNewWindow
    Write-Log "ReparaciÃ³n DISM finalizada."
})

$btnCHKDSK.Add_Click({
    $confirm = [System.Windows.Forms.MessageBox]::Show(
        "El comando CHKDSK /F /R examinarÃ¡ el disco C: en busca de errores lÃ³gicos y sectores defectuoso.`n`nâš ï¸ ADVERTENCIAS:`n1. Como la unidad C: estÃ¡ en uso, se programarÃ¡ la revisiÃ³n para el prÃ³ximo reinicio del sistema.`n2. El proceso puede demorar desde varios minutos hasta varias horas segÃºn la velocidad y salud del disco.`n`nÂ¿Deseas continuar y programar la comprobaciÃ³n?",
        "Advertencia Importante - CHKDSK /F /R",
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Warning
    )
    if ($confirm -eq [System.Windows.Forms.DialogResult]::Yes) {
        Write-Log "Iniciando solicitud de CHKDSK C: /F /R..."
        Start-Process "cmd.exe" -ArgumentList "/c chkdsk C: /f /r" -Verb RunAs
        Write-Log "Solicitud enviada. Recuerda reiniciar el sistema para completar el anÃ¡lisis."
    } else {
        Write-Log "OperaciÃ³n CHKDSK cancelada."
    }
})

$btnNetReset.Add_Click({
    Write-Log "Restableciendo componentes de red..."
    netsh winsock reset | Out-Null
    netsh int ip reset | Out-Null
    Write-Log "Pila de red reiniciada. Requiere reiniciar el equipo."
})

$btnFullFix.Add_Click({
    Write-Log "=== INICIANDO REPARACIÃ“N INTEGRAL ==="
    Write-Log "Paso 1: Ejecutando SFC..."
    Start-Process "sfc.exe" -ArgumentList "/scannow" -Wait -NoNewWindow
    Write-Log "Paso 2: Ejecutando DISM (La velocidad depende del disco duro)..."
    Start-Process "dism.exe" -ArgumentList "/Online /Cleanup-Image /RestoreHealth" -Wait -NoNewWindow
    Write-Log "Paso 3: Reiniciando red y DNS..."
    netsh winsock reset | Out-Null
    Clear-DnsClientCache
    Write-Log "=== REPARACIÃ“N COMPLETA FINALIZADA ==="
})

Write-Log "GUI cargada correctamente. Consulta 'PresentaciÃ³n / Ayuda' para ver detalles."
$form.ShowDialog() | Out-Null
