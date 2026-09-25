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
# PROYECTO: OmegaSolver V3.3 (Actualizado con Limpieza de Logs y WinSxS Avanzada)
# ARCHIVO: OmegaSolver_V3.3.ps1
# DESCRIPCIÃ“N: Herramienta grÃ¡fica de diagnÃ³stico, reparaciÃ³n y optimizaciÃ³n.
# ==============================================================================

Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="OmegaSolver V3.3" Height="670" Width="850"
        WindowStartupLocation="CenterScreen" Background="#121212" Foreground="#FFFFFF">
    <Window.Resources>
        <Style TargetType="Button">
            <Setter Property="Background" Value="#252526"/>
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Setter Property="BorderBrush" Value="#3F3F46"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Padding" Value="8,6"/>
            <Setter Property="Margin" Value="4"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Cursor" Value="Hand"/>
        </Style>
        <Style x:Key="PrimaryButton" TargetType="Button" BasedOn="{StaticResource {x:Type Button}}">
            <Setter Property="Background" Value="#0078D4"/>
            <Setter Property="FontWeight" Value="Bold"/>
        </Style>
    </Window.Resources>
    
    <Grid Margin="15">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <!-- Cabecera -->
        <StackPanel Grid.Row="0" Margin="0,0,0,15">
            <TextBlock Text="OmegaSolver V3.3" FontSize="22" FontWeight="Bold" Foreground="#0078D4"/>
            <TextBlock x:Name="lblStatus" Text="Estado: Listo" FontSize="12" Foreground="#AAAAAA" Margin="0,4,0,0"/>
        </StackPanel>

        <!-- Contenido Principal -->
        <Grid Grid.Row="1">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>

            <!-- Tarjeta 1: Sistema -->
            <Border Grid.Column="0" Background="#1E1E1E" CornerRadius="6" Padding="10" Margin="0,0,5,0" BorderBrush="#2D2D2D" BorderThickness="1">
                <StackPanel>
                    <TextBlock Text="ðŸ› ï¸ Sistema y Rendimiento" FontSize="14" FontWeight="Bold" Margin="4,0,0,10" Foreground="#0078D4"/>
                    <Button x:Name="btnSfc" Content="Ejecutar SFC /Scannow"/>
                    <Button x:Name="btnDism" Content="Reparar Imagen DISM"/>
                    <Button x:Name="btnChkDsk" Content="Escanear Disco (CHKDSK)"/>
                    <Button x:Name="btnMaxPower" Content="âš¡ Activar MÃ¡ximo Rendimiento"/>
                </StackPanel>
            </Border>

            <!-- Tarjeta 2: Red -->
            <Border Grid.Column="1" Background="#1E1E1E" CornerRadius="6" Padding="10" Margin="5,0,5,0" BorderBrush="#2D2D2D" BorderThickness="1">
                <StackPanel>
                    <TextBlock Text="ðŸŒ Red y ConexiÃ³n" FontSize="14" FontWeight="Bold" Margin="4,0,0,10" Foreground="#0078D4"/>
                    <Button x:Name="btnFlushDns" Content="Limpiar CachÃ© DNS"/>
                    <Button x:Name="btnResetNet" Content="Restablecer Winsock / IP"/>
                    <Button x:Name="btnQoS" Content="ðŸš€ Desbloquear Ancho de Banda QoS"/>
                </StackPanel>
            </Border>

            <!-- Tarjeta 3: Mantenimiento -->
            <Border Grid.Column="2" Background="#1E1E1E" CornerRadius="6" Padding="10" Margin="5,0,0,0" BorderBrush="#2D2D2D" BorderThickness="1">
                <StackPanel>
                    <TextBlock Text="ðŸ§¹ Mantenimiento" FontSize="14" FontWeight="Bold" Margin="4,0,0,10" Foreground="#0078D4"/>
                    <Button x:Name="btnTemp" Content="Limpiar Temporales BÃ¡sicos"/>
                    <Button x:Name="btnDeepClean" Content="ðŸ§¹ Limpieza Profunda / WinUpdate"/>
                    <Button x:Name="btnLogClean" Content="ðŸ—‘ï¸ Limpiar Logs y WinSxS"/>
                    <Button x:Name="btnManual" Content="ðŸ“– Manual / IntroducciÃ³n"/>
                    <Button x:Name="btnFullRepair" Style="{StaticResource PrimaryButton}" Content="âš¡ ReparaciÃ³n 1-Clic" Margin="4,10,4,4"/>
                </StackPanel>
            </Border>
        </Grid>

        <!-- Terminal de Logs -->
        <Border Grid.Row="2" Background="#1E1E1E" CornerRadius="6" Padding="10" Margin="0,15,0,0" BorderBrush="#2D2D2D" BorderThickness="1">
            <StackPanel>
                <TextBlock Text="ðŸ“œ Registro de Actividad" FontSize="12" FontWeight="Bold" Foreground="#AAAAAA" Margin="0,0,0,5"/>
                <TextBox x:Name="txtLog" Height="140" Background="#0F0F0F" Foreground="#00FF66" 
                         FontFamily="Consolas" FontSize="11" IsReadOnly="True" 
                         TextWrapping="Wrap" VerticalScrollBarVisibility="Auto"/>
            </StackPanel>
        </Border>
    </Grid>
</Window>
"@

# Cargar la interfaz WPF
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

# Vincular Controles XAML
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
$btnFullRepair = $window.FindName("btnFullRepair")

# FunciÃ³n de registro de logs
function Write-OmegaLog ($message) {
    $timestamp = Get-Date -Format "HH:mm:ss"
    $txtLog.AppendText("[$timestamp] $message`n")
    $txtLog.ScrollToEnd()
}

# Rutina de Limpieza Avanzada de Logs y WinSxS
function Start-LogAndWinSxSCleanup {
    Write-OmegaLog "[+] Iniciando limpieza profunda de archivos LOG y almacÃ©n WinSxS..."

    Write-OmegaLog "[+] Vaciando registros de eventos de Windows (.evtx)..."
    $eventLogs = Get-WinEvent -ListLog * -ErrorAction SilentlyContinue
    foreach ($log in $eventLogs) {
        if ($log.RecordCount -gt 0) {
            try {
                [Diagnostics.Eventing.Reader.EventLogSession]::GlobalSession.ClearLog($log.LogName)
            } catch {
                # Omitir registros protegidos del sistema
            }
        }
    }
    Write-OmegaLog "âœ… Registros de eventos de Windows depurados con Ã©xito."

    Write-OmegaLog "[+] Eliminando archivos LOG residuales (Sistema, Panther y SoftwareDistribution)..."
    Remove-Item -Path "$env:SystemRoot\Logs\*.log" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SystemRoot\Logs\CBS\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SystemRoot\Panther\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SystemRoot\SoftwareDistribution\DataStore\Logs\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-OmegaLog "âœ… Archivos LOG eliminados de las rutas de sistema."

    Write-OmegaLog "[+] Ejecutando optimizaciÃ³n profunda del almacÃ©n de componentes (WinSxS)..."
    Start-Process DISM.exe -ArgumentList "/Online /Cleanup-Image /StartComponentCleanup /ResetBase" -NoNewWindow -Wait
    Write-OmegaLog "âœ… AlmacÃ©n WinSxS limpiado y compactado correctamente."

    Write-OmegaLog "Â¡Limpieza de Logs y WinSxS completada con Ã©xito!"
}

# Rutina de Limpieza Profunda
function Start-DeepCleaningRoutine {
    Write-OmegaLog "[+] Desactivando archivo de hibernaciÃ³n (hiberfil.sys)..."
    powercfg -h off | Out-Null

    Write-OmegaLog "[+] Deteniendo servicios temporales (Windows Update, FontCache, UsoSvc)..."
    Stop-Service -Name wuauserv, FontCache, UsoSvc -Force -ErrorAction SilentlyContinue

    Write-OmegaLog "[+] Vaciando descargas de WinUpdate y cachÃ©s de sistema..."
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

    Write-OmegaLog "[+] Restaurando servicios esenciales de Windows..."
    Start-Service -Name wuauserv, FontCache, UsoSvc -ErrorAction SilentlyContinue

    Write-OmegaLog "[+] Ejecutando Liberador de Espacio nativo..."
    Start-Process cleanmgr.exe -ArgumentList "/sagerun:1" -NoNewWindow -Wait

    Write-OmegaLog "Â¡Limpieza profunda y optimizaciÃ³n completadas con Ã©xito!"
}

# InicializaciÃ³n
Write-OmegaLog "OmegaSolver V3.3 iniciado correctamente."
Write-OmegaLog "Esperando acciÃ³n del usuario..."

# Eventos
$btnManual.Add_Click({$manualText = "Â¡Bienvenido a OmegaSolver V3.3!`n`n" +
                  "ðŸ› ï¸ SISTEMA Y RENDIMIENTO:`n" +
                  "- Activar MÃ¡ximo Rendimiento: Configura el plan de energÃ­a de Windows para evitar caÃ­das de frecuencia en el procesador, ideal para gaming y grabaciÃ³n.`n`n" +
                  "ðŸŒ RED Y CONEXIÃ“N:`n" +
                  "- Desbloquear Ancho de Banda QoS: Modifica el registro de Windows para establecer el lÃ­mite de ancho de banda reservable en 0%.`n`n" +
                  "ðŸ§¹ MANTENIMIENTO:`n" +
                  "- Limpiar Logs y WinSxS: Depura registros de eventos (.evtx), archivos .log de sistema/Panther y compacta el almacÃ©n de componentes WinSxS."
                  
    [System.Windows.MessageBox]::Show($manualText, "Manual Explicativo - OmegaSolver V3.3", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
})

$btnSfc.Add_Click({
    Write-OmegaLog "Iniciando comprobaciÃ³n de archivos del sistema (SFC)..."
    $lblStatus.Text = "Estado: Ejecutando SFC..."
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command sfc /scannow" -Verb RunAs
})

$btnDism.Add_Click({
    Write-OmegaLog "Iniciando reparaciÃ³n de imagen con DISM..."
    $lblStatus.Text = "Estado: Ejecutando DISM..."
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command DISM /Online /Cleanup-Image /RestoreHealth" -Verb RunAs
})

$btnChkDsk.Add_Click({
    Write-OmegaLog "Iniciando escaneo de disco (CHKDSK)..."
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command chkdsk" -Verb RunAs
})

$btnMaxPower.Add_Click({
    Write-OmegaLog "Configurando plan de energÃ­a a Alto Rendimiento..."
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c | Out-Null
    Write-OmegaLog "âœ… Plan de Alto Rendimiento activado. Frecuencias de CPU al mÃ¡ximo."
})

$btnFlushDns.Add_Click({
    Write-OmegaLog "Vaciando cachÃ© DNS..."
    ipconfig /flushdns | Out-Null
    Write-OmegaLog "CachÃ© DNS limpiada con Ã©xito."
})

$btnResetNet.Add_Click({
    Write-OmegaLog "Restableciendo sockets de red (Winsock)..."
    netsh winsock reset | Out-Null
    Write-OmegaLog "Red restablecida. Se recomienda reiniciar el equipo."
})

$btnQoS.Add_Click({
    Write-OmegaLog "Configurando LÃ­mite de Ancho de Banda Reservable QoS a 0%..."
    $regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched"
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }
    Set-ItemProperty -Path $regPath -Name "NonBestEffortLimit" -Value 0 -Type DWord
    Write-OmegaLog "âœ… LÃ­mite de ancho de banda reservable establecido en 0% con Ã©xito."
})

$btnTemp.Add_Click({
    Write-OmegaLog "Limpiando archivos temporales bÃ¡sicos..."
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-OmegaLog "Archivos temporales eliminados."
})

$btnDeepClean.Add_Click({
    Write-OmegaLog "Iniciando secuencia de Limpieza Profunda..."
    $lblStatus.Text = "Estado: Ejecutando Limpieza Profunda..."
    Start-DeepCleaningRoutine
    $lblStatus.Text = "Estado: Listo"
})

$btnLogClean.Add_Click({
    Write-OmegaLog "Iniciando Limpieza Avanzada de Logs y WinSxS..."
    $lblStatus.Text = "Estado: Limpiando Logs y WinSxS..."
    Start-LogAndWinSxSCleanup
    $lblStatus.Text = "Estado: Listo"
})

$btnFullRepair.Add_Click({
    Write-OmegaLog "âš¡ Iniciando rutina de ReparaciÃ³n 1-Clic..."
    $lblStatus.Text = "Estado: ReparaciÃ³n 1-Clic en progreso..."
    
    ipconfig /flushdns | Out-Null
    Write-OmegaLog "1/4: CachÃ© DNS vaciada."
    
    Start-DeepCleaningRoutine
    Write-OmegaLog "2/4: Limpieza profunda finalizada."

    Start-LogAndWinSxSCleanup
    Write-OmegaLog "3/4: Limpieza de Logs y WinSxS finalizada."
    
    Write-OmegaLog "4/4: Lanzando comprobaciÃ³n de sistema (SFC)..."
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command sfc /scannow" -Verb RunAs
    $lblStatus.Text = "Estado: Listo"
})

# Lanzar Ventana
$window.ShowDialog() | Out-Null
