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
# PROYECTO: OmegaSolver V4.1 ALT (Basic 2-col Â· Advanced 3-col Â· UX reflow)
# + PULIDO: TamaÃ±os base aumentados
# + PARCHES: Instancia Ãºnica Â· CachÃ© SSD/HDD Â· EnumeraciÃ³n rÃ¡pida Â· Timeout
# ===============================================================================

# ---------- 1. CARGAR WPF ----------------------------------------------------
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

# ---------- 2. ELEVACIÃ“N A ADMINISTRADOR + INSTANCIA ÃšNICA -------------------
function Test-OmegaAdministrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# â˜… Mutex de instancia Ãºnica. Se libera SIEMPRE (try/finally + Window.Closed).
$script:OmegaMutex = $null
$script:OmegaMutexOwned = $false
try {
    $script:OmegaMutex = New-Object System.Threading.Mutex($false, 'Local\OmegaSolverV41_SingleInstance')
    try {
        $script:OmegaMutexOwned = $script:OmegaMutex.WaitOne(0, $false)
    } catch [System.Threading.AbandonedMutexException] {
        # La instancia anterior crasheÃ³ sin liberar. La adquirimos igual.
        $script:OmegaMutexOwned = $true
    }
} catch {
    $script:OmegaMutexOwned = $false
}

if (-not $script:OmegaMutexOwned) {
    [System.Windows.MessageBox]::Show(
        "Ya hay una instancia de OmegaSolver en ejecuciÃ³n.`n`nCierra la ventana abierta antes de iniciar otra.",
        "OmegaSolver â€” Instancia Ãºnica",
        'OK', 'Warning') | Out-Null
    if ($script:OmegaMutex) { try { $script:OmegaMutex.Dispose() } catch { } }
    exit 0
}

if (-not (Test-OmegaAdministrator)) {
    try {
        $scriptPath = $MyInvocation.MyCommand.Path
        if (-not $scriptPath) {
            [System.Windows.MessageBox]::Show("Guarda el script como archivo .ps1 y ejecÃºtalo de nuevo.", "OmegaSolver V4.1 ALT", 'OK', 'Warning') | Out-Null
            try { $script:OmegaMutex.ReleaseMutex() } catch { }
            try { $script:OmegaMutex.Dispose() } catch { }
            exit 1
        }
        $hostExe = $null
        try { $hostExe = (Get-Process -Id $PID -ErrorAction Stop).Path } catch { }
        if ([string]::IsNullOrWhiteSpace($hostExe) -or -not (Test-Path $hostExe)) {
            $hostExe = Join-Path $PSHOME 'powershell.exe'
            if (-not (Test-Path $hostExe)) { $hostExe = 'powershell.exe' }
        }
        # Liberamos ANTES de elevar (para que la instancia elevada pueda adquirirlo)
        try { $script:OmegaMutex.ReleaseMutex() } catch { }
        try { $script:OmegaMutex.Dispose() } catch { }
        $script:OmegaMutexOwned = $false
        Start-Process $hostExe -Verb RunAs -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', "`"$scriptPath`"") | Out-Null
        exit 0
    } catch {
        [System.Windows.MessageBox]::Show("OmegaSolver necesita permisos de administrador para ejecutarse.", "OmegaSolver V4.1 ALT", 'OK', 'Warning') | Out-Null
        try { $script:OmegaMutex.ReleaseMutex() } catch { }
        try { $script:OmegaMutex.Dispose() } catch { }
        exit 1
    }
}

# ---------- 3. XAML PRINCIPAL (CUSTOM CHROME) --------------------------------
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="OmegaSolver V4.1 ALT" Height="860" Width="1180"
        MinHeight="720" MinWidth="1080"
        WindowStartupLocation="CenterScreen"
        ResizeMode="CanResize"
        WindowStyle="None"
        AllowsTransparency="True"
        Background="Transparent">
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
            <Setter Property="Padding" Value="11,9"/>
            <Setter Property="Margin" Value="5"/>
            <Setter Property="FontSize" Value="13.5"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="MinHeight" Value="34"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="ButtonBorder" Background="{TemplateBinding Background}"
                                BorderBrush="{TemplateBinding BorderBrush}"
                                BorderThickness="{TemplateBinding BorderThickness}"
                                CornerRadius="6" Padding="{TemplateBinding Padding}">
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
                                <Setter TargetName="ButtonBorder" Property="Opacity" Value="0.4"/>
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
        <Style x:Key="HeroButton" TargetType="Button" BasedOn="{StaticResource PrimaryButton}">
            <Setter Property="Height" Value="60"/>
            <Setter Property="FontSize" Value="17"/>
            <Setter Property="FontWeight" Value="Black"/>
            <Setter Property="Margin" Value="5,14,5,5"/>
        </Style>

        <Style x:Key="WindowControlButton" TargetType="Button" BasedOn="{StaticResource {x:Type Button}}">
            <Setter Property="Width" Value="40"/>
            <Setter Property="Height" Value="30"/>
            <Setter Property="Padding" Value="0"/>
            <Setter Property="Margin" Value="2,0,0,0"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="MinHeight" Value="0"/>
        </Style>

        <Style x:Key="CloseButton" TargetType="Button" BasedOn="{StaticResource WindowControlButton}">
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#C0392B"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <Style x:Key="SectionHeading" TargetType="TextBlock">
            <Setter Property="FontSize" Value="14"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Foreground" Value="{DynamicResource ThemeAccent}"/>
            <Setter Property="Margin" Value="4,0,0,8"/>
        </Style>
        <Style x:Key="SubHeading" TargetType="TextBlock">
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Foreground" Value="{DynamicResource ThemeMutedText}"/>
            <Setter Property="Margin" Value="5,12,0,6"/>
        </Style>

        <!-- ============================================================
             SCROLLBAR MINIMALISTA â€” sin flechas, adaptable a todos los temas
             ============================================================ -->
        <Style x:Key="MinimalScrollThumb" TargetType="Thumb">
            <Setter Property="OverridesDefaultStyle" Value="True"/>
            <Setter Property="IsTabStop" Value="False"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Thumb">
                        <Border x:Name="ThumbBorder"
                                Background="{DynamicResource ThemeBorderStrong}"
                                CornerRadius="4"
                                Margin="3,0,3,0"/>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="ThumbBorder" Property="Background" Value="{DynamicResource ThemeAccent}"/>
                            </Trigger>
                            <Trigger Property="IsDragging" Value="True">
                                <Setter TargetName="ThumbBorder" Property="Background" Value="{DynamicResource ThemeAccent}"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style TargetType="ScrollBar">
            <Setter Property="OverridesDefaultStyle" Value="True"/>
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Width" Value="12"/>
            <Setter Property="MinWidth" Value="12"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="ScrollBar">
                        <Grid Background="Transparent" SnapsToDevicePixels="True">
                            <Track x:Name="PART_Track" IsDirectionReversed="True">
                                <Track.DecreaseRepeatButton>
                                    <RepeatButton Command="ScrollBar.PageUpCommand" Focusable="False">
                                        <RepeatButton.Template>
                                            <ControlTemplate TargetType="RepeatButton">
                                                <Border Background="Transparent"/>
                                            </ControlTemplate>
                                        </RepeatButton.Template>
                                    </RepeatButton>
                                </Track.DecreaseRepeatButton>
                                <Track.Thumb>
                                    <Thumb Style="{StaticResource MinimalScrollThumb}"/>
                                </Track.Thumb>
                                <Track.IncreaseRepeatButton>
                                    <RepeatButton Command="ScrollBar.PageDownCommand" Focusable="False">
                                        <RepeatButton.Template>
                                            <ControlTemplate TargetType="RepeatButton">
                                                <Border Background="Transparent"/>
                                            </ControlTemplate>
                                        </RepeatButton.Template>
                                    </RepeatButton>
                                </Track.IncreaseRepeatButton>
                            </Track>
                        </Grid>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>

    <Border x:Name="MainBorder" Background="{DynamicResource ThemeWindowBackground}"
            BorderBrush="{DynamicResource ThemeAccent}" BorderThickness="2"
            CornerRadius="10">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>

            <Border x:Name="TitleBar" Grid.Row="0"
                    Background="{DynamicResource ThemePanelBackground}"
                    BorderBrush="{DynamicResource ThemeAccent}"
                    BorderThickness="0,0,0,2"
                    CornerRadius="8,8,0,0"
                    Padding="16,10,12,10">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="Auto"/>
                    </Grid.ColumnDefinitions>

                    <StackPanel x:Name="DragArea" Grid.Column="0" Background="Transparent" VerticalAlignment="Center">
                        <StackPanel Orientation="Horizontal">
                            <TextBlock x:Name="lblAppTitle" Text="OmegaSolver" FontSize="18" FontWeight="Bold"
                                       Foreground="{DynamicResource ThemeAccent}" VerticalAlignment="Center"/>
                            <TextBlock x:Name="lblAppVersion" Text=" V4.1 ALT" FontSize="13"
                                       Foreground="{DynamicResource ThemeMutedText}"
                                       VerticalAlignment="Bottom" Margin="5,0,0,2"/>
                        </StackPanel>
                        <TextBlock x:Name="lblStatus" Text="Estado: Iniciando..." FontSize="11"
                                   Foreground="{DynamicResource ThemeSecondaryText}" Margin="0,2,0,0"/>
                    </StackPanel>

                    <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Center">
                        <TextBlock x:Name="lblThemeCaption" Text="Tema:" Foreground="{DynamicResource ThemeMutedText}"
                                   VerticalAlignment="Center" Margin="0,0,6,0" FontSize="12"/>
                        <ComboBox x:Name="cmbTheme" Width="150" Height="32" Margin="0,0,10,0" FontSize="12"/>
                        <ComboBox x:Name="cmbOmegaColor" Width="220" Height="32" Margin="0,0,10,0" FontSize="12"
                                  Visibility="Collapsed" ToolTip="Sub-color neÃ³n para OMEGASOLVER style"/>
                        <CheckBox x:Name="chkAdvanced" Content="Avanzado" Foreground="{DynamicResource ThemeSecondaryText}"
                                  VerticalAlignment="Center" FontSize="12" Margin="0,0,12,0"/>
                        <Button x:Name="btnMin" Content="â”€" Style="{StaticResource WindowControlButton}" ToolTip="Minimizar"/>
                        <Button x:Name="btnMax" Content="â–¡" Style="{StaticResource WindowControlButton}" ToolTip="Maximizar"/>
                        <Button x:Name="btnClose" Content="âœ•" Style="{StaticResource CloseButton}" ToolTip="Cerrar"/>
                    </StackPanel>
                </Grid>
            </Border>

            <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled">
                <Grid Margin="16">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                    </Grid.RowDefinitions>

                    <!-- ============ INFO BAR ============ -->
                    <Border Grid.Row="0" Background="{DynamicResource ThemePanelBackground}"
                            BorderBrush="{DynamicResource ThemeBorder}" BorderThickness="1"
                            CornerRadius="8" Padding="12" Margin="0,0,0,14">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="1.35*"/>
                                <ColumnDefinition Width="1.15*"/>
                                <ColumnDefinition Width="1.15*"/>
                                <ColumnDefinition Width="1.8*"/>
                            </Grid.ColumnDefinitions>
                            <StackPanel Grid.Column="0" Margin="2,0,10,0">
                                <TextBlock Text="EQUIPO" FontSize="10" Foreground="{DynamicResource ThemeLabelText}"/>
                                <TextBlock x:Name="lblPCName" Text="Detectando..." FontSize="13" FontWeight="Bold"
                                           Foreground="{DynamicResource ThemeMainText}" TextTrimming="CharacterEllipsis"/>
                            </StackPanel>
                            <StackPanel Grid.Column="1" Margin="2,0,10,0">
                                <TextBlock Text="WINDOWS" FontSize="10" Foreground="{DynamicResource ThemeLabelText}"/>
                                <TextBlock x:Name="lblWindowsInfo" Text="Detectando..." FontSize="12"
                                           Foreground="{DynamicResource ThemeSecondaryText}" TextTrimming="CharacterEllipsis"/>
                            </StackPanel>
                            <StackPanel Grid.Column="2" Margin="2,0,10,0">
                                <TextBlock Text="POWERSHELL" FontSize="10" Foreground="{DynamicResource ThemeLabelText}"/>
                                <TextBlock x:Name="lblPowerShellInfo" Text="Detectando..." FontSize="12"
                                           Foreground="{DynamicResource ThemeSecondaryText}" TextTrimming="CharacterEllipsis"/>
                            </StackPanel>
                            <StackPanel Grid.Column="3" Margin="2,0,2,0">
                                <TextBlock Text="COMPONENTES" FontSize="10" Foreground="{DynamicResource ThemeLabelText}"/>
                                <TextBlock x:Name="lblComponentsInfo" Text="Comprobando..." FontSize="11"
                                           Foreground="{DynamicResource ThemeSecondaryText}" TextWrapping="Wrap"/>
                            </StackPanel>
                        </Grid>
                    </Border>

                    <!-- ============ STATS PANEL ============ -->
                    <Border x:Name="statsPanel" Grid.Row="1" Background="{DynamicResource ThemePanelBackground}"
                            CornerRadius="8" Padding="14" Margin="0,0,0,14"
                            BorderBrush="{DynamicResource ThemeBorder}" BorderThickness="1" Visibility="Collapsed">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="1.4*"/>
                                <ColumnDefinition Width="2*"/>
                            </Grid.ColumnDefinitions>
                            <StackPanel Grid.Column="0" Margin="2,0,18,0" VerticalAlignment="Center">
                                <TextBlock Text="ðŸ” DiagnÃ³stico detallado" FontSize="14" FontWeight="Bold" Foreground="{DynamicResource ThemeAccent}"/>
                                <TextBlock Text="Nivel de temporales y cachÃ©s" FontSize="11" Foreground="{DynamicResource ThemeMutedText}" Margin="0,3,0,6"/>
                                <ProgressBar x:Name="pbJunkLevel" Height="18" Minimum="0" Maximum="100" Value="0"
                                             Background="{DynamicResource ThemeInputBackground}"
                                             Foreground="{DynamicResource ThemeAccent}"
                                             BorderBrush="{DynamicResource ThemeBorderStrong}"/>
                                <TextBlock x:Name="lblJunkPercent" Text="Analizando..." FontSize="12" FontWeight="Bold"
                                           Foreground="{DynamicResource ThemeMainText}" Margin="0,6,0,0"/>
                            </StackPanel>
                            <StackPanel Grid.Column="1" Margin="2,0,2,0" VerticalAlignment="Center">
                                <TextBlock Text="RESUMEN" FontSize="10" Foreground="{DynamicResource ThemeLabelText}"/>
                                <TextBlock x:Name="lblJunkDetails" Text="Preparando anÃ¡lisis..." FontSize="12"
                                           Foreground="{DynamicResource ThemeSecondaryText}" TextWrapping="Wrap" Margin="0,4,0,0"/>
                            </StackPanel>
                        </Grid>
                    </Border>

                    <!-- ============ CONTENT GRIDS ============ -->
                    <Grid Grid.Row="2">

                        <!-- â˜… MODO BÃSICO â€” 2 COLUMNAS -->
                        <Grid x:Name="gridBasic" Visibility="Visible">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="1.35*"/>
                                <ColumnDefinition Width="14"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>

                            <Border Grid.Column="0" Background="{DynamicResource ThemeCardBackground}"
                                    CornerRadius="8" Padding="14"
                                    BorderBrush="{DynamicResource ThemeBorder}" BorderThickness="1">
                                <StackPanel>
                                    <TextBlock Text="ðŸ› ï¸ Reparar mi PC" Style="{StaticResource SectionHeading}" FontSize="15"/>

                                    <Border Background="{DynamicResource ThemeInputBackground}"
                                            BorderBrush="{DynamicResource ThemeBorder}"
                                            BorderThickness="1" CornerRadius="6" Padding="8" Margin="4,0,4,8">
                                        <StackPanel>
                                            <TextBlock Text="ðŸŽ¯ Disco a revisar:" FontSize="11"
                                                       Foreground="{DynamicResource ThemeLabelText}" Margin="0,0,0,5"/>
                                            <ComboBox x:Name="cmbRepairDriveBasic" Height="32" Margin="0,0,0,7" FontSize="12"/>
                                            <Button x:Name="btnRefreshDrivesBasic" Content="â†º Actualizar"
                                                    Style="{StaticResource PrimaryButton}" Margin="0" FontSize="12"/>
                                        </StackPanel>
                                    </Border>
                                    <TextBlock x:Name="lblDiskInfoBasic" Text="Detectando discos..." FontSize="11"
                                               Foreground="{DynamicResource ThemeMutedText}" TextWrapping="Wrap"
                                               Margin="4,0,4,8"/>

                                    <TextBlock Text="ðŸ”§ ReparaciÃ³n" Style="{StaticResource SubHeading}"/>
                                    <Button x:Name="btnSfcBasic" Content="Reparar Windows"/>
                                    <Button x:Name="btnDismBasic" Content="Recuperar sistema"/>
                                    <Button x:Name="btnChkDskBasic" Content="Comprobar disco"/>
                                    <Button x:Name="btnDefragBasic" Content="Ordenar disco"/>
                                    <Button x:Name="btnMaxPowerBasic" Content="âš¡ Modo rendimiento"/>

                                    <Border Height="1" Background="{DynamicResource ThemeBorder}" Margin="8,14,8,4" Opacity="0.5"/>

                                    <TextBlock Text="ðŸ§¹ Limpieza" Style="{StaticResource SubHeading}"/>
                                    <Button x:Name="btnTempBasic" Content="Borrar temporales"/>
                                    <Button x:Name="btnDeepCleanBasic" Content="Limpieza completa"/>
                                    <Button x:Name="btnLogCleanBasic" Content="Borrar historial"/>

                                    <Button x:Name="btnFullRepairBasic" Content="âš¡ Reparar todo"
                                            Style="{StaticResource HeroButton}"/>
                                </StackPanel>
                            </Border>

                            <Border Grid.Column="2" Background="{DynamicResource ThemeCardBackground}"
                                    CornerRadius="8" Padding="14"
                                    BorderBrush="{DynamicResource ThemeBorder}" BorderThickness="1">
                                <StackPanel>
                                    <TextBlock Text="ðŸŒ Arreglar Internet" Style="{StaticResource SectionHeading}" FontSize="15"/>
                                    <TextBlock Text="Si las pÃ¡ginas no cargan o el WiFi falla." FontSize="11"
                                               Foreground="{DynamicResource ThemeMutedText}"
                                               TextWrapping="Wrap" Margin="4,0,4,10"/>
                                    <Button x:Name="btnFlushDnsBasic" Content="Arreglar internet"/>
                                    <Button x:Name="btnResetNetBasic" Content="Reiniciar la red"/>
                                    <Button x:Name="btnQoSBasic" Content="ðŸš€ Acelerar red"/>

                                    <Border Height="1" Background="{DynamicResource ThemeBorder}" Margin="8,18,8,4" Opacity="0.35"/>
                                    <TextBlock Text="ðŸ’¡ Consejo" FontSize="11" FontWeight="Bold"
                                               Foreground="{DynamicResource ThemeMutedText}"
                                               Margin="5,0,0,5"/>
                                    <TextBlock Text="Si nada funciona, prueba 'Reiniciar la red'. Algunos cambios requieren reiniciar el equipo."
                                               FontSize="11"
                                               Foreground="{DynamicResource ThemeMutedText}"
                                               TextWrapping="Wrap" Margin="5,0,5,0" LineHeight="17"/>
                                </StackPanel>
                            </Border>
                        </Grid>

                        <!-- â˜… MODO AVANZADO â€” 3 COLUMNAS -->
                        <Grid x:Name="gridAdvanced" Visibility="Collapsed">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="14"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="14"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>

                            <Border Grid.Column="0" Background="{DynamicResource ThemeCardBackground}"
                                    CornerRadius="8" Padding="14"
                                    BorderBrush="{DynamicResource ThemeBorder}" BorderThickness="1">
                                <StackPanel>
                                    <TextBlock Text="ðŸ› ï¸ Sistema y Rendimiento" Style="{StaticResource SectionHeading}"/>
                                    <Border Background="{DynamicResource ThemeInputBackground}"
                                            BorderBrush="{DynamicResource ThemeBorder}"
                                            BorderThickness="1" CornerRadius="6" Padding="7" Margin="4,0,4,8">
                                        <StackPanel>
                                            <TextBlock Text="ðŸŽ¯ Disco objetivo:" FontSize="11"
                                                       Foreground="{DynamicResource ThemeLabelText}" Margin="0,0,0,4"/>
                                            <ComboBox x:Name="cmbRepairDriveAdv" Height="32" Margin="0,0,0,7" FontSize="12"/>
                                            <Button x:Name="btnRefreshDrivesAdv" Content="â†º Actualizar discos"
                                                    Style="{StaticResource PrimaryButton}" Margin="0" FontSize="12"/>
                                        </StackPanel>
                                    </Border>
                                    <TextBlock x:Name="lblDiskInfoAdv" Text="Detectando discos..." FontSize="11"
                                               Foreground="{DynamicResource ThemeMutedText}" TextWrapping="Wrap" Margin="4,0,4,8"/>
                                    <Button x:Name="btnSfcAdv" Content="Ejecutar SFC /Scannow"/>
                                    <Button x:Name="btnDismAdv" Content="Reparar Imagen DISM"/>
                                    <Button x:Name="btnChkDskAdv" Content="Reparar Disco (CHKDSK /f)"/>
                                    <Button x:Name="btnDefragAdv" Content="ðŸ’½ Desfragmentar Unidad"/>
                                    <Button x:Name="btnMaxPowerAdv" Content="âš¡ Activar Alto Rendimiento"/>
                                </StackPanel>
                            </Border>

                            <Border Grid.Column="2" Background="{DynamicResource ThemeCardBackground}"
                                    CornerRadius="8" Padding="14"
                                    BorderBrush="{DynamicResource ThemeBorder}" BorderThickness="1">
                                <StackPanel>
                                    <TextBlock Text="ðŸŒ Red y ConexiÃ³n" Style="{StaticResource SectionHeading}"/>
                                    <Button x:Name="btnFlushDnsAdv" Content="Limpiar CachÃ© DNS"/>
                                    <Button x:Name="btnResetNetAdv" Content="Restablecer Winsock / IP"/>
                                    <Button x:Name="btnQoSAdv" Content="ðŸš€ Configurar QoS a 0%"/>
                                </StackPanel>
                            </Border>

                            <Border Grid.Column="4" Background="{DynamicResource ThemeCardBackground}"
                                    CornerRadius="8" Padding="14"
                                    BorderBrush="{DynamicResource ThemeBorder}" BorderThickness="1">
                                <StackPanel>
                                    <TextBlock Text="ðŸ§¹ Mantenimiento" Style="{StaticResource SectionHeading}"/>
                                    <Button x:Name="btnTempAdv" Content="Limpiar Temporales BÃ¡sicos"/>
                                    <Button x:Name="btnDeepCleanAdv" Content="ðŸ§¹ Limpieza Profunda / WinUpdate"/>
                                    <Button x:Name="btnLogCleanAdv" Content="ðŸ—‘ï¸ Limpiar Logs y WinSxS"/>
                                    <Button x:Name="btnFullRepairAdv" Style="{StaticResource PrimaryButton}"
                                            Content="âš¡ ReparaciÃ³n 1-Clic" Margin="5,12,5,5"/>
                                </StackPanel>
                            </Border>
                        </Grid>
                    </Grid>

                    <!-- ============ RECOMENDACIONES ============ -->
                    <Border Grid.Row="3" Background="{DynamicResource ThemePanelBackground}" CornerRadius="8" Padding="14"
                            Margin="0,14,0,0" BorderBrush="{DynamicResource ThemeBorder}" BorderThickness="1">
                        <StackPanel>
                            <TextBlock Text="ðŸ’¡ Recomendaciones personalizadas" FontSize="14" FontWeight="Bold"
                                       Foreground="{DynamicResource ThemeAccent}" Margin="0,0,0,7"/>
                            <TextBox x:Name="txtRecommendations" Text="Analizando el estado del equipo..."
                                     Height="120" Background="{DynamicResource ThemeInputBackground}"
                                     Foreground="{DynamicResource ThemeMainText}"
                                     BorderBrush="{DynamicResource ThemeBorder}"
                                     IsReadOnly="True" TextWrapping="Wrap"
                                     VerticalScrollBarVisibility="Auto" FontSize="13" Padding="10"
                                     FontFamily="Segoe UI"/>
                        </StackPanel>
                    </Border>

                    <!-- ============ LOG PANEL ============ -->
                    <Border x:Name="logPanel" Grid.Row="4" Background="{DynamicResource ThemePanelBackground}"
                            CornerRadius="8" Padding="12" Margin="0,14,0,0"
                            BorderBrush="{DynamicResource ThemeBorder}" BorderThickness="1" Visibility="Collapsed">
                        <StackPanel>
                            <TextBlock Text="ðŸ“œ Registro de Actividad" FontSize="12" FontWeight="Bold"
                                       Foreground="{DynamicResource ThemeMutedText}" Margin="0,0,0,6"/>
                            <TextBox x:Name="txtLog" Height="130" Background="{DynamicResource ThemeInputBackground}"
                                     Foreground="{DynamicResource ThemeLogForeground}"
                                     BorderBrush="{DynamicResource ThemeBorder}"
                                     FontFamily="Consolas" FontSize="11" IsReadOnly="True"
                                     TextWrapping="Wrap" VerticalScrollBarVisibility="Auto"/>
                        </StackPanel>
                    </Border>

                    <!-- ============ FOOTER ============ -->
                    <Border Grid.Row="5" Background="{DynamicResource ThemePanelBackground}" CornerRadius="8"
                            Padding="8" Margin="0,14,0,0" BorderBrush="{DynamicResource ThemeBorder}" BorderThickness="1">
                        <DockPanel>
                            <StackPanel Orientation="Horizontal" DockPanel.Dock="Right">
                                <Button x:Name="btnDiagnose" Content="ðŸ” Analizar PC" Width="160" Style="{StaticResource ManualButton}"/>
                                <Button x:Name="btnManual" Content="ðŸ“– Manual detallado" Width="180" Style="{StaticResource ManualButton}"/>
                                <Button x:Name="btnRevert" Content="â†© Revertir cambios" Width="180" Style="{StaticResource RevertButton}"/>
                            </StackPanel>
                            <TextBlock Text="Los cambios reversibles se guardan localmente en el equipo."
                                       VerticalAlignment="Center" Foreground="{DynamicResource ThemeMutedText}"
                                       TextWrapping="Wrap" Margin="10,0,12,0" FontSize="12"/>
                        </DockPanel>
                    </Border>
                </Grid>
            </ScrollViewer>
        </Grid>
    </Border>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

# --- Refs comunes ---
$global:MainBorder        = $window.FindName("MainBorder")
$global:TitleBar          = $window.FindName("TitleBar")
$global:DragArea          = $window.FindName("DragArea")
$global:lblAppTitle       = $window.FindName("lblAppTitle")
$global:lblAppVersion     = $window.FindName("lblAppVersion")
$global:lblThemeCaption   = $window.FindName("lblThemeCaption")
$global:btnMin            = $window.FindName("btnMin")
$global:btnMax            = $window.FindName("btnMax")
$global:btnClose          = $window.FindName("btnClose")
$global:txtLog            = $window.FindName("txtLog")
$global:lblStatus         = $window.FindName("lblStatus")
$global:lblPCName         = $window.FindName("lblPCName")
$global:lblWindowsInfo    = $window.FindName("lblWindowsInfo")
$global:lblPowerShellInfo = $window.FindName("lblPowerShellInfo")
$global:lblComponentsInfo = $window.FindName("lblComponentsInfo")
$global:pbJunkLevel       = $window.FindName("pbJunkLevel")
$global:lblJunkPercent    = $window.FindName("lblJunkPercent")
$global:lblJunkDetails    = $window.FindName("lblJunkDetails")
$global:txtRecommendations= $window.FindName("txtRecommendations")
$global:btnDiagnose       = $window.FindName("btnDiagnose")
$global:btnManual         = $window.FindName("btnManual")
$global:btnRevert         = $window.FindName("btnRevert")
$global:cmbTheme          = $window.FindName("cmbTheme")
$global:cmbOmegaColor     = $window.FindName("cmbOmegaColor")
$global:chkAdvanced       = $window.FindName("chkAdvanced")
$global:statsPanel        = $window.FindName("statsPanel")
$global:logPanel          = $window.FindName("logPanel")
$global:gridBasic         = $window.FindName("gridBasic")
$global:gridAdvanced      = $window.FindName("gridAdvanced")

# --- Refs MODO BÃSICO ---
$global:cmbRepairDriveBasic   = $window.FindName("cmbRepairDriveBasic")
$global:btnRefreshDrivesBasic = $window.FindName("btnRefreshDrivesBasic")
$global:lblDiskInfoBasic      = $window.FindName("lblDiskInfoBasic")
$global:btnSfcBasic           = $window.FindName("btnSfcBasic")
$global:btnDismBasic          = $window.FindName("btnDismBasic")
$global:btnChkDskBasic        = $window.FindName("btnChkDskBasic")
$global:btnDefragBasic        = $window.FindName("btnDefragBasic")
$global:btnMaxPowerBasic      = $window.FindName("btnMaxPowerBasic")
$global:btnTempBasic          = $window.FindName("btnTempBasic")
$global:btnDeepCleanBasic     = $window.FindName("btnDeepCleanBasic")
$global:btnLogCleanBasic      = $window.FindName("btnLogCleanBasic")
$global:btnFullRepairBasic    = $window.FindName("btnFullRepairBasic")
$global:btnFlushDnsBasic      = $window.FindName("btnFlushDnsBasic")
$global:btnResetNetBasic      = $window.FindName("btnResetNetBasic")
$global:btnQoSBasic           = $window.FindName("btnQoSBasic")

# --- Refs MODO AVANZADO ---
$global:cmbRepairDriveAdv   = $window.FindName("cmbRepairDriveAdv")
$global:btnRefreshDrivesAdv = $window.FindName("btnRefreshDrivesAdv")
$global:lblDiskInfoAdv      = $window.FindName("lblDiskInfoAdv")
$global:btnSfcAdv           = $window.FindName("btnSfcAdv")
$global:btnDismAdv          = $window.FindName("btnDismAdv")
$global:btnChkDskAdv        = $window.FindName("btnChkDskAdv")
$global:btnDefragAdv        = $window.FindName("btnDefragAdv")
$global:btnMaxPowerAdv      = $window.FindName("btnMaxPowerAdv")
$global:btnTempAdv          = $window.FindName("btnTempAdv")
$global:btnDeepCleanAdv     = $window.FindName("btnDeepCleanAdv")
$global:btnLogCleanAdv      = $window.FindName("btnLogCleanAdv")
$global:btnFullRepairAdv    = $window.FindName("btnFullRepairAdv")
$global:btnFlushDnsAdv      = $window.FindName("btnFlushDnsAdv")
$global:btnResetNetAdv      = $window.FindName("btnResetNetAdv")
$global:btnQoSAdv           = $window.FindName("btnQoSAdv")

# ---------- 4. FUNCIONES AUXILIARES ------------------------------------------
function Write-OmegaLog {
    param([string]$message)
    try {
        if ($null -eq $global:txtLog) { return }
        $timestamp = Get-Date -Format "HH:mm:ss"
        $global:txtLog.Dispatcher.Invoke([Action]{
            $global:txtLog.AppendText("[$timestamp] $message`n")
            $global:txtLog.ScrollToEnd()
        })
    } catch { }
}

function Set-OmegaStatus {
    param([string]$Text)
    try { if ($global:lblStatus) { $global:lblStatus.Text = "Estado: $Text" } } catch { }
}

function Get-ActiveRepairCombo {
    try {
        if ($global:gridAdvanced.Visibility -eq 'Visible') { return $global:cmbRepairDriveAdv }
    } catch { }
    return $global:cmbRepairDriveBasic
}

function Get-ActiveDiskInfoLabel {
    try {
        if ($global:gridAdvanced.Visibility -eq 'Visible') { return $global:lblDiskInfoAdv }
    } catch { }
    return $global:lblDiskInfoBasic
}

# ==============================================================================
# CONVERSOR DE BRUSH â€” SOPORTA SOLID + GRADIENTE VERTICAL (VIA '|')
# ==============================================================================
function ConvertTo-OmegaBrush {
    param($Value)
    if ($null -eq $Value) { return $null }
    if ($Value -is [System.Management.Automation.PSObject]) {
        try { $Value = $Value.PSObject.BaseObject } catch { }
    }
    if ($Value -is [System.Management.Automation.PSObject]) {
        try { $Value = $Value.BaseObject } catch { }
    }
    if ($Value -isnot [string]) { return $null }
    $str = [string]$Value
    if ([string]::IsNullOrWhiteSpace($str)) { return $null }
    $bc = New-Object System.Windows.Media.BrushConverter
    if ($str.Contains('|')) {
        $parts = $str -split '\|'
        $lg = New-Object System.Windows.Media.LinearGradientBrush
        $lg.StartPoint = New-Object System.Windows.Point(0.0, 0.0)
        $lg.EndPoint   = New-Object System.Windows.Point(0.0, 1.0)
        $count = @($parts).Count
        for ($i = 0; $i -lt $count; $i++) {
            $colorStr = "$($parts[$i])".Trim()
            if ([string]::IsNullOrWhiteSpace($colorStr)) { continue }
            if (-not $colorStr.StartsWith('#')) { $colorStr = "#$colorStr" }
            try {
                $c = $bc.ConvertFromString($colorStr)
                if ($null -eq $c) { continue }
                if ($c -is [System.Management.Automation.PSObject]) { $c = $c.PSObject.BaseObject }
                $gs = New-Object System.Windows.Media.GradientStop
                $gs.Color = [System.Windows.Media.Color]$c.Color
                $gs.Offset = $(if ($count -gt 1) { [double]$i / [double]($count - 1) } else { 0.0 })
                [void]$lg.GradientStops.Add($gs)
            } catch { }
        }
        if ($lg.GradientStops.Count -gt 0) {
            try { $lg.Freeze() } catch { }
            return [System.Windows.Media.Brush]$lg
        }
        return $null
    }
    if (-not $str.StartsWith('#')) { $str = "#$str" }
    try {
        $brush = $bc.ConvertFromString($str)
        if ($null -eq $brush) { return $null }
        if ($brush -is [System.Management.Automation.PSObject]) { $brush = $brush.PSObject.BaseObject }
        return [System.Windows.Media.Brush]$brush
    } catch { return $null }
}

function Set-OmegaResourceSafe {
    param($Win, [string]$Key, $Value)
    if ($null -eq $Value -or $null -eq $Win) { return }
    try {
        $v = $Value
        $guard = 0
        while ($v -is [System.Management.Automation.PSObject] -and $guard -lt 3) {
            try {
                $inner = $v.PSObject.BaseObject
                if ($null -eq $inner -or [object]::ReferenceEquals($inner, $v)) { break }
                $v = $inner
            } catch { break }
            $guard++
        }
        if ($v -isnot [System.Windows.Media.Brush]) {
            $converted = ConvertTo-OmegaBrush -Value $v
            if ($null -eq $converted) { return }
            $v = $converted
            if ($v -is [System.Management.Automation.PSObject]) { $v = $v.PSObject.BaseObject }
        }
        $brush = [System.Windows.Media.Brush]$v
        $Win.Resources[$Key] = $brush
    } catch { }
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
    $commands = [ordered]@{ 'SFC'='sfc.exe'; 'DISM'='dism.exe'; 'CHKDSK'='chkdsk.exe'; 'PowerCfg'='powercfg.exe'; 'Netsh'='netsh.exe'; 'IPConfig'='ipconfig.exe'; 'CleanMgr'='cleanmgr.exe'; 'Defrag'='dfrgui.exe' }
    foreach ($key in $commands.Keys) { $sysProfile.Components[$key] = [bool](Get-Command $commands[$key] -ErrorAction SilentlyContinue) }
    $sysProfile.Components['WPF'] = $true
    return [pscustomobject]$sysProfile
}

function Initialize-OmegaSystemProfile {
    param([object]$SysProfile)
    try { $global:lblPCName.Text = "ðŸ”¹ $($SysProfile.ComputerName)" } catch { }
    $edition = if ($SysProfile.PowerShellEdition -eq 'Core') { 'Core' } else { 'Desktop' }
    try { $global:lblPowerShellInfo.Text = "$($SysProfile.PowerShellVersion) ($edition)" } catch { }
    $winVersion = if ($SysProfile.WindowsDisplayVersion) { $SysProfile.WindowsDisplayVersion } elseif ($SysProfile.WindowsVersion) { $SysProfile.WindowsVersion } else { 'versiÃ³n desconocida' }
    $buildText = if ($SysProfile.WindowsBuild) { "Build $($SysProfile.WindowsBuild)" } else { '' }
    try { $global:lblWindowsInfo.Text = "$($SysProfile.WindowsName) $winVersion $buildText".Trim() } catch { }
    $available = @($SysProfile.Components.GetEnumerator() | Where-Object { $_.Value } | ForEach-Object { $_.Key })
    $missing = @($SysProfile.Components.GetEnumerator() | Where-Object { -not $_.Value } | ForEach-Object { $_.Key })
    try {
        if ($missing.Count -eq 0) {
            $global:lblComponentsInfo.Text = "âœ… Listo Â· $($available -join ', ')"
            $global:lblComponentsInfo.Foreground = [System.Windows.Media.Brushes]::LightGreen
        } else {
            $global:lblComponentsInfo.Text = "âš ï¸ Faltan: $($missing -join ', ')"
            $global:lblComponentsInfo.Foreground = [System.Windows.Media.Brushes]::Khaki
        }
    } catch { }
    Write-OmegaLog "ðŸ’» Equipo: $($SysProfile.ComputerName) Â· $($SysProfile.WindowsName) Â· PS $($SysProfile.PowerShellVersion)."
}

# â˜… PARCHED: EnumeraciÃ³n rÃ¡pida con DirectoryInfo (evita Get-Item por archivo)
function Get-OmegaFolderSizeBytes {
    param([string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path) -or -not (Test-Path -LiteralPath $Path)) { return [int64]0 }
    [int64]$sum = 0
    try {
        $di = New-Object System.IO.DirectoryInfo($Path)
        foreach ($file in $di.EnumerateFiles('*', [System.IO.SearchOption]::AllDirectories)) {
            try { $sum += [int64]$file.Length } catch { }
        }
    } catch { }
    return $sum
}

function Get-OmegaSmartDiagnostics {
    $paths = [ordered]@{
        'Temporales de usuario'        = $env:TEMP
        'Temporales de Windows'        = Join-Path $env:SystemRoot 'Temp'
        'Descargas Windows Update'     = Join-Path $env:SystemRoot 'SoftwareDistribution\Download'
        'Cache Delivery Optimization'  = Join-Path $env:SystemRoot 'ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache'
        'Cache Edge'                   = Join-Path $env:LOCALAPPDATA 'Microsoft\Edge\User Data\Default\Cache'
        'Cache Chrome'                 = Join-Path $env:LOCALAPPDATA 'Google\Chrome\User Data\Default\Cache'
    }
    [int64]$junkBytes = 0
    foreach ($entry in $paths.GetEnumerator()) {
        if (-not [string]::IsNullOrWhiteSpace($entry.Value)) {
            $junkBytes += Get-OmegaFolderSizeBytes -Path $entry.Value
        }
    }
    $systemDisk = $null
    try { $systemDisk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='$($env:SystemDrive)'" -ErrorAction Stop } catch { }
    $totalBytes = if ($systemDisk -and $systemDisk.Size) { [int64]$systemDisk.Size } else { [int64]0 }
    $freeBytes  = if ($systemDisk -and $systemDisk.FreeSpace) { [int64]$systemDisk.FreeSpace } else { [int64]0 }
    $freePct = $(if ($totalBytes -gt 0) { [math]::Round(($freeBytes / $totalBytes) * 100, 1) } else { $null })
    $junkLevel = [math]::Min(100, [math]::Round(($junkBytes / 5GB) * 100, 0))
    $junkGB = [math]::Round($junkBytes / 1GB, 2)
    $batteryState = 'Desktop/CA'
    try {
        $battery = @(Get-CimInstance Win32_Battery -ErrorAction Stop)
        if ($battery.Count -gt 0) {
            $discharging = $battery | Where-Object { $_.BatteryStatus -eq 1 }
            $batteryState = $(if ($discharging) { 'En baterÃ­a' } else { 'Con corriente' })
        }
    } catch { }
    $recommendations = [System.Collections.Generic.List[string]]::new()
    if ($freePct -ne $null -and $freePct -lt 15) { [void]$recommendations.Add('Espacio libre bajo en el disco del sistema. Prioriza liberar espacio.') }
    elseif ($freePct -ne $null -and $freePct -lt 25) { [void]$recommendations.Add('El espacio libre esta algo reducido; una limpieza puede ayudar.') }
    if ($junkGB -ge 1) { [void]$recommendations.Add("Se detectan ~$junkGB GB en temporales/caches.") }
    else { [void]$recommendations.Add('Poco contenido temporal; no es urgente limpiar.') }
    if ($junkGB -ge 3) { [void]$recommendations.Add('La Limpieza Profunda puede recuperar mas espacio.') }
    if ($batteryState -eq 'En bateria') { [void]$recommendations.Add('Con bateria: Alto Rendimiento es opcional y aumenta consumo.') }
    else { [void]$recommendations.Add('Alto Rendimiento disponible para priorizar velocidad.') }
    [pscustomobject]@{
        JunkBytes       = $junkBytes
        JunkGB          = $junkGB
        JunkLevel       = $junkLevel
        FreePct         = $freePct
        FreeGB          = $(if ($freeBytes) { [math]::Round($freeBytes / 1GB, 1) } else { $null })
        TotalGB         = $(if ($totalBytes) { [math]::Round($totalBytes / 1GB, 1) } else { $null })
        BatteryState    = $batteryState
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
        $global:lblJunkDetails.Text = 'Calculando tamaÃ±o aproximado...'
        $diag = Get-OmegaSmartDiagnostics
        $global:pbJunkLevel.Value = [double]$diag.JunkLevel
        Set-OmegaProgressAppearance -Value $diag.JunkLevel
        $freeText = if ($null -ne $diag.FreePct) { "$($diag.FreePct)% libres ($($diag.FreeGB)/$($diag.TotalGB) GB)" } else { 'no disponible' }
        $global:lblJunkPercent.Text = "$($diag.JunkLevel)% Â· nivel orientativo"
        $global:lblJunkDetails.Text = "Temporales/cachÃ©s: $($diag.JunkGB) GB.`nDisco: $freeText.`nEnergÃ­a: $($diag.BatteryState)."
        $global:txtRecommendations.Text = ($diag.Recommendations -join "`n")
        Write-OmegaLog "ðŸ” DiagnÃ³stico: $($diag.JunkGB) GB Â· $($diag.JunkLevel)% Â· $freeText."
    } catch {
        $global:pbJunkLevel.Value = 0
        $global:lblJunkPercent.Text = 'DiagnÃ³stico no disponible'
        $global:lblJunkDetails.Text = $_.Exception.Message
        $global:txtRecommendations.Text = 'No se pudo completar el anÃ¡lisis.'
        Write-OmegaLog "âš ï¸ DiagnÃ³stico no completado: $($_.Exception.Message)"
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
                Display="$drive â€” $role â€” $label ($freeGB/$sizeGB GB)"
                VolumeName=$label; SizeGB=$sizeGB; FreeGB=$freeGB
            }
        }
    } catch { Write-OmegaLog "âš ï¸ No se detectaron discos: $($_.Exception.Message)" }
    return $results
}

function Get-SelectedOmegaDriveInfo {
    $combo = Get-ActiveRepairCombo
    if (-not $combo -or -not $combo.SelectedItem) { return $null }
    return $combo.SelectedItem.Tag
}

# â˜… PARCHED: Cacheo de tipo SSD/HDD por letra de unidad
function Get-OmegaDriveMediaType {
    param([string]$DriveLetter)
    $key = $DriveLetter.TrimEnd(':').ToUpperInvariant()
    if ($script:OmegaMediaTypeCache.ContainsKey($key)) {
        return $script:OmegaMediaTypeCache[$key]
    }
    $result = 'Unknown'
    try {
        $partition = Get-Partition -DriveLetter $key -ErrorAction Stop
        $physicalDisk = Get-PhysicalDisk -DeviceNumber $partition.DiskNumber -ErrorAction Stop
        switch ($physicalDisk.MediaType) {
            'SSD' { $result = 'SSD' }
            'HDD' { $result = 'HDD' }
            default { $result = 'Unknown' }
        }
    } catch {
        try {
            $partQuery = "ASSOCIATORS OF {Win32_LogicalDisk.DeviceID='$($key):'} WHERE AssocClass=Win32_LogicalDiskToPartition"
            $partitions = @(Get-WmiObject -Query $partQuery -ErrorAction Stop)
            foreach ($part in $partitions) {
                $diskQuery = "ASSOCIATORS OF {Win32_DiskPartition.DeviceID='$($part.DeviceID)'} WHERE AssocClass=Win32_DiskDriveToDiskPartition"
                $disks = @(Get-WmiObject -Query $diskQuery -ErrorAction Stop)
                foreach ($disk in $disks) {
                    if ($disk.MediaType -match 'SSD') { $result = 'SSD'; break }
                    if ($disk.MediaType -match 'Fixed hard disk') { $result = 'HDD'; break }
                }
                if ($result -ne 'Unknown') { break }
            }
        } catch { }
    }
    $script:OmegaMediaTypeCache[$key] = $result
    return $result
}

function Update-OmegaRepairDriveState {
    try {
        $info = Get-SelectedOmegaDriveInfo
        $lblInfo = Get-ActiveDiskInfoLabel
        $btnDefrag = $(if ($global:gridAdvanced.Visibility -eq 'Visible') { $global:btnDefragAdv } else { $global:btnDefragBasic })
        $btnSfc    = $(if ($global:gridAdvanced.Visibility -eq 'Visible') { $global:btnSfcAdv }    else { $global:btnSfcBasic })
        $btnDism   = $(if ($global:gridAdvanced.Visibility -eq 'Visible') { $global:btnDismAdv }   else { $global:btnDismBasic })
        $btnChkDsk = $(if ($global:gridAdvanced.Visibility -eq 'Visible') { $global:btnChkDskAdv } else { $global:btnChkDskBasic })

        if (-not $info) {
            $lblInfo.Text = "No hay unidad seleccionada."
            $btnSfc.IsEnabled = $false; $btnDism.IsEnabled = $false; $btnChkDsk.IsEnabled = $false
            $btnDefrag.IsEnabled = $false
            $btnDefrag.Content = "ðŸ’½ Ordenar (Sin unidad)"
            return
        }
        if ($info.IsSystemDrive) {
            $lblInfo.Text = "$($info.Drive): Windows activo. SFC/DISM en modo Online."
            $btnSfc.IsEnabled  = [bool]$script:OmegaSystemProfile.Components['SFC']
            $btnDism.IsEnabled = [bool]$script:OmegaSystemProfile.Components['DISM']
        } elseif ($info.HasWindows) {
            $lblInfo.Text = "$($info.Drive): Windows offline. SFC/DISM en modo Offline."
            $btnSfc.IsEnabled  = [bool]$script:OmegaSystemProfile.Components['SFC']
            $btnDism.IsEnabled = [bool]$script:OmegaSystemProfile.Components['DISM']
        } else {
            $lblInfo.Text = "$($info.Drive): datos. Solo CHKDSK aplica."
            $btnSfc.IsEnabled = $false; $btnDism.IsEnabled = $false
        }
        $btnChkDsk.IsEnabled = [bool]$script:OmegaSystemProfile.Components['CHKDSK']

        $isAdvanced = $global:gridAdvanced.Visibility -eq 'Visible'
        $mediaType = Get-OmegaDriveMediaType -DriveLetter $info.Drive
        switch ($mediaType) {
            'HDD' {
                $btnDefrag.IsEnabled = $true
                $btnDefrag.Content = $(if ($isAdvanced) { "ðŸ’½ Desfragmentar Unidad" } else { "Ordenar disco" })
                $btnDefrag.ToolTip = "Optimizar $($info.Drive) (HDD detectado)."
                Write-OmegaLog "ðŸ’½ $($info.Drive) detectado como HDD. OptimizaciÃ³n habilitada."
            }
            'SSD' {
                $btnDefrag.IsEnabled = $false
                $btnDefrag.Content = $(if ($isAdvanced) { "ðŸ’½ Desfragmentar (SSD - Bloqueado)" } else { "Ordenar disco (SSD - Bloqueado)" })
                $btnDefrag.ToolTip = "Bloqueado por seguridad: $($info.Drive) es un SSD."
                Write-OmegaLog "ðŸ›¡ï¸ $($info.Drive) detectado como SSD. OptimizaciÃ³n bloqueada."
            }
            default {
                $btnDefrag.IsEnabled = $false
                $btnDefrag.Content = $(if ($isAdvanced) { "ðŸ’½ Desfragmentar (No detectado)" } else { "Ordenar disco (No detectado)" })
                $btnDefrag.ToolTip = "No se pudo determinar el tipo de disco."
            }
        }
    } catch { }
}

function Refresh-OmegaRepairDrives {
    try {
        $script:OmegaMediaTypeCache = @{}   # â˜… Limpiar cachÃ© al refrescar discos
        $driveInfos = @(Get-OmegaRepairDrives)
        foreach ($combo in @($global:cmbRepairDriveBasic, $global:cmbRepairDriveAdv)) {
            if ($null -eq $combo) { continue }
            $combo.Items.Clear()
            foreach ($info in $driveInfos) {
                $item = New-Object System.Windows.Controls.ComboBoxItem
                $item.Content = $info.Display
                $item.Tag = $info
                [void]$combo.Items.Add($item)
            }
            if ($driveInfos.Count -gt 0) {
                $systemIndex = 0
                for ($i = 0; $i -lt $driveInfos.Count; $i++) {
                    if ($driveInfos[$i].IsSystemDrive) { $systemIndex = $i; break }
                }
                $combo.SelectedIndex = $systemIndex
            }
        }
        if ($driveInfos.Count -eq 0) {
            try { $global:lblDiskInfoBasic.Text = "No se detectaron unidades." } catch { }
            try { $global:lblDiskInfoAdv.Text = "No se detectaron unidades." } catch { }
            return
        }
        Update-OmegaRepairDriveState
        Write-OmegaLog "Discos detectados: $($driveInfos.Count)."
    } catch {
        Write-OmegaLog "Error detectando discos: $($_.Exception.Message)"
    }
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
        if ($current) { $script:OmegaState.PowerPlan.OriginalSchemeGuid = $current; Write-OmegaLog "â†³ Plan original guardado." }
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
    Write-OmegaLog "â†³ Estado reversible guardado."
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
    if (-not $DriveInfo -or -not $DriveInfo.HasWindows) { Write-OmegaLog "âš ï¸ SFC no aplica."; return $null }
    if ($DriveInfo.IsSystemDrive) {
        Write-OmegaLog "ðŸ› ï¸ SFC: reparando Windows activo..."
        return Start-Process -FilePath "cmd.exe" -ArgumentList @('/c', 'sfc /scannow') -WindowStyle Hidden -PassThru
    } else {
        Write-OmegaLog "ðŸ› ï¸ SFC: reparando Windows offline..."
        return Start-Process -FilePath "cmd.exe" -ArgumentList @('/c', "sfc /scannow /offbootdir=$($DriveInfo.Root) /offwindir=$($DriveInfo.Root)Windows") -WindowStyle Hidden -PassThru
    }
}

function Start-OmegaDismRepair {
    param([object]$DriveInfo)
    if (-not $DriveInfo -or -not $DriveInfo.HasWindows) { Write-OmegaLog "âš ï¸ DISM no aplica."; return $null }
    if ($DriveInfo.IsSystemDrive) {
        Write-OmegaLog "ðŸ› ï¸ DISM: reparando imagen activa..."
        return Start-Process -FilePath "cmd.exe" -ArgumentList @('/c', 'DISM /Online /Cleanup-Image /RestoreHealth') -WindowStyle Hidden -PassThru
    } else {
        Write-OmegaLog "ðŸ› ï¸ DISM: reparando imagen offline..."
        return Start-Process -FilePath "cmd.exe" -ArgumentList @('/c', "DISM /Image:$($DriveInfo.Root) /Cleanup-Image /RestoreHealth") -WindowStyle Hidden -PassThru
    }
}

function Start-OmegaChkdskRepair {
    param([object]$DriveInfo)
    if (-not $DriveInfo) { return $null }
    Write-OmegaLog "ðŸ’¾ CHKDSK: comprobando $($DriveInfo.Drive)..."
    return Start-Process -FilePath "cmd.exe" -ArgumentList @('/c', "chkdsk $($DriveInfo.Drive) /f") -WindowStyle Hidden -PassThru
}

function Start-BasicTempCleanup {
    Write-OmegaLog "[+] Limpiando archivos temporales bÃ¡sicos..."
    try {
        Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:SystemRoot\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-OmegaLog "âœ… Temporales bÃ¡sicos eliminados."
    } catch {
        Write-OmegaLog "âš ï¸ Error: $($_.Exception.Message)"
    }
    return $null
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
    return Start-Process DISM.exe -ArgumentList "/Online /Cleanup-Image /StartComponentCleanup /ResetBase" -WindowStyle Hidden -PassThru
}

function Start-DeepCleaningRoutine {
    Save-ReversibleStateBeforeDeepClean
    Write-OmegaLog "[+] Desactivando hibernaciÃ³n..."
    powercfg -h off | Out-Null
    Write-OmegaLog "[+] Deteniendo servicios..."
    Stop-Service -Name wuauserv, FontCache, UsoSvc -Force -ErrorAction SilentlyContinue
    Write-OmegaLog "[+] Limpiando cachÃ©s y temporales..."
    Remove-Item -Path "$env:SystemRoot\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SystemRoot\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SystemRoot\ServiceProfiles\LocalService\AppData\Local\FontCache\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SystemRoot\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SystemDrive\Config.Msi" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SystemDrive\AMD" -Recurse -Force -ErrorAction SilentlyContinue
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    Restore-OmegaServiceStates
    if ($script:OmegaSystemProfile.Components['CleanMgr']) {
        return Start-Process cleanmgr.exe -ArgumentList "/sagerun:1" -WindowStyle Hidden -PassThru
    }
    return $null
}

function Start-OmegaRevertChanges {
    if (-not (Confirm-OmegaAction -Title "Revertir Cambios" -Message "Â¿Restaurar las configuraciones guardadas de energÃ­a, QoS y servicios?")) { return $null }
    Write-OmegaLog "[+] Revirtiendo cambios..."
    try {
        if (-not [string]::IsNullOrWhiteSpace($script:OmegaState.PowerPlan.OriginalSchemeGuid)) {
            powercfg -setactive $script:OmegaState.PowerPlan.OriginalSchemeGuid | Out-Null
            Write-OmegaLog "â†© Plan de energÃ­a restaurado."
        }
        $regPath = $script:OmegaState.QoS.RegistryPath
        if (Test-Path $regPath) {
            if ($script:OmegaState.QoS.OriginalValueExists -and $null -ne $script:OmegaState.QoS.OriginalValue) {
                Set-ItemProperty -Path $regPath -Name "NonBestEffortLimit" -Value $script:OmegaState.QoS.OriginalValue -Type DWord
                Write-OmegaLog "â†© QoS restaurado."
            } else {
                Remove-ItemProperty -Path $regPath -Name "NonBestEffortLimit" -ErrorAction SilentlyContinue
                Write-OmegaLog "â†© QoS eliminado."
            }
        }
        if ($script:OmegaState.FastStartup.OriginalHibernationEnabled -eq $true) {
            powercfg -h on | Out-Null
            Write-OmegaLog "â†© HibernaciÃ³n reactivada."
        }
        Restore-OmegaServiceStates
        Write-OmegaLog "âœ… RestauraciÃ³n completada."
    } catch {
        Write-OmegaLog "âš ï¸ Error: $($_.Exception.Message)"
    }
    return $null
}

# ==============================================================================
# MANUAL â€” BILINGÃœE Y ADAPTATIVO
# ==============================================================================
function Show-OmegaManual {
    $currentTheme = [string]$global:cmbTheme.SelectedItem
    if (-not $currentTheme) { $currentTheme = "Spotify Neon" }
    $palette = $null
    if ($currentTheme -eq 'OMEGASOLVER style') {
        $subColor = [string]$global:cmbOmegaColor.SelectedItem
        if ($subColor -and $script:OmegaSolverPalettes.Contains($subColor)) {
            $palette = $script:OmegaSolverPalettes[$subColor]
        }
    }
    if (-not $palette) { $palette = $script:OmegaThemes[$currentTheme] }
    $isAdvanced = [bool]$global:chkAdvanced.IsChecked

    if ($isAdvanced) {
        $esItems = @(
            'H|ðŸ› ï¸  SISTEMA Y RENDIMIENTO',
            'I|SFC /Scannow|Ejecuta System File Checker para verificar y reparar archivos del sistema corruptos.',
            'I|DISM /RestoreHealth|Repara la imagen de Windows vÃ­a Windows Update usando el componente store.',
            'I|CHKDSK /f|Verifica la integridad del sistema de archivos NTFS y repara errores lÃ³gicos del volumen.',
            'I|Desfragmentar|Optimiza la tabla MFT y reorganiza clusters. Solo HDD; bloqueado en SSD por TRIM.',
            'I|Alto Rendimiento|Cambia el power plan activo al GUID de mÃ¡ximo rendimiento (powercfg /setactive).',
            'H|ðŸŒ  RED Y CONEXIÃ“N',
            'I|CachÃ© DNS|Ejecuta ipconfig /flushdns para limpiar el resolver cache del sistema.',
            'I|Winsock / IP|Ejecuta netsh winsock reset para reiniciar la pila TCP/IP completa.',
            'I|QoS|Establece NonBestEffortLimit=0 en HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched.',
            'H|ðŸ§¹  MANTENIMIENTO',
            'I|Temporales|Purga recursivamente %TEMP% y %SystemRoot%\Temp.',
            'I|Limpieza Profunda|Purga SoftwareDistribution\Download, DeliveryOptimization y cachÃ©s de navegadores.',
            'I|Logs y WinSxS|VacÃ­a EventLogs vÃ­a EventLogSession y ejecuta DISM /StartComponentCleanup /ResetBase.',
            'I|ReparaciÃ³n 1-Clic|Cadena automatizada: limpieza bÃ¡sica â†’ flushdns â†’ SFC â†’ DISM.',
            'H|ðŸŽ¨  TEMAS Y MODOS',
            'I|Layout adaptativo|BÃ¡sico usa 2 columnas; Avanzado usa 3 columnas.',
            'I|OMEGASOLVER style|Tema alienÃ­gena con 6 sub-paletas neÃ³n inspiradas en Murder Drones.',
            'I|Gradiente real|El sub-color "Uzi Post-Cyn" usa LinearGradientBrush vertical.',
            'H|ðŸ”’  SEGURIDAD',
            'I|ProtecciÃ³n SSD|Se bloquea dfrgui.exe en unidades con MediaType=SSD.',
            'I|Persistencia|Estado reversible en %ProgramData%\OmegaSolver\reversible-state.json.'
        )
        $enItems = @(
            'H|ðŸ› ï¸  SYSTEM &amp; PERFORMANCE',
            'I|SFC /Scannow|Runs System File Checker to verify and repair corrupted system files.',
            'I|DISM /RestoreHealth|Repairs the Windows image via Windows Update component store.',
            'I|CHKDSK /f|Verifies NTFS file system integrity and repairs logical volume errors.',
            'I|Defragment|Optimizes MFT table and reorders clusters. HDD only; blocked on SSD.',
            'I|High Performance|Switches active power plan to the max-performance GUID.',
            'H|ðŸŒ  NETWORK &amp; CONNECTION',
            'I|DNS Cache|Runs ipconfig /flushdns to clear the system resolver cache.',
            'I|Winsock / IP|Runs netsh winsock reset to restart the full TCP/IP stack.',
            'I|QoS|Sets NonBestEffortLimit=0 in HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched.',
            'H|ðŸ§¹  MAINTENANCE',
            'I|Temporary Files|Recursively purges %TEMP% and %SystemRoot%\Temp.',
            'I|Deep Clean|Purges SoftwareDistribution\Download, DeliveryOptimization and browser caches.',
            'I|Logs &amp; WinSxS|Clears EventLogs via EventLogSession and runs DISM /StartComponentCleanup /ResetBase.',
            'I|1-Click Repair|Automated chain: basic cleanup â†’ flushdns â†’ SFC â†’ DISM.',
            'H|ðŸŽ¨  THEMES &amp; MODES',
            'I|Adaptive layout|Basic uses 2 columns; Advanced uses 3 columns.',
            'I|OMEGASOLVER style|Alien theme with 6 neon sub-palettes inspired by Murder Drones.',
            'I|Real Gradient|The "Uzi Post-Cyn" sub-color uses a vertical LinearGradientBrush.',
            'H|ðŸ”’  SAFETY',
            'I|SSD Protection|dfrgui.exe is blocked on drives with MediaType=SSD.',
            'I|Persistence|Reversible state stored in %ProgramData%\OmegaSolver\reversible-state.json.'
        )
    } else {
        $esItems = @(
            'H|ðŸ› ï¸  REPARAR MI PC',
            'I|Reparar Windows|Escanea y repara automÃ¡ticamente los archivos daÃ±ados del sistema.',
            'I|Recuperar sistema|Restaura las piezas internas de Windows que estÃ©n rotas o faltantes.',
            'I|Comprobar disco|Revisa que tu disco duro no tenga errores escondidos.',
            'I|Ordenar disco|Organiza los archivos para que el equipo vaya mÃ¡s rÃ¡pido (solo HDD).',
            'I|Modo rÃ¡pido|Ajusta tu PC para que trabaje a la mÃ¡xima velocidad posible.',
            'H|ðŸ§¹  LIMPIEZA',
            'I|Borrar temporales|Elimina los archivos basura que se van acumulando con el tiempo.',
            'I|Limpieza completa|Barre a fondo las cachÃ©s de Windows, actualizaciones y navegadores.',
            'I|Borrar historial|Elimina los archivos de registro del sistema que ya no sirven.',
            'I|Reparar todo|Hace todo el mantenimiento automÃ¡ticamente con un solo clic.',
            'H|ðŸŒ  ARREGLAR INTERNET',
            'I|Arreglar internet|Borra la memoria temporal de internet para que las webs carguen bien.',
            'I|Reiniciar la red|Restaura la conexiÃ³n a internet del equipo por si estÃ¡ fallando.',
            'I|Acelerar red|Libera el ancho de banda que Windows se reserva sin que lo sepas.',
            'H|ðŸŽ¨  TEMAS Y MODOS',
            'I|Temas visuales|Elige entre 18 estilos de color distintos para la interfaz.',
            'I|Modo avanzado|Activa 3 columnas con informaciÃ³n tÃ©cnica mÃ¡s detallada.',
            'H|ðŸ”’  SEGURIDAD',
            'I|ProtecciÃ³n SSD|El programa evita daÃ±ar la vida Ãºtil de los discos SSD automÃ¡ticamente.',
            'I|Todo reversible|Todos los cambios se pueden deshacer desde "Deshacer cambios".'
        )
        $enItems = @(
            'H|ðŸ› ï¸  REPAIR MY PC',
            'I|Repair Windows|Scans and automatically repairs damaged system files.',
            'I|Recover System|Restores broken or missing internal Windows components.',
            'I|Check Disk|Verifies your hard drive has no hidden errors.',
            'I|Order Disk|Organizes files to make your PC faster (HDD only).',
            'I|Fast Mode|Tunes your PC to work at maximum speed.',
            'H|ðŸ§¹  CLEANUP',
            'I|Delete Temporary Files|Removes junk files that accumulate over time.',
            'I|Full Cleanup|Deep sweeps Windows caches, updates and browsers.',
            'I|Clear Logs|Removes old system log files that are no longer needed.',
            'I|Repair All|Performs all maintenance automatically with a single click.',
            'H|ðŸŒ  FIX INTERNET',
            'I|Fix Internet|Clears temporary internet memory so websites load properly.',
            'I|Restart Network|Restores your internet connection in case it is failing.',
            'I|Speed Up Network|Releases the bandwidth Windows reserves without you knowing.',
            'H|ðŸŽ¨  THEMES &amp; MODES',
            'I|Visual Themes|Choose from 18 different color styles for the interface.',
            'I|Advanced Mode|Enables 3 columns with more detailed technical information.',
            'H|ðŸ”’  SAFETY',
            'I|SSD Protection|The program prevents damaging your SSD lifespan automatically.',
            'I|Fully Reversible|All changes can be easily undone via "Undo Changes".'
        )
    }

    $manualXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Manual de Usuario Â· User Manual"
        Height="820" Width="1180"
        WindowStartupLocation="CenterOwner"
        ResizeMode="NoResize"
        WindowStyle="None"
        AllowsTransparency="True"
        Background="Transparent">
    <Border Background="{DynamicResource ManualPanelBg}"
            BorderBrush="{DynamicResource ManualAccent}"
            BorderThickness="2"
            CornerRadius="12">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="95"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="65"/>
            </Grid.RowDefinitions>

            <Border Grid.Row="0" Background="{DynamicResource ManualAccent}" CornerRadius="10,10,0,0">
                <Grid>
                    <StackPanel Orientation="Horizontal" VerticalAlignment="Center" Margin="35,0,0,0">
                        <TextBlock Text="ðŸ“–" FontSize="44" Foreground="White" Margin="0,0,20,0" VerticalAlignment="Center"/>
                        <StackPanel VerticalAlignment="Center">
                            <TextBlock Text="Manual de Usuario Â· User Manual" FontSize="24" FontWeight="Bold" Foreground="White"/>
                            <TextBlock x:Name="lblManualMode" Text="OmegaSolver V4.1 ALT" FontSize="13" Foreground="White" Opacity="0.85"/>
                        </StackPanel>
                    </StackPanel>
                    <Button x:Name="btnManualX" Content="âœ•" HorizontalAlignment="Right" VerticalAlignment="Top"
                            Width="42" Height="42" Margin="0,8,10,0" FontSize="18" FontWeight="Bold"
                            Foreground="White" Background="Transparent" BorderThickness="0"
                            Cursor="Hand" ToolTip="Cerrar / Close"/>
                </Grid>
            </Border>

            <Border Grid.Row="1" Background="{DynamicResource ManualCardBg}" Padding="22,10">
                <TextBlock x:Name="lblModeBadge" FontSize="12" FontWeight="SemiBold"
                           Foreground="{DynamicResource ManualAccent}" HorizontalAlignment="Center"/>
            </Border>

            <Grid Grid.Row="2" Margin="22,14,22,14">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="18"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>

                <Border Grid.Column="0" Background="{DynamicResource ManualCardBg}"
                        BorderBrush="{DynamicResource ManualBorder}" BorderThickness="1"
                        CornerRadius="8" Padding="18">
                    <ScrollViewer VerticalScrollBarVisibility="Auto" Padding="0,0,8,0">
                        <StackPanel>
                            <TextBlock Text="ðŸ‡ªðŸ‡¸  ESPAÃ‘OL" FontSize="17" FontWeight="Bold"
                                       Foreground="{DynamicResource ManualAccent}" Margin="0,0,0,14"/>
                            <StackPanel x:Name="stackEs"/>
                        </StackPanel>
                    </ScrollViewer>
                </Border>

                <Border Grid.Column="2" Background="{DynamicResource ManualCardBg}"
                        BorderBrush="{DynamicResource ManualBorder}" BorderThickness="1"
                        CornerRadius="8" Padding="18">
                    <ScrollViewer VerticalScrollBarVisibility="Auto" Padding="0,0,8,0">
                        <StackPanel>
                            <TextBlock Text="ðŸ‡ºðŸ‡¸  ENGLISH" FontSize="17" FontWeight="Bold"
                                       Foreground="{DynamicResource ManualAccent}" Margin="0,0,0,14"/>
                            <StackPanel x:Name="stackEn"/>
                        </StackPanel>
                    </ScrollViewer>
                </Border>
            </Grid>

            <Border Grid.Row="3" Background="{DynamicResource ManualCardBg}" CornerRadius="0,0,10,10" Padding="25,0">
                <Grid>
                    <TextBlock Text="â„¹  InformaciÃ³n aplicable a la versiÃ³n actual. Â· Info applies to the current version."
                               FontSize="11" Foreground="{DynamicResource ManualMuted}"
                               VerticalAlignment="Center" HorizontalAlignment="Left"/>
                    <Button x:Name="btnManualClose" Content="Cerrar Â· Close" Width="160" Height="36"
                            HorizontalAlignment="Right" FontSize="12" FontWeight="Bold"
                            Background="{DynamicResource ManualAccent}" Foreground="White"
                            BorderThickness="0" Cursor="Hand"/>
                </Grid>
            </Border>
        </Grid>
    </Border>
</Window>
"@

    $mw = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader ([xml]$manualXaml)))

    Set-OmegaResourceSafe -Win $mw -Key "ManualPanelBg" -Value $palette.PanelBg
    Set-OmegaResourceSafe -Win $mw -Key "ManualCardBg"  -Value $palette.CardBg
    Set-OmegaResourceSafe -Win $mw -Key "ManualAccent"  -Value $palette.Accent
    Set-OmegaResourceSafe -Win $mw -Key "ManualText"    -Value $palette.MainText
    Set-OmegaResourceSafe -Win $mw -Key "ManualMuted"   -Value $palette.MutedText
    Set-OmegaResourceSafe -Win $mw -Key "ManualBorder"  -Value $palette.Border

    if ($isAdvanced) {
        $mw.FindName("lblManualMode").Text = "OmegaSolver V4.1 ALT Â· Advanced Mode / Modo Avanzado"
        $mw.FindName("lblModeBadge").Text  = "ðŸ”§  Layout de 3 columnas Â· 3-column layout"
    } else {
        $mw.FindName("lblManualMode").Text = "OmegaSolver V4.1 ALT Â· Basic Mode / Modo BÃ¡sico"
        $mw.FindName("lblModeBadge").Text  = "ðŸ’¡  Layout simplificado de 2 columnas Â· Simplified 2-column layout"
    }

    function Add-ManualContent {
        param($StackPanel, $Items, $AccentB, $TextB, $MutedB)
        foreach ($raw in $Items) {
            $parts = $raw -split '\|'
            $type = $parts[0]
            if ($type -eq 'H') {
                $tb = New-Object System.Windows.Controls.TextBlock
                $tb.Text = $parts[1]; $tb.FontSize = 13.5; $tb.FontWeight = 'Bold'
                $tb.Foreground = $AccentB
                $tb.Margin = New-Object System.Windows.Thickness(0,14,0,8)
                $tb.TextWrapping = 'Wrap'
                [void]$StackPanel.Children.Add($tb)
            } elseif ($type -eq 'I') {
                $label = $parts[1]; $desc = $parts[2]
                $tb = New-Object System.Windows.Controls.TextBlock
                $tb.FontSize = 11.5; $tb.LineHeight = 20; $tb.TextWrapping = 'Wrap'
                $tb.Margin = New-Object System.Windows.Thickness(0,0,0,6)
                $r1 = New-Object System.Windows.Documents.Run('â€¢ ')
                $r1.Foreground = $AccentB; $r1.FontWeight = 'Bold'
                $r2 = New-Object System.Windows.Documents.Run("$label â€” ")
                $r2.Foreground = $TextB; $r2.FontWeight = 'Bold'
                $r3 = New-Object System.Windows.Documents.Run($desc)
                $r3.Foreground = $MutedB
                $tb.Inlines.Add($r1); $tb.Inlines.Add($r2); [void]$tb.Inlines.Add($r3)
                [void]$StackPanel.Children.Add($tb)
            }
        }
    }

    $accentBrush = ConvertTo-OmegaBrush -Value $palette.Accent
    $textBrush   = ConvertTo-OmegaBrush -Value $palette.MainText
    $mutedBrush  = ConvertTo-OmegaBrush -Value $palette.MutedText

    Add-ManualContent -StackPanel $mw.FindName("stackEs") -Items $esItems -AccentB $accentBrush -TextB $textBrush -MutedB $mutedBrush
    Add-ManualContent -StackPanel $mw.FindName("stackEn") -Items $enItems -AccentB $accentBrush -TextB $textBrush -MutedB $mutedBrush

    $mw.FindName("btnManualX").Add_Click({ $mw.Close() })
    $mw.FindName("btnManualClose").Add_Click({ $mw.Close() })

    $mw.Owner = $window
    [void]$mw.ShowDialog()
}

# ---------------- 5. TEMAS ----------------
function Set-OmegaThemeResources {
    param($Palette)
    if ($null -eq $Palette -or $null -eq $window.Resources) { return }
    $map = @{
        ThemeWindowBackground='WindowBg'; ThemePanelBackground='PanelBg'; ThemeCardBackground='CardBg'
        ThemeInputBackground='InputBg'; ThemeMainText='MainText'; ThemeSecondaryText='SecondaryText'
        ThemeMutedText='MutedText'; ThemeLabelText='LabelText'; ThemeAccent='Accent'; ThemeAccentAlt='AccentAlt'
        ThemeBorder='Border'; ThemeBorderStrong='BorderStrong'; ThemeButtonBackground='ButtonBg'
        ThemeButtonHover='ButtonHover'; ThemeButtonPressed='ButtonPressed'; ThemeBorderHover='BorderHover'
        ThemeBorderPressed='BorderPressed'; ThemePrimaryBackground='PrimaryBg'; ThemePrimaryHover='PrimaryHover'
        ThemePrimaryPressed='PrimaryPressed'; ThemeRevertBackground='RevertBg'; ThemeRevertBorder='RevertBorder'
        ThemeRevertHover='RevertHover'; ThemeRevertPressed='RevertPressed'; ThemeManualBackground='ManualBg'
        ThemeManualHover='ManualHover'; ThemeManualPressed='ManualPressed'; ThemeLogForeground='Log'
    }
    foreach ($resKey in $map.Keys) {
        $palKey = $map[$resKey]
        $value = $null
        try { $value = $Palette[$palKey] } catch { }
        if ($null -eq $value) { continue }
        Set-OmegaResourceSafe -Win $window -Key $resKey -Value $value
    }
}

function Get-OmegaThemeName {
    try {
        if (Test-Path $script:OmegaThemePath) {
            $saved = (Get-Content -Path $script:OmegaThemePath -Raw -ErrorAction Stop).Trim()
            if ($script:OmegaThemes.ContainsKey($saved) -or $saved -eq 'OMEGASOLVER style') { return $saved }
        }
    } catch { }
    return "Spotify Neon"
}

function Save-OmegaThemeName {
    param([string]$Name)
    try { Set-Content -Path $script:OmegaThemePath -Value $Name -Encoding UTF8 -Force } catch { }
}

function Save-OmegaSubColor {
    param([string]$Name)
    try {
        if ([string]::IsNullOrWhiteSpace($Name)) {
            if (Test-Path $script:OmegaSolverSubPath) { Remove-Item -Path $script:OmegaSolverSubPath -Force -ErrorAction SilentlyContinue }
        } else {
            Set-Content -Path $script:OmegaSolverSubPath -Value $Name -Encoding UTF8 -Force
        }
    } catch { }
}

# ---------- 6. RUTAS Y ESTADO ------------------------------------------------
$script:OmegaStateDir       = Join-Path $env:ProgramData "OmegaSolver"
$script:OmegaStatePath      = Join-Path $script:OmegaStateDir "reversible-state.json"
$script:OmegaThemePath      = Join-Path $script:OmegaStateDir "theme.txt"
$script:OmegaSolverSubPath  = Join-Path $script:OmegaStateDir "omega-subcolor.txt"
$script:OmegaWarningAckPath = Join-Path $script:OmegaStateDir "omega-warning.ack"
if (-not (Test-Path $script:OmegaStateDir)) { New-Item -Path $script:OmegaStateDir -ItemType Directory -Force | Out-Null }

# â˜… PARCHED: Cache global para tipo de disco (SSD/HDD)
$script:OmegaMediaTypeCache = @{}

# ==============================================================================
# PALETAS OMEGASOLVER â€” MURDER DRONES (con gradientes como string "|")
# ==============================================================================
$script:OmegaSolverPalettes = [ordered]@{
    "ðŸŸ¡ Amarillo (Cyn & N)" = @{
        WindowBg="#030200"; PanelBg="#0A0800"; CardBg="#141000"; InputBg="#000000"
        MainText="#FFFBE6"; SecondaryText="#FFE97A"; MutedText="#8A7500"; LabelText="#FFD400"
        Accent="#FFD400"; AccentAlt="#FFEB3B"; Border="#4A3F00"; BorderStrong="#7A6800"
        ButtonBg="#0F0D00"; ButtonHover="#1A1700"; ButtonPressed="#050400"
        BorderHover="#FFD400"; BorderPressed="#FFEB3B"
        PrimaryBg="#5C4D00"; PrimaryHover="#8A7500"; PrimaryPressed="#3A3000"
        RevertBg="#3A0000"; RevertBorder="#FF2A2A"; RevertHover="#550000"; RevertPressed="#220000"
        ManualBg="#141000"; ManualHover="#221C00"; ManualPressed="#0A0800"; Log="#FFD400"
    }
    "ðŸŸ¡ Amarillo (V)" = @{
        WindowBg="#040300"; PanelBg="#0A0800"; CardBg="#141000"; InputBg="#000000"
        MainText="#FFF8E0"; SecondaryText="#FFD180"; MutedText="#8A5A00"; LabelText="#FFB300"
        Accent="#FFB300"; AccentAlt="#FFC107"; Border="#4A3800"; BorderStrong="#7A5C00"
        ButtonBg="#0F0C00"; ButtonHover="#1A1500"; ButtonPressed="#050400"
        BorderHover="#FFB300"; BorderPressed="#FFC107"
        PrimaryBg="#5C4600"; PrimaryHover="#8A6A00"; PrimaryPressed="#3A2C00"
        RevertBg="#3A0000"; RevertBorder="#FF2A2A"; RevertHover="#550000"; RevertPressed="#220000"
        ManualBg="#141000"; ManualHover="#221C00"; ManualPressed="#0A0800"; Log="#FFB300"
    }
    "ðŸ”´ Rojo (Doll)" = @{
        WindowBg="#050000"; PanelBg="#0A0000"; CardBg="#140000"; InputBg="#000000"
        MainText="#FFEEEE"; SecondaryText="#FFC4C4"; MutedText="#8A2020"; LabelText="#FF4D4D"
        Accent="#FF2A2A"; AccentAlt="#FF5555"; Border="#4A0000"; BorderStrong="#7A0A0A"
        ButtonBg="#0F0000"; ButtonHover="#1A0000"; ButtonPressed="#050000"
        BorderHover="#FF2A2A"; BorderPressed="#FF5555"
        PrimaryBg="#5C0000"; PrimaryHover="#8A0000"; PrimaryPressed="#3A0000"
        RevertBg="#3A0000"; RevertBorder="#FF2A2A"; RevertHover="#550000"; RevertPressed="#220000"
        ManualBg="#140000"; ManualHover="#220000"; ManualPressed="#0A0000"; Log="#FF2A2A"
    }
    "ðŸŸ£ Morado (Uzi)" = @{
        WindowBg="#05020A"; PanelBg="#0A0514"; CardBg="#140A22"; InputBg="#020005"
        MainText="#F3E8FF"; SecondaryText="#D8B4FE"; MutedText="#7E22CE"; LabelText="#A855F7"
        Accent="#A855F7"; AccentAlt="#D946EF"; Border="#3B0A5C"; BorderStrong="#5B1499"
        ButtonBg="#0A0514"; ButtonHover="#140A22"; ButtonPressed="#05020A"
        BorderHover="#A855F7"; BorderPressed="#D946EF"
        PrimaryBg="#5B1499"; PrimaryHover="#7E22CE"; PrimaryPressed="#3B0A5C"
        RevertBg="#3A0000"; RevertBorder="#FF2A2A"; RevertHover="#550000"; RevertPressed="#220000"
        ManualBg="#140A22"; ManualHover="#221040"; ManualPressed="#0A0514"; Log="#A855F7"
    }
    "ðŸŸ£â†’ðŸŸ¡ Gradiente (Uzi Post-Cyn)" = @{
        WindowBg="#050208"; PanelBg="#0A0510"; CardBg="#120818"; InputBg="#020004"
        MainText="#F8E8FF"; SecondaryText="#F0C870"; MutedText="#9A6FB0"; LabelText="#C026D3"
        Accent="#C026D3|#FACC15"
        AccentAlt="#FACC15|#C026D3"
        Border="#7A1F8A|#8A7500"
        BorderStrong="#C026D3|#FACC15"
        BorderHover="#C026D3|#FACC15"
        BorderPressed="#FACC15|#C026D3"
        PrimaryBg="#5C1468|#5C4D00"
        PrimaryHover="#7A1F8A|#8A7500"
        PrimaryPressed="#3A0A44|#3A3000"
        ButtonBg="#0A0510"; ButtonHover="#150A1C"; ButtonPressed="#050208"
        RevertBg="#3A0000"; RevertBorder="#FF2A2A"; RevertHover="#550000"; RevertPressed="#220000"
        ManualBg="#120818"; ManualHover="#221040"; ManualPressed="#0A0510"; Log="#FACC15"
    }
    "ðŸŸ¢ Verde (Lizzy)" = @{
        WindowBg="#000502"; PanelBg="#000A05"; CardBg="#00140A"; InputBg="#000000"
        MainText="#E8FFF0"; SecondaryText="#A7F3D0"; MutedText="#166534"; LabelText="#22C55E"
        Accent="#22C55E"; AccentAlt="#4ADE80"; Border="#0A4A20"; BorderStrong="#157A3A"
        ButtonBg="#000F05"; ButtonHover="#001A0A"; ButtonPressed="#000500"
        BorderHover="#22C55E"; BorderPressed="#4ADE80"
        PrimaryBg="#0F5C2A"; PrimaryHover="#157A3A"; PrimaryPressed="#0A3A1A"
        RevertBg="#3A0000"; RevertBorder="#FF2A2A"; RevertHover="#550000"; RevertPressed="#220000"
        ManualBg="#00140A"; ManualHover="#002214"; ManualPressed="#000A05"; Log="#22C55E"
    }
}

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
    "Spotify Neon" = @{
        WindowBg="#121212"; PanelBg="#181818"; CardBg="#242424"; InputBg="#121212"
        MainText="#FFFFFF"; SecondaryText="#B3B3B3"; MutedText="#A7A7A7"; LabelText="#A7A7A7"
        Accent="#1DB954"; AccentAlt="#1ED760"; Border="#282828"; BorderStrong="#3E3E3E"
        ButtonBg="#282828"; ButtonHover="#333333"; ButtonPressed="#1A1A1A"
        BorderHover="#1DB954"; BorderPressed="#1ED760"
        PrimaryBg="#1DB954"; PrimaryHover="#1ED760"; PrimaryPressed="#169C46"
        RevertBg="#E91E63"; RevertBorder="#F48FB1"; RevertHover="#C2185B"; RevertPressed="#880E4F"
        ManualBg="#333333"; ManualHover="#444444"; ManualPressed="#222222"; Log="#1DB954"
    }
    "VS Code Dark" = @{
        WindowBg="#1E1E1E"; PanelBg="#252526"; CardBg="#2D2D2D"; InputBg="#1E1E1E"
        MainText="#CCCCCC"; SecondaryText="#CCCCCC"; MutedText="#858585"; LabelText="#858585"
        Accent="#007ACC"; AccentAlt="#1C97EA"; Border="#3C3C3C"; BorderStrong="#474747"
        ButtonBg="#3C3C3C"; ButtonHover="#464647"; ButtonPressed="#2A2A2B"
        BorderHover="#007ACC"; BorderPressed="#1C97EA"
        PrimaryBg="#007ACC"; PrimaryHover="#0062A3"; PrimaryPressed="#004D80"
        RevertBg="#F44747"; RevertBorder="#F88080"; RevertHover="#D13434"; RevertPressed="#A82828"
        ManualBg="#333333"; ManualHover="#444444"; ManualPressed="#252526"; Log="#4EC9B0"
    }
    "Steam Night" = @{
        WindowBg="#171A21"; PanelBg="#1B2838"; CardBg="#2A475E"; InputBg="#101822"
        MainText="#C5C5C5"; SecondaryText="#C5C5C5"; MutedText="#8F98A0"; LabelText="#8F98A0"
        Accent="#66C0F4"; AccentAlt="#4B9CD3"; Border="#2A475E"; BorderStrong="#3B6485"
        ButtonBg="#213448"; ButtonHover="#2A475E"; ButtonPressed="#17212B"
        BorderHover="#66C0F4"; BorderPressed="#4B9CD3"
        PrimaryBg="#171A21"; PrimaryHover="#2A475E"; PrimaryPressed="#101822"
        RevertBg="#CD5C5C"; RevertBorder="#F08080"; RevertHover="#B22222"; RevertPressed="#8B0000"
        ManualBg="#2A475E"; ManualHover="#3B6485"; ManualPressed="#1B2838"; Log="#66C0F4"
    }
    "YouTube Dark" = @{
        WindowBg="#0F0F0F"; PanelBg="#212121"; CardBg="#282828"; InputBg="#0F0F0F"
        MainText="#F1F1F1"; SecondaryText="#AAAAAA"; MutedText="#717171"; LabelText="#AAAAAA"
        Accent="#FF0000"; AccentAlt="#CC0000"; Border="#3F3F3F"; BorderStrong="#555555"
        ButtonBg="#272727"; ButtonHover="#3F3F3F"; ButtonPressed="#1F1F1F"
        BorderHover="#FF0000"; BorderPressed="#CC0000"
        PrimaryBg="#FF0000"; PrimaryHover="#CC0000"; PrimaryPressed="#990000"
        RevertBg="#D32F2F"; RevertBorder="#EF5350"; RevertHover="#B71C1C"; RevertPressed="#7F0000"
        ManualBg="#383838"; ManualHover="#4F4F4F"; ManualPressed="#282828"; Log="#FF4E4E"
    }
    "Dracula Studio" = @{
        WindowBg="#282A36"; PanelBg="#44475A"; CardBg="#343746"; InputBg="#21222C"
        MainText="#F8F8F2"; SecondaryText="#F8F8F2"; MutedText="#6272A4"; LabelText="#6272A4"
        Accent="#BD93F9"; AccentAlt="#FF79C6"; Border="#6272A4"; BorderStrong="#44475A"
        ButtonBg="#44475A"; ButtonHover="#6272A4"; ButtonPressed="#282A36"
        BorderHover="#BD93F9"; BorderPressed="#FF79C6"
        PrimaryBg="#BD93F9"; PrimaryHover="#A470F7"; PrimaryPressed="#8B4BF4"
        RevertBg="#FF5555"; RevertBorder="#FF7777"; RevertHover="#CC4444"; RevertPressed="#993333"
        ManualBg="#6272A4"; ManualHover="#798BC2"; ManualPressed="#44475A"; Log="#50FA7B"
    }
    "Gemini" = @{
        WindowBg="#0B0F1A"; PanelBg="#111726"; CardBg="#1A1F2E"; InputBg="#080B14"
        MainText="#E8EAF6"; SecondaryText="#C5CAE9"; MutedText="#7986CB"; LabelText="#9FA8DA"
        Accent="#4285F4"; AccentAlt="#A142F4"; Border="#2A3142"; BorderStrong="#3F4759"
        ButtonBg="#1E2434"; ButtonHover="#2A3142"; ButtonPressed="#151A26"
        BorderHover="#4285F4"; BorderPressed="#A142F4"
        PrimaryBg="#4285F4"; PrimaryHover="#1967D2"; PrimaryPressed="#0B57D0"
        RevertBg="#DA3633"; RevertBorder="#FF7B72"; RevertHover="#B62324"; RevertPressed="#8E1519"
        ManualBg="#2A3142"; ManualHover="#3F4759"; ManualPressed="#1A1F2E"; Log="#34A853"
    }
    "Copilot" = @{
        WindowBg="#0A0E1A"; PanelBg="#111827"; CardBg="#1E2535"; InputBg="#070A14"
        MainText="#F0F4F8"; SecondaryText="#C8D1E0"; MutedText="#7E8BA3"; LabelText="#A0AEC0"
        Accent="#0078D4"; AccentAlt="#8661C5"; Border="#2D3748"; BorderStrong="#4A5568"
        ButtonBg="#1E2535"; ButtonHover="#2D3748"; ButtonPressed="#151B28"
        BorderHover="#0078D4"; BorderPressed="#8661C5"
        PrimaryBg="#0078D4"; PrimaryHover="#106EBE"; PrimaryPressed="#005A9E"
        RevertBg="#E53E3E"; RevertBorder="#FC8181"; RevertHover="#C53030"; RevertPressed="#9B2C2C"
        ManualBg="#2D3748"; ManualHover="#4A5568"; ManualPressed="#1E2535"; Log="#48BB78"
    }
    "ChatGPT" = @{
        WindowBg="#202123"; PanelBg="#2A2B32"; CardBg="#343541"; InputBg="#1E1F22"
        MainText="#ECECF1"; SecondaryText="#D1D5DB"; MutedText="#9CA3AF"; LabelText="#8E8EA0"
        Accent="#10A37F"; AccentAlt="#1BC99F"; Border="#444654"; BorderStrong="#565869"
        ButtonBg="#343541"; ButtonHover="#444654"; ButtonPressed="#202123"
        BorderHover="#10A37F"; BorderPressed="#1BC99F"
        PrimaryBg="#10A37F"; PrimaryHover="#0E8C6D"; PrimaryPressed="#0A6E55"
        RevertBg="#EF4146"; RevertBorder="#FF7A7A"; RevertHover="#C53030"; RevertPressed="#9B2C2C"
        ManualBg="#444654"; ManualHover="#565869"; ManualPressed="#343541"; Log="#10A37F"
    }
    "Hermes Agent" = @{
        WindowBg="#150B26"; PanelBg="#1F1236"; CardBg="#2A1A47"; InputBg="#0F0719"
        MainText="#F5F0FF"; SecondaryText="#D8CCF0"; MutedText="#9B8CC2"; LabelText="#B8A6DD"
        Accent="#A855F7"; AccentAlt="#D946EF"; Border="#3D2A5F"; BorderStrong="#553D7D"
        ButtonBg="#2A1A47"; ButtonHover="#3D2A5F"; ButtonPressed="#1F1236"
        BorderHover="#A855F7"; BorderPressed="#D946EF"
        PrimaryBg="#A855F7"; PrimaryHover="#9333EA"; PrimaryPressed="#7E22CE"
        RevertBg="#DC2626"; RevertBorder="#F87171"; RevertHover="#B91C1C"; RevertPressed="#7F1D1D"
        ManualBg="#3D2A5F"; ManualHover="#553D7D"; ManualPressed="#2A1A47"; Log="#A855F7"
    }
    "Windhawk Glass" = @{
        WindowBg="#0A0612"; PanelBg="#1A0F2A"; CardBg="#221540"; InputBg="#0F0518"
        MainText="#F8F4FF"; SecondaryText="#DDD1F0"; MutedText="#9B8CC2"; LabelText="#B8A6DD"
        Accent="#FF6B35"; AccentAlt="#C77DFF"; Border="#4A3A7F"; BorderStrong="#6A55A0"
        ButtonBg="#2A1A47"; ButtonHover="#3D2857"; ButtonPressed="#1F1236"
        BorderHover="#FF6B35"; BorderPressed="#C77DFF"
        PrimaryBg="#FF6B35"; PrimaryHover="#E85A28"; PrimaryPressed="#C94A1F"
        RevertBg="#3A0A0A"; RevertBorder="#FF6B6B"; RevertHover="#551010"; RevertPressed="#1F0505"
        ManualBg="#3D2A5F"; ManualHover="#553D7D"; ManualPressed="#2A1A47"; Log="#FFB088"
    }
    "OMEGASOLVER style" = @{
        WindowBg="#030200"; PanelBg="#0A0800"; CardBg="#141000"; InputBg="#000000"
        MainText="#FFFBE6"; SecondaryText="#FFE97A"; MutedText="#8A7500"; LabelText="#FFD400"
        Accent="#FFD400"; AccentAlt="#FFEB3B"; Border="#4A3F00"; BorderStrong="#7A6800"
        ButtonBg="#0F0D00"; ButtonHover="#1A1700"; ButtonPressed="#050400"
        BorderHover="#FFD400"; BorderPressed="#FFEB3B"
        PrimaryBg="#5C4D00"; PrimaryHover="#8A7500"; PrimaryPressed="#3A3000"
        RevertBg="#3A0000"; RevertBorder="#FF2A2A"; RevertHover="#550000"; RevertPressed="#220000"
        ManualBg="#141000"; ManualHover="#221C00"; ManualPressed="#0A0800"; Log="#FFD400"
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

# ==============================================================================
# EFECTOS OMEGASOLVER STYLE
# ==============================================================================
function Apply-OmegaSolverEffects {
    try {
        $alienFont = New-Object System.Windows.Media.FontFamily("Rajdhani, Orbitron, Michroma, Consolas, Lucida Console, Segoe UI")
        $window.FontFamily = $alienFont
        $global:lblAppTitle.Text = "â—¤ OMEGASOLVER â—¢"
        $global:lblAppTitle.FontSize = 17
        $global:lblAppTitle.FontWeight = 'Black'
        $global:lblAppVersion.Text = "  // v4.1 ALT //"
        $global:lblThemeCaption.Text = "PATRÃ“N:"

        $glowColor = [System.Windows.Media.Colors]::Yellow
        try {
            $accentBrush = $window.Resources['ThemeAccent']
            if ($accentBrush -is [System.Management.Automation.PSObject]) { $accentBrush = $accentBrush.PSObject.BaseObject }
            if ($accentBrush -is [System.Windows.Media.SolidColorBrush]) {
                $glowColor = $accentBrush.Color
            } elseif ($accentBrush -is [System.Windows.Media.LinearGradientBrush] -and $accentBrush.GradientStops.Count -gt 0) {
                $glowColor = $accentBrush.GradientStops[0].Color
            }
        } catch { }

        $glow = New-Object System.Windows.Media.Effects.DropShadowEffect
        $glow.Color = $glowColor; $glow.BlurRadius = 18; $glow.ShadowDepth = 0; $glow.Opacity = 0.95
        $global:lblAppTitle.Effect = $glow

        $borderGlow = New-Object System.Windows.Media.Effects.DropShadowEffect
        $borderGlow.Color = $glowColor; $borderGlow.BlurRadius = 22; $borderGlow.ShadowDepth = 0; $borderGlow.Opacity = 0.55
        $global:MainBorder.Effect = $borderGlow
        $global:MainBorder.BorderThickness = New-Object System.Windows.Thickness(2)
        $global:TitleBar.BorderThickness = New-Object System.Windows.Thickness(0,0,0,2)
        $global:TitleBar.Background = $window.Resources['ThemeCardBackground']
    } catch { Write-OmegaLog "âš ï¸ Error aplicando efectos OMEGASOLVER: $($_.Exception.Message)" }
}

function Reset-OmegaSolverEffects {
    try {
        $window.FontFamily = New-Object System.Windows.Media.FontFamily("Segoe UI")
        $global:lblAppTitle.Text = "OmegaSolver"; $global:lblAppTitle.FontSize = 18; $global:lblAppTitle.FontWeight = 'Bold'
        $global:lblAppTitle.Effect = $null
        $global:lblAppVersion.Text = " V4.1 ALT"
        $global:lblThemeCaption.Text = "Tema:"
        $global:MainBorder.Effect = $null
        $global:MainBorder.BorderThickness = New-Object System.Windows.Thickness(2)
        $global:TitleBar.BorderThickness = New-Object System.Windows.Thickness(0,0,0,2)
    } catch { }
}

function Set-OmegaModeUI {
    param([bool]$Advanced)
    try {
        if ($Advanced) {
            $global:gridBasic.Visibility = 'Collapsed'
            $global:gridAdvanced.Visibility = 'Visible'
            $global:statsPanel.Visibility = 'Visible'; $global:logPanel.Visibility = 'Visible'
            if ($window.WindowState -eq [System.Windows.WindowState]::Normal) { $window.Height = 980 }
            $global:chkAdvanced.Content = "ðŸ”§ Avanzado"
        } else {
            $global:gridBasic.Visibility = 'Visible'
            $global:gridAdvanced.Visibility = 'Collapsed'
            $global:statsPanel.Visibility = 'Collapsed'; $global:logPanel.Visibility = 'Collapsed'
            if ($window.WindowState -eq [System.Windows.WindowState]::Normal) { $window.Height = 860 }
            $global:chkAdvanced.Content = "Avanzado"
        }
        Update-OmegaRepairDriveState
    } catch { }
}

Initialize-OmegaSystemProfile -SysProfile $script:OmegaSystemProfile

$themeList = $script:OmegaThemes.Keys | Sort-Object
foreach ($themeKey in $themeList) { [void]$global:cmbTheme.Items.Add($themeKey) }

foreach ($colorKey in ($script:OmegaSolverPalettes.Keys | Sort-Object)) {
    [void]$global:cmbOmegaColor.Items.Add($colorKey)
}

$script:__Initializing = $true

$savedSubColor = $null
try {
    if (Test-Path $script:OmegaSolverSubPath) {
        $savedSubColor = (Get-Content -Path $script:OmegaSolverSubPath -Raw -ErrorAction Stop).Trim()
    }
} catch { }

if ($savedSubColor -and $script:OmegaSolverPalettes.Contains($savedSubColor)) {
    $global:cmbOmegaColor.SelectedItem = $savedSubColor
} elseif ($global:cmbOmegaColor.Items.Count -gt 0) {
    $global:cmbOmegaColor.SelectedIndex = 0
}

$savedTheme = Get-OmegaThemeName
if ($themeList -contains $savedTheme -or $savedTheme -eq 'OMEGASOLVER style') {
    $global:cmbTheme.SelectedItem = $savedTheme
} else {
    $savedTheme = "Spotify Neon"
    $global:cmbTheme.SelectedItem = $savedTheme
}

try {
    if ($savedTheme -eq 'OMEGASOLVER style') {
        $subColor = [string]$global:cmbOmegaColor.SelectedItem
        if ($subColor -and $script:OmegaSolverPalettes.Contains($subColor)) {
            Set-OmegaThemeResources -Palette $script:OmegaSolverPalettes[$subColor]
        }
        $global:cmbOmegaColor.Visibility = 'Visible'
        Apply-OmegaSolverEffects
        Write-OmegaLog "ðŸ›¸ OMEGASOLVER STYLE restaurado Â· sub-color: $subColor"
    } elseif ($script:OmegaThemes.ContainsKey($savedTheme)) {
        Set-OmegaThemeResources -Palette $script:OmegaThemes[$savedTheme]
        Write-OmegaLog "ðŸŽ¨ Tema restaurado: $savedTheme"
    }
} catch { Write-OmegaLog "âš ï¸ Error restaurando tema: $($_.Exception.Message)" }

$script:__Initializing = $false

Set-OmegaModeUI -Advanced $false
Refresh-OmegaRepairDrives
Write-OmegaLog "OmegaSolver V4.1 ALT iniciado (Basic 2-col / Advanced 3-col)."

# ==============================================================================
# XAML DE LA PANTALLA DE CARGA
# ==============================================================================
$script:OmegaLoadingXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Procesando..." Height="450" Width="700"
        WindowStartupLocation="CenterScreen"
        ResizeMode="NoResize"
        WindowStyle="None"
        AllowsTransparency="True"
        Topmost="True"
        ShowInTaskbar="False"
        Background="Transparent">
    <Border Background="{DynamicResource ThemePanelBackground}"
            BorderBrush="{DynamicResource ThemeAccent}"
            BorderThickness="3"
            CornerRadius="14">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="110"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="70"/>
            </Grid.RowDefinitions>

            <Border Grid.Row="0" Background="{DynamicResource ThemeAccent}" CornerRadius="11,11,0,0">
                <StackPanel Orientation="Horizontal" VerticalAlignment="Center" Margin="35,0,0,0">
                    <TextBlock Text="âš™ï¸" FontSize="42" Foreground="White" Margin="0,0,20,0"/>
                    <StackPanel VerticalAlignment="Center">
                        <TextBlock x:Name="lblTitle" Text="Procesando..." FontSize="26" FontWeight="Bold" Foreground="White"/>
                        <TextBlock Text="OmegaSolver V4.1 ALT" FontSize="13" Foreground="White" Opacity="0.85"/>
                    </StackPanel>
                </StackPanel>
            </Border>

            <StackPanel Grid.Row="1" Margin="45,35,45,35" VerticalAlignment="Center">
                <TextBlock x:Name="lblMainMessage" Text="Iniciando..." FontSize="20" FontWeight="SemiBold"
                           Foreground="{DynamicResource ThemeMainText}" TextWrapping="Wrap" Margin="0,0,0,25"/>
                <ProgressBar x:Name="pbLoading" Height="18" IsIndeterminate="True"
                             Background="{DynamicResource ThemeInputBackground}"
                             Foreground="{DynamicResource ThemeAccent}"
                             BorderThickness="0" Margin="0,0,0,25"/>
                <TextBlock x:Name="lblSubMessage" Text="Por favor, espera..." FontSize="14"
                           Foreground="{DynamicResource ThemeMutedText}" TextWrapping="Wrap"/>
            </StackPanel>

            <Border Grid.Row="2" Background="{DynamicResource ThemeCardBackground}" CornerRadius="0,0,12,12" Padding="25,0">
                <TextBlock Text="âš  Por favor, no cierres esta ventana mientras el proceso estÃ¡ en marcha."
                           FontSize="12" Foreground="{DynamicResource ThemeMutedText}"
                           HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
        </Grid>
    </Border>
</Window>
"@

function Invoke-OmegaTask {
    param(
        [string]$Title,
        [string[]]$Steps,
        [ScriptBlock]$Action
    )

    $currentTheme = [string]$global:cmbTheme.SelectedItem
    $palette = $null
    if ($currentTheme -eq 'OMEGASOLVER style') {
        $subColor = [string]$global:cmbOmegaColor.SelectedItem
        if ($subColor -and $script:OmegaSolverPalettes.Contains($subColor)) {
            $palette = $script:OmegaSolverPalettes[$subColor]
        }
    }
    if (-not $palette) {
        if (-not $currentTheme) { $currentTheme = "Spotify Neon" }
        $palette = $script:OmegaThemes[$currentTheme]
    }

    $lw = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader ([xml]$script:OmegaLoadingXaml)))
    Set-OmegaResourceSafe -Win $lw -Key "ThemePanelBackground"  -Value $palette.PanelBg
    Set-OmegaResourceSafe -Win $lw -Key "ThemeAccent"           -Value $palette.Accent
    Set-OmegaResourceSafe -Win $lw -Key "ThemeMainText"         -Value $palette.MainText
    Set-OmegaResourceSafe -Win $lw -Key "ThemeInputBackground"  -Value $palette.InputBg
    Set-OmegaResourceSafe -Win $lw -Key "ThemeMutedText"        -Value $palette.MutedText
    Set-OmegaResourceSafe -Win $lw -Key "ThemeCardBackground"   -Value $palette.CardBg

    $lw.FindName("lblTitle").Text = $Title
    $lw.FindName("lblMainMessage").Text = $Steps[0]
    $lw.FindName("lblSubMessage").Text = "Esto puede tardar unos minutos..."

    $script:__Olw = $lw
    $script:__OSteps = $Steps
    $script:__OStepIdx = 0
    $script:__OProcs = @()
    $script:__OFrame = New-Object System.Windows.Threading.DispatcherFrame

    $script:__OStepTimer = New-Object System.Windows.Threading.DispatcherTimer
    $script:__OStepTimer.Interval = [TimeSpan]::FromSeconds(3)
    $script:__OStepTimer.Add_Tick({
        $script:__OStepIdx = ($script:__OStepIdx + 1) % $script:__OSteps.Count
        $script:__Olw.FindName("lblMainMessage").Text = $script:__OSteps[$script:__OStepIdx]
    })

    $window.IsEnabled = $false
    $lw.Show()
    $script:__OStepTimer.Start()

    $result = $null
    try { $result = $Action.Invoke() } catch { Write-OmegaLog "Error en tarea: $($_.Exception.Message)" }

    $script:__OProcs = @()
    if ($null -ne $result) {
        if ($result -is [array]) {
            $script:__OProcs = @($result | Where-Object { $_ -ne $null -and $_ -is [System.Diagnostics.Process] })
        } elseif ($result -is [System.Diagnostics.Process]) {
            $script:__OProcs = @($result)
        }
    }

    if ($script:__OProcs.Count -eq 0) {
        $script:__OCloseTimer = New-Object System.Windows.Threading.DispatcherTimer
        $script:__OCloseTimer.Interval = [TimeSpan]::FromMilliseconds(1500)
        $script:__OCloseTimer.Add_Tick({
            $script:__OCloseTimer.Stop(); $script:__OStepTimer.Stop()
            try { $script:__Olw.Close() } catch { }
            $script:__OFrame.Continue = $false
        })
        $script:__OCloseTimer.Start()
    } else {
        # â˜… PARCHED: Poll con timeout mÃ¡ximo de 15 min (evita timers zombis)
        $script:__OPollTimer = New-Object System.Windows.Threading.DispatcherTimer
        $script:__OPollTimer.Interval = [TimeSpan]::FromMilliseconds(500)
        $script:__OPollTimeout = [DateTime]::UtcNow.AddMinutes(15)
        $script:__OPollTimer.Add_Tick({
            $allDone = $true
            foreach ($p in $script:__OProcs) {
                try { if (-not $p.HasExited) { $allDone = $false; break } } catch { }
            }
            if ($allDone -or [DateTime]::UtcNow -gt $script:__OPollTimeout) {
                $script:__OPollTimer.Stop(); $script:__OStepTimer.Stop()
                try { $script:__Olw.Close() } catch { }
                $script:__OFrame.Continue = $false
            }
        })
        $script:__OPollTimer.Start()
    }

    [System.Windows.Threading.Dispatcher]::PushFrame($script:__OFrame)
    $window.IsEnabled = $true
    $window.Activate()
}

# ==============================================================================
# EVENTOS â€” Custom Chrome
# ==============================================================================
$global:DragArea.Add_MouseLeftButtonDown({
    param($sender, $e)
    try { if ($e.ButtonState -eq [System.Windows.Input.MouseButtonState]::Pressed) { $window.DragMove() } } catch { }
})
$global:TitleBar.Add_MouseLeftButtonDown({
    param($sender, $e)
    try {
        if ($e.OriginalSource -is [System.Windows.Controls.Button] -or
            $e.OriginalSource -is [System.Windows.Controls.ComboBox] -or
            $e.OriginalSource -is [System.Windows.Controls.ComboBoxItem] -or
            $e.OriginalSource -is [System.Windows.Controls.CheckBox] -or
            $e.OriginalSource -is [System.Windows.Controls.TextBlock]) { return }
        if ($e.ButtonState -eq [System.Windows.Input.MouseButtonState]::Pressed) { $window.DragMove() }
    } catch { }
})

$global:btnMin.Add_Click({ try { $window.WindowState = [System.Windows.WindowState]::Minimized } catch { } })
$global:btnMax.Add_Click({
    try {
        if ($window.WindowState -eq [System.Windows.WindowState]::Maximized) {
            $window.WindowState = [System.Windows.WindowState]::Normal
            $global:MainBorder.CornerRadius = New-Object System.Windows.CornerRadius(10)
            $global:TitleBar.CornerRadius = New-Object System.Windows.CornerRadius(8,8,0,0)
            $global:btnMax.Content = "â–¡"
        } else {
            $window.WindowState = [System.Windows.WindowState]::Maximized
            $global:MainBorder.CornerRadius = New-Object System.Windows.CornerRadius(0)
            $global:TitleBar.CornerRadius = New-Object System.Windows.CornerRadius(0)
            $global:btnMax.Content = "â"
        }
    } catch { }
})
$global:btnClose.Add_Click({ try { $window.Close() } catch { } })

$global:chkAdvanced.Add_Checked({ try { Set-OmegaModeUI -Advanced $true; Write-OmegaLog "ðŸ”§ Modo Avanzado activado (3 columnas)." } catch { } })
$global:chkAdvanced.Add_Unchecked({ try { Set-OmegaModeUI -Advanced $false; Write-OmegaLog "ðŸŽ¯ Modo BÃ¡sico activado (2 columnas)." } catch { } })

$global:cmbTheme.Add_SelectionChanged({
    try {
        if ($script:__Initializing) { return }
        $selected = [string]$global:cmbTheme.SelectedItem
        if ([string]::IsNullOrWhiteSpace($selected)) { return }
        Save-OmegaThemeName -Name $selected

        if ($selected -eq 'OMEGASOLVER style') {
            if (-not (Test-Path $script:OmegaWarningAckPath)) {
                $result = [System.Windows.MessageBox]::Show(
                    "âš  ADVERTENCIA â€” OMEGASOLVER STYLE`n`n" +
                    "Este tema TRANSFORMA la interfaz con estÃ©tica alienÃ­gena inspirada en Murder Drones.`n`n" +
                    "SOLO RECOMENDADO PARA USUARIOS AVANZADOS.`n`n" +
                    "Â¿Deseas activar el modo OMEGASOLVER?",
                    "OMEGASOLVER STYLE â€” Advertencia", 'YesNo', 'Warning')
                if ($result -ne [System.Windows.MessageBoxResult]::Yes) {
                    Save-OmegaThemeName -Name "Spotify Neon"
                    $global:cmbTheme.SelectedItem = "Spotify Neon"
                    return
                }
                try { Set-Content -Path $script:OmegaWarningAckPath -Value "ack" -Encoding UTF8 -Force } catch { }
            }

            $global:cmbOmegaColor.Visibility = 'Visible'
            if (-not $global:cmbOmegaColor.SelectedItem) {
                $restored = $false
                try {
                    if (Test-Path $script:OmegaSolverSubPath) {
                        $savedSub = (Get-Content -Path $script:OmegaSolverSubPath -Raw -ErrorAction Stop).Trim()
                        if ($savedSub -and $script:OmegaSolverPalettes.Contains($savedSub)) {
                            $global:cmbOmegaColor.SelectedItem = $savedSub
                            $restored = $true
                        }
                    }
                } catch { }
                if (-not $restored -and $global:cmbOmegaColor.Items.Count -gt 0) {
                    $global:cmbOmegaColor.SelectedIndex = 0
                }
            }
            $subColor = [string]$global:cmbOmegaColor.SelectedItem
            if ($subColor) { Save-OmegaSubColor -Name $subColor }
            if ($subColor -and $script:OmegaSolverPalettes.Contains($subColor)) {
                Set-OmegaThemeResources -Palette $script:OmegaSolverPalettes[$subColor]
            }
            Apply-OmegaSolverEffects
            Write-OmegaLog "ðŸ›¸ OMEGASOLVER STYLE activado Â· sub-color: $subColor"
        } else {
            $global:cmbOmegaColor.Visibility = 'Collapsed'
            Save-OmegaSubColor -Name $null
            Reset-OmegaSolverEffects
            if ($script:OmegaThemes.ContainsKey($selected)) {
                Set-OmegaThemeResources -Palette $script:OmegaThemes[$selected]
            }
            Write-OmegaLog "ðŸŽ¨ Tema aplicado: $selected"
        }
    } catch { Write-OmegaLog "âš ï¸ Error al aplicar tema: $($_.Exception.Message)" }
})

$global:cmbOmegaColor.Add_SelectionChanged({
    try {
        if ($script:__Initializing) { return }
        if ([string]$global:cmbTheme.SelectedItem -ne 'OMEGASOLVER style') { return }
        $subColor = [string]$global:cmbOmegaColor.SelectedItem
        if ([string]::IsNullOrWhiteSpace($subColor)) { return }
        if (-not $script:OmegaSolverPalettes.Contains($subColor)) { return }
        Save-OmegaSubColor -Name $subColor
        Set-OmegaThemeResources -Palette $script:OmegaSolverPalettes[$subColor]
        Apply-OmegaSolverEffects
        Write-OmegaLog "ðŸ›¸ OMEGASOLVER sub-color: $subColor"
    } catch { Write-OmegaLog "âš ï¸ Error al cambiar sub-color: $($_.Exception.Message)" }
})

$global:cmbRepairDriveBasic.Add_SelectionChanged({ try { Update-OmegaRepairDriveState } catch { } })
$global:cmbRepairDriveAdv.Add_SelectionChanged({ try { Update-OmegaRepairDriveState } catch { } })
$global:btnRefreshDrivesBasic.Add_Click({ try { Refresh-OmegaRepairDrives } catch { } })
$global:btnRefreshDrivesAdv.Add_Click({ try { Refresh-OmegaRepairDrives } catch { } })

$global:btnDiagnose.Add_Click({
    try {
        Set-OmegaStatus "Analizando..."
        Invoke-OmegaTask -Title "Analizando PC" -Steps @(
            "Recopilando informaciÃ³n del sistema...",
            "Calculando tamaÃ±o de temporales y cachÃ©s...",
            "Evaluando estado de discos y baterÃ­a...",
            "Generando recomendaciones..."
        ) -Action { Start-OmegaDiagnostics; return $null }
        Set-OmegaStatus "Listo"
    } catch { }
})

$sfcHandler = {
    try {
        $info = Get-SelectedOmegaDriveInfo
        if (-not $info) { return }
        if (-not (Confirm-OmegaAction -Title "SFC" -Message "SFC se ejecutarÃ¡ sobre $($info.Drive). Â¿Continuar?" -Image 'Information')) { return }
        Invoke-OmegaTask -Title "Reparando Sistema" -Steps @(
            "Preparando verificaciÃ³n de archivos...",
            "Ejecutando SFC /Scannow en $($info.Drive)...",
            "Esto puede tardar varios minutos...",
            "Por favor, no cierres la aplicaciÃ³n..."
        ) -Action { return Start-OmegaSfcRepair $info }
    } catch { Write-OmegaLog "Error: $($_.Exception.Message)" }
}
$global:btnSfcBasic.Add_Click($sfcHandler)
$global:btnSfcAdv.Add_Click($sfcHandler)

$dismHandler = {
    try {
        $info = Get-SelectedOmegaDriveInfo
        if (-not $info) { return }
        if (-not (Confirm-OmegaAction -Title "DISM" -Message "DISM se ejecutarÃ¡ sobre $($info.Drive). Â¿Continuar?" -Image 'Information')) { return }
        Invoke-OmegaTask -Title "Reparando Imagen" -Steps @(
            "Preparando reparaciÃ³n de imagen...",
            "Ejecutando DISM /RestoreHealth en $($info.Drive)...",
            "Esto puede tardar varios minutos...",
            "Por favor, no cierres la aplicaciÃ³n..."
        ) -Action { return Start-OmegaDismRepair $info }
    } catch { Write-OmegaLog "Error: $($_.Exception.Message)" }
}
$global:btnDismBasic.Add_Click($dismHandler)
$global:btnDismAdv.Add_Click($dismHandler)

$chkdskHandler = {
    try {
        $info = Get-SelectedOmegaDriveInfo
        if (-not $info) { return }
        if (-not (Confirm-OmegaAction -Title "CHKDSK" -Message "CHKDSK /f se ejecutarÃ¡ sobre $($info.Drive). Puede requerir reinicio. Â¿Continuar?")) { return }
        Invoke-OmegaTask -Title "Comprobando Disco" -Steps @(
            "Preparando comprobaciÃ³n de disco...",
            "Ejecutando CHKDSK /f en $($info.Drive)...",
            "Esto puede tardar varios minutos...",
            "Por favor, no cierres la aplicaciÃ³n..."
        ) -Action { return Start-OmegaChkdskRepair $info }
    } catch { Write-OmegaLog "Error: $($_.Exception.Message)" }
}
$global:btnChkDskBasic.Add_Click($chkdskHandler)
$global:btnChkDskAdv.Add_Click($chkdskHandler)

$defragHandler = {
    try {
        $info = Get-SelectedOmegaDriveInfo
        if (-not $info) { return }
        $mediaType = Get-OmegaDriveMediaType -DriveLetter $info.Drive
        if ($mediaType -eq 'SSD') {
            [System.Windows.MessageBox]::Show(
                "La unidad $($info.Drive) es un SSD.`n`nDesfragmentar un SSD acorta su vida Ãºtil.`nWindows ya aplica TRIM.`n`nEsta acciÃ³n estÃ¡ bloqueada por seguridad.",
                "OperaciÃ³n Bloqueada", 'OK', 'Warning') | Out-Null
            Write-OmegaLog "ðŸ›¡ï¸ Intento bloqueado: $($info.Drive) es SSD."
            return
        }
        if ($mediaType -eq 'Unknown') {
            [System.Windows.MessageBox]::Show("No se pudo determinar el tipo de disco de $($info.Drive). Por seguridad, bloqueado.", "Desconocido", 'OK', 'Warning') | Out-Null
            return
        }
        if (-not (Confirm-OmegaAction -Title "Optimizar Disco" -Message "Se abrirÃ¡ el Desfragmentador para $($info.Drive).`n`nSelecciona la unidad y pulsa 'Optimizar'.`n`nÂ¿Continuar?" -Image 'Information')) { return }
        Write-OmegaLog "ðŸ’½ Abriendo dfrgui.exe..."
        Start-Process -FilePath "dfrgui.exe" | Out-Null
        Write-OmegaLog "âœ… Desfragmentador abierto. Selecciona $($info.Drive) y pulsa 'Optimizar'."
    } catch { Write-OmegaLog "Error: $($_.Exception.Message)" }
}
$global:btnDefragBasic.Add_Click($defragHandler)
$global:btnDefragAdv.Add_Click($defragHandler)

$maxPowerHandler = {
    try {
        Invoke-OmegaTask -Title "Optimizando EnergÃ­a" -Steps @(
            "Analizando plan de energÃ­a actual...",
            "Activando modo de alto rendimiento...",
            "Aplicando cambios..."
        ) -Action {
            Save-ReversibleStateBeforePowerPlanChange
            powercfg -setactive $script:OmegaState.PowerPlan.TargetSchemeGuid | Out-Null
            return $null
        }
    } catch { Write-OmegaLog "Error: $($_.Exception.Message)" }
}
$global:btnMaxPowerBasic.Add_Click($maxPowerHandler)
$global:btnMaxPowerAdv.Add_Click($maxPowerHandler)

$flushDnsHandler = {
    try {
        Invoke-OmegaTask -Title "Limpiando DNS" -Steps @(
            "Accediendo a la cachÃ© DNS...",
            "Eliminando registros DNS obsoletos..."
        ) -Action { ipconfig /flushdns | Out-Null; return $null }
    } catch { }
}
$global:btnFlushDnsBasic.Add_Click($flushDnsHandler)
$global:btnFlushDnsAdv.Add_Click($flushDnsHandler)

$resetNetHandler = {
    try {
        if (-not (Confirm-OmegaAction -Title "Reset Red" -Message "Se restablecerÃ¡ Winsock. Puede requerir reinicio. Â¿Continuar?")) { return }
        Invoke-OmegaTask -Title "Restableciendo Red" -Steps @(
            "Restableciendo sockets de red...",
            "Reiniciando interfaces TCP/IP...",
            "Puede requerir reinicio del equipo..."
        ) -Action { netsh winsock reset | Out-Null; return $null }
    } catch { Write-OmegaLog "Error: $($_.Exception.Message)" }
}
$global:btnResetNetBasic.Add_Click($resetNetHandler)
$global:btnResetNetAdv.Add_Click($resetNetHandler)

$qosHandler = {
    try {
        Invoke-OmegaTask -Title "Optimizando Red" -Steps @(
            "Accediendo a polÃ­ticas de red...",
            "Configurando lÃ­mite QoS a 0%...",
            "Aplicando cambios en el registro..."
        ) -Action {
            Save-ReversibleStateBeforeQoSChange
            $regPath = $script:OmegaState.QoS.RegistryPath
            if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
            Set-ItemProperty -Path $regPath -Name "NonBestEffortLimit" -Value 0 -Type DWord
            return $null
        }
    } catch { Write-OmegaLog "Error: $($_.Exception.Message)" }
}
$global:btnQoSBasic.Add_Click($qosHandler)
$global:btnQoSAdv.Add_Click($qosHandler)

$tempHandler = {
    try {
        Invoke-OmegaTask -Title "Limpiando Temporales" -Steps @(
            "Accediendo a carpetas temporales...",
            "Eliminando archivos basura...",
            "Liberando espacio en disco..."
        ) -Action { Start-BasicTempCleanup; return $null }
    } catch { Write-OmegaLog "Error: $($_.Exception.Message)" }
}
$global:btnTempBasic.Add_Click($tempHandler)
$global:btnTempAdv.Add_Click($tempHandler)

$deepCleanHandler = {
    try {
        if (-not (Confirm-OmegaAction -Title "Limpieza Profunda" -Message "Se borrarÃ¡n cachÃ©s de sistema y descargas de Windows Update. Â¿Continuar?")) { return }
        Invoke-OmegaTask -Title "Limpieza Profunda" -Steps @(
            "Deteniendo servicios de actualizaciÃ³n...",
            "Limpiando cachÃ©s de Windows Update...",
            "Eliminando archivos temporales y logs...",
            "Restaurando servicios...",
            "Casi listo..."
        ) -Action { return Start-DeepCleaningRoutine }
    } catch { Write-OmegaLog "Error: $($_.Exception.Message)" }
}
$global:btnDeepCleanBasic.Add_Click($deepCleanHandler)
$global:btnDeepCleanAdv.Add_Click($deepCleanHandler)

$logCleanHandler = {
    try {
        if (-not (Confirm-OmegaAction -Title "Limpiar Logs y WinSxS" -Message "Se vaciarÃ¡n visores de eventos y logs del sistema. Â¿Continuar?")) { return }
        Invoke-OmegaTask -Title "Limpiando Logs" -Steps @(
            "Vaciando registros de eventos...",
            "Eliminando logs del sistema...",
            "Ejecutando limpieza de WinSxS...",
            "Esto puede tardar varios minutos..."
        ) -Action { return Start-LogAndWinSxSCleanup }
    } catch { Write-OmegaLog "Error: $($_.Exception.Message)" }
}
$global:btnLogCleanBasic.Add_Click($logCleanHandler)
$global:btnLogCleanAdv.Add_Click($logCleanHandler)

$fullRepairHandler = {
    try {
        if (-not (Confirm-OmegaAction -Title "ReparaciÃ³n Completa" -Message "Â¿Desea ejecutar el mantenimiento completo automÃ¡tico?")) { return }
        $info = Get-SelectedOmegaDriveInfo
        Invoke-OmegaTask -Title "ReparaciÃ³n Completa" -Steps @(
            "Iniciando mantenimiento automÃ¡tico...",
            "Limpiando archivos temporales...",
            "Optimizando configuraciÃ³n de red...",
            "Ejecutando SFC /Scannow...",
            "Ejecutando DISM /RestoreHealth...",
            "Finalizando reparaciÃ³n..."
        ) -Action {
            Start-BasicTempCleanup
            ipconfig /flushdns | Out-Null
            $procs = @()
            if ($info) {
                $p1 = Start-OmegaSfcRepair $info
                if ($p1) { $procs += $p1 }
                $p2 = Start-OmegaDismRepair $info
                if ($p2) { $procs += $p2 }
            }
            return $procs
        }
    } catch { Write-OmegaLog "Error: $($_.Exception.Message)" }
}
$global:btnFullRepairBasic.Add_Click($fullRepairHandler)
$global:btnFullRepairAdv.Add_Click($fullRepairHandler)

$global:btnManual.Add_Click({ try { Show-OmegaManual } catch { Write-OmegaLog "Error: $($_.Exception.Message)" } })

$global:btnRevert.Add_Click({
    try {
        Invoke-OmegaTask -Title "Revirtiendo Cambios" -Steps @(
            "Restaurando plan de energÃ­a...",
            "Restaurando configuraciÃ³n QoS...",
            "Restaurando estados de servicios...",
            "Finalizando restauraciÃ³n..."
        ) -Action { Start-OmegaRevertChanges; return $null }
    } catch { Write-OmegaLog "Error: $($_.Exception.Message)" }
})

$window.Add_Loaded({
    $script:__AutoDiagTimer = New-Object System.Windows.Threading.DispatcherTimer
    $script:__AutoDiagTimer.Interval = [TimeSpan]::FromMilliseconds(800)
    $script:__AutoDiagTimer.Add_Tick({
        $script:__AutoDiagTimer.Stop()
        try {
            Invoke-OmegaTask -Title "Iniciando OmegaSolver" -Steps @(
                "Preparando el diagnÃ³stico inicial del equipo...",
                "Analizando el estado general del sistema...",
                "Calculando el tamaÃ±o de temporales y cachÃ©s...",
                "Evaluando discos, baterÃ­a y componentes...",
                "Generando recomendaciones personalizadas...",
                "Casi listo..."
            ) -Action { Start-OmegaDiagnostics; return $null }
            Write-OmegaLog "âœ… DiagnÃ³stico inicial completado correctamente."
        } catch { Write-OmegaLog "âš ï¸ Error en diagnÃ³stico inicial: $($_.Exception.Message)" }
    })
    $script:__AutoDiagTimer.Start()
})

Set-OmegaStatus "Listo"

# â˜… Liberar el mutex al cerrar la ventana (respaldo por si algo falla)
$window.Add_Closed({
    try {
        if ($script:OmegaMutexOwned -and $script:OmegaMutex) {
            try { $script:OmegaMutex.ReleaseMutex() } catch { }
            $script:OmegaMutexOwned = $false
        }
    } catch { }
})

try {
    [void]$window.ShowDialog()
} finally {
    # â˜… Limpieza garantizada incluso ante excepciones
    try {
        if ($script:OmegaMutexOwned -and $script:OmegaMutex) {
            try { $script:OmegaMutex.ReleaseMutex() } catch { }
        }
    } catch { }
    try { if ($script:OmegaMutex) { $script:OmegaMutex.Dispose() } } catch { }
}
