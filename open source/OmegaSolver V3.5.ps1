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

# ==============================================================================
# PROYECTO: OmegaSolver V3.6
# ARCHIVO: OmegaSolver V3.6.ps1
# DESCRIPCIÃ“N: Herramienta grÃ¡fica de diagnÃ³stico, reparaciÃ³n, mantenimiento
#              y optimizaciÃ³n de Windows con registro de cambios reversibles.
# ================================================================================

# Solicitar permisos de administrador porque varias funciones modifican Windows.
function Test-OmegaAdministrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-OmegaAdministrator)) {
    try {
        $scriptPath = $MyInvocation.MyCommand.Path
        if (-not $scriptPath) {
            [System.Windows.MessageBox]::Show("Guarda el script como archivo .ps1 y ejecÃºtalo de nuevo.", "OmegaSolver V3.6") | Out-Null
            exit 1
        }
        Start-Process powershell.exe -Verb RunAs -ArgumentList @(
            '-NoProfile',
            '-ExecutionPolicy', 'Bypass',
            '-File', "`"$scriptPath`""
        ) | Out-Null
        exit 0
    }
    catch {
        Add-Type -AssemblyName PresentationFramework
        [System.Windows.MessageBox]::Show("OmegaSolver necesita permisos de administrador para ejecutar varias funciones.", "OmegaSolver V3.6", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning) | Out-Null
        exit 1
    }
}

Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

# ------------------------------------------------------------------------------
# XAML / INTERFAZ
# ------------------------------------------------------------------------------
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="OmegaSolver V3.6" Height="780" Width="1020"
        MinHeight="700" MinWidth="940"
        WindowStartupLocation="CenterScreen" Background="#101216" Foreground="#FFFFFF">
    <Window.Resources>
        <!-- Botones normales: hover oscuro para conservar contraste y lectura. -->
        <Style TargetType="Button">
            <Setter Property="Background" Value="#242831"/>
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Setter Property="BorderBrush" Value="#4B5563"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Padding" Value="8,6"/>
            <Setter Property="Margin" Value="4"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="ButtonBorder"
                                Background="{TemplateBinding Background}"
                                BorderBrush="{TemplateBinding BorderBrush}"
                                BorderThickness="{TemplateBinding BorderThickness}"
                                CornerRadius="5"
                                Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center"
                                              VerticalAlignment="Center"
                                              RecognizesAccessKey="True"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="ButtonBorder" Property="Background" Value="#1E293B"/>
                                <Setter TargetName="ButtonBorder" Property="BorderBrush" Value="#94A3B8"/>
                                <Setter Property="Foreground" Value="#FFFFFF"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="ButtonBorder" Property="Background" Value="#111827"/>
                                <Setter TargetName="ButtonBorder" Property="BorderBrush" Value="#CBD5E1"/>
                                <Setter Property="Foreground" Value="#FFFFFF"/>
                            </Trigger>
                            <Trigger Property="IsEnabled" Value="False">
                                <Setter TargetName="ButtonBorder" Property="Opacity" Value="0.55"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="PrimaryButton" TargetType="Button" BasedOn="{StaticResource {x:Type Button}}">
            <Setter Property="Background" Value="#0067A3"/>
            <Setter Property="BorderBrush" Value="#2EA3F2"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#004D7A"/>
                    <Setter Property="Foreground" Value="#FFFFFF"/>
                </Trigger>
                <Trigger Property="IsPressed" Value="True">
                    <Setter Property="Background" Value="#003855"/>
                    <Setter Property="Foreground" Value="#FFFFFF"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <Style x:Key="RevertButton" TargetType="Button" BasedOn="{StaticResource {x:Type Button}}">
            <Setter Property="Background" Value="#7A2E2E"/>
            <Setter Property="BorderBrush" Value="#F87171"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#5B1E1E"/>
                    <Setter Property="Foreground" Value="#FFFFFF"/>
                </Trigger>
                <Trigger Property="IsPressed" Value="True">
                    <Setter Property="Background" Value="#3F1515"/>
                    <Setter Property="Foreground" Value="#FFFFFF"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <Style x:Key="ManualButton" TargetType="Button" BasedOn="{StaticResource {x:Type Button}}">
            <Setter Property="Background" Value="#374151"/>
            <Setter Property="BorderBrush" Value="#9CA3AF"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#4B5563"/>
                    <Setter Property="Foreground" Value="#FFFFFF"/>
                </Trigger>
                <Trigger Property="IsPressed" Value="True">
                    <Setter Property="Background" Value="#1F2937"/>
                    <Setter Property="Foreground" Value="#FFFFFF"/>
                </Trigger>
            </Style.Triggers>
        </Style>
    </Window.Resources>

    <Grid Margin="15">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="170"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <!-- Cabecera -->
        <StackPanel Grid.Row="0" Margin="0,0,0,12">
            <TextBlock Text="OmegaSolver V3.6" FontSize="23" FontWeight="Bold" Foreground="#38BDF8"/>
            <TextBlock Text="DiagnÃ³stico, mantenimiento y optimizaciÃ³n de Windows" FontSize="12" Foreground="#AEB7C4" Margin="0,3,0,0"/>
            <TextBlock x:Name="lblStatus" Text="Estado: Listo" FontSize="12" Foreground="#D1D5DB" Margin="0,4,0,0"/>
        </StackPanel>

        <!-- Contenido Principal -->
        <Grid Grid.Row="1">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>

            <!-- Tarjeta 1: Sistema -->
            <Border Grid.Column="0" Background="#1B1F27" CornerRadius="7" Padding="10" Margin="0,0,6,0" BorderBrush="#303846" BorderThickness="1">
                <StackPanel>
                    <TextBlock Text="ðŸ› ï¸ Sistema y Rendimiento" FontSize="14" FontWeight="Bold" Margin="4,0,0,8" Foreground="#38BDF8"/>
                    <TextBlock Text="Disco objetivo para reparaciones:" FontSize="11" Foreground="#D1D5DB" Margin="4,0,4,3"/>
                    <StackPanel Orientation="Horizontal" Margin="0,0,0,4">
                        <ComboBox x:Name="cmbRepairDrive" Width="190" Height="32" Background="#0C0E12" Foreground="#FFFFFF" BorderBrush="#4B5563" Padding="6,4" ToolTip="Selecciona el volumen sobre el que se aplicarÃ¡n SFC, DISM y CHKDSK."/>
                        <Button x:Name="btnRefreshDrives" Content="â†» Actualizar" Width="92" Height="32" Margin="6,0,0,0" ToolTip="Vuelve a detectar los discos disponibles."/>
                    </StackPanel>
                    <TextBlock x:Name="lblDiskInfo" Text="Detectando discos..." FontSize="10" Foreground="#9CA3AF" TextWrapping="Wrap" Margin="4,0,4,7"/>
                    <Button x:Name="btnSfc" Content="Ejecutar SFC /Scannow" ToolTip="Repara archivos protegidos de Windows en el disco seleccionado. En C: usa el Windows activo; en otra unidad usa reparaciÃ³n offline si existe una instalaciÃ³n de Windows."/>
                    <Button x:Name="btnDism" Content="Reparar Imagen DISM" ToolTip="Repara componentes de la imagen de Windows mediante DISM."/>
                    <Button x:Name="btnChkDsk" Content="Reparar Disco (CHKDSK /f)" ToolTip="Comprueba y repara errores del sistema de archivos del volumen seleccionado. Puede pedir reinicio si es el disco del sistema."/>
                    <Button x:Name="btnMaxPower" Content="âš¡ Activar Alto Rendimiento" ToolTip="Guarda el plan actual y activa el plan Alto rendimiento."/>
                </StackPanel>
            </Border>

            <!-- Tarjeta 2: Red -->
            <Border Grid.Column="1" Background="#1B1F27" CornerRadius="7" Padding="10" Margin="6,0,6,0" BorderBrush="#303846" BorderThickness="1">
                <StackPanel>
                    <TextBlock Text="ðŸŒ Red y ConexiÃ³n" FontSize="14" FontWeight="Bold" Margin="4,0,0,10" Foreground="#38BDF8"/>
                    <Button x:Name="btnFlushDns" Content="Limpiar CachÃ© DNS" ToolTip="VacÃ­a la cachÃ© DNS local; se vuelve a crear automÃ¡ticamente al navegar."/>
                    <Button x:Name="btnResetNet" Content="Restablecer Winsock / IP" ToolTip="Restablece componentes de red. Puede requerir reinicio y no tiene un deshacer general."/>
                    <Button x:Name="btnQoS" Content="ðŸš€ Configurar LÃ­mite QoS a 0%" ToolTip="Guarda el valor anterior del lÃ­mite QoS y establece NonBestEffortLimit en 0."/>
                </StackPanel>
            </Border>

            <!-- Tarjeta 3: Mantenimiento -->
            <Border Grid.Column="2" Background="#1B1F27" CornerRadius="7" Padding="10" Margin="6,0,0,0" BorderBrush="#303846" BorderThickness="1">
                <StackPanel>
                    <TextBlock Text="ðŸ§¹ Mantenimiento" FontSize="14" FontWeight="Bold" Margin="4,0,0,10" Foreground="#38BDF8"/>
                    <Button x:Name="btnTemp" Content="Limpiar Temporales BÃ¡sicos" ToolTip="Elimina temporales del usuario. Algunos archivos pueden estar en uso y se omiten."/>
                    <Button x:Name="btnDeepClean" Content="ðŸ§¹ Limpieza Profunda / WinUpdate" ToolTip="Limpia temporales, cachÃ©s y Windows Update. Guarda antes los estados necesarios para revertir ajustes."/>
                    <Button x:Name="btnLogClean" Content="ðŸ—‘ï¸ Limpiar Logs y WinSxS" ToolTip="Depura logs y ejecuta DISM ResetBase. Parte de esta operaciÃ³n es irreversible."/>
                    <Button x:Name="btnFullRepair" Style="{StaticResource PrimaryButton}" Content="âš¡ ReparaciÃ³n 1-Clic" Margin="4,10,4,4" ToolTip="Combina varias operaciones de mantenimiento y reparaciÃ³n. Revisa el manual antes de usarla."/>
                </StackPanel>
            </Border>
        </Grid>

        <!-- Terminal de Logs -->
        <Border Grid.Row="2" Background="#181B21" CornerRadius="7" Padding="10" Margin="0,12,0,0" BorderBrush="#303846" BorderThickness="1">
            <StackPanel>
                <TextBlock Text="ðŸ“œ Registro de Actividad" FontSize="12" FontWeight="Bold" Foreground="#AEB7C4" Margin="0,0,0,5"/>
                <TextBox x:Name="txtLog" Height="130" Background="#0C0E12" Foreground="#63F28B"
                         BorderBrush="#2A303A" FontFamily="Consolas" FontSize="11" IsReadOnly="True"
                         TextWrapping="Wrap" VerticalScrollBarVisibility="Auto"/>
            </StackPanel>
        </Border>

        <!-- Barra de herramientas separada -->
        <Border Grid.Row="3" Background="#181B21" CornerRadius="7" Padding="7" Margin="0,12,0,0" BorderBrush="#303846" BorderThickness="1">
            <DockPanel>
                <StackPanel Orientation="Horizontal" DockPanel.Dock="Right">
                    <Button x:Name="btnManual" Style="{StaticResource ManualButton}" Content="ðŸ“– Manual detallado" Width="170"/>
                    <Button x:Name="btnRevert" Style="{StaticResource RevertButton}" Content="â†© Revertir cambios" Width="170" ToolTip="Restaura los cambios de configuraciÃ³n que OmegaSolver haya guardado como reversibles."/>
                </StackPanel>
                <TextBlock Text="Los cambios reversibles se guardan en el equipo para poder restaurarlos incluso despuÃ©s de cerrar la aplicaciÃ³n."
                           VerticalAlignment="Center" Foreground="#9CA3AF" TextWrapping="Wrap" Margin="8,0,10,0"/>
            </DockPanel>
        </Border>
    </Grid>
</Window>
"@

# Cargar la interfaz WPF
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

# Vincular controles XAML
$txtLog        = $window.FindName("txtLog")
$lblStatus     = $window.FindName("lblStatus")
$btnSfc        = $window.FindName("btnSfc")
$btnDism       = $window.FindName("btnDism")
$btnChkDsk     = $window.FindName("btnChkDsk")
$btnMaxPower   = $window.FindName("btnMaxPower")
$btnFlushDns   = $window.FindName("btnFlushDns")
$btnResetNet   = $window.FindName("btnResetNet")
$btnQoS        = $window.FindName("btnQoS")
$btnTemp       = $window.FindName("btnTemp")
$btnDeepClean  = $window.FindName("btnDeepClean")
$btnLogClean   = $window.FindName("btnLogClean")
$btnManual     = $window.FindName("btnManual")
$btnRevert     = $window.FindName("btnRevert")
$btnFullRepair = $window.FindName("btnFullRepair")
$cmbRepairDrive = $window.FindName("cmbRepairDrive")
$lblDiskInfo = $window.FindName("lblDiskInfo")
$btnRefreshDrives = $window.FindName("btnRefreshDrives")

# ------------------------------------------------------------------------------
# ESTADO PERSISTENTE DE CAMBIOS REVERSIBLES
# ------------------------------------------------------------------------------
$OmegaStateDir  = Join-Path $env:ProgramData "OmegaSolver"
$OmegaStatePath = Join-Path $OmegaStateDir "reversible-state.json"

if (-not (Test-Path $OmegaStateDir)) {
    New-Item -Path $OmegaStateDir -ItemType Directory -Force | Out-Null
}

function Get-DefaultOmegaState {
    return [ordered]@{
        Version = 1
        SavedAt = $null
        PowerPlan = [ordered]@{
            OriginalSchemeGuid = $null
            TargetSchemeGuid = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
        }
        FastStartup = [ordered]@{
            OriginalHibernationEnabled = $null
            OriginalHiberbootEnabled = $null
        }
        QoS = [ordered]@{
            RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched"
            OriginalValueExists = $false
            OriginalValue = $null
        }
        Services = [ordered]@{
            wuauserv = $null
            FontCache = $null
            UsoSvc = $null
        }
    }
}

function Save-OmegaState {
    param([object]$State)
    $State.SavedAt = (Get-Date).ToString("o")
    $State | ConvertTo-Json -Depth 8 | Set-Content -Path $OmegaStatePath -Encoding UTF8
}

function Load-OmegaState {
    try {
        if (Test-Path $OmegaStatePath) {
            $state = Get-Content -Path $OmegaStatePath -Raw -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
            if ($state.Version -eq 1) { return $state }
        }
    } catch {
        Write-OmegaLog "âš  No se pudo leer el estado guardado; se crearÃ¡ uno nuevo."
    }
    return (Get-DefaultOmegaState | ConvertTo-Json -Depth 8 | ConvertFrom-Json)
}

$OmegaState = Load-OmegaState

# ------------------------------------------------------------------------------
# FUNCIONES AUXILIARES
# ------------------------------------------------------------------------------
function Write-OmegaLog {
    param([string]$message)
    $timestamp = Get-Date -Format "HH:mm:ss"
    $txtLog.AppendText("[$timestamp] $message`n")
    $txtLog.ScrollToEnd()
}

function Set-OmegaStatus {
    param([string]$Text)
    $lblStatus.Text = "Estado: $Text"
}

function Get-OmegaRepairDrives {
    $results = @()
    try {
        $disks = Get-CimInstance Win32_LogicalDisk -ErrorAction Stop | Where-Object { $_.DriveType -in 2,3 } | Sort-Object DeviceID
        foreach ($disk in $disks) {
            $drive = $disk.DeviceID
            $root = "$drive\"
            $windowsPath = Join-Path $root "Windows\System32\config\SYSTEM"
            $hasWindows = Test-Path $windowsPath
            $isSystemDrive = ($drive -ieq $env:SystemDrive)
            $sizeGB = if ($disk.Size) { [math]::Round($disk.Size / 1GB, 1) } else { 0 }
            $freeGB = if ($disk.FreeSpace) { [math]::Round($disk.FreeSpace / 1GB, 1) } else { 0 }
            $label = if ([string]::IsNullOrWhiteSpace($disk.VolumeName)) { "Sin etiqueta" } else { $disk.VolumeName }
            $role = if ($isSystemDrive) { "Windows activo" } elseif ($hasWindows) { "Windows offline detectado" } else { "Datos / almacenamiento" }
            $display = "$drive â€” $role â€” $label ($freeGB / $sizeGB GB libres)"
            $results += [pscustomobject]@{
                Drive = $drive
                Root = $root
                HasWindows = $hasWindows
                IsSystemDrive = $isSystemDrive
                Display = $display
                VolumeName = $label
                SizeGB = $sizeGB
                FreeGB = $freeGB
            }
        }
    } catch {
        Write-OmegaLog "âš  No se pudieron detectar los discos automÃ¡ticamente: $($_.Exception.Message)"
    }
    return $results
}

function Get-SelectedOmegaDriveInfo {
    if (-not $cmbRepairDrive.SelectedItem) { return $null }
    $item = $cmbRepairDrive.SelectedItem
    return $item.Tag
}

function Update-OmegaRepairDriveState {
    $info = Get-SelectedOmegaDriveInfo
    if (-not $info) {
        $lblDiskInfo.Text = "No hay una unidad seleccionada. Pulsa 'â†» Actualizar' para detectar los volÃºmenes."
        $btnSfc.IsEnabled = $false
        $btnDism.IsEnabled = $false
        $btnChkDsk.IsEnabled = $false
        return
    }

    if ($info.IsSystemDrive) {
        $lblDiskInfo.Text = "$($info.Drive): es el Windows activo. SFC y DISM funcionarÃ¡n en modo Online; CHKDSK puede solicitar reinicio."
        $btnSfc.IsEnabled = $true
        $btnDism.IsEnabled = $true
    } elseif ($info.HasWindows) {
        $lblDiskInfo.Text = "$($info.Drive): contiene una instalaciÃ³n de Windows. SFC y DISM se ejecutarÃ¡n en modo Offline sobre esa instalaciÃ³n."
        $btnSfc.IsEnabled = $true
        $btnDism.IsEnabled = $true
    } else {
        $lblDiskInfo.Text = "$($info.Drive): no se detectÃ³ una instalaciÃ³n de Windows. SFC/DISM no aplican a un disco de datos; CHKDSK sÃ­ puede comprobarlo y repararlo."
        $btnSfc.IsEnabled = $false
        $btnDism.IsEnabled = $false
    }
    $btnChkDsk.IsEnabled = $true
}

function Refresh-OmegaRepairDrives {
    $cmbRepairDrive.Items.Clear()
    $driveInfos = @(Get-OmegaRepairDrives)
    foreach ($info in $driveInfos) {
        $item = New-Object System.Windows.Controls.ComboBoxItem
        $item.Content = $info.Display
        $item.Tag = $info
        $cmbRepairDrive.Items.Add($item) | Out-Null
    }

    if ($driveInfos.Count -eq 0) {
        $lblDiskInfo.Text = "No se detectaron unidades locales/removibles aptas para reparaciÃ³n."
        $btnSfc.IsEnabled = $false
        $btnDism.IsEnabled = $false
        $btnChkDsk.IsEnabled = $false
        return
    }

    $systemIndex = 0
    for ($i = 0; $i -lt $driveInfos.Count; $i++) {
        if ($driveInfos[$i].IsSystemDrive) { $systemIndex = $i; break }
    }
    $cmbRepairDrive.SelectedIndex = $systemIndex
    Update-OmegaRepairDriveState
    Write-OmegaLog "ðŸ”Ž Discos detectados para reparaciÃ³n: $($driveInfos.Count)."
}

function Start-OmegaSfcRepair {
    param([object]$DriveInfo)
    if (-not $DriveInfo) { return }
    if (-not $DriveInfo.HasWindows) {
        Write-OmegaLog "âš  SFC no estÃ¡ disponible en $($DriveInfo.Drive) porque no contiene una instalaciÃ³n de Windows detectada."
        return
    }

    if ($DriveInfo.IsSystemDrive) {
        Write-OmegaLog "ðŸ› ï¸ SFC: reparando la instalaciÃ³n de Windows activa en $($DriveInfo.Drive)..."
        Start-Process cmd.exe -ArgumentList @('/k', 'sfc /scannow') | Out-Null
    } else {
        $offBoot = "$($DriveInfo.Root)"
        $offWin = "$($DriveInfo.Root)Windows"
        $command = "sfc /scannow /offbootdir=$offBoot /offwindir=$offWin"
        Write-OmegaLog "ðŸ› ï¸ SFC: reparaciÃ³n offline de Windows en $($DriveInfo.Drive)..."
        Start-Process cmd.exe -ArgumentList @('/k', $command) | Out-Null
    }
}

function Start-OmegaDismRepair {
    param([object]$DriveInfo)
    if (-not $DriveInfo) { return }
    if (-not $DriveInfo.HasWindows) {
        Write-OmegaLog "âš  DISM no estÃ¡ disponible en $($DriveInfo.Drive) porque no contiene una instalaciÃ³n de Windows detectada."
        return
    }

    if ($DriveInfo.IsSystemDrive) {
        Write-OmegaLog "ðŸ› ï¸ DISM: reparando la imagen de Windows activa en $($DriveInfo.Drive)..."
        Start-Process cmd.exe -ArgumentList @('/k', 'DISM /Online /Cleanup-Image /RestoreHealth') | Out-Null
    } else {
        $command = "DISM /Image:$($DriveInfo.Root) /Cleanup-Image /RestoreHealth"
        Write-OmegaLog "ðŸ› ï¸ DISM: reparaciÃ³n offline de la imagen de Windows en $($DriveInfo.Drive)..."
        Start-Process cmd.exe -ArgumentList @('/k', $command) | Out-Null
    }
}

function Start-OmegaChkdskRepair {
    param([object]$DriveInfo)
    if (-not $DriveInfo) { return }
    $drive = $DriveInfo.Drive
    Write-OmegaLog "ðŸ’½ CHKDSK: comprobando y reparando $drive con /f..."
    Start-Process cmd.exe -ArgumentList @('/k', "chkdsk $drive /f") | Out-Null
}

function Get-ActivePowerSchemeGuid {
    try {
        $output = powercfg /getactivescheme 2>&1 | Out-String
        $match = [regex]::Match($output, '(?i)[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}')
        if ($match.Success) { return $match.Value.ToLowerInvariant() }
    } catch { }
    return $null
}

function Test-HibernationEnabled {
    try {
        $value = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -Name HibernateEnabled -ErrorAction Stop).HibernateEnabled
        return ([int]$value -eq 1)
    } catch {
        return $false
    }
}

function Get-HiberbootEnabled {
    try {
        return [int](Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name HiberbootEnabled -ErrorAction Stop).HiberbootEnabled
    } catch {
        return $null
    }
}

function Save-ReversibleStateBeforePowerPlanChange {
    # No sobrescribir una copia pendiente: asÃ­ el primer estado original sigue siendo recuperable.
    if ([string]::IsNullOrWhiteSpace([string]$OmegaState.PowerPlan.OriginalSchemeGuid)) {
        $current = Get-ActivePowerSchemeGuid
        if ($current) {
            $OmegaState.PowerPlan.OriginalSchemeGuid = $current
            Write-OmegaLog "â†³ Plan de energÃ­a original guardado: $current"
        } else {
            Write-OmegaLog "âš  No se pudo identificar el plan de energÃ­a actual."
        }
    } else {
        Write-OmegaLog "â†³ Se conserva el plan de energÃ­a original ya guardado para la reversiÃ³n."
    }
    $OmegaState.PowerPlan.TargetSchemeGuid = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
    Save-OmegaState $OmegaState
}

function Save-ReversibleStateBeforeDeepClean {
    # Guardar solo si no existe una reversiÃ³n pendiente.
    if ($null -eq $OmegaState.FastStartup.OriginalHibernationEnabled) {
        $OmegaState.FastStartup.OriginalHibernationEnabled = Test-HibernationEnabled
    }
    if ($null -eq $OmegaState.FastStartup.OriginalHiberbootEnabled) {
        $OmegaState.FastStartup.OriginalHiberbootEnabled = Get-HiberbootEnabled
    }

    foreach ($name in @('wuauserv','FontCache','UsoSvc')) {
        if ($null -eq $OmegaState.Services.$name) {
            try {
                $service = Get-Service -Name $name -ErrorAction Stop
                $OmegaState.Services.$name = $service.Status.ToString()
            } catch {
                $OmegaState.Services.$name = $null
            }
        }
    }

    Save-OmegaState $OmegaState
    Write-OmegaLog "â†³ Estado de hibernaciÃ³n/Inicio rÃ¡pido y servicios guardado para poder revertirlo."
}

function Save-ReversibleStateBeforeQoSChange {
    # Conservar el primer valor original hasta que el usuario lo revierta.
    if (-not [bool]$OmegaState.QoS.OriginalValueExists -and $null -eq $OmegaState.QoS.OriginalValue) {
        $regPath = $OmegaState.QoS.RegistryPath
        try {
            $property = Get-ItemProperty -Path $regPath -Name NonBestEffortLimit -ErrorAction Stop
            $OmegaState.QoS.OriginalValueExists = $true
            $OmegaState.QoS.OriginalValue = [int]$property.NonBestEffortLimit
        } catch {
            $OmegaState.QoS.OriginalValueExists = $false
            $OmegaState.QoS.OriginalValue = $null
        }
    } else {
        Write-OmegaLog "â†³ Se conserva el valor QoS original ya guardado para la reversiÃ³n."
    }
    Save-OmegaState $OmegaState
}

function Confirm-OmegaAction {
    param(
        [string]$Title,
        [string]$Message,
        [System.Windows.MessageBoxImage]$Image = [System.Windows.MessageBoxImage]::Warning
    )
    $result = [System.Windows.MessageBox]::Show(
        $Message,
        $Title,
        [System.Windows.MessageBoxButton]::YesNo,
        $Image
    )
    return ($result -eq [System.Windows.MessageBoxResult]::Yes)
}

# ------------------------------------------------------------------------------
# LIMPIEZA AVANZADA DE LOGS Y WINSXS
# ------------------------------------------------------------------------------
function Start-LogAndWinSxSCleanup {
    Write-OmegaLog "[+] Iniciando limpieza profunda de archivos LOG y almacÃ©n WinSxS..."

    Write-OmegaLog "[+] Vaciando registros de eventos de Windows (.evtx)..."
    $eventLogs = Get-WinEvent -ListLog * -ErrorAction SilentlyContinue
    foreach ($log in $eventLogs) {
        if ($log.RecordCount -gt 0) {
            try {
                [Diagnostics.Eventing.Reader.EventLogSession]::GlobalSession.ClearLog($log.LogName)
            } catch {
                # Omitir registros protegidos del sistema.
            }
        }
    }
    Write-OmegaLog "âœ… Registros de eventos de Windows depurados con Ã©xito."

    Write-OmegaLog "[+] Eliminando archivos LOG residuales..."
    Remove-Item -Path "$env:SystemRoot\Logs\*.log" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SystemRoot\Logs\CBS\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SystemRoot\Panther\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SystemRoot\SoftwareDistribution\DataStore\Logs\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-OmegaLog "âœ… Archivos LOG residuales procesados."

    Write-OmegaLog "[+] Ejecutando DISM /StartComponentCleanup /ResetBase..."
    $dism = Start-Process DISM.exe -ArgumentList "/Online /Cleanup-Image /StartComponentCleanup /ResetBase" -NoNewWindow -Wait -PassThru
    if ($dism.ExitCode -eq 0) {
        Write-OmegaLog "âœ… WinSxS limpiado correctamente."
    } else {
        Write-OmegaLog "âš  DISM finalizÃ³ con cÃ³digo $($dism.ExitCode)."
    }

    Write-OmegaLog "âš  Esta rutina contiene operaciones que no tienen deshacer general."
}

# ------------------------------------------------------------------------------
# LIMPIEZA PROFUNDA
# ------------------------------------------------------------------------------
function Start-DeepCleaningRoutine {
    Save-ReversibleStateBeforeDeepClean

    Write-OmegaLog "[+] Desactivando temporalmente la hibernaciÃ³n para liberar hiberfil.sys..."
    powercfg -h off | Out-Null

    Write-OmegaLog "[+] Deteniendo servicios temporales (Windows Update, FontCache, UsoSvc)..."
    Stop-Service -Name wuauserv, FontCache, UsoSvc -Force -ErrorAction SilentlyContinue

    Write-OmegaLog "[+] Vaciando descargas de Windows Update y cachÃ©s de sistema..."
    Remove-Item -Path "$env:SystemRoot\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SystemRoot\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SystemRoot\ServiceProfiles\LocalService\AppData\Local\FontCache\*" -Recurse -Force -ErrorAction SilentlyContinue

    Write-OmegaLog "[+] Limpiando cachÃ© de navegadores Chromium (Edge y Chrome)..."
    Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue

    Write-OmegaLog "[+] Eliminando temporales de usuario y del sistema..."
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SystemRoot\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

    Write-OmegaLog "[+] Eliminando residuos de instaladores (Config.Msi y drivers AMD)..."
    Remove-Item -Path "C:\Config.Msi" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\AMD" -Recurse -Force -ErrorAction SilentlyContinue

    Write-OmegaLog "[+] Vaciando Papelera de Reciclaje..."
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue

    Write-OmegaLog "[+] Restaurando servicios esenciales al estado que tenÃ­an antes de la limpieza..."
    Restore-OmegaServiceStates

    Write-OmegaLog "[+] Ejecutando Liberador de espacio nativo..."
    Start-Process cleanmgr.exe -ArgumentList "/sagerun:1" -NoNewWindow -Wait

    Write-OmegaLog "Â¡Limpieza profunda completada! Usa 'Revertir cambios' para restaurar la configuraciÃ³n reversible guardada."
}

function Restore-OmegaServiceStates {
    foreach ($name in @('wuauserv','FontCache','UsoSvc')) {
        $original = $OmegaState.Services.$name
        if (-not $original) { continue }
        try {
            if ($original -eq 'Running') {
                Start-Service -Name $name -ErrorAction SilentlyContinue
            } elseif ($original -eq 'Stopped') {
                Stop-Service -Name $name -Force -ErrorAction SilentlyContinue
            }
        } catch { }
    }
}

# ------------------------------------------------------------------------------
# MANUAL DETALLADO
# ------------------------------------------------------------------------------
$manualText = @"
OmegaSolver V3.6 â€” MANUAL DETALLADO

Â¿QUÃ‰ HACE ESTA APLICACIÃ“N?
OmegaSolver reÃºne herramientas de Windows para diagnÃ³stico, reparaciÃ³n, limpieza y algunos ajustes de configuraciÃ³n. No todas las operaciones son reversibles, por lo que el botÃ³n 'Revertir cambios' solo actÃºa sobre configuraciones cuyo estado anterior se haya podido guardar.

ðŸ› ï¸ SISTEMA Y RENDIMIENTO
â€¢ Selector de disco: antes de utilizar SFC, DISM o CHKDSK puedes elegir C:, D:, E: u otra unidad detectada. OmegaSolver muestra si una unidad es el Windows activo, contiene otra instalaciÃ³n de Windows o es un disco de datos.
â€¢ SFC /Scannow: comprueba archivos protegidos de Windows e intenta repararlos. En el Windows activo (normalmente C:) usa el modo Online. Si eliges D:, E: u otra unidad que contenga una instalaciÃ³n de Windows detectada, usa SFC en modo Offline sobre esa instalaciÃ³n. En discos que solo contienen datos, el botÃ³n se desactiva porque SFC no repara archivos de un volumen que no tiene Windows.
â€¢ DISM /RestoreHealth: repara componentes de una imagen de Windows. En C: usa DISM /Online. En otra unidad con Windows detectado usa DISM /Image:<unidad> para reparar esa instalaciÃ³n Offline. En un disco de datos el botÃ³n se desactiva porque DISM necesita una imagen de Windows.
â€¢ CHKDSK /f: comprueba y corrige errores del sistema de archivos del volumen seleccionado. Funciona tanto en C: como en D:, E: y otras unidades. Si el volumen estÃ¡ en uso, Windows puede ofrecer programar la reparaciÃ³n para el prÃ³ximo reinicio.
â€¢ Alto Rendimiento: guarda el plan de energÃ­a activo y activa el plan 'Alto rendimiento'. Esto cambia la polÃ­tica de energÃ­a, pero no garantiza que el procesador vaya siempre a su frecuencia mÃ¡xima.

ðŸ’½ Â¿CÃ“MO ELEGIR OTRO DISCO?
1) Abre 'Disco objetivo para reparaciones'.
2) Selecciona C:, D:, E: u otra unidad disponible.
3) Lee el texto informativo debajo del selector: allÃ­ se indica quÃ© reparaciones son compatibles con esa unidad.
4) Pulsa SFC, DISM o CHKDSK segÃºn lo que necesites. El botÃ³n 'â†» Actualizar' vuelve a detectar unidades si conectaste o desconectaste un disco.
5) Para un disco con solo archivos personales, CHKDSK es la reparaciÃ³n aplicable; SFC y DISM se desactivan intencionalmente.

ðŸŒ RED Y CONEXIÃ“N
â€¢ Limpiar CachÃ© DNS: vacÃ­a la cachÃ© DNS local. No borra la configuraciÃ³n de Internet y la cachÃ© se vuelve a llenar automÃ¡ticamente.
â€¢ Restablecer Winsock / IP: restablece componentes de red de Windows. Puede solucionar determinados problemas de conectividad, pero puede requerir reiniciar el PC. No existe un deshacer universal para todo el catÃ¡logo de red, por eso esta operaciÃ³n no se incluye en la reversiÃ³n automÃ¡tica.
â€¢ QoS a 0%: guarda el valor anterior de 'NonBestEffortLimit' en la directiva de QoS y lo cambia a 0. El botÃ³n 'Revertir cambios' puede restaurar el valor original o eliminar el valor si antes no existÃ­a.

ðŸ§¹ MANTENIMIENTO
â€¢ Temporales bÃ¡sicos: elimina archivos temporales del usuario. Los que estÃ©n en uso pueden quedar sin borrar.
â€¢ Limpieza Profunda / WinUpdate: limpia descargas de Windows Update, cachÃ©s, temporales, la Papelera y algunos residuos. Para liberar hiberfil.sys ejecuta 'powercfg -h off'. Antes de hacerlo, OmegaSolver guarda el estado de hibernaciÃ³n, Inicio rÃ¡pido y tres servicios para poder restaurarlos.
â€¢ Logs y WinSxS: limpia registros de eventos y archivos LOG, y ejecuta DISM con '/ResetBase'. Esta parte puede eliminar informaciÃ³n de diagnÃ³stico y hace que determinadas actualizaciones de componentes anteriores dejen de poder desinstalarse. No hay deshacer automÃ¡tico de esos archivos eliminados.
â€¢ ReparaciÃ³n 1-Clic: usa el disco seleccionado para SFC, DISM y CHKDSK, mientras que la limpieza DNS, temporales, Windows Update y WinSxS se aplica al Windows activo. Si el disco seleccionado contiene otra instalaciÃ³n de Windows, SFC y DISM se ejecutan Offline sobre ella. Debido a que incluye operaciones irreversibles en la limpieza de WinSxS, conviene usarla solo despuÃ©s de leer este manual.

â†© REVERTIR CAMBIOS
El botÃ³n intenta restaurar:
1) El plan de energÃ­a que estaba activo antes de aplicar 'Alto Rendimiento'.
2) El estado anterior de hibernaciÃ³n y de 'Inicio rÃ¡pido' cuando la Limpieza Profunda lo modificÃ³.
3) El valor anterior de la polÃ­tica QoS, incluyendo su ausencia si no existÃ­a.
4) El estado (Iniciado/Detenido) de Windows Update, FontCache y UsoSvc guardado antes de la Limpieza Profunda.

IMPORTANTE
â€¢ Revertir no recupera archivos temporales, cachÃ©s, logs, eventos ni componentes WinSxS que ya hayan sido eliminados.
â€¢ Si el usuario cambia manualmente la configuraciÃ³n despuÃ©s de usar OmegaSolver, la reversiÃ³n restaura lo que OmegaSolver guardÃ³ como estado anterior, no necesariamente la configuraciÃ³n que el usuario prefiera actualmente.
â€¢ Es recomendable cerrar juegos y programas importantes antes de ejecutar rutinas de limpieza.
"@

# ------------------------------------------------------------------------------
# INICIALIZACIÃ“N
# ------------------------------------------------------------------------------
Write-OmegaLog "OmegaSolver V3.6 iniciado correctamente."
Write-OmegaLog "Estado reversible guardado en: $OmegaStatePath"
Write-OmegaLog "Esperando acciÃ³n del usuario..."

# ------------------------------------------------------------------------------
# DETECCIÃ“N INICIAL DE DISCOS DE REPARACIÃ“N
# ------------------------------------------------------------------------------
Refresh-OmegaRepairDrives

# ------------------------------------------------------------------------------
# EVENTOS
# ------------------------------------------------------------------------------
$btnRefreshDrives.Add_Click({
    Refresh-OmegaRepairDrives
})

$cmbRepairDrive.Add_SelectionChanged({
    Update-OmegaRepairDriveState
})

$btnManual.Add_Click({
    $manualWindow = New-Object System.Windows.Window
    $manualWindow.Title = "Manual detallado - OmegaSolver V3.6"
    $manualWindow.Width = 820
    $manualWindow.Height = 680
    $manualWindow.WindowStartupLocation = "CenterOwner"
    $manualWindow.Owner = $window
    $manualWindow.Background = "#101216"

    $scroll = New-Object System.Windows.Controls.ScrollViewer
    $scroll.VerticalScrollBarVisibility = "Auto"
    $scroll.Margin = New-Object System.Windows.Thickness(14)

    $manualBox = New-Object System.Windows.Controls.TextBox
    $manualBox.Text = $manualText
    $manualBox.IsReadOnly = $true
    $manualBox.TextWrapping = "Wrap"
    $manualBox.AcceptsReturn = $true
    $manualBox.VerticalScrollBarVisibility = "Auto"
    $manualBox.Background = "#0C0E12"
    $manualBox.Foreground = "#F3F4F6"
    $manualBox.BorderBrush = "#374151"
    $manualBox.FontFamily = New-Object System.Windows.Media.FontFamily -ArgumentList "Segoe UI"
    $manualBox.FontSize = 13
    $manualBox.Padding = New-Object System.Windows.Thickness(14)

    $scroll.Content = $manualBox
    $manualWindow.Content = $scroll
    $manualWindow.ShowDialog() | Out-Null
})

$btnRevert.Add_Click({
    $hasPowerPlan = -not [string]::IsNullOrWhiteSpace([string]$OmegaState.PowerPlan.OriginalSchemeGuid)
    $hasFastStartup = $null -ne $OmegaState.FastStartup.OriginalHibernationEnabled -or $null -ne $OmegaState.FastStartup.OriginalHiberbootEnabled
    $hasQoS = [bool]$OmegaState.QoS.OriginalValueExists
    $hasServices = $false
    foreach ($name in @('wuauserv','FontCache','UsoSvc')) {
        if ($null -ne $OmegaState.Services.$name) { $hasServices = $true; break }
    }

    if (-not ($hasPowerPlan -or $hasFastStartup -or $hasQoS -or $hasServices)) {
        [System.Windows.MessageBox]::Show("No hay cambios reversibles guardados por OmegaSolver.", "Revertir cambios", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information) | Out-Null
        return
    }

    if (-not (Confirm-OmegaAction -Title "Revertir cambios" -Message "OmegaSolver restaurarÃ¡ Ãºnicamente los estados de configuraciÃ³n que guardÃ³ antes de modificarlos.`n`nNo se recuperarÃ¡n temporales, logs, eventos ni archivos eliminados.`n`nÂ¿Continuar?")) {
        return
    }

    Set-OmegaStatus "Revirtiendo cambios..."
    Write-OmegaLog "â†© Iniciando reversiÃ³n de cambios guardados..."

    # Restaurar plan de energÃ­a.
    if ($hasPowerPlan) {
        try {
            powercfg -setactive $OmegaState.PowerPlan.OriginalSchemeGuid | Out-Null
            Write-OmegaLog "âœ… Plan de energÃ­a restaurado: $($OmegaState.PowerPlan.OriginalSchemeGuid)"
            $OmegaState.PowerPlan.OriginalSchemeGuid = $null
        } catch {
            Write-OmegaLog "âš  No se pudo restaurar el plan de energÃ­a."
        }
    }

    # Restaurar hibernaciÃ³n / Inicio rÃ¡pido.
    if ($hasFastStartup) {
        try {
            if ($null -ne $OmegaState.FastStartup.OriginalHibernationEnabled) {
                if ([bool]$OmegaState.FastStartup.OriginalHibernationEnabled) {
                    powercfg -h on | Out-Null
                    Write-OmegaLog "âœ… HibernaciÃ³n restaurada a ACTIVADA."
                } else {
                    powercfg -h off | Out-Null
                    Write-OmegaLog "âœ… HibernaciÃ³n restaurada a DESACTIVADA."
                }
            }
            if ($null -ne $OmegaState.FastStartup.OriginalHiberbootEnabled) {
                $hiberbootPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
                Set-ItemProperty -Path $hiberbootPath -Name HiberbootEnabled -Value ([int]$OmegaState.FastStartup.OriginalHiberbootEnabled) -Type DWord
                Write-OmegaLog "âœ… Estado de Inicio rÃ¡pido restaurado."
            }
            $OmegaState.FastStartup.OriginalHibernationEnabled = $null
            $OmegaState.FastStartup.OriginalHiberbootEnabled = $null
        } catch {
            Write-OmegaLog "âš  No se pudo restaurar por completo hibernaciÃ³n/Inicio rÃ¡pido."
        }
    }

    # Restaurar QoS.
    if ($hasQoS) {
        try {
            $regPath = $OmegaState.QoS.RegistryPath
            if ($OmegaState.QoS.OriginalValueExists) {
                if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
                Set-ItemProperty -Path $regPath -Name NonBestEffortLimit -Value ([int]$OmegaState.QoS.OriginalValue) -Type DWord
                Write-OmegaLog "âœ… Valor QoS restaurado a $($OmegaState.QoS.OriginalValue)."
            } else {
                Remove-ItemProperty -Path $regPath -Name NonBestEffortLimit -ErrorAction SilentlyContinue
                Write-OmegaLog "âœ… Valor QoS restaurado a 'sin definir'."
            }
            $OmegaState.QoS.OriginalValueExists = $false
            $OmegaState.QoS.OriginalValue = $null
        } catch {
            Write-OmegaLog "âš  No se pudo restaurar la configuraciÃ³n QoS."
        }
    }

    # Restaurar estados de servicios.
    if ($hasServices) {
        Restore-OmegaServiceStates
        Write-OmegaLog "âœ… Estados guardados de Windows Update / FontCache / UsoSvc restaurados."
        foreach ($name in @('wuauserv','FontCache','UsoSvc')) {
            $OmegaState.Services.$name = $null
        }
    }

    Save-OmegaState $OmegaState
    Set-OmegaStatus "Listo"
    Write-OmegaLog "â†© ReversiÃ³n finalizada."
})

$btnSfc.Add_Click({
    $driveInfo = Get-SelectedOmegaDriveInfo
    if (-not $driveInfo) {
        [System.Windows.MessageBox]::Show("Selecciona primero un disco de reparaciÃ³n.", "SFC", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information) | Out-Null
        return
    }
    if (-not (Confirm-OmegaAction -Title "ReparaciÃ³n SFC" -Message "SFC se ejecutarÃ¡ sobre $($driveInfo.Drive).`n`n$($lblDiskInfo.Text)`n`nÂ¿Continuar?" -Image ([System.Windows.MessageBoxImage]::Information))) { return }
    Set-OmegaStatus "Ejecutando SFC en $($driveInfo.Drive)..."
    Start-OmegaSfcRepair $driveInfo
})

$btnDism.Add_Click({
    $driveInfo = Get-SelectedOmegaDriveInfo
    if (-not $driveInfo) {
        [System.Windows.MessageBox]::Show("Selecciona primero un disco de reparaciÃ³n.", "DISM", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information) | Out-Null
        return
    }
    if (-not (Confirm-OmegaAction -Title "ReparaciÃ³n DISM" -Message "DISM se ejecutarÃ¡ sobre $($driveInfo.Drive).`n`n$($lblDiskInfo.Text)`n`nÂ¿Continuar?" -Image ([System.Windows.MessageBoxImage]::Information))) { return }
    Set-OmegaStatus "Ejecutando DISM en $($driveInfo.Drive)..."
    Start-OmegaDismRepair $driveInfo
})

$btnChkDsk.Add_Click({
    $driveInfo = Get-SelectedOmegaDriveInfo
    if (-not $driveInfo) {
        [System.Windows.MessageBox]::Show("Selecciona primero un disco de reparaciÃ³n.", "CHKDSK", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information) | Out-Null
        return
    }
    if (-not (Confirm-OmegaAction -Title "Reparar disco" -Message "CHKDSK se ejecutarÃ¡ con /f sobre $($driveInfo.Drive).`n`nEsto corrige errores del sistema de archivos y puede requerir reinicio si el volumen estÃ¡ en uso.`n`nÂ¿Continuar?")) { return }
    Set-OmegaStatus "Ejecutando CHKDSK en $($driveInfo.Drive)..."
    Start-OmegaChkdskRepair $driveInfo
})

$btnMaxPower.Add_Click({
    Save-ReversibleStateBeforePowerPlanChange
    Write-OmegaLog "Configurando plan de energÃ­a a Alto rendimiento..."
    try {
        powercfg -setactive $OmegaState.PowerPlan.TargetSchemeGuid | Out-Null
        Write-OmegaLog "âœ… Plan de Alto rendimiento activado. El plan anterior puede restaurarse con 'Revertir cambios'."
    } catch {
        Write-OmegaLog "âš  No se pudo activar el plan de Alto rendimiento."
    }
})

$btnFlushDns.Add_Click({
    Write-OmegaLog "Vaciando cachÃ© DNS..."
    ipconfig /flushdns | Out-Null
    Write-OmegaLog "CachÃ© DNS limpiada con Ã©xito."
})

$btnResetNet.Add_Click({
    if (-not (Confirm-OmegaAction -Title "Restablecer red" -Message "Esta operaciÃ³n restablecerÃ¡ el catÃ¡logo Winsock.`n`nNo existe un deshacer general para este cambio y puede ser necesario reiniciar Windows.`n`nÂ¿Continuar?")) { return }
    Write-OmegaLog "Restableciendo sockets de red (Winsock)..."
    netsh winsock reset | Out-Null
    Write-OmegaLog "Red restablecida. Se recomienda reiniciar el equipo."
})

$btnQoS.Add_Click({
    Save-ReversibleStateBeforeQoSChange
    Write-OmegaLog "Configurando lÃ­mite de ancho de banda reservable QoS a 0%..."
    try {
        $regPath = $OmegaState.QoS.RegistryPath
        if (-not (Test-Path $regPath)) {
            New-Item -Path $regPath -Force | Out-Null
        }
        Set-ItemProperty -Path $regPath -Name "NonBestEffortLimit" -Value 0 -Type DWord
        Write-OmegaLog "âœ… QoS establecido en 0%. El valor anterior puede restaurarse con 'Revertir cambios'."
    } catch {
        Write-OmegaLog "âš  No se pudo modificar la configuraciÃ³n QoS."
    }
})

$btnTemp.Add_Click({
    Write-OmegaLog "Limpiando archivos temporales bÃ¡sicos..."
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-OmegaLog "Archivos temporales procesados."
})

$btnDeepClean.Add_Click({
    if (-not (Confirm-OmegaAction -Title "Limpieza Profunda" -Message "Esta rutina elimina temporales y cachÃ©s, vacÃ­a la Papelera y desactiva temporalmente la hibernaciÃ³n para liberar hiberfil.sys.`n`nOmegaSolver guardarÃ¡ los estados reversibles antes de comenzar.`n`nÂ¿Continuar?")) { return }
    Write-OmegaLog "Iniciando secuencia de Limpieza Profunda..."
    Set-OmegaStatus "Ejecutando Limpieza Profunda..."
    Start-DeepCleaningRoutine
    Set-OmegaStatus "Listo"
})

$btnLogClean.Add_Click({
    if (-not (Confirm-OmegaAction -Title "Logs y WinSxS" -Message "Esta operaciÃ³n elimina registros de eventos y ejecuta DISM con /ResetBase.`n`nParte de los cambios NO es reversible y algunos componentes/actualizaciones anteriores pueden dejar de poder recuperarse.`n`nÂ¿Continuar?")) { return }
    Write-OmegaLog "Iniciando Limpieza Avanzada de Logs y WinSxS..."
    Set-OmegaStatus "Limpiando Logs y WinSxS..."
    Start-LogAndWinSxSCleanup
    Set-OmegaStatus "Listo"
})

$btnFullRepair.Add_Click({
    $driveInfo = Get-SelectedOmegaDriveInfo
    if (-not $driveInfo) {
        [System.Windows.MessageBox]::Show("Selecciona primero un disco de reparaciÃ³n.", "ReparaciÃ³n 1-Clic", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information) | Out-Null
        return
    }
    $message = "ReparaciÃ³n 1-Clic usarÃ¡ $($driveInfo.Drive) como disco objetivo para SFC/DISM/CHKDSK.`n`nLa limpieza DNS, temporales, Windows Update, logs y WinSxS seguirÃ¡ aplicÃ¡ndose al Windows activo (normalmente C:).`n`nIncluye DISM /ResetBase en la limpieza WinSxS, que no tiene un deshacer general.`n`nÂ¿Continuar?"
    if (-not (Confirm-OmegaAction -Title "ReparaciÃ³n 1-Clic" -Message $message)) { return }

    Write-OmegaLog "âš¡ Iniciando rutina de ReparaciÃ³n 1-Clic para $($driveInfo.Drive)..."
    Set-OmegaStatus "ReparaciÃ³n 1-Clic en progreso..."

    ipconfig /flushdns | Out-Null
    Write-OmegaLog "1/5: CachÃ© DNS vaciada en el Windows activo."

    Start-DeepCleaningRoutine
    Write-OmegaLog "2/5: Limpieza profunda finalizada en el Windows activo."

    Start-LogAndWinSxSCleanup
    Write-OmegaLog "3/5: Limpieza de Logs y WinSxS finalizada en el Windows activo."

    Write-OmegaLog "4/6: Lanzando reparaciÃ³n SFC en $($driveInfo.Drive)..."
    Start-OmegaSfcRepair $driveInfo

    Write-OmegaLog "5/6: Lanzando reparaciÃ³n DISM en $($driveInfo.Drive)..."
    Start-OmegaDismRepair $driveInfo

    Write-OmegaLog "6/6: Lanzando reparaciÃ³n CHKDSK en $($driveInfo.Drive)..."
    Start-OmegaChkdskRepair $driveInfo
    Set-OmegaStatus "Listo"
})

# Lanzar ventana
$window.ShowDialog() | Out-Null

