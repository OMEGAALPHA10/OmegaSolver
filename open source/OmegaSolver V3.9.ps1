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
# PROYECTO: OmegaSolver V3.9
# ARCHIVO: OmegaSolver V3.9.ps1
# DESCRIPCIÓN: Mantenimiento de Windows con Modo Básico/Avanzado y 7 temas.
# ===============================================================================

# ---------- 1. ELEVACIÓN A ADMINISTRADOR -------------------------------------
function Test-OmegaAdministrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
if (-not (Test-OmegaAdministrator)) {
    try {
        $scriptPath = $MyInvocation.MyCommand.Path
        if (-not $scriptPath) {
            [System.Windows.MessageBox]::Show("Guarda el script como .ps1 y ejecútalo de nuevo.", "OmegaSolver V3.9") | Out-Null
            exit 1
        }
        $hostExe = $null
        try { $hostExe = (Get-Process -Id $PID -ErrorAction Stop).Path } catch { }
        if ([string]::IsNullOrWhiteSpace($hostExe) -or -not (Test-Path $hostExe)) {
            $hostExe = Join-Path $PSHOME 'powershell.exe'
            if (-not (Test-Path $hostExe)) { $hostExe = 'powershell.exe' }
        }
        Start-Process $hostExe -Verb RunAs -ArgumentList @('-NoProfile','-ExecutionPolicy','Bypass','-File',"`"$scriptPath`"") | Out-Null
        exit 0
    } catch {
        Add-Type -AssemblyName PresentationFramework
        [System.Windows.MessageBox]::Show("OmegaSolver necesita permisos de administrador.", "OmegaSolver V3.9",'OK','Warning') | Out-Null
        exit 1
    }
}

# ---------- 2. CARGAR WPF ----------------------------------------------------
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

# ---------- 3. XAML ----------------------------------------------------------
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="OmegaSolver V3.9" Height="720" Width="1000"
        MinHeight="620" MinWidth="900"
        WindowStartupLocation="CenterScreen"
        Background="#101216" Foreground="#FFFFFF">
    <Window.Resources>
        <SolidColorBrush x:Key="ThemeWindowBackground" Color="#101216"/>
        <SolidColorBrush x:Key="ThemePanelBackground" Color="#171B22"/>
        <SolidColorBrush x:Key="ThemeCardBackground" Color="#1B1F27"/>
        <SolidColorBrush x:Key="ThemeInputBackground" Color="#0C0E12"/>
        <SolidColorBrush x:Key="ThemeMainText" Color="#FFFFFF"/>
        <SolidColorBrush x:Key="ThemeSecondaryText" Color="#E5E7EB"/>
        <SolidColorBrush x:Key="ThemeMutedText" Color="#AEB7C4"/>
        <SolidColorBrush x:Key="ThemeLabelText" Color="#93A4B8"/>
        <SolidColorBrush x:Key="ThemeAccent" Color="#38BDF8"/>
        <SolidColorBrush x:Key="ThemeAccentAlt" Color="#2EA3F2"/>
        <SolidColorBrush x:Key="ThemeBorder" Color="#303846"/>
        <SolidColorBrush x:Key="ThemeBorderStrong" Color="#4B5563"/>
        <SolidColorBrush x:Key="ThemeButtonBackground" Color="#242831"/>
        <SolidColorBrush x:Key="ThemeButtonHover" Color="#1E293B"/>
        <SolidColorBrush x:Key="ThemeButtonPressed" Color="#111827"/>
        <SolidColorBrush x:Key="ThemeBorderHover" Color="#94A3B8"/>
        <SolidColorBrush x:Key="ThemeBorderPressed" Color="#CBD5E1"/>
        <SolidColorBrush x:Key="ThemePrimaryBackground" Color="#0067A3"/>
        <SolidColorBrush x:Key="ThemePrimaryHover" Color="#004D7A"/>
        <SolidColorBrush x:Key="ThemePrimaryPressed" Color="#003855"/>
        <SolidColorBrush x:Key="ThemeRevertBackground" Color="#7A2E2E"/>
        <SolidColorBrush x:Key="ThemeRevertBorder" Color="#F87171"/>
        <SolidColorBrush x:Key="ThemeRevertHover" Color="#5B1E1E"/>
        <SolidColorBrush x:Key="ThemeRevertPressed" Color="#3F1515"/>
        <SolidColorBrush x:Key="ThemeManualBackground" Color="#374151"/>
        <SolidColorBrush x:Key="ThemeManualHover" Color="#4B5563"/>
        <SolidColorBrush x:Key="ThemeManualPressed" Color="#1F2937"/>
        <SolidColorBrush x:Key="ThemeLogForeground" Color="#63F28B"/>

        <Style TargetType="Button">
            <Setter Property="Background" Value="{DynamicResource ThemeButtonBackground}"/>
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Setter Property="BorderBrush" Value="{DynamicResource ThemeBorderStrong}"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Padding" Value="8,6"/>
            <Setter Property="Margin" Value="3"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="ButtonBorder" Background="{TemplateBinding Background}"
                                BorderBrush="{TemplateBinding BorderBrush}"
                                BorderThickness="{TemplateBinding BorderThickness}"
                                CornerRadius="5" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="ButtonBorder" Property="Background" Value="{DynamicResource ThemeButtonHover}"/>
                                <Setter TargetName="ButtonBorder" Property="BorderBrush" Value="{DynamicResource ThemeBorderHover}"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="ButtonBorder" Property="Background" Value="{DynamicResource ThemeButtonPressed}"/>
                                <Setter TargetName="ButtonBorder" Property="BorderBrush" Value="{DynamicResource ThemeBorderPressed}"/>
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
            <Setter Property="Background" Value="{DynamicResource ThemePrimaryBackground}"/>
            <Setter Property="BorderBrush" Value="{DynamicResource ThemeAccentAlt}"/>
            <Setter Property="FontWeight" Value="Bold"/>
        </Style>

        <Style x:Key="RevertButton" TargetType="Button" BasedOn="{StaticResource {x:Type Button}}">
            <Setter Property="Background" Value="{DynamicResource ThemeRevertBackground}"/>
            <Setter Property="BorderBrush" Value="{DynamicResource ThemeRevertBorder}"/>
            <Setter Property="FontWeight" Value="Bold"/>
        </Style>

        <Style x:Key="ManualButton" TargetType="Button" BasedOn="{StaticResource {x:Type Button}}">
            <Setter Property="Background" Value="{DynamicResource ThemeManualBackground}"/>
            <Setter Property="FontWeight" Value="Bold"/>
        </Style>
    </Window.Resources>

    <Grid Margin="10">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <!-- HEADER -->
        <Grid Grid.Row="0" Margin="0,0,0,8">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="Auto"/>
            </Grid.ColumnDefinitions>
            <StackPanel Grid.Column="0">
                <TextBlock Text="OmegaSolver V3.9" FontSize="20" FontWeight="Bold" Foreground="{DynamicResource ThemeAccent}"/>
                <TextBlock x:Name="lblStatus" Text="Estado: Iniciando..." FontSize="11"
                           Foreground="{DynamicResource ThemeSecondaryText}" Margin="0,2,0,0"/>
            </StackPanel>
            <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Top">
                <TextBlock Text="Tema:" Foreground="{DynamicResource ThemeMutedText}" VerticalAlignment="Center" Margin="0,0,6,0" FontSize="11"/>
                <ComboBox x:Name="cmbTheme" Width="130" Height="28" Margin="0,0,10,0" FontSize="12"/>
                <CheckBox x:Name="chkAdvanced" Content="Modo Avanzado" Foreground="{DynamicResource ThemeSecondaryText}"
                          VerticalAlignment="Center" FontSize="11"/>
            </StackPanel>
        </Grid>

        <!-- INFO BAR -->
        <Border Grid.Row="1" Background="{DynamicResource ThemePanelBackground}"
                BorderBrush="{DynamicResource ThemeBorder}" BorderThickness="1"
                CornerRadius="6" Padding="8" Margin="0,0,0,8">
            <Grid>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="1.35*"/>
                    <ColumnDefinition Width="1.15*"/>
                    <ColumnDefinition Width="1.15*"/>
                    <ColumnDefinition Width="1.8*"/>
                </Grid.ColumnDefinitions>
                <StackPanel Grid.Column="0" Margin="2,0,8,0">
                    <TextBlock Text="EQUIPO" FontSize="9" Foreground="{DynamicResource ThemeLabelText}"/>
                    <TextBlock x:Name="lblPCName" Text="Detectando..." FontSize="12" FontWeight="Bold"
                               Foreground="{DynamicResource ThemeMainText}" TextTrimming="CharacterEllipsis"/>
                </StackPanel>
                <StackPanel Grid.Column="1" Margin="2,0,8,0">
                    <TextBlock Text="WINDOWS" FontSize="9" Foreground="{DynamicResource ThemeLabelText}"/>
                    <TextBlock x:Name="lblWindowsInfo" Text="Detectando..." FontSize="11"
                               Foreground="{DynamicResource ThemeSecondaryText}" TextTrimming="CharacterEllipsis"/>
                </StackPanel>
                <StackPanel Grid.Column="2" Margin="2,0,8,0">
                    <TextBlock Text="POWERSHELL" FontSize="9" Foreground="{DynamicResource ThemeLabelText}"/>
                    <TextBlock x:Name="lblPowerShellInfo" Text="Detectando..." FontSize="11"
                               Foreground="{DynamicResource ThemeSecondaryText}" TextTrimming="CharacterEllipsis"/>
                </StackPanel>
                <StackPanel Grid.Column="3" Margin="2,0,2,0">
                    <TextBlock Text="COMPONENTES" FontSize="9" Foreground="{DynamicResource ThemeLabelText}"/>
                    <TextBlock x:Name="lblComponentsInfo" Text="Comprobando..." FontSize="10"
                               Foreground="{DynamicResource ThemeSecondaryText}" TextWrapping="Wrap"/>
                </StackPanel>
            </Grid>
        </Border>

        <!-- STATS PANEL (solo visible en Modo Avanzado) -->
        <Border x:Name="statsPanel" Grid.Row="2" Background="{DynamicResource ThemePanelBackground}"
                CornerRadius="7" Padding="10" Margin="0,0,0,8"
                BorderBrush="{DynamicResource ThemeBorder}" BorderThickness="1" Visibility="Collapsed">
            <Grid>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="1.4*"/>
                    <ColumnDefinition Width="2*"/>
                </Grid.ColumnDefinitions>
                <StackPanel Grid.Column="0" Margin="2,0,14,0" VerticalAlignment="Center">
                    <TextBlock Text="🔍 Diagnóstico detallado" FontSize="12" FontWeight="Bold" Foreground="{DynamicResource ThemeAccent}"/>
                    <TextBlock Text="Nivel de temporales y cachés" FontSize="10" Foreground="{DynamicResource ThemeMutedText}" Margin="0,2,0,4"/>
                    <ProgressBar x:Name="pbJunkLevel" Height="14" Minimum="0" Maximum="100" Value="0"
                                 Background="{DynamicResource ThemeInputBackground}"
                                 Foreground="{DynamicResource ThemeAccent}"
                                 BorderBrush="{DynamicResource ThemeBorderStrong}"/>
                    <TextBlock x:Name="lblJunkPercent" Text="Analizando..." FontSize="11" FontWeight="Bold"
                               Foreground="{DynamicResource ThemeMainText}" Margin="0,4,0,0"/>
                </StackPanel>
                <StackPanel Grid.Column="1" Margin="2,0,2,0" VerticalAlignment="Center">
                    <TextBlock Text="RESUMEN" FontSize="9" Foreground="{DynamicResource ThemeLabelText}"/>
                    <TextBlock x:Name="lblJunkDetails" Text="Preparando análisis..." FontSize="11"
                               Foreground="{DynamicResource ThemeSecondaryText}" TextWrapping="Wrap" Margin="0,3,0,0"/>
                </StackPanel>
            </Grid>
        </Border>

        <!-- TARJETAS PRINCIPALES (siempre visibles) -->
        <Grid Grid.Row="3">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>

            <!-- Card 1: Sistema -->
            <Border Grid.Column="0" Background="{DynamicResource ThemeCardBackground}" CornerRadius="7" Padding="8"
                    Margin="0,0,5,0" BorderBrush="{DynamicResource ThemeBorder}" BorderThickness="1">
                <ScrollViewer VerticalScrollBarVisibility="Auto">
                    <StackPanel>
                        <TextBlock Text="🛠️ Sistema y Rendimiento" FontSize="12" FontWeight="Bold" Margin="3,0,0,6"
                                   Foreground="{DynamicResource ThemeAccent}"/>
                        <Border Background="{DynamicResource ThemeInputBackground}" BorderBrush="{DynamicResource ThemeBorder}"
                                BorderThickness="1" CornerRadius="5" Padding="5" Margin="3,0,3,6">
                            <StackPanel>
                                <TextBlock Text="🎯 Disco objetivo:" FontSize="10"
                                           Foreground="{DynamicResource ThemeLabelText}" Margin="0,0,0,3"/>
                                <ComboBox x:Name="cmbRepairDrive" Height="26" Margin="0,0,0,5" FontSize="11"/>
                                <Button x:Name="btnRefreshDrives" Content="↻ Actualizar discos"
                                        Style="{StaticResource PrimaryButton}" Margin="0" FontSize="11"/>
                            </StackPanel>
                        </Border>
                        <TextBlock x:Name="lblDiskInfo" Text="Detectando discos..." FontSize="10"
                                   Foreground="{DynamicResource ThemeMutedText}" TextWrapping="Wrap" Margin="3,0,3,6"/>
                        <Button x:Name="btnSfc" Content="Ejecutar SFC /Scannow"/>
                        <Button x:Name="btnDism" Content="Reparar Imagen DISM"/>
                        <Button x:Name="btnChkDsk" Content="Reparar Disco (CHKDSK /f)"/>
                        <Button x:Name="btnMaxPower" Content="⚡ Activar Alto Rendimiento"/>
                    </StackPanel>
                </ScrollViewer>
            </Border>

            <!-- Card 2: Red -->
            <Border Grid.Column="1" Background="{DynamicResource ThemeCardBackground}" CornerRadius="7" Padding="8"
                    Margin="5,0,5,0" BorderBrush="{DynamicResource ThemeBorder}" BorderThickness="1">
                <StackPanel>
                    <TextBlock Text="🌐 Red y Conexión" FontSize="12" FontWeight="Bold" Margin="3,0,0,8"
                               Foreground="{DynamicResource ThemeAccent}"/>
                    <Button x:Name="btnFlushDns" Content="Limpiar Caché DNS"/>
                    <Button x:Name="btnResetNet" Content="Restablecer Winsock / IP"/>
                    <Button x:Name="btnQoS" Content="🚀 Configurar QoS a 0%"/>
                </StackPanel>
            </Border>

            <!-- Card 3: Mantenimiento -->
            <Border Grid.Column="2" Background="{DynamicResource ThemeCardBackground}" CornerRadius="7" Padding="8"
                    Margin="5,0,0,0" BorderBrush="{DynamicResource ThemeBorder}" BorderThickness="1">
                <StackPanel>
                    <TextBlock Text="🧹 Mantenimiento" FontSize="12" FontWeight="Bold" Margin="3,0,0,8"
                               Foreground="{DynamicResource ThemeAccent}"/>
                    <Button x:Name="btnTemp" Content="Limpiar Temporales Básicos"/>
                    <Button x:Name="btnDeepClean" Content="🧹 Limpieza Profunda / WinUpdate"/>
                    <Button x:Name="btnLogClean" Content="🗑️ Limpiar Logs y WinSxS"/>
                    <Button x:Name="btnFullRepair" Style="{StaticResource PrimaryButton}"
                            Content="⚡ Reparación 1-Clic" Margin="3,8,3,3"/>
                </StackPanel>
            </Border>
        </Grid>

        <!-- RECOMENDACIONES (más grande y legible) -->
        <Border Grid.Row="4" Background="{DynamicResource ThemePanelBackground}" CornerRadius="7" Padding="10"
                Margin="0,8,0,0" BorderBrush="{DynamicResource ThemeBorder}" BorderThickness="1">
            <StackPanel>
                <TextBlock Text="💡 Recomendaciones personalizadas" FontSize="12" FontWeight="Bold"
                           Foreground="{DynamicResource ThemeAccent}" Margin="0,0,0,5"/>
                <TextBox x:Name="txtRecommendations" Text="Analizando el estado del equipo..."
                         Height="110" Background="{DynamicResource ThemeInputBackground}"
                         Foreground="{DynamicResource ThemeMainText}"
                         BorderBrush="{DynamicResource ThemeBorder}"
                         IsReadOnly="True" TextWrapping="Wrap"
                         VerticalScrollBarVisibility="Auto" FontSize="12" Padding="8"
                         FontFamily="Segoe UI"/>
            </StackPanel>
        </Border>

        <!-- LOG (solo visible en Modo Avanzado) -->
        <Border x:Name="logPanel" Grid.Row="5" Background="{DynamicResource ThemePanelBackground}"
                CornerRadius="7" Padding="8" Margin="0,8,0,0"
                BorderBrush="{DynamicResource ThemeBorder}" BorderThickness="1" Visibility="Collapsed">
            <StackPanel>
                <TextBlock Text="📜 Registro de Actividad" FontSize="11" FontWeight="Bold"
                           Foreground="{DynamicResource ThemeMutedText}" Margin="0,0,0,4"/>
                <TextBox x:Name="txtLog" Height="90" Background="{DynamicResource ThemeInputBackground}"
                         Foreground="{DynamicResource ThemeLogForeground}"
                         BorderBrush="{DynamicResource ThemeBorder}"
                         FontFamily="Consolas" FontSize="10" IsReadOnly="True"
                         TextWrapping="Wrap" VerticalScrollBarVisibility="Auto"/>
            </StackPanel>
        </Border>

        <!-- BOTTOM TOOLBAR -->
        <Border Grid.Row="6" Background="{DynamicResource ThemePanelBackground}" CornerRadius="7"
                Padding="6" Margin="0,8,0,0" BorderBrush="{DynamicResource ThemeBorder}" BorderThickness="1">
            <DockPanel>
                <StackPanel Orientation="Horizontal" DockPanel.Dock="Right">
                    <Button x:Name="btnDiagnose" Content="🔍 Analizar PC" Width="140" Style="{StaticResource ManualButton}"/>
                    <Button x:Name="btnManual" Content="📖 Manual detallado" Width="160" Style="{StaticResource ManualButton}"/>
                    <Button x:Name="btnRevert" Content="↩ Revertir cambios" Width="160" Style="{StaticResource RevertButton}"/>
                </StackPanel>
                <TextBlock Text="Los cambios reversibles se guardan en el equipo."
                           VerticalAlignment="Center" Foreground="{DynamicResource ThemeMutedText}"
                           TextWrapping="Wrap" Margin="8,0,10,0" FontSize="11"/>
            </DockPanel>
        </Border>
    </Grid>
</Window>
"@

# ---------- 4. CARGAR XAML ---------------------------------------------------
$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

# ---------- 5. VINCULAR CONTROLES --------------------------------------------
$global:txtLog             = $window.FindName("txtLog")
$global:lblStatus          = $window.FindName("lblStatus")
$global:lblPCName          = $window.FindName("lblPCName")
$global:lblWindowsInfo     = $window.FindName("lblWindowsInfo")
$global:lblPowerShellInfo  = $window.FindName("lblPowerShellInfo")
$global:lblComponentsInfo  = $window.FindName("lblComponentsInfo")
$global:btnSfc             = $window.FindName("btnSfc")
$global:btnDism            = $window.FindName("btnDism")
$global:btnChkDsk          = $window.FindName("btnChkDsk")
$global:btnMaxPower        = $window.FindName("btnMaxPower")
$global:btnFlushDns        = $window.FindName("btnFlushDns")
$global:btnResetNet        = $window.FindName("btnResetNet")
$global:btnQoS             = $window.FindName("btnQoS")
$global:btnTemp            = $window.FindName("btnTemp")
$global:btnDeepClean       = $window.FindName("btnDeepClean")
$global:btnLogClean        = $window.FindName("btnLogClean")
$global:btnManual          = $window.FindName("btnManual")
$global:btnRevert          = $window.FindName("btnRevert")
$global:btnFullRepair      = $window.FindName("btnFullRepair")
$global:cmbRepairDrive     = $window.FindName("cmbRepairDrive")
$global:lblDiskInfo        = $window.FindName("lblDiskInfo")
$global:btnRefreshDrives   = $window.FindName("btnRefreshDrives")
$global:pbJunkLevel        = $window.FindName("pbJunkLevel")
$global:lblJunkPercent     = $window.FindName("lblJunkPercent")
$global:lblJunkDetails     = $window.FindName("lblJunkDetails")
$global:txtRecommendations = $window.FindName("txtRecommendations")
$global:btnDiagnose        = $window.FindName("btnDiagnose")
$global:cmbTheme           = $window.FindName("cmbTheme")
$global:chkAdvanced        = $window.FindName("chkAdvanced")
$global:statsPanel         = $window.FindName("statsPanel")
$global:logPanel           = $window.FindName("logPanel")

# ---------- 6. FUNCIONES AUXILIARES ------------------------------------------
function Write-OmegaLog {
    param([string]$message)
    try {
        if ($null -eq $global:txtLog) { return }
        $timestamp = Get-Date -Format "HH:mm:ss"
        $global:txtLog.AppendText("[$timestamp] $message`n")
        $global:txtLog.ScrollToEnd()
    } catch { }
}

function Set-OmegaStatus {
    param([string]$Text)
    try { if ($global:lblStatus) { $global:lblStatus.Text = "Estado: $Text" } } catch { }
}

function Get-OmegaSystemProfile {
    $sysProfile = [ordered]@{
        ComputerName = if ([string]::IsNullOrWhiteSpace($env:COMPUTERNAME)) { 'Equipo local' } else { $env:COMPUTERNAME }
        PowerShellVersion = if ($PSVersionTable.PSVersion) { $PSVersionTable.PSVersion.ToString() } else { 'Desconocida' }
        PowerShellEdition = if ($PSVersionTable.PSEdition) { $PSVersionTable.PSEdition } else { 'Desktop' }
        Architecture = if ([Environment]::Is64BitOperatingSystem) { '64 bits' } else { '32 bits' }
        WindowsName = 'Windows'; WindowsVersion = ''; WindowsBuild = ''; WindowsDisplayVersion = ''
        Components = [ordered]@{}
    }
    try {
        $os = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
        $sysProfile.WindowsName = [string]$os.Caption
        $sysProfile.WindowsBuild = [string]$os.BuildNumber
    } catch { }
    try {
        $cv = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -ErrorAction Stop
        if ($cv.ProductName) { $sysProfile.WindowsName = [string]$cv.ProductName }
        if ($cv.DisplayVersion) { $sysProfile.WindowsDisplayVersion = [string]$cv.DisplayVersion }
        elseif ($cv.ReleaseId) { $sysProfile.WindowsDisplayVersion = [string]$cv.ReleaseId }
        if ($cv.CurrentBuildNumber) { $sysProfile.WindowsBuild = [string]$cv.CurrentBuildNumber }
        if ($null -ne $cv.UBR) { $sysProfile.WindowsVersion = "$($sysProfile.WindowsBuild).$($cv.UBR)" }
    } catch { }
    if ($sysProfile.WindowsBuild -match '^\d+$') {
        if ([int]$sysProfile.WindowsBuild -ge 22000) { $sysProfile.WindowsName = 'Windows 11' }
        elseif ($sysProfile.WindowsName -match 'Windows 10|Windows 11') { $sysProfile.WindowsName = 'Windows 10' }
    }
    $commands = [ordered]@{ 'SFC'='sfc.exe'; 'DISM'='dism.exe'; 'CHKDSK'='chkdsk.exe'; 'PowerCfg'='powercfg.exe'; 'Netsh'='netsh.exe'; 'IPConfig'='ipconfig.exe'; 'CleanMgr'='cleanmgr.exe' }
    foreach ($key in $commands.Keys) { $sysProfile.Components[$key] = [bool](Get-Command $commands[$key] -ErrorAction SilentlyContinue) }
    $sysProfile.Components['WPF'] = $true
    return [pscustomobject]$sysProfile
}

function Initialize-OmegaSystemProfile {
    param([object]$SysProfile)
    try { $global:lblPCName.Text = "🔹 $($SysProfile.ComputerName)" } catch { }
    $edition = if ($SysProfile.PowerShellEdition -eq 'Core') { 'Core' } else { 'Desktop' }
    try { $global:lblPowerShellInfo.Text = "$($SysProfile.PowerShellVersion) ($edition)" } catch { }
    $winVersion = if ($SysProfile.WindowsDisplayVersion) { $SysProfile.WindowsDisplayVersion } elseif ($SysProfile.WindowsVersion) { $SysProfile.WindowsVersion } else { 'versión desconocida' }
    $buildText = if ($SysProfile.WindowsBuild) { "Build $($SysProfile.WindowsBuild)" } else { '' }
    try { $global:lblWindowsInfo.Text = "$($SysProfile.WindowsName) $winVersion $buildText".Trim() } catch { }
    $available = @($SysProfile.Components.GetEnumerator() | Where-Object { $_.Value } | ForEach-Object { $_.Key })
    $missing = @($SysProfile.Components.GetEnumerator() | Where-Object { -not $_.Value } | ForEach-Object { $_.Key })
    try {
        if ($missing.Count -eq 0) {
            $global:lblComponentsInfo.Text = "✅ Listo · $($available -join ', ')"
            $global:lblComponentsInfo.Foreground = [System.Windows.Media.Brushes]::LightGreen
        } else {
            $global:lblComponentsInfo.Text = "⚠ Faltan: $($missing -join ', ')"
            $global:lblComponentsInfo.Foreground = [System.Windows.Media.Brushes]::Khaki
        }
    } catch { }
    Write-OmegaLog "💻 Equipo: $($SysProfile.ComputerName) · $($SysProfile.WindowsName) · PS $($SysProfile.PowerShellVersion)."
}

function Get-OmegaFolderSizeBytes {
    param([string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path) -or -not (Test-Path -LiteralPath $Path)) { return [int64]0 }
    [int64]$sum = 0
    try {
        foreach ($file in [System.IO.Directory]::EnumerateFiles($Path, '*', [System.IO.SearchOption]::AllDirectories)) {
            try { $sum += [int64](Get-Item -LiteralPath $file -Force -ErrorAction Stop).Length } catch { }
        }
    } catch { }
    return $sum
}

function Get-OmegaSmartDiagnostics {
    $paths = [ordered]@{
        'Temporales de usuario' = $env:TEMP
        'Temporales de Windows' = Join-Path $env:SystemRoot 'Temp'
        'Descargas Windows Update' = Join-Path $env:SystemRoot 'SoftwareDistribution\Download'
        'Cache Delivery Optimization' = Join-Path $env:SystemRoot 'ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache'
        'Cache Edge' = Join-Path $env:LOCALAPPDATA 'Microsoft\Edge\User Data\Default\Cache'
        'Cache Chrome' = Join-Path $env:LOCALAPPDATA 'Google\Chrome\User Data\Default\Cache'
    }
    [int64]$junkBytes = 0
    foreach ($entry in $paths.GetEnumerator()) { $junkBytes += Get-OmegaFolderSizeBytes -Path $entry.Value }
    $systemDisk = $null
    try { $systemDisk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='$($env:SystemDrive)'" -ErrorAction Stop } catch { }
    $totalBytes = if ($systemDisk -and $systemDisk.Size) { [int64]$systemDisk.Size } else { [int64]0 }
    $freeBytes  = if ($systemDisk -and $systemDisk.FreeSpace) { [int64]$systemDisk.FreeSpace } else { [int64]0 }
    $freePct = if ($totalBytes -gt 0) { [math]::Round(($freeBytes / $totalBytes) * 100, 1) } else { $null }
    $junkLevel = [math]::Min(100, [math]::Round(($junkBytes / 5GB) * 100, 0))
    $junkGB = [math]::Round($junkBytes / 1GB, 2)
    $batteryState = 'Desktop/CA'
    try {
        $battery = @(Get-CimInstance Win32_Battery -ErrorAction Stop)
        if ($battery.Count -gt 0) {
            $discharging = $battery | Where-Object { $_.BatteryStatus -eq 1 }
            $batteryState = if ($discharging) { 'En batería' } else { 'Con corriente' }
        }
    } catch { }
    $recommendations = New-Object System.Collections.Generic.List[string]
    if ($freePct -ne $null -and $freePct -lt 15) { [void]$recommendations.Add('⚠ Espacio libre bajo en el disco del sistema. Prioriza liberar espacio.') }
    elseif ($freePct -ne $null -and $freePct -lt 25) { [void]$recommendations.Add('ℹ El espacio libre está algo reducido; una limpieza puede ayudar.') }
    if ($junkGB -ge 1) { [void]$recommendations.Add("🧹 Se detectan ~$junkGB GB en temporales/cachés. La limpieza básica puede ser apropiada.") }
    else { [void]$recommendations.Add('✅ Poco contenido temporal; no es urgente limpiar.') }
    if ($junkGB -ge 3) { [void]$recommendations.Add('🧼 La Limpieza Profunda puede recuperar más espacio.') }
    if ($batteryState -eq 'En batería') { [void]$recommendations.Add('🔋 Con batería: Alto Rendimiento es opcional y aumenta consumo.') }
    else { [void]$recommendations.Add('⚡ Alto Rendimiento disponible para priorizar velocidad.') }
    [pscustomobject]@{
        JunkBytes = $junkBytes; JunkGB = $junkGB; JunkLevel = $junkLevel
        FreePct = $freePct
        FreeGB  = if ($freeBytes) { [math]::Round($freeBytes / 1GB, 1) } else { $null }
        TotalGB = if ($totalBytes) { [math]::Round($totalBytes / 1GB, 1) } else { $null }
        BatteryState = $batteryState
        Recommendations = @($recommendations)
    }
}

function Set-OmegaProgressAppearance {
    param([double]$Value)
    try {
        if ($Value -ge 70) {
            $global:pbJunkLevel.Foreground = [System.Windows.Media.Brushes]::IndianRed
            $global:lblJunkPercent.Foreground = [System.Windows.Media.Brushes]::LightCoral
        } elseif ($Value -ge 35) {
            $global:pbJunkLevel.Foreground = [System.Windows.Media.Brushes]::Khaki
            $global:lblJunkPercent.Foreground = [System.Windows.Media.Brushes]::Khaki
        } else {
            $global:pbJunkLevel.Foreground = [System.Windows.Media.Brushes]::LightGreen
            $global:lblJunkPercent.Foreground = [System.Windows.Media.Brushes]::LightGreen
        }
    } catch { }
}

function Start-OmegaDiagnostics {
    try {
        $global:txtRecommendations.Text = 'Analizando el estado del equipo...'
        $global:pbJunkLevel.Value = 0
        $global:lblJunkPercent.Text = 'Analizando...'
        $global:lblJunkDetails.Text = 'Calculando tamaño aproximado...'

        $diag = Get-OmegaSmartDiagnostics
        $global:pbJunkLevel.Value = [double]$diag.JunkLevel
        Set-OmegaProgressAppearance -Value $diag.JunkLevel
        $freeText = if ($null -ne $diag.FreePct) { "$($diag.FreePct)% libres ($($diag.FreeGB)/$($diag.TotalGB) GB)" } else { 'no disponible' }
        $global:lblJunkPercent.Text = "$($diag.JunkLevel)% · nivel orientativo"
        $global:lblJunkDetails.Text = "Temporales/cachés: $($diag.JunkGB) GB.`nDisco: $freeText.`nEnergía: $($diag.BatteryState)."
        $global:txtRecommendations.Text = ($diag.Recommendations -join "`n")
        Write-OmegaLog "🔍 Diagnóstico: $($diag.JunkGB) GB · $($diag.JunkLevel)% · $freeText."
    } catch {
        $global:pbJunkLevel.Value = 0
        $global:lblJunkPercent.Text = 'Diagnóstico no disponible'
        $global:lblJunkDetails.Text = $_.Exception.Message
        $global:txtRecommendations.Text = 'No se pudo completar el análisis. Las funciones siguen disponibles.'
        Write-OmegaLog "⚠ Diagnóstico no completado: $($_.Exception.Message)"
    }
}

function Get-OmegaRepairDrives {
    $results = @()
    try {
        $disks = Get-CimInstance Win32_LogicalDisk -ErrorAction Stop | Where-Object { $_.DriveType -in 2,3 } | Sort-Object DeviceID
        foreach ($disk in $disks) {
            $drive = $disk.DeviceID
            $root = "$drive\"
            $hasWindows = Test-Path (Join-Path $root "Windows\System32\config\SYSTEM")
            $isSystemDrive = ($drive -ieq $env:SystemDrive)
            $sizeGB = if ($disk.Size) { [math]::Round($disk.Size / 1GB, 1) } else { 0 }
            $freeGB = if ($disk.FreeSpace) { [math]::Round($disk.FreeSpace / 1GB, 1) } else { 0 }
            $label = if ([string]::IsNullOrWhiteSpace($disk.VolumeName)) { "Sin etiqueta" } else { $disk.VolumeName }
            $role = if ($isSystemDrive) { "Windows activo" } elseif ($hasWindows) { "Windows offline" } else { "Datos" }
            $results += [pscustomobject]@{
                Drive=$drive; Root=$root; HasWindows=$hasWindows; IsSystemDrive=$isSystemDrive
                Display="$drive — $role — $label ($freeGB/$sizeGB GB)"
                VolumeName=$label; SizeGB=$sizeGB; FreeGB=$freeGB
            }
        }
    } catch { Write-OmegaLog "⚠ No se detectaron discos: $($_.Exception.Message)" }
    return $results
}

function Get-SelectedOmegaDriveInfo {
    if (-not $global:cmbRepairDrive.SelectedItem) { return $null }
    return $global:cmbRepairDrive.SelectedItem.Tag
}

function Update-OmegaRepairDriveState {
    try {
        $info = Get-SelectedOmegaDriveInfo
        if (-not $info) {
            $global:lblDiskInfo.Text = "No hay unidad seleccionada."
            $global:btnSfc.IsEnabled = $false; $global:btnDism.IsEnabled = $false; $global:btnChkDsk.IsEnabled = $false
            return
        }
        if ($info.IsSystemDrive) {
            $global:lblDiskInfo.Text = "$($info.Drive): Windows activo. SFC/DISM en modo Online."
            $global:btnSfc.IsEnabled  = [bool]$script:OmegaSystemProfile.Components['SFC']
            $global:btnDism.IsEnabled = [bool]$script:OmegaSystemProfile.Components['DISM']
        } elseif ($info.HasWindows) {
            $global:lblDiskInfo.Text = "$($info.Drive): Windows offline. SFC/DISM en modo Offline."
            $global:btnSfc.IsEnabled  = [bool]$script:OmegaSystemProfile.Components['SFC']
            $global:btnDism.IsEnabled = [bool]$script:OmegaSystemProfile.Components['DISM']
        } else {
            $global:lblDiskInfo.Text = "$($info.Drive): datos. Solo CHKDSK aplica."
            $global:btnSfc.IsEnabled = $false; $global:btnDism.IsEnabled = $false
        }
        $global:btnChkDsk.IsEnabled = [bool]$script:OmegaSystemProfile.Components['CHKDSK']
    } catch { }
}

function Refresh-OmegaRepairDrives {
    try {
        $global:cmbRepairDrive.Items.Clear()
        $driveInfos = @(Get-OmegaRepairDrives)
        foreach ($info in $driveInfos) {
            $item = New-Object System.Windows.Controls.ComboBoxItem
            $item.Content = $info.Display
            $item.Tag = $info
            [void]$global:cmbRepairDrive.Items.Add($item)
        }
        if ($driveInfos.Count -eq 0) { $global:lblDiskInfo.Text = "No se detectaron unidades."; return }
        $systemIndex = 0
        for ($i = 0; $i -lt $driveInfos.Count; $i++) { if ($driveInfos[$i].IsSystemDrive) { $systemIndex = $i; break } }
        $global:cmbRepairDrive.SelectedIndex = $systemIndex
        Update-OmegaRepairDriveState
        Write-OmegaLog "🔎 Discos detectados: $($driveInfos.Count)."
    } catch { Write-OmegaLog "⚠ Error detectando discos: $($_.Exception.Message)" }
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
    } catch { return $false }
}

function Get-HiberbootEnabled {
    try { return [int](Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name HiberbootEnabled -ErrorAction Stop).HiberbootEnabled }
    catch { return $null }
}

function Confirm-OmegaAction {
    param([string]$Title, [string]$Message, $Image = 'Warning')
    try {
        $result = [System.Windows.MessageBox]::Show($Message, $Title, 'YesNo', $Image)
        return ($result -eq [System.Windows.MessageBoxResult]::Yes)
    } catch { return $false }
}

function Save-OmegaState {
    param([object]$State)
    try {
        $State.SavedAt = (Get-Date).ToString("o")
        $State | ConvertTo-Json -Depth 8 | Set-Content -Path $script:OmegaStatePath -Encoding UTF8
    } catch { }
}

function Save-ReversibleStateBeforePowerPlanChange {
    if ([string]::IsNullOrWhiteSpace([string]$script:OmegaState.PowerPlan.OriginalSchemeGuid)) {
        $current = Get-ActivePowerSchemeGuid
        if ($current) { $script:OmegaState.PowerPlan.OriginalSchemeGuid = $current; Write-OmegaLog "↳ Plan original guardado." }
    }
    $script:OmegaState.PowerPlan.TargetSchemeGuid = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
    Save-OmegaState $script:OmegaState
}

function Save-ReversibleStateBeforeDeepClean {
    if ($null -eq $script:OmegaState.FastStartup.OriginalHibernationEnabled) { $script:OmegaState.FastStartup.OriginalHibernationEnabled = Test-HibernationEnabled }
    if ($null -eq $script:OmegaState.FastStartup.OriginalHiberbootEnabled) { $script:OmegaState.FastStartup.OriginalHiberbootEnabled = Get-HiberbootEnabled }
    foreach ($name in @('wuauserv','FontCache','UsoSvc')) {
        if ($null -eq $script:OmegaState.Services.$name) {
            try { $script:OmegaState.Services.$name = (Get-Service -Name $name -ErrorAction Stop).Status.ToString() }
            catch { $script:OmegaState.Services.$name = $null }
        }
    }
    Save-OmegaState $script:OmegaState
    Write-OmegaLog "↳ Estado reversible guardado."
}

function Save-ReversibleStateBeforeQoSChange {
    if (-not [bool]$script:OmegaState.QoS.OriginalValueExists) {
        try {
            $property = Get-ItemProperty -Path $script:OmegaState.QoS.RegistryPath -Name NonBestEffortLimit -ErrorAction Stop
            $script:OmegaState.QoS.OriginalValueExists = $true
            $script:OmegaState.QoS.OriginalValue = [int]$property.NonBestEffortLimit
        } catch {
            $script:OmegaState.QoS.OriginalValueExists = $false
            $script:OmegaState.QoS.OriginalValue = $null
        }
    }
    Save-OmegaState $script:OmegaState
}

function Restore-OmegaServiceStates {
    foreach ($name in @('wuauserv','FontCache','UsoSvc')) {
        $original = $script:OmegaState.Services.$name
        if (-not $original) { continue }
        try {
            if ($original -eq 'Running') { Start-Service -Name $name -ErrorAction SilentlyContinue }
            elseif ($original -eq 'Stopped') { Stop-Service -Name $name -Force -ErrorAction SilentlyContinue }
        } catch { }
    }
}

function Start-OmegaSfcRepair {
    param([object]$DriveInfo)
    if (-not $DriveInfo -or -not $DriveInfo.HasWindows) { Write-OmegaLog "⚠ SFC no aplica a $($DriveInfo.Drive)."; return }
    if ($DriveInfo.IsSystemDrive) {
        Write-OmegaLog "🛠️ SFC: reparando Windows activo..."
        Start-Process cmd.exe -ArgumentList @('/k','sfc /scannow') | Out-Null
    } else {
        Write-OmegaLog "🛠️ SFC: reparando Windows offline en $($DriveInfo.Drive)..."
        Start-Process cmd.exe -ArgumentList @('/k', "sfc /scannow /offbootdir=$($DriveInfo.Root) /offwindir=$($DriveInfo.Root)Windows") | Out-Null
    }
}

function Start-OmegaDismRepair {
    param([object]$DriveInfo)
    if (-not $DriveInfo -or -not $DriveInfo.HasWindows) { Write-OmegaLog "⚠ DISM no aplica a $($DriveInfo.Drive)."; return }
    if ($DriveInfo.IsSystemDrive) {
        Write-OmegaLog "🛠️ DISM: reparando imagen activa..."
        Start-Process cmd.exe -ArgumentList @('/k','DISM /Online /Cleanup-Image /RestoreHealth') | Out-Null
    } else {
        Write-OmegaLog "🛠️ DISM: reparando imagen offline en $($DriveInfo.Drive)..."
        Start-Process cmd.exe -ArgumentList @('/k', "DISM /Image:$($DriveInfo.Root) /Cleanup-Image /RestoreHealth") | Out-Null
    }
}

function Start-OmegaChkdskRepair {
    param([object]$DriveInfo)
    if (-not $DriveInfo) { return }
    Write-OmegaLog "💽 CHKDSK: comprobando $($DriveInfo.Drive) con /f..."
    Start-Process cmd.exe -ArgumentList @('/k', "chkdsk $($DriveInfo.Drive) /f") | Out-Null
}

function Start-LogAndWinSxSCleanup {
    Write-OmegaLog "[+] Limpieza de Logs y WinSxS..."
    try {
        $eventLogs = Get-WinEvent -ListLog * -ErrorAction SilentlyContinue
        foreach ($log in $eventLogs) {
            if ($log.RecordCount -gt 0) {
                try { [Diagnostics.Eventing.Reader.EventLogSession]::GlobalSession.ClearLog($log.LogName) } catch { }
            }
        }
    } catch { }
    Remove-Item -Path "$env:SystemRoot\Logs\*.log" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SystemRoot\Logs\CBS\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SystemRoot\Panther\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SystemRoot\SoftwareDistribution\DataStore\Logs\*" -Recurse -Force -ErrorAction SilentlyContinue
    $dism = Start-Process DISM.exe -ArgumentList "/Online /Cleanup-Image /StartComponentCleanup /ResetBase" -NoNewWindow -Wait -PassThru
    if ($dism.ExitCode -eq 0) { Write-OmegaLog "✅ WinSxS limpiado." } else { Write-OmegaLog "⚠ DISM terminó con código $($dism.ExitCode)." }
}

function Start-DeepCleaningRoutine {
    Save-ReversibleStateBeforeDeepClean
    Write-OmegaLog "[+] Desactivando hibernación..."
    powercfg -h off | Out-Null
    Write-OmegaLog "[+] Deteniendo servicios..."
    Stop-Service -Name wuauserv, FontCache, UsoSvc -Force -ErrorAction SilentlyContinue
    Write-OmegaLog "[+] Limpiando cachés y temporales..."
    Remove-Item -Path "$env:SystemRoot\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SystemRoot\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SystemRoot\ServiceProfiles\LocalService\AppData\Local\FontCache\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SystemRoot\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Config.Msi" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\AMD" -Recurse -Force -ErrorAction SilentlyContinue
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    Restore-OmegaServiceStates
    if ($script:OmegaSystemProfile.Components['CleanMgr']) { Start-Process cleanmgr.exe -ArgumentList "/sagerun:1" -NoNewWindow -Wait }
    Write-OmegaLog "✅ Limpieza profunda completada."
}

# ---------- 7. TEMAS ---------------------------------------------------------
function Set-OmegaThemeResources {
    param($Palette)
    if ($null -eq $Palette -or $null -eq $window.Resources) { return }
    $map = @{
        ThemeWindowBackground='WindowBg'; ThemePanelBackground='PanelBg'; ThemeCardBackground='CardBg'
        ThemeInputBackground='InputBg'; ThemeMainText='MainText'; ThemeSecondaryText='SecondaryText'
        ThemeMutedText='MutedText'; ThemeLabelText='LabelText'; ThemeAccent='Accent'
        ThemeAccentAlt='AccentAlt'; ThemeBorder='Border'; ThemeBorderStrong='BorderStrong'
        ThemeButtonBackground='ButtonBg'; ThemeButtonHover='ButtonHover'; ThemeButtonPressed='ButtonPressed'
        ThemeBorderHover='BorderHover'; ThemeBorderPressed='BorderPressed'
        ThemePrimaryBackground='PrimaryBg'; ThemePrimaryHover='PrimaryHover'; ThemePrimaryPressed='PrimaryPressed'
        ThemeRevertBackground='RevertBg'; ThemeRevertBorder='RevertBorder'
        ThemeRevertHover='RevertHover'; ThemeRevertPressed='RevertPressed'
        ThemeManualBackground='ManualBg'; ThemeManualHover='ManualHover'; ThemeManualPressed='ManualPressed'
        ThemeLogForeground='Log'
    }
    $brushConverter = New-Object System.Windows.Media.BrushConverter
    foreach ($resKey in $map.Keys) {
        $palKey = $map[$resKey]
        $hex = $null
        try { $hex = $Palette[$palKey] } catch { }
        if ([string]::IsNullOrWhiteSpace([string]$hex)) { continue }
        $hexStr = [string]$hex
        if (-not $hexStr.StartsWith("#")) { $hexStr = "#$hexStr" }
        try {
            $brush = $brushConverter.ConvertFromString($hexStr)
            if ($null -ne $brush) { $window.Resources[$resKey] = $brush }
        } catch { }
    }
}

function Get-OmegaThemeName {
    try {
        if (Test-Path $script:OmegaThemePath) {
            $saved = (Get-Content -Path $script:OmegaThemePath -Raw -ErrorAction Stop).Trim()
            if ($script:OmegaThemes.ContainsKey($saved)) { return $saved }
        }
    } catch { }
    return "Oscuro"
}

function Save-OmegaThemeName {
    param([string]$Name)
    try { Set-Content -Path $script:OmegaThemePath -Value $Name -Encoding UTF8 -Force } catch { }
}

# ---------- 8. RUTAS Y ESTADO ------------------------------------------------
$script:OmegaStateDir = Join-Path $env:ProgramData "OmegaSolver"
$script:OmegaStatePath = Join-Path $script:OmegaStateDir "reversible-state.json"
$script:OmegaThemePath = Join-Path $script:OmegaStateDir "theme.txt"
if (-not (Test-Path $script:OmegaStateDir)) { New-Item -Path $script:OmegaStateDir -ItemType Directory -Force | Out-Null }

$script:OmegaThemes = @{
    "Oscuro" = @{
        WindowBg="#101216"; PanelBg="#171B22"; CardBg="#1B1F27"; InputBg="#0C0E12"
        MainText="#FFFFFF"; SecondaryText="#E5E7EB"; MutedText="#AEB7C4"; LabelText="#93A4B8"
        Accent="#38BDF8"; AccentAlt="#2EA3F2"; Border="#303846"; BorderStrong="#4B5563"
        ButtonBg="#242831"; ButtonHover="#1E293B"; ButtonPressed="#111827"
        BorderHover="#94A3B8"; BorderPressed="#CBD5E1"
        PrimaryBg="#0067A3"; PrimaryHover="#004D7A"; PrimaryPressed="#003855"
        RevertBg="#7A2E2E"; RevertBorder="#F87171"; RevertHover="#5B1E1E"; RevertPressed="#3F1515"
        ManualBg="#374151"; ManualHover="#4B5563"; ManualPressed="#1F2937"; Log="#63F28B"
    }
    "Claro" = @{
        WindowBg="#F4F7FB"; PanelBg="#FFFFFF"; CardBg="#EEF3F8"; InputBg="#FFFFFF"
        MainText="#111827"; SecondaryText="#1F2937"; MutedText="#4B5563"; LabelText="#64748B"
        Accent="#0067A3"; AccentAlt="#0284C7"; Border="#CBD5E1"; BorderStrong="#94A3B8"
        ButtonBg="#E2E8F0"; ButtonHover="#CBD5E1"; ButtonPressed="#94A3B8"
        BorderHover="#475569"; BorderPressed="#334155"
        PrimaryBg="#0067A3"; PrimaryHover="#004D7A"; PrimaryPressed="#003855"
        RevertBg="#B91C1C"; RevertBorder="#EF4444"; RevertHover="#991B1B"; RevertPressed="#7F1D1D"
        ManualBg="#475569"; ManualHover="#334155"; ManualPressed="#1E293B"; Log="#166534"
    }
    "GitHub" = @{
        WindowBg="#0D1117"; PanelBg="#161B22"; CardBg="#21262D"; InputBg="#0D1117"
        MainText="#F0F6FC"; SecondaryText="#C9D1D9"; MutedText="#8B949E"; LabelText="#8B949E"
        Accent="#2F81F7"; AccentAlt="#58A6FF"; Border="#30363D"; BorderStrong="#484F58"
        ButtonBg="#21262D"; ButtonHover="#30363D"; ButtonPressed="#484F58"
        BorderHover="#8B949E"; BorderPressed="#B1BAC4"
        PrimaryBg="#238636"; PrimaryHover="#2EA043"; PrimaryPressed="#196C2E"
        RevertBg="#DA3633"; RevertBorder="#FF7B72"; RevertHover="#B62324"; RevertPressed="#8E1519"
        ManualBg="#30363D"; ManualHover="#484F58"; ManualPressed="#21262D"; Log="#3FB950"
    }
    "Retro" = @{
        WindowBg="#0B0F0C"; PanelBg="#111A12"; CardBg="#172217"; InputBg="#050805"
        MainText="#E6FFE8"; SecondaryText="#B8E6BD"; MutedText="#78A97D"; LabelText="#6FBE78"
        Accent="#7CFF6B"; AccentAlt="#A4FF8F"; Border="#315C35"; BorderStrong="#4E8F54"
        ButtonBg="#17331A"; ButtonHover="#215126"; ButtonPressed="#0E2411"
        BorderHover="#7CFF6B"; BorderPressed="#B6FFAA"
        PrimaryBg="#216E2A"; PrimaryHover="#2E8B39"; PrimaryPressed="#164B1C"
        RevertBg="#7A2929"; RevertBorder="#FF7A7A"; RevertHover="#5A1E1E"; RevertPressed="#3D1414"
        ManualBg="#25442A"; ManualHover="#33613A"; ManualPressed="#17331A"; Log="#7CFF6B"
    }
    # ---- TEMA TWITTER / X ----
    "Twitter X" = @{
        WindowBg="#000000"; PanelBg="#16181C"; CardBg="#1C1F23"; InputBg="#000000"
        MainText="#E7E9EA"; SecondaryText="#D6D9DB"; MutedText="#71767B"; LabelText="#71767B"
        Accent="#1D9BF0"; AccentAlt="#4A99E9"; Border="#2F3336"; BorderStrong="#536471"
        ButtonBg="#1E2024"; ButtonHover="#272C30"; ButtonPressed="#16181C"
        BorderHover="#536471"; BorderPressed="#8899A6"
        PrimaryBg="#1D9BF0"; PrimaryHover="#1A8CD8"; PrimaryPressed="#0F6EAC"
        RevertBg="#67070F"; RevertBorder="#F4212E"; RevertHover="#4D050B"; RevertPressed="#360306"
        ManualBg="#2F3336"; ManualHover="#3E4144"; ManualPressed="#202327"; Log="#00BA7C"
    }
    # ---- TEMA DISCORD ----
    "Discord" = @{
        WindowBg="#1E1F22"; PanelBg="#2B2D31"; CardBg="#313338"; InputBg="#1E1F22"
        MainText="#F2F3F5"; SecondaryText="#DBDEE1"; MutedText="#949BA4"; LabelText="#B5BAC1"
        Accent="#5865F2"; AccentAlt="#7289DA"; Border="#3F4147"; BorderStrong="#4E5058"
        ButtonBg="#2B2D31"; ButtonHover="#383A40"; ButtonPressed="#1E1F22"
        BorderHover="#5865F2"; BorderPressed="#7289DA"
        PrimaryBg="#5865F2"; PrimaryHover="#4752C4"; PrimaryPressed="#3C45A5"
        RevertBg="#DA373C"; RevertBorder="#ED4245"; RevertHover="#A12D29"; RevertPressed="#7F1D1D"
        ManualBg="#4E5058"; ManualHover="#5D6068"; ManualPressed="#3F4147"; Log="#57F287"
    }
    # ---- TEMA WHATSAPP ----
    "WhatsApp" = @{
        WindowBg="#0B141A"; PanelBg="#111B21"; CardBg="#1F2C33"; InputBg="#2A3942"
        MainText="#E9EDEF"; SecondaryText="#D1D7DB"; MutedText="#8696A0"; LabelText="#8696A0"
        Accent="#00A884"; AccentAlt="#06CF9C"; Border="#2A3942"; BorderStrong="#3B4A54"
        ButtonBg="#202C33"; ButtonHover="#2A3942"; ButtonPressed="#111B21"
        BorderHover="#00A884"; BorderPressed="#06CF9C"
        PrimaryBg="#00A884"; PrimaryHover="#008069"; PrimaryPressed="#005C4B"
        RevertBg="#7F1D1D"; RevertBorder="#F87171"; RevertHover="#991B1B"; RevertPressed="#450A0A"
        ManualBg="#3B4A54"; ManualHover="#4A5A64"; ManualPressed="#202C33"; Log="#25D366"
    }
}

function Get-DefaultOmegaState {
    return [ordered]@{
        Version = 1; SavedAt = $null
        PowerPlan = [ordered]@{ OriginalSchemeGuid = $null; TargetSchemeGuid = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c" }
        FastStartup = [ordered]@{ OriginalHibernationEnabled = $null; OriginalHiberbootEnabled = $null }
        QoS = [ordered]@{ RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched"; OriginalValueExists = $false; OriginalValue = $null }
        Services = [ordered]@{ wuauserv = $null; FontCache = $null; UsoSvc = $null }
    }
}

try {
    if (Test-Path $script:OmegaStatePath) {
        $loaded = Get-Content -Path $script:OmegaStatePath -Raw -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
        if ($loaded.Version -eq 1) { $script:OmegaState = $loaded }
        else { $script:OmegaState = (Get-DefaultOmegaState | ConvertTo-Json -Depth 8 | ConvertFrom-Json) }
    } else {
        $script:OmegaState = (Get-DefaultOmegaState | ConvertTo-Json -Depth 8 | ConvertFrom-Json)
    }
} catch {
    $script:OmegaState = (Get-DefaultOmegaState | ConvertTo-Json -Depth 8 | ConvertFrom-Json)
}

$script:OmegaSystemProfile = Get-OmegaSystemProfile

# ---------- 9. MODO BÁSICO/AVANZADO ------------------------------------------
function Set-OmegaModeUI {
    param([bool]$Advanced)
    try {
        if ($Advanced) {
            $global:statsPanel.Visibility = 'Visible'
            $global:logPanel.Visibility = 'Visible'
            $global:btnSfc.Content = "Ejecutar SFC /Scannow"
            $global:btnDism.Content = "Reparar Imagen DISM"
            $global:btnChkDsk.Content = "Reparar Disco (CHKDSK /f)"
            $global:btnMaxPower.Content = "⚡ Activar Alto Rendimiento"
            $global:btnFlushDns.Content = "Limpiar Caché DNS"
            $global:btnResetNet.Content = "Restablecer Winsock / IP"
            $global:btnQoS.Content = "🚀 Configurar QoS a 0%"
            $global:btnTemp.Content = "Limpiar Temporales Básicos"
            $global:btnDeepClean.Content = "🧹 Limpieza Profunda / WinUpdate"
            $global:btnLogClean.Content = "🗑️ Limpiar Logs y WinSxS"
            $global:btnFullRepair.Content = "⚡ Reparación 1-Clic"
            $global:btnManual.Content = "📖 Manual detallado"
            $global:btnRevert.Content = "↩ Revertir cambios"
            $global:btnDiagnose.Content = "🔍 Analizar PC"
            $global:btnRefreshDrives.Content = "↻ Actualizar discos"
            $global:chkAdvanced.Content = "🔧 Modo Avanzado"
        } else {
            $global:statsPanel.Visibility = 'Collapsed'
            $global:logPanel.Visibility = 'Collapsed'
            $global:btnSfc.Content = "Reparar archivos de Windows"
            $global:btnDism.Content = "Reparar imagen del sistema"
            $global:btnChkDsk.Content = "Comprobar disco"
            $global:btnMaxPower.Content = "⚡ Modo rendimiento"
            $global:btnFlushDns.Content = "Limpiar caché de internet"
            $global:btnResetNet.Content = "Reparar conexión de red"
            $global:btnQoS.Content = "🚀 Mejorar velocidad de red"
            $global:btnTemp.Content = "Limpiar archivos temporales"
            $global:btnDeepClean.Content = "🧹 Limpieza completa"
            $global:btnLogClean.Content = "🗑️ Limpiar registros"
            $global:btnFullRepair.Content = "⚡ Reparar todo"
            $global:btnManual.Content = "📖 Manual de uso"
            $global:btnRevert.Content = "↩ Deshacer cambios"
            $global:btnDiagnose.Content = "🔍 Analizar PC"
            $global:btnRefreshDrives.Content = "↻ Actualizar"
            $global:chkAdvanced.Content = "Modo Avanzado"
        }
    } catch { }
}

# ---------- 10. INICIALIZACIÓN DE UI -----------------------------------------
Initialize-OmegaSystemProfile -SysProfile $script:OmegaSystemProfile

# Rellenar el ComboBox de temas
$themeList = @('Oscuro','Claro','GitHub','Retro','Twitter X','Discord','WhatsApp')
foreach ($themeKey in $themeList) { [void]$global:cmbTheme.Items.Add($themeKey) }
$savedTheme = Get-OmegaThemeName
if ($themeList -contains $savedTheme) {
    $global:cmbTheme.SelectedItem = $savedTheme
    Set-OmegaThemeResources -Palette $script:OmegaThemes[$savedTheme]
}

# Estado inicial: Modo Básico
Set-OmegaModeUI -Advanced $false

Refresh-OmegaRepairDrives
Write-OmegaLog "OmegaSolver V3.9 iniciado en Modo Básico."

# ---------- 11. EVENTOS ------------------------------------------------------

# Toggle Modo Avanzado
$global:chkAdvanced.Add_Checked({
    try {
        Set-OmegaModeUI -Advanced $true
        Write-OmegaLog "🔧 Modo Avanzado activado."
    } catch { }
})
$global:chkAdvanced.Add_Unchecked({
    try {
        Set-OmegaModeUI -Advanced $false
        Write-OmegaLog "🎯 Modo Básico activado."
    } catch { }
})

# Cambio de tema
$global:cmbTheme.Add_SelectionChanged({
    try {
        $selected = $global:cmbTheme.SelectedItem
        if ($selected -and $script:OmegaThemes.ContainsKey([string]$selected)) {
            Set-OmegaThemeResources -Palette $script:OmegaThemes[[string]$selected]
            Save-OmegaThemeName -Name ([string]$selected)
        }
    } catch { }
})

$global:cmbRepairDrive.Add_SelectionChanged({ try { Update-OmegaRepairDriveState } catch { } })

$global:btnDiagnose.Add_Click({ try { Set-OmegaStatus "Analizando..."; Start-OmegaDiagnostics; Set-OmegaStatus "Listo" } catch { } })
$global:btnRefreshDrives.Add_Click({ try { Refresh-OmegaRepairDrives } catch { } })

$global:btnSfc.Add_Click({
    try {
        $info = Get-SelectedOmegaDriveInfo
        if (-not $info) { return }
        if (-not (Confirm-OmegaAction -Title "SFC" -Message "SFC se ejecutará sobre $($info.Drive). ¿Continuar?" -Image 'Information')) { return }
        Start-OmegaSfcRepair $info
    } catch { Write-OmegaLog "Error: $($_.Exception.Message)" }
})

$global:btnDism.Add_Click({
    try {
        $info = Get-SelectedOmegaDriveInfo
        if (-not $info) { return }
        if (-not (Confirm-OmegaAction -Title "DISM" -Message "DISM se ejecutará sobre $($info.Drive). ¿Continuar?" -Image 'Information')) { return }
        Start-OmegaDismRepair $info
    } catch { Write-OmegaLog "Error: $($_.Exception.Message)" }
})

$global:btnChkDsk.Add_Click({
    try {
        $info = Get-SelectedOmegaDriveInfo
        if (-not $info) { return }
        if (-not (Confirm-OmegaAction -Title "CHKDSK" -Message "CHKDSK /f se ejecutará sobre $($info.Drive). Puede requerir reinicio. ¿Continuar?")) { return }
        Start-OmegaChkdskRepair $info
    } catch { Write-OmegaLog "Error: $($_.Exception.Message)" }
})

$global:btnMaxPower.Add_Click({
    try {
        Save-ReversibleStateBeforePowerPlanChange
        powercfg -setactive $script:OmegaState.PowerPlan.TargetSchemeGuid | Out-Null
        Write-OmegaLog "✅ Alto Rendimiento activado."
    } catch { Write-OmegaLog "Error: $($_.Exception.Message)" }
})

$global:btnFlushDns.Add_Click({ try { ipconfig /flushdns | Out-Null; Write-OmegaLog "✅ Caché DNS limpiada." } catch { } })

$global:btnResetNet.Add_Click({
    try {
        if (-not (Confirm-OmegaAction -Title "Reset Red" -Message "Se restablecerá Winsock. Puede requerir reinicio. ¿Continuar?")) { return }
        netsh winsock reset | Out-Null
        Write-OmegaLog "✅ Red restablecida."
    } catch { Write-OmegaLog "Error: $($_.Exception.Message)" }
})

$global:btnQoS.Add_Click({
    try {
        Save-ReversibleStateBeforeQoSChange
        $regPath = $script:OmegaState.QoS.RegistryPath
        if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
        Set-ItemProperty -Path $regPath -Name "NonBestEffortLimit" -Value 0 -Type DWord
        Write-OmegaLog "✅ QoS establecido en 0%."
    } catch { Write-OmegaLog "Error: $($_.Exception.Message)" }
})

$global:btnTemp.Add_Click({
    try {
        Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-OmegaLog "✅ Temporales procesados."
    } catch { Write-OmegaLog "Error: $($_.Exception.Message)" }
})

$global:btnDeepClean.Add_Click({
    try {
        if (-not (Confirm-OmegaAction -Title "Limpieza Profunda" -Message "Elimina temporales, cachés y desactiva hibernación temporalmente. Guarda estado reversible. ¿Continuar?")) { return }
        Start-DeepCleaningRoutine
        Start-OmegaDiagnostics
    } catch { Write-OmegaLog "Error: $($_.Exception.Message)" }
})

$global:btnLogClean.Add_Click({
    try {
        if (-not (Confirm-OmegaAction -Title "Logs y WinSxS" -Message "Incluye DISM /ResetBase (irreversible). ¿Continuar?")) { return }
        Start-LogAndWinSxSCleanup
    } catch { Write-OmegaLog "Error: $($_.Exception.Message)" }
})

$global:btnFullRepair.Add_Click({
    try {
        $info = Get-SelectedOmegaDriveInfo
        if (-not $info) { return }
        if (-not (Confirm-OmegaAction -Title "Reparación 1-Clic" -Message "SFC + DISM + CHKDSK + Limpieza profunda sobre $($info.Drive). ¿Continuar?")) { return }
        ipconfig /flushdns | Out-Null
        Start-DeepCleaningRoutine
        Start-LogAndWinSxSCleanup
        Start-OmegaSfcRepair $info
        Start-OmegaDismRepair $info
        Start-OmegaChkdskRepair $info
    } catch { Write-OmegaLog "Error: $($_.Exception.Message)" }
})

$global:btnManual.Add_Click({
    try {
        $manualText = @"
OmegaSolver V3.9 — MANUAL

MODOS DE USO
• Básico: nombres simples, sin panel de estadísticas ni registro de actividad.
• Avanzado: activa el checkbox "Modo Avanzado" arriba a la derecha para ver nombres técnicos, estadísticas y el registro de actividad.

BOTONES DISPONIBLES
• Reparar archivos de Windows (SFC): repara archivos del sistema.
• Reparar imagen del sistema (DISM): repara componentes de Windows.
• Comprobar disco (CHKDSK): corrige errores del sistema de archivos.
• Modo rendimiento: activa el plan Alto Rendimiento.
• Limpiar caché de internet: vacía la caché DNS.
• Reparar conexión de red: restablece Winsock.
• Mejorar velocidad de red (QoS): ajusta reserva de ancho de banda a 0%.
• Limpiar archivos temporales: borra TEMP de usuario.
• Limpieza completa: cachés, temporales, papelera, etc.
• Limpiar registros: registros de eventos y WinSxS (irreversible).
• Reparar todo: combinación de SFC + DISM + CHKDSK + Limpieza.

REVERSIÓN
El botón "Deshacer cambios" restaura:
1. Plan de energía original.
2. Hibernación e Inicio rápido.
3. Valor original de QoS.
4. Estado de servicios (Windows Update, FontCache, UsoSvc).

NOTA: No recupera archivos eliminados.
"@
        $mw = New-Object System.Windows.Window
        $mw.Title = "Manual - OmegaSolver V3.9"
        $mw.Width = 820; $mw.Height = 620
        $mw.WindowStartupLocation = "CenterOwner"
        $mw.Owner = $window
        $mw.Background = "#101216"
        $scroll = New-Object System.Windows.Controls.ScrollViewer
        $scroll.VerticalScrollBarVisibility = "Auto"
        $scroll.Margin = New-Object System.Windows.Thickness(14)
        $tb = New-Object System.Windows.Controls.TextBox
        $tb.Text = $manualText; $tb.IsReadOnly = $true; $tb.TextWrapping = "Wrap"
        $tb.AcceptsReturn = $true; $tb.VerticalScrollBarVisibility = "Auto"
        $tb.Background = "#0C0E12"; $tb.Foreground = "#F3F4F6"; $tb.BorderBrush = "#374151"
        $tb.FontFamily = New-Object System.Windows.Media.FontFamily -ArgumentList "Segoe UI"
        $tb.FontSize = 13; $tb.Padding = New-Object System.Windows.Thickness(14)
        $scroll.Content = $tb; $mw.Content = $scroll
        $mw.ShowDialog() | Out-Null
    } catch { Write-OmegaLog "Error mostrando manual: $($_.Exception.Message)" }
})

$global:revertAction = {
    try {
        $hasPowerPlan = -not [string]::IsNullOrWhiteSpace([string]$script:OmegaState.PowerPlan.OriginalSchemeGuid)
        $hasFastStartup = $null -ne $script:OmegaState.FastStartup.OriginalHibernationEnabled -or $null -ne $script:OmegaState.FastStartup.OriginalHiberbootEnabled
        $hasQoS = [bool]$script:OmegaState.QoS.OriginalValueExists
        $hasServices = $false
        foreach ($name in @('wuauserv','FontCache','UsoSvc')) {
            if ($null -ne $script:OmegaState.Services.$name) { $hasServices = $true; break }
        }
        if (-not ($hasPowerPlan -or $hasFastStartup -or $hasQoS -or $hasServices)) {
            [System.Windows.MessageBox]::Show("No hay cambios reversibles guardados.", "Revertir", 'OK', 'Information') | Out-Null
            return
        }
        if (-not (Confirm-OmegaAction -Title "Revertir cambios" -Message "Se restaurarán solo los estados guardados. ¿Continuar?")) { return }
        Set-OmegaStatus "Revirtiendo..."
        if ($hasPowerPlan) {
            try {
                powercfg -setactive $script:OmegaState.PowerPlan.OriginalSchemeGuid | Out-Null
                Write-OmegaLog "✅ Plan de energía restaurado."
                $script:OmegaState.PowerPlan.OriginalSchemeGuid = $null
            } catch { Write-OmegaLog "⚠ No se pudo restaurar plan de energía." }
        }
        if ($hasFastStartup) {
            try {
                if ($null -ne $script:OmegaState.FastStartup.OriginalHibernationEnabled) {
                    if ([bool]$script:OmegaState.FastStartup.OriginalHibernationEnabled) { powercfg -h on | Out-Null }
                    else { powercfg -h off | Out-Null }
                }
                if ($null -ne $script:OmegaState.FastStartup.OriginalHiberbootEnabled) {
                    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name HiberbootEnabled -Value ([int]$script:OmegaState.FastStartup.OriginalHiberbootEnabled) -Type DWord
                }
                $script:OmegaState.FastStartup.OriginalHibernationEnabled = $null
                $script:OmegaState.FastStartup.OriginalHiberbootEnabled = $null
                Write-OmegaLog "✅ Hibernación/Inicio rápido restaurados."
            } catch { Write-OmegaLog "⚠ No se pudo restaurar hibernación." }
        }
        if ($hasQoS) {
            try {
                $regPath = $script:OmegaState.QoS.RegistryPath
                if ($script:OmegaState.QoS.OriginalValueExists) {
                    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
                    Set-ItemProperty -Path $regPath -Name NonBestEffortLimit -Value ([int]$script:OmegaState.QoS.OriginalValue) -Type DWord
                } else {
                    Remove-ItemProperty -Path $regPath -Name NonBestEffortLimit -ErrorAction SilentlyContinue
                }
                $script:OmegaState.QoS.OriginalValueExists = $false
                $script:OmegaState.QoS.OriginalValue = $null
                Write-OmegaLog "✅ QoS restaurado."
            } catch { Write-OmegaLog "⚠ No se pudo restaurar QoS." }
        }
        if ($hasServices) {
            Restore-OmegaServiceStates
            foreach ($name in @('wuauserv','FontCache','UsoSvc')) { $script:OmegaState.Services.$name = $null }
            Write-OmegaLog "✅ Servicios restaurados."
        }
        Save-OmegaState $script:OmegaState
        Set-OmegaStatus "Listo"
    } catch { Write-OmegaLog "Error revirtiendo: $($_.Exception.Message)" }
}
$global:btnRevert.Add_Click($global:revertAction)

# Diagnóstico automático tras renderizar
$window.Add_ContentRendered({ try { Start-OmegaDiagnostics } catch { } })

# ---------- 12. MOSTRAR VENTANA ---------------------------------------------
$window.ShowDialog() | Out-Null
