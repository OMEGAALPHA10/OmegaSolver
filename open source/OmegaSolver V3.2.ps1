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

<#
.SYNOPSIS
    OmegaSolver v2.0 - Fluent UI (WPF / XAML)
    Creado por: OMEGA_ALPHA
    Compatible con Windows 10 y 11
#>

# Cargar Ensamblados de WPF
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

# ---------------------------------------------------------------------------
# INTERFAZ GRÃFICA XAML
# ---------------------------------------------------------------------------
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="OmegaSolver - Herramienta de Mantenimiento" 
        Height="680" Width="980"
        WindowStartupLocation="CenterScreen"
        Background="#181818" Foreground="#FFFFFF"
        FontFamily="Segoe UI Variable Display, Segoe UI, sans-serif">

    <Window.Resources>
        <Style TargetType="Button">
            <Setter Property="Background" Value="#2D2D2D"/>
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Padding" Value="12,8"/>
            <Setter Property="Margin" Value="4"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="BorderBrush" Value="#3D3D3D"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border" Background="{TemplateBinding Background}" 
                                BorderBrush="{TemplateBinding BorderBrush}" 
                                BorderThickness="{TemplateBinding BorderThickness}" 
                                CornerRadius="6">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="border" Property="Background" Value="#3A3A3A"/>
                                <Setter TargetName="border" Property="BorderBrush" Value="#0078D4"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="border" Property="Background" Value="#005FB8"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="PrimaryButton" TargetType="Button" BasedOn="{StaticResource {x:Type Button}}">
            <Setter Property="Background" Value="#0078D4"/>
            <Setter Property="BorderBrush" Value="#1084DE"/>
            <Setter Property="FontWeight" Value="Bold"/>
        </Style>
    </Window.Resources>

    <Grid Margin="20">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="180"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <!-- ENCABEZADO -->
        <DockPanel Grid.Row="0" Margin="0,0,0,15">
            <StackPanel Orientation="Vertical">
                <TextBlock Text="OMEGASOLVER" FontSize="22" FontWeight="Bold" Foreground="#0078D4"/>
                <TextBlock Text="Centro de DiagnÃ³stico, Mantenimiento y ReparaciÃ³n de Sistema" FontSize="12" Foreground="#AAAAAA"/>
            </StackPanel>
            <Border HorizontalAlignment="Right" VerticalAlignment="Center" Background="#262626" CornerRadius="12" Padding="10,4" BorderBrush="#333333" BorderThickness="1">
                <TextBlock Text="Creado por OMEGA_ALPHA" FontSize="11" FontWeight="SemiBold" Foreground="#88C0D0"/>
            </Border>
        </DockPanel>

        <!-- ÃREA PRINCIPAL -->
        <Grid Grid.Row="1" Margin="0,0,0,15">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>

            <!-- Tarjeta 1 -->
            <Border Grid.Column="0" Background="#202020" CornerRadius="8" Padding="12" Margin="0,0,8,0" BorderBrush="#2D2D2D" BorderThickness="1">
                <StackPanel>
                    <TextBlock Text="ðŸ› ï¸ ReparaciÃ³n de Sistema" FontSize="14" FontWeight="Bold" Margin="4,0,0,10" Foreground="#0078D4"/>
                    <Button x:Name="btnSfc" Content="Ejecutar SFC /Scannow"/>
                    <Button x:Name="btnDism" Content="Reparar Imagen DISM"/>
                    <Button x:Name="btnChkdsk" Content="Programar CHKDSK"/>
                </StackPanel>
            </Border>

            <!-- Tarjeta 2 -->
            <Border Grid.Column="1" Background="#202020" CornerRadius="8" Padding="12" Margin="4,0,4,0" BorderBrush="#2D2D2D" BorderThickness="1">
                <StackPanel>
                    <TextBlock Text="ðŸŒ OptimizaciÃ³n de Red" FontSize="14" FontWeight="Bold" Margin="4,0,0,10" Foreground="#0078D4"/>
                    <Button x:Name="btnFlushDns" Content="Limpiar CachÃ© DNS"/>
                    <Button x:Name="btnResetNet" Content="Reiniciar Winsock / IP"/>
                </StackPanel>
            </Border>

            <!-- Tarjeta 3 -->
            <Border Grid.Column="2" Background="#202020" CornerRadius="8" Padding="12" Margin="8,0,0,0" BorderBrush="#2D2D2D" BorderThickness="1">
                <StackPanel>
                    <TextBlock Text="ðŸš€ Acciones RÃ¡pidas" FontSize="14" FontWeight="Bold" Margin="4,0,0,10" Foreground="#0078D4"/>
                    <Button x:Name="btnTemp" Content="Limpiar Archivos Temporales"/>
                    <Button x:Name="btnFullRepair" Style="{StaticResource PrimaryButton}" Content="âš¡ ReparaciÃ³n 1-Clic" Margin="4,15,4,4"/>
                </StackPanel>
            </Border>
        </Grid>

        <!-- REGISTRO / LOGS -->
        <Border Grid.Row="2" Background="#111111" CornerRadius="8" Padding="10" BorderBrush="#282828" BorderThickness="1">
            <DockPanel>
                <TextBlock DockPanel.Dock="Top" Text="REGISTRO DE ACTIVIDAD" FontSize="10" FontWeight="Bold" Foreground="#666666" Margin="0,0,0,5"/>
                <TextBox x:Name="txtLog" Background="Transparent" Foreground="#00FF66" BorderThickness="0" 
                         FontFamily="Consolas" FontSize="12" IsReadOnly="True" VerticalScrollBarVisibility="Auto" TextWrapping="Wrap"/>
            </DockPanel>
        </Border>

        <!-- BARRA INFERIOR -->
        <DockPanel Grid.Row="3" Margin="0,10,0,0">
            <TextBlock x:Name="lblStatus" Text="Estado: Listo" FontSize="11" Foreground="#AAAAAA"/>
            <TextBlock Text="OmegaSolver v2.0 | Creado por OMEGA_ALPHA" HorizontalAlignment="Right" FontSize="11" Foreground="#555555"/>
        </DockPanel>
    </Grid>
</Window>
"@

# ---------------------------------------------------------------------------
# CARGA DE LA VENTANA Y EVENTOS
# ---------------------------------------------------------------------------
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [System.Windows.Markup.XamlReader]::Load($reader)

# Vincular Controles
$txtLog     = $window.FindName("txtLog")
$lblStatus  = $window.FindName("lblStatus")
$btnSfc     = $window.FindName("btnSfc")
$btnDism    = $window.FindName("btnDism")
$btnTemp    = $window.FindName("btnTemp")
$btn1Clic   = $window.FindName("btnFullRepair")

# FunciÃ³n de Log
function Write-OmegaLog ($Message) {
    $timestamp = Get-Date -Format "HH:mm:ss"
    $txtLog.AppendText("[$timestamp] $Message`r`n")
    $txtLog.ScrollToEnd()
}

# DefiniciÃ³n de Eventos
$btnSfc.Add_Click({
    Write-OmegaLog "Iniciando Comprobador de Archivos de Sistema (SFC)..."
})

$btnDism.Add_Click({
    Write-OmegaLog "Iniciando ReparaciÃ³n de Salud de Imagen DISM..."
})

$btnTemp.Add_Click({
    Write-OmegaLog "Limpiando archivos temporales del sistema..."
})

$btn1Clic.Add_Click({
    Write-OmegaLog "--- INICIANDO MANTENIMIENTO COMPLETO ---"
})

# InicializaciÃ³n
Write-OmegaLog "OmegaSolver iniciado correctamente."
Write-OmegaLog "Herramienta desarrollada por OMEGA_ALPHA."

# Lanzar Interfaz
$window.ShowDialog() | Out-Null
