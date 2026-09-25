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
# PROYECTO: OmegaSolver V3.2.1
# ARCHIVO: OmegaSolver_V3.2.1.ps1
# DESCRIPCIÃ“N: Herramienta grÃ¡fica de diagnÃ³stico, reparaciÃ³n y mantenimiento.
# ==============================================================================

Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="OmegaSolver V3.2.1" Height="600" Width="850"
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
            <TextBlock Text="OmegaSolver V3.2.1" FontSize="22" FontWeight="Bold" Foreground="#0078D4"/>
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
                    <TextBlock Text="ðŸ› ï¸ Sistema" FontSize="14" FontWeight="Bold" Margin="4,0,0,10" Foreground="#0078D4"/>
                    <Button x:Name="btnSfc" Content="Ejecutar SFC /Scannow"/>
                    <Button x:Name="btnDism" Content="Reparar Imagen DISM"/>
                    <Button x:Name="btnChkDsk" Content="Escanear Disco (CHKDSK)"/>
                </StackPanel>
            </Border>

            <!-- Tarjeta 2: Red -->
            <Border Grid.Column="1" Background="#1E1E1E" CornerRadius="6" Padding="10" Margin="5,0,5,0" BorderBrush="#2D2D2D" BorderThickness="1">
                <StackPanel>
                    <TextBlock Text="ðŸŒ Red y ConexiÃ³n" FontSize="14" FontWeight="Bold" Margin="4,0,0,10" Foreground="#0078D4"/>
                    <Button x:Name="btnFlushDns" Content="Limpiar CachÃ© DNS"/>
                    <Button x:Name="btnResetNet" Content="Restablecer Winsock / IP"/>
                </StackPanel>
            </Border>

            <!-- Tarjeta 3: Acciones RÃ¡pidas -->
            <Border Grid.Column="2" Background="#1E1E1E" CornerRadius="6" Padding="10" Margin="5,0,0,0" BorderBrush="#2D2D2D" BorderThickness="1">
                <StackPanel>
                    <TextBlock Text="ðŸš€ Acciones RÃ¡pidas" FontSize="14" FontWeight="Bold" Margin="4,0,0,10" Foreground="#0078D4"/>
                    <Button x:Name="btnTemp" Content="Limpiar Temporales"/>
                    <Button x:Name="btnManual" Content="ðŸ“– Manual / IntroducciÃ³n"/>
                    <Button x:Name="btnFullRepair" Style="{StaticResource PrimaryButton}" Content="âš¡ ReparaciÃ³n 1-Clic" Margin="4,15,4,4"/>
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
$btnFlushDns   = $window.FindName("btnFlushDns")
$btnResetNet   = $window.FindName("btnResetNet")
$btnTemp       = $window.FindName("btnTemp")
$btnManual     = $window.FindName("btnManual")
$btnFullRepair = $window.FindName("btnFullRepair")

# FunciÃ³n de registro de logs
function Write-OmegaLog ($message) {
    $timestamp = Get-Date -Format "HH:mm:ss"
    $txtLog.AppendText("[$timestamp] $message`n")
    $txtLog.ScrollToEnd()
}

# InicializaciÃ³n
Write-OmegaLog "OmegaSolver V3.2.1 iniciado correctamente."
Write-OmegaLog "Esperando acciÃ³n del usuario..."

# Eventos
$btnManual.Add_Click({
    $manualText = "Â¡Bienvenido a OmegaSolver V3.2.1!`n`n" +
                  "Esta herramienta centraliza el diagnÃ³stico y mantenimiento de Windows en una sola interfaz.`n`n" +
                  "ðŸ› ï¸ SISTEMA:`n" +
                  "- SFC /Scannow: Analiza y repara archivos daÃ±ados del sistema.`n" +
                  "- DISM: Repara la imagen base de Windows si SFC presenta errores.`n" +
                  "- CHKDSK: Diagnostica el estado del disco duro.`n`n" +
                  "ðŸŒ RED Y CONEXIÃ“N:`n" +
                  "- Limpia la cachÃ© DNS y restablece Winsock para resolver problemas de internet.`n`n" +
                  "ðŸš€ ACCIONES RÃPIDAS:`n" +
                  "- Limpiar Temporales: Elimina archivos residuales de la carpeta %TEMP%.`n" +
                  "- ReparaciÃ³n 1-Clic: Ejecuta el mantenimiento completo en secuencia automatizada.`n`n" +
                  "Nota: Se recomienda ejecutar esta aplicaciÃ³n con privilegios de Administrador."
                  
    [System.Windows.MessageBox]::Show($manualText, "Manual Explicativo - OmegaSolver V3.2.1", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    Write-OmegaLog "El usuario abriÃ³ el Manual de IntroducciÃ³n."
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

$btnTemp.Add_Click({
    Write-OmegaLog "Limpiando archivos temporales..."
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-OmegaLog "Archivos temporales eliminados."
})

$btnFullRepair.Add_Click({
    Write-OmegaLog "âš¡ Iniciando rutina de ReparaciÃ³n 1-Clic..."
    $lblStatus.Text = "Estado: ReparaciÃ³n 1-Clic en progreso..."
    
    ipconfig /flushdns | Out-Null
    Write-OmegaLog "1/3: CachÃ© DNS vaciada."
    
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-OmegaLog "2/3: Archivos temporales eliminados."
    
    Write-OmegaLog "3/3: Lanzando comprobaciÃ³n de sistema (SFC)..."
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command sfc /scannow" -Verb RunAs
})

# Lanzar Ventana
$window.ShowDialog() | Out-Null
