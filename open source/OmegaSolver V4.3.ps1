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
# PROYECTO: OmegaSolver V4.3 (Basic 2-col Balanced Â· Advanced 3-col Â· Red Share)
# + Easy Context Menu Ready Â· Dism++ Inspired Tools Â· Robust DPI Adaptive
# + One-Click Cleanup Â· Restore Point Â· Startup Manager Â· Locked Files Handler
# + Network File Sharing (Robocopy + FTP) Â· Fixed window bounds detection
# + Auto-Update Checker (GitHub) Â· Low-Resource Mode
# + Language Menu (ES/EN/PT) Â· 3-Column Manual (Basic + Technical)
# + Easy Context Menu auto-detection & integration
# + FIXED: Full i18n coverage (log, dialogs, status, loading, recommendations)
# ===============================================================================

# ---------- 0. DPI AWARENESS + ROBUST SCREEN DETECTION -----------------------
try {
    Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class DpiHelper {
    [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
    [DllImport("shcore.dll")] public static extern int SetProcessDpiAwareness(int value);
}
"@ -ErrorAction SilentlyContinue
    try { [DpiHelper]::SetProcessDpiAwareness(2) | Out-Null } catch { }
    try { [DpiHelper]::SetProcessDPIAware() | Out-Null } catch { }
} catch { }

# ---------- 1. CARGAR WPF ----------------------------------------------------
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms

# ---------- 2. CONFIGURACIÃ“N GLOBAL ------------------------------------------
$script:OmegaGitHubRepo     = "OMEGAALPHA10/OmegaSolver"
$script:OmegaCurrentVersion = "4.3"
$script:OmegaUpdateTimeout  = 8

# ==============================================================================
# â˜… SISTEMA DE IDIOMAS (ES / EN / PT)
# ==============================================================================
$script:OmegaStrings = @{
    'ES' = @{
        'Lang_Caption' = 'Idioma:'
        'Theme_Caption' = 'Tema:'
        'Check_Advanced' = 'Avanzado'
        'Check_LowMode' = 'Modo Low'
        'Status_Prefix' = 'Estado: '
        'Status_Ready' = 'Listo'
        'Status_Starting' = 'Iniciando...'
        'Status_Analyzing' = 'Analizando...'
        'Status_Checking_Updates' = 'Comprobando actualizaciones...'
        'Status_Checking' = 'Comprobando...'
        'Status_Detecting' = 'Detectando...'
        'Detecting' = 'Detectando...'
        'Checking' = 'Comprobando...'
        'Lbl_PC' = 'EQUIPO'
        'Lbl_Windows' = 'WINDOWS'
        'Lbl_PowerShell' = 'POWERSHELL'
        'Lbl_Components' = 'COMPONENTES'
        'Stats_Heading' = 'ðŸ” DiagnÃ³stico detallado'
        'Stats_Subtitle' = 'Nivel de temporales y cachÃ©s'
        'Stats_Analyzing' = 'Analizando...'
        'Stats_Summary' = 'RESUMEN'
        'Stats_Preparing' = 'Preparando anÃ¡lisis...'
        'Stats_Calculating' = 'Calculando...'
        'Stats_Reference' = 'referencia'
        'Stats_Unavailable' = 'DiagnÃ³stico no disponible'
        'Stats_CouldNotComplete' = 'No se pudo completar el anÃ¡lisis.'
        'Stats_Text_Line1' = 'Temp/cachÃ©s: {0} GB.'
        'Stats_Text_Line2' = 'Disco: {0}.'
        'Stats_Text_Line3' = 'EnergÃ­a: {0}.'
        'Stats_Free_Format' = '{0}% libre ({1}/{2} GB)'
        'Stats_NA' = 'n/d'
        'Rec_LowDisk' = 'Espacio en disco bajo. Prioriza la limpieza.'
        'Rec_LowDiskMid' = 'Espacio en disco algo bajo; limpieza recomendada.'
        'Rec_JunkDetected' = '~{0} GB detectados en temp/cachÃ©s.'
        'Rec_LittleJunk' = 'Poco contenido temporal; limpieza no urgente.'
        'Rec_DeepCleanHint' = 'La limpieza profunda puede recuperar mÃ¡s espacio.'
        'Rec_Battery' = 'Con baterÃ­a: Alto Rendimiento aumenta el consumo.'
        'Rec_AC' = 'Alto Rendimiento disponible.'
        'Basic_RepairHeading' = 'ðŸ› ï¸ Reparar mi PC'
        'Label_TargetDisk' = 'ðŸŽ¯ Disco a revisar:'
        'Btn_Refresh' = 'â†º Actualizar'
        'Sub_Repair' = 'ðŸ”§ ReparaciÃ³n'
        'Btn_RepairWindows' = 'Reparar Windows'
        'Btn_RecoverSystem' = 'Recuperar sistema'
        'Btn_CheckDisk' = 'Comprobar disco'
        'Btn_DefragDisk' = 'Ordenar disco'
        'Btn_MaxPerformance' = 'âš¡ Modo rendimiento'
        'Sub_Security' = 'ðŸ›¡ï¸ Seguridad'
        'Btn_RestorePoint' = 'Crear Punto de RestauraciÃ³n'
        'Btn_StartupManager' = 'Gestionar Programas de Inicio'
        'Btn_RepairAll' = 'âš¡ Reparar todo'
        'Basic_CleanHeading' = 'ðŸ§¹ Limpieza'
        'Btn_TempCleanup' = 'Borrar temporales'
        'Btn_DeepClean' = 'Limpieza completa'
        'Btn_ClearHistory' = 'Borrar historial'
        'Sub_Internet' = 'ðŸŒ Arreglar Internet'
        'Btn_FixInternet' = 'Arreglar internet'
        'Btn_RestartNetwork' = 'Reiniciar la red'
        'Btn_SpeedNetwork' = 'ðŸš€ Acelerar red'
        'Btn_CleanAll' = 'ðŸ§¹ Limpieza en 1-Clic'
        'Tip_Heading' = 'ðŸ’¡ Consejo'
        'Tip_Text' = "Si nada funciona, prueba 'Reiniciar la red'. Algunos cambios requieren reiniciar el equipo."
        'Adv_SystemHeading' = 'ðŸ› ï¸ Sistema y Rendimiento'
        'Label_TargetDiskAdv' = 'ðŸŽ¯ Disco objetivo:'
        'Btn_RefreshDrives' = 'â†º Actualizar discos'
        'Btn_RunSFC' = 'Ejecutar SFC /Scannow'
        'Btn_RepairDISM' = 'Reparar Imagen DISM'
        'Btn_RepairCHKDSK' = 'Reparar Disco (CHKDSK /f)'
        'Btn_DefragUnit' = 'ðŸ’½ Desfragmentar Unidad'
        'Btn_HighPerf' = 'âš¡ Activar Alto Rendimiento'
        'Adv_NetworkHeading' = 'ðŸŒ Red y ConexiÃ³n'
        'Btn_ClearDNSCache' = 'Limpiar CachÃ© DNS'
        'Btn_ResetWinsock' = 'Restablecer Winsock / IP'
        'Btn_ConfigQoS' = 'ðŸš€ Configurar QoS a 0%'
        'Sub_Share' = 'ðŸ“¡ Compartir Archivos'
        'Btn_ShareFiles' = 'ðŸ”— Conectar con otra PC / MÃ³vil'
        'Share_Desc' = 'Comparte archivos entre PC y mÃ³vil vÃ­a red local (Robocopy / FTP).'
        'Sub_SystemTools' = 'ðŸ›¡ï¸ Herramientas del Sistema'
        'Btn_AnalyzeUpdates' = 'Analizar Actualizaciones'
        'Adv_MaintHeading' = 'ðŸ§¹ Mantenimiento'
        'Btn_TempCleanAdv' = 'Limpiar Temporales BÃ¡sicos'
        'Btn_DeepCleanWinUpd' = 'ðŸ§¹ Limpieza Profunda / WinUpdate'
        'Btn_CleanLogsWinSxS' = 'ðŸ—‘ï¸ Limpiar Logs y WinSxS'
        'Sub_AdvancedTools' = 'ðŸ› ï¸ Herramientas Avanzadas'
        'Btn_LockedFiles' = 'Gestor de Archivos Bloqueados'
        'Btn_DriverCleanup' = 'Limpiar Controladores Obsoletos'
        'Btn_OneClickRepair' = 'âš¡ ReparaciÃ³n 1-Clic'
        'Btn_OneClickClean' = 'ðŸ§¹ Limpieza en 1-Clic'
        'Rec_Heading' = 'ðŸ’¡ Recomendaciones personalizadas'
        'Rec_Placeholder' = 'Analizando el estado del equipo...'
        'Log_Heading' = 'ðŸ“œ Registro de Actividad'
        'Footer_Notice' = 'Los cambios reversibles se guardan localmente en el equipo.'
        'Btn_AnalyzePC' = 'ðŸ” Analizar PC'
        'Btn_Manual' = 'ðŸ“– Manual detallado'
        'Btn_Revert' = 'â†© Revertir cambios'
        'Update_Badge' = 'â¬† Nueva versiÃ³n: {0}'
        'Update_Tooltip' = 'Click para abrir la pÃ¡gina de descarga'
        'UpdateCheck_Tooltip' = 'Buscar actualizaciones en GitHub'
        # --- Drive info ---
        'Drive_NoLabel' = 'Sin etiqueta'
        'Drive_ActiveWindows' = 'Windows activo'
        'Drive_OfflineWindows' = 'Windows offline'
        'Drive_Data' = 'Datos'
        'Drive_NoSelected' = 'Ninguna unidad seleccionada.'
        'Drive_SFC_Online' = '{0}: Windows activo. Modo SFC/DISM Online.'
        'Drive_SFC_Offline' = '{0}: Windows offline. Modo SFC/DISM Offline.'
        'Drive_DataOnly' = '{0}: datos. Solo CHKDSK aplica.'
        'Drive_NoDrivesDetected' = 'No se detectaron unidades.'
        'Drive_DetectedCount' = 'Unidades detectadas: {0}.'
        'Drive_DetectError' = 'Error detectando unidades: {0}'
        'Drive_HDDDetected' = 'ðŸ’½ {0} HDD detectado. OptimizaciÃ³n habilitada.'
        'Drive_SSDDetected' = 'ðŸ›¡ï¸ {0} SSD detectado. OptimizaciÃ³n bloqueada.'
        'Drive_CouldNotDetermine' = 'No se pudo determinar el tipo de disco.'
        'Btn_Defrag_NoDrive' = 'ðŸ’½ (Sin unidad)'
        'Btn_Defrag_HDD' = 'Ordenar disco'
        'Btn_Defrag_SSD_Blocked' = 'Ordenar disco (SSD - Bloqueado)'
        'Btn_Defrag_Unknown' = 'Ordenar disco (No detectado)'
        'Btn_DefragAdv_HDD' = 'ðŸ’½ Desfragmentar Unidad'
        'Btn_DefragAdv_SSD_Blocked' = 'ðŸ’½ Desfragmentar (SSD - Bloqueado)'
        'Btn_DefragAdv_Unknown' = 'ðŸ’½ Desfragmentar (No detectado)'
        'Drive_Tooltip_HDD' = 'Optimizar {0} (HDD detectado).'
        'Drive_Tooltip_SSD' = 'Bloqueado por seguridad: {0} es un SSD.'
        'Drive_Tooltip_Unknown' = 'No se pudo determinar el tipo de disco.'
        # --- Repair logs ---
        'Repair_NotApplicable_SFC' = 'âš ï¸ SFC no aplicable.'
        'Repair_NotApplicable_DISM' = 'âš ï¸ DISM no aplicable.'
        'Repair_SFC_Online' = 'ðŸ› ï¸ SFC: reparando Windows activo...'
        'Repair_SFC_Offline' = 'ðŸ› ï¸ SFC: reparando Windows offline...'
        'Repair_DISM_Online' = 'ðŸ› ï¸ DISM: reparando imagen activa...'
        'Repair_DISM_Offline' = 'ðŸ› ï¸ DISM: reparando imagen offline...'
        'Repair_CHKDSK_Checking' = 'ðŸ’¾ CHKDSK: verificando {0}...'
        # --- Clean logs ---
        'Clean_Basic_Start' = '[+] Limpiando archivos temporales bÃ¡sicos...'
        'Clean_Basic_Done' = 'âœ… Archivos temporales bÃ¡sicos eliminados.'
        'Clean_Error' = 'âš ï¸ Error: {0}'
        'Clean_Logs_Start' = '[+] Limpiando logs y WinSxS...'
        'Clean_Deep_Disabling' = '[+] Deshabilitando hibernaciÃ³n...'
        'Clean_Deep_StoppingServices' = '[+] Deteniendo servicios...'
        'Clean_Deep_CleaningCaches' = '[+] Limpiando cachÃ©s y temporales...'
        'Clean_1Click_Start' = 'ðŸ§¹ Iniciando Limpieza en 1-Clic...'
        'Clean_1Click_Done' = 'âœ… Limpieza completa. Archivos temporales: {0} GB.'
        # --- Revert ---
        'Revert_Confirm_Title' = 'Revertir Cambios'
        'Revert_Confirm_Message' = 'Â¿Restaurar la configuraciÃ³n guardada de energÃ­a, QoS y servicios?'
        'Revert_Start' = '[+] Revirtiendo cambios...'
        'Revert_PowerRestored' = 'â†© Plan de energÃ­a restaurado.'
        'Revert_QoSRestored' = 'â†© QoS restaurado.'
        'Revert_QoSRemoved' = 'â†© QoS eliminado.'
        'Revert_Hibernation' = 'â†© HibernaciÃ³n reactivada.'
        'Revert_Done' = 'âœ… RestauraciÃ³n completada.'
        # --- Update ---
        'Update_Checking' = 'Comprobando actualizaciones...'
        'Update_CheckGitHub' = 'ðŸ”„ Comprobando actualizaciones en GitHub...'
        'Update_Available_Log' = 'â¬† Nueva versiÃ³n disponible: v{0} (actual: v{1})'
        'Update_Latest_Log' = 'EstÃ¡s en la Ãºltima versiÃ³n (v{0}).'
        'Update_Offline_Log' = 'Sin conexiÃ³n a Internet â€” no se pueden comprobar actualizaciones.'
        'Update_RepoNotFound_Log' = 'Repositorio de GitHub no encontrado.'
        'Update_Error_Log' = 'Error: {0}'
        'Update_Dialog_Title' = 'ActualizaciÃ³n Disponible'
        'Update_Dialog_Message' = 'Â¡Nueva versiÃ³n disponible!`n`nActual: v{0}`nÃšltima: v{1}`n`nÂ¿Abrir pÃ¡gina de descarga?'
        'Update_NoUpdates_Title' = 'Sin Actualizaciones'
        'Update_NoUpdates_Message' = 'EstÃ¡s en la Ãºltima versiÃ³n (v{0}).'
        'Update_Offline_Title' = 'Sin ConexiÃ³n'
        'Update_Offline_Message' = 'No se pudieron comprobar actualizaciones. Sin conexiÃ³n a Internet.'
        'Update_Error_Title' = 'Error'
        'Update_Error_Message' = 'No se pudieron comprobar las actualizaciones.`n`n{0}'
        'Update_StatusLine' = 'ðŸ”„ ComprobaciÃ³n: {0}'
        'Update_FailedLog' = 'âš ï¸ ComprobaciÃ³n de actualizaciones fallida: {0}'
        'Update_UIError' = 'âš ï¸ Error en UI de actualizaciÃ³n: {0}'
        # --- Low Mode ---
        'LowMode_Enabled' = 'ðŸ¢ Modo Low ACTIVADO â€” efectos reducidos para PCs de bajos recursos.'
        'LowMode_Disabled' = 'âš¡ Modo Low DESACTIVADO â€” efectos restaurados.'
        'LowMode_Error' = 'âš ï¸ Error aplicando Modo Low: {0}'
        # --- Restore Point ---
        'Restore_Enabled' = 'ðŸ”§ ProtecciÃ³n del sistema habilitada.'
        'Restore_CouldNotEnable' = 'âš ï¸ No se pudo habilitar la protecciÃ³n (puede ya estar activa).'
        'Restore_Created' = 'âœ… Punto de restauraciÃ³n creado: {0}'
        'Restore_Success' = 'Punto de restauraciÃ³n creado correctamente.'
        'Restore_Error' = 'âš ï¸ Error creando punto de restauraciÃ³n: {0}'
        'Restore_ErrorDlg' = 'No se pudo crear el punto de restauraciÃ³n.`n`nError: {0}'
        'Restore_SuccessTitle' = 'Ã‰xito'
        'Restore_ErrorTitle' = 'Error'
        # --- Startup Manager ---
        'Startup_Analyzing' = 'ðŸ” Analizando programas de inicio...'
        'Startup_NoPrograms' = 'No se encontraron programas de inicio.'
        'Startup_Title' = 'Gestor de Inicio'
        'Startup_Found' = 'Se encontraron {0} programas de inicio.`n`nVer ''Recomendaciones'' para detalles.'
        'Startup_Header' = '=== PROGRAMAS DE INICIO ({0} encontrados) ==='
        'Startup_Location' = 'UbicaciÃ³n'
        'Startup_Command' = 'Comando'
        'Startup_Error' = 'âš ï¸ Error analizando inicio: {0}'
        # --- Updates report ---
        'Updates_Analyzing' = 'ðŸ” Analizando actualizaciones instaladas...'
        'Updates_Header' = '=== ACTUALIZACIONES INSTALADAS (Ãºltimas 15) ==='
        'Updates_Found' = 'âœ… Se encontraron {0} actualizaciones.'
        'Updates_Error' = 'âš ï¸ Error obteniendo actualizaciones: {0}'
        # --- Locked files ---
        'LockedFile_Title' = 'Selecciona archivo bloqueado para eliminar'
        'LockedFile_Filter' = 'Todos los archivos (*.*)|*.*'
        'LockedFile_ConfirmTitle' = 'Eliminar Archivo Bloqueado'
        'LockedFile_Confirm' = 'Forzar eliminaciÃ³n:`n`n{0}`n`nâš  IRREVERSIBLE.'
        'LockedFile_Attempting' = 'ðŸ”¨ Intentando eliminar: {0}'
        'LockedFile_Deleted' = 'âœ… Archivo eliminado: {0}'
        'LockedFile_Success' = 'Archivo eliminado.'
        'LockedFile_CouldNotDelete' = 'âš ï¸ No se pudo eliminar: {0}'
        'LockedFile_ErrorDlg' = 'No se pudo eliminar.`n`nError: {0}'
        'LockedFile_HandlerError' = 'âš ï¸ Error en el gestor de archivos: {0}'
        'LockedFile_SuccessTitle' = 'Ã‰xito'
        'LockedFile_ErrorTitle' = 'Error'
        # --- Drivers ---
        'Drivers_Start' = 'ðŸ§¹ Iniciando limpieza de controladores obsoletos...'
        'Drivers_Saved' = 'ðŸ“‹ Lista de controladores guardada: {0}'
        'Drivers_Hint' = 'â„¹ Para eliminar un controlador: pnputil /delete-driver <oemXX.inf> /uninstall /force'
        'Drivers_Error' = 'âš ï¸ Error limpiando controladores: {0}'
        # --- Confirmations ---
        'Confirm_SFC_Title' = 'SFC'
        'Confirm_SFC_Message' = 'SFC se ejecutarÃ¡ en {0}. Â¿Continuar?'
        'Confirm_DISM_Title' = 'DISM'
        'Confirm_DISM_Message' = 'DISM se ejecutarÃ¡ en {0}. Â¿Continuar?'
        'Confirm_CHKDSK_Title' = 'CHKDSK'
        'Confirm_CHKDSK_Message' = 'CHKDSK /f se ejecutarÃ¡ en {0}. Puede requerir reinicio. Â¿Continuar?'
        'Confirm_Optimize_Title' = 'Optimizar Disco'
        'Confirm_Optimize_Message' = 'Abriendo Desfragmentador para {0}.`n`nSelecciona la unidad y haz clic en ''Optimizar''.`n`nÂ¿Continuar?'
        'Confirm_ResetNet_Title' = 'Restablecer Red'
        'Confirm_ResetNet_Message' = 'Winsock se restablecerÃ¡. Puede requerir reinicio. Â¿Continuar?'
        'Confirm_DeepClean_Title' = 'Limpieza Profunda'
        'Confirm_DeepClean_Message' = 'Se eliminarÃ¡n cachÃ©s del sistema y descargas de Windows Update. Â¿Continuar?'
        'Confirm_LogsClean_Title' = 'Limpiar Logs y WinSxS'
        'Confirm_LogsClean_Message' = 'Se limpiarÃ¡n los registros de eventos y del sistema. Â¿Continuar?'
        'Confirm_FullRepair_Title' = 'ReparaciÃ³n Completa'
        'Confirm_FullRepair_Message' = 'Â¿Ejecutar mantenimiento completo automÃ¡tico?`n`nCadena: limpieza â†’ flushdns â†’ SFC â†’ DISM.'
        'Confirm_FullClean_Title' = 'Limpieza en 1-Clic'
        'Confirm_FullClean_Message' = 'Â¿Ejecutar limpieza rÃ¡pida?`n`nElimina: temp, prefetch, cachÃ© DNS, cachÃ©s de navegadores, papelera.'
        'Confirm_RestorePoint_Title' = 'Punto de RestauraciÃ³n'
        'Confirm_RestorePoint_Message' = 'Se crearÃ¡ un punto de restauraciÃ³n. Puede tardar 1-3 minutos. Â¿Continuar?'
        'Confirm_CleanDrivers_Title' = 'Limpiar Controladores'
        'Confirm_CleanDrivers_Message' = 'Se limpiarÃ¡n componentes obsoletos vÃ­a DISM.`n`nSe recomienda un punto de restauraciÃ³n primero.`nÂ¿Continuar?'
        # --- SSD / Unknown block ---
        'SSD_Blocked_Title' = 'Bloqueado'
        'SSD_Blocked_Message' = 'La unidad {0} es un SSD.`n`nDesfragmentar un SSD acorta su vida Ãºtil.`nWindows ya usa TRIM.`n`nAcciÃ³n bloqueada por seguridad.'
        'SSD_Blocked_Log' = 'ðŸ›¡ï¸ Bloqueado: {0} es SSD.'
        'Unknown_Blocked_Message' = 'No se pudo determinar el tipo de disco de {0}. Bloqueado por seguridad.'
        'Unknown_Blocked_Title' = 'Desconocido'
        # --- Log messages (UI) ---
        'Log_System' = 'ðŸ’» {0} Â· {1} Â· PS {2}.'
        'Log_Diagnostics' = 'ðŸ” DiagnÃ³stico: {0} GB Â· {1}% Â· {2}.'
        'Log_DiagFailed' = 'âš ï¸ DiagnÃ³stico fallido: {0}'
        'Log_NoDisks' = 'âš ï¸ No se detectaron discos: {0}'
        'Log_Window' = 'ðŸ“ Ventana: {0}x{1} (pantalla {2}x{3} Â· pos {4},{5})'
        'Log_WindowError' = 'âš ï¸ No se pudo ajustar la ventana: {0}'
        'Log_ThemeRestored' = 'ðŸŽ¨ Tema restaurado: {0}'
        'Log_ThemeError' = 'âš ï¸ Error restaurando tema: {0}'
        'Log_LowModeRestored' = 'ðŸ¢ Modo Low restaurado.'
        'Log_AppStart' = 'OmegaSolver V4.3 iniciado (2-col BÃ¡sico / 3-col Avanzado Â· DPI Adaptativo Â· Comprobador de Actualizaciones Â· Modo Low Â· ES/EN/PT).'
        'Log_InitialDiag' = 'âœ… DiagnÃ³stico inicial completado.'
        'Log_DiagError' = 'âš ï¸ Error en diagnÃ³stico: {0}'
        'Log_CheckUpdates' = 'ðŸ”„ Comprobando actualizaciones en GitHub...'
        'Log_EcmFailed' = 'âš ï¸ ComprobaciÃ³n ECM fallida: {0}'
        'Log_LangChanged' = 'ðŸŒ Idioma cambiado a: {0}'
        'Log_LangError' = 'Error cambiando idioma: {0}'
        'Log_AdvancedOn' = 'ðŸ”§ Modo Avanzado ACTIVADO (3 columnas).'
        'Log_BasicOn' = 'ðŸŽ¯ Modo BÃ¡sico ACTIVADO (2 columnas balanceadas).'
        'Log_OmegaOn' = 'ðŸ›¸ ESTILO OMEGASOLVER ACTIVADO Â· sub-color: {0}'
        'Log_OmegaRestored' = 'ðŸ›¸ ESTILO OMEGASOLVER restaurado Â· sub-color: {0}'
        'Log_ThemeApplied' = 'ðŸŽ¨ Tema aplicado: {0}'
        'Log_ThemeApplyError' = 'âš ï¸ Error aplicando tema: {0}'
        'Log_OriginalPlan' = 'â†³ Plan original guardado.'
        'Log_ReversibleSaved' = 'â†³ Estado reversible guardado.'
        'Log_TaskError' = 'Error en tarea: {0}'
        'Log_OmegaEffectError' = 'âš ï¸ Error aplicando efectos OMEGASOLVER: {0}'
        'Log_UpdateError' = 'Error de actualizaciÃ³n: {0}'
        # --- Loading screen ---
        'Loading_SubMessage' = 'Esto puede tardar unos minutos...'
        'Loading_DoNotClose' = 'âš  Por favor no cierres esta ventana mientras el proceso estÃ¡ en ejecuciÃ³n.'
        # --- Task titles / steps ---
        'Task_AnalyzePC_Title' = 'Analizando PC'
        'Task_AnalyzePC_Step1' = 'Recopilando informaciÃ³n del sistema...'
        'Task_AnalyzePC_Step2' = 'Calculando temporales y cachÃ©s...'
        'Task_AnalyzePC_Step3' = 'Evaluando discos y baterÃ­a...'
        'Task_AnalyzePC_Step4' = 'Generando recomendaciones...'
        'Task_Starting_Title' = 'Iniciando OmegaSolver V4.3'
        'Task_Starting_Step1' = 'Preparando diagnÃ³stico inicial...'
        'Task_Starting_Step2' = 'Analizando sistema...'
        'Task_Starting_Step3' = 'Calculando temporales y cachÃ©s...'
        'Task_Starting_Step4' = 'Evaluando discos y baterÃ­a...'
        'Task_Starting_Step5' = 'Generando recomendaciones...'
        'Task_Starting_Step6' = 'Casi listo...'
        'Task_SFC_Title' = 'Reparando Sistema'
        'Task_SFC_Step1' = 'Preparando verificaciÃ³n de archivos...'
        'Task_SFC_Step2' = 'Ejecutando SFC /Scannow en {0}...'
        'Task_SFC_Step3' = 'Esto puede tardar varios minutos...'
        'Task_SFC_Step4' = 'Por favor no cierres la aplicaciÃ³n...'
        'Task_DISM_Title' = 'Reparando Imagen'
        'Task_DISM_Step1' = 'Preparando reparaciÃ³n de imagen...'
        'Task_DISM_Step2' = 'Ejecutando DISM /RestoreHealth en {0}...'
        'Task_DISM_Step3' = 'Esto puede tardar varios minutos...'
        'Task_DISM_Step4' = 'Por favor no cierres la aplicaciÃ³n...'
        'Task_CHKDSK_Title' = 'Comprobando Disco'
        'Task_CHKDSK_Step1' = 'Preparando comprobaciÃ³n de disco...'
        'Task_CHKDSK_Step2' = 'Ejecutando CHKDSK /f en {0}...'
        'Task_CHKDSK_Step3' = 'Esto puede tardar varios minutos...'
        'Task_CHKDSK_Step4' = 'Por favor no cierres la aplicaciÃ³n...'
        'Task_MaxPower_Title' = 'Optimizando EnergÃ­a'
        'Task_MaxPower_Step1' = 'Analizando plan de energÃ­a actual...'
        'Task_MaxPower_Step2' = 'Activando modo alto rendimiento...'
        'Task_MaxPower_Step3' = 'Aplicando cambios...'
        'Task_FlushDNS_Title' = 'Limpiando DNS'
        'Task_FlushDNS_Step1' = 'Accediendo a la cachÃ© DNS...'
        'Task_FlushDNS_Step2' = 'Eliminando registros DNS antiguos...'
        'Task_ResetNet_Title' = 'Restableciendo Red'
        'Task_ResetNet_Step1' = 'Restableciendo sockets de red...'
        'Task_ResetNet_Step2' = 'Reiniciando interfaces TCP/IP...'
        'Task_ResetNet_Step3' = 'Puede requerir reinicio...'
        'Task_QoS_Title' = 'Optimizando Red'
        'Task_QoS_Step1' = 'Accediendo a polÃ­ticas de red...'
        'Task_QoS_Step2' = 'Estableciendo lÃ­mite QoS a 0%...'
        'Task_QoS_Step3' = 'Aplicando cambios de registro...'
        'Task_Temp_Title' = 'Limpiando Temporales'
        'Task_Temp_Step1' = 'Accediendo a carpetas temporales...'
        'Task_Temp_Step2' = 'Eliminando archivos basura...'
        'Task_Temp_Step3' = 'Liberando espacio en disco...'
        'Task_DeepClean_Title' = 'Limpieza Profunda'
        'Task_DeepClean_Step1' = 'Deteniendo servicios de actualizaciÃ³n...'
        'Task_DeepClean_Step2' = 'Limpiando cachÃ©s de Windows Update...'
        'Task_DeepClean_Step3' = 'Eliminando temporales y registros...'
        'Task_DeepClean_Step4' = 'Restaurando servicios...'
        'Task_DeepClean_Step5' = 'Casi listo...'
        'Task_LogsClean_Title' = 'Limpiando Logs'
        'Task_LogsClean_Step1' = 'Limpiando registros de eventos...'
        'Task_LogsClean_Step2' = 'Eliminando registros del sistema...'
        'Task_LogsClean_Step3' = 'Ejecutando limpieza de WinSxS...'
        'Task_LogsClean_Step4' = 'Esto puede tardar varios minutos...'
        'Task_FullRepair_Title' = 'ReparaciÃ³n Completa'
        'Task_FullRepair_Step1' = 'Iniciando mantenimiento automÃ¡tico...'
        'Task_FullRepair_Step2' = 'Limpiando archivos temporales...'
        'Task_FullRepair_Step3' = 'Optimizando red...'
        'Task_FullRepair_Step4' = 'Ejecutando SFC...'
        'Task_FullRepair_Step5' = 'Ejecutando DISM...'
        'Task_FullRepair_Step6' = 'Finalizando reparaciÃ³n...'
        'Task_FullClean_Title' = 'Limpieza en 1-Clic'
        'Task_FullClean_Step1' = 'Eliminando temp de usuario...'
        'Task_FullClean_Step2' = 'Eliminando temp de Windows...'
        'Task_FullClean_Step3' = 'Limpiando prefetch...'
        'Task_FullClean_Step4' = 'Vaciando cachÃ© DNS...'
        'Task_FullClean_Step5' = 'Limpiando cachÃ©s de navegadores...'
        'Task_FullClean_Step6' = 'Vaciando papelera de reciclaje...'
        'Task_FullClean_Step7' = 'Finalizando...'
        'Task_RestorePoint_Title' = 'Creando Punto de RestauraciÃ³n'
        'Task_RestorePoint_Step1' = 'Comprobando protecciÃ³n del sistema...'
        'Task_RestorePoint_Step2' = 'Habilitando si es necesario...'
        'Task_RestorePoint_Step3' = 'Creando punto de restauraciÃ³n...'
        'Task_RestorePoint_Step4' = 'Por favor espera...'
        'Task_Startup_Title' = 'Gestor de Inicio'
        'Task_Startup_Step1' = 'Consultando registro de inicio...'
        'Task_Startup_Step2' = 'Analizando programas...'
        'Task_Startup_Step3' = 'Generando informe...'
        'Task_Updates_Title' = 'Analizando Actualizaciones'
        'Task_Updates_Step1' = 'Consultando historial de actualizaciones...'
        'Task_Updates_Step2' = 'Ordenando por fecha...'
        'Task_Updates_Step3' = 'Generando informe...'
        'Task_Drivers_Title' = 'Limpiando Controladores'
        'Task_Drivers_Step1' = 'Enumerando controladores...'
        'Task_Drivers_Step2' = 'Analizando componentes obsoletos...'
        'Task_Drivers_Step3' = 'Ejecutando limpieza DISM...'
        'Task_Drivers_Step4' = 'Esto puede tardar varios minutos...'
        'Task_Revert_Title' = 'Revirtiendo Cambios'
        'Task_Revert_Step1' = 'Restaurando plan de energÃ­a...'
        'Task_Revert_Step2' = 'Restaurando configuraciÃ³n QoS...'
        'Task_Revert_Step3' = 'Restaurando estados de servicios...'
        'Task_Revert_Step4' = 'Finalizando restauraciÃ³n...'
        # --- ECM ---
        'Ecm_Detected_Log' = 'âœ… Easy Context Menu detectado: {0}'
        'Ecm_OpenLog' = 'ðŸš€ Abriendo Easy Context Menu...'
        'Ecm_CouldNotOpen' = 'âš ï¸ No se pudo abrir ECM: {0}'
        'Ecm_NotDetected_Log' = 'â„¹ï¸ Easy Context Menu no detectado.'
        'Ecm_DownloadLog' = 'ðŸŒ Abriendo pÃ¡gina de descarga de ECM...'
        'Ecm_BrowserError' = 'âš ï¸ No se pudo abrir el navegador: {0}'
        'Ecm_IntegrationError' = 'âš ï¸ Error en integraciÃ³n ECM: {0}'
        'Ecm_Detected_Title' = 'Easy Context Menu detectado'
        'Ecm_NotInstalled_Title' = 'Easy Context Menu no instalado'
        # --- Share window ---
        'Share_WindowTitle' = 'Compartir Archivos - OmegaSolver V4.3'
        'Share_Header' = 'ðŸ“¡ Compartir Archivos por Red'
        'Share_SubHeader' = 'Conecta tu PC con otro dispositivo en la misma LAN'
        'Share_YourIPs' = 'ðŸ–¥ï¸ Tus IPs locales (para que el otro dispositivo se conecte):'
        'Share_CopyIP' = 'ðŸ“‹ Copiar IP principal'
        'Share_Method' = 'ðŸ”§ MÃ©todo de transferencia:'
        'Share_Method_Robocopy' = 'ðŸ“‚ Robocopy (SMB) â€” Windows â†” Windows'
        'Share_Method_FTP' = 'ðŸŒ FTP â€” Windows â†” Android / iOS / Smart TV'
        'Share_Hint_Robocopy' = 'Recomendado: crea una carpeta compartida en el otro dispositivo.'
        'Share_Hint_FTP' = "Instala una app de Servidor FTP en tu mÃ³vil (ej. 'WiFi FTP Server')."
        'Share_RemoteDetails' = 'ðŸŽ¯ Detalles del dispositivo remoto:'
        'Share_RemoteIP' = 'IP remota:'
        'Share_ShareName' = 'Nombre de carpeta compartida:'
        'Share_FtpPort' = 'Puerto FTP:'
        'Share_FtpPath' = 'Ruta FTP remota:'
        'Share_FtpUser' = 'Usuario FTP:'
        'Share_FtpPass' = 'ContraseÃ±a FTP:'
        'Share_LocalFolder' = 'ðŸ“ Carpeta local (enviar o recibir):'
        'Share_Browse' = 'ðŸ“‚ Explorar...'
        'Share_Direction' = 'â¬†ï¸â¬‡ï¸ DirecciÃ³n:'
        'Share_Send' = 'â¬† Enviar (yo â†’ otro dispositivo)'
        'Share_Receive' = 'â¬‡ Recibir (otro â†’ yo)'
        'Share_Status' = 'ðŸ“œ Estado:'
        'Share_StartTransfer' = 'ðŸš€ Iniciar Transferencia'
        'Share_Cancel' = 'Cancelar'
        'Share_NoIPs' = '  (No se detectaron IPs locales)'
        'Share_SelectFolder' = 'Seleccionar carpeta local'
        'Share_MissingRemoteIP' = 'âš  Falta la IP remota.'
        'Share_LocalFolderMissing' = 'âš  La carpeta local no existe: {0}'
        'Share_RobocopyMode' = 'ðŸ”— Modo Robocopy (SMB)'
        'Share_UncPath' = '   Ruta UNC: {0}'
        'Share_LocalPath' = '   Local:     {0}'
        'Share_CannotAccess' = 'âŒ No se puede acceder a {0}'
        'Share_CheckShare' = '   â€¢ Verifica la carpeta compartida en el otro dispositivo.'
        'Share_CheckFirewall' = '   â€¢ Verifica que el firewall permita compartir archivos.'
        'Share_Sending' = 'â¬† Enviando...'
        'Share_Receiving' = 'â¬‡ Recibiendo...'
        'Share_TransferComplete' = 'âœ… Transferencia completa (cÃ³digo {0}).'
        'Share_TransferErrors' = 'âš  Errores de Robocopy (cÃ³digo {0}).'
        'Share_FtpMode' = 'ðŸ”— Modo FTP: {0}'
        'Share_Uploading' = 'â¬† Subiendo {0} archivos...'
        'Share_UploadDone' = 'âœ… Subida completa. OK: {0} Â· Fallos: {1}'
        'Share_FtpDownload_NotSupported' = 'â„¹ Descarga FTP no soportada en esta versiÃ³n. Usa Robocopy.'
        'Share_Error' = 'âš  Error: {0}'
        'Share_RobocopyDone' = 'ðŸ“¡ Robocopy finalizado.'
        'Share_LoadError' = 'âš ï¸ Error cargando ventana de compartir: {0}'
        'Share_LoadErrorDlg' = 'No se pudo abrir la ventana de compartir.`n`n{0}'
        'Share_WindowError' = 'âš ï¸ Error en ventana de compartir: {0}'
        'Share_Close' = 'Cerrar'
        # --- Manual ---
        'Manual_Title' = 'Manual Â· Manual Â· Manual'
        'Manual_AppLine' = 'OmegaSolver V4.3'
        'Manual_Mode_Advanced' = 'Advanced Â· Avanzado Â· AvanÃ§ado'
        'Manual_Mode_Basic' = 'Basic Â· BÃ¡sico Â· BÃ¡sico'
        'Manual_Badge' = 'ðŸ”„  Auto-detectado: {0}  |  3 idiomas Â· 3 languages Â· 3 idiomas'
        'Manual_EsTitle' = 'ðŸ‡ªðŸ‡¸  ESPAÃ‘OL'
        'Manual_EnTitle' = 'ðŸ‡ºðŸ‡¸  ENGLISH'
        'Manual_PtTitle' = 'ðŸ‡§ðŸ‡·  PORTUGUÃŠS'
        'Manual_Footer' = 'â„¹  BAS = BÃ¡sico Â· TEC = TÃ©cnico  |  La info aplica a la versiÃ³n actual.'
        'Manual_CloseBtn' = 'Cerrar Â· Close Â· Fechar'
        # --- Error general ---
        'Error_Title' = 'Error'
        'Success_Title' = 'Ã‰xito'
        'Warning_Title' = 'Aviso'
        'Info_Title' = 'InformaciÃ³n'
        'SingleInstance_Title' = 'OmegaSolver V4.3 â€” Instancia Ãºnica'
        'SingleInstance_Message' = 'Ya hay una instancia de OmegaSolver V4.3 en ejecuciÃ³n.`n`nCierra la ventana abierta antes de iniciar otra.'
        'Admin_Required' = 'OmegaSolver V4.3 necesita permisos de administrador.'
        'Save_As_Ps1' = 'Guarda el script como .ps1 y ejecÃºtalo de nuevo.'
        # --- Component status ---
        'Components_OK' = 'âœ… OK Â· {0}'
        'Components_Missing' = 'âš ï¸ Faltan: {0}'
        # --- Window title bar ---
        'App_Title' = 'OmegaSolver'
        'App_Version' = ' V4.3'
        'Omega_Title' = 'â—¤ OMEGASOLVER â—¢'
        'Omega_Version' = '  // v4.3 //'
        'Omega_Pattern' = 'PATRÃ“N:'
        'Omega_Warning_Title' = 'OMEGASOLVER STYLE â€” Advertencia'
        'Omega_Warning_Message' = "âš  ADVERTENCIA â€” ESTILO OMEGASOLVER`n`nEste tema TRANSFORMA la UI con estÃ©tica alienÃ­gena inspirada en Murder Drones.`n`nSOLO RECOMENDADO PARA USUARIOS AVANZADOS.`n`nÂ¿Activar el modo OMEGASOLVER?"
        'Omega_SubColor_Tooltip' = 'Sub-color neÃ³n para el estilo OMEGASOLVER'
    }
    'EN' = @{
        'Lang_Caption' = 'Language:'
        'Theme_Caption' = 'Theme:'
        'Check_Advanced' = 'Advanced'
        'Check_LowMode' = 'Low Mode'
        'Status_Prefix' = 'Status: '
        'Status_Ready' = 'Ready'
        'Status_Starting' = 'Starting...'
        'Status_Analyzing' = 'Analyzing...'
        'Status_Checking_Updates' = 'Checking updates...'
        'Status_Checking' = 'Checking...'
        'Status_Detecting' = 'Detecting...'
        'Detecting' = 'Detecting...'
        'Checking' = 'Checking...'
        'Lbl_PC' = 'DEVICE'
        'Lbl_Windows' = 'WINDOWS'
        'Lbl_PowerShell' = 'POWERSHELL'
        'Lbl_Components' = 'COMPONENTS'
        'Stats_Heading' = 'ðŸ” Detailed Diagnostics'
        'Stats_Subtitle' = 'Temporary files and caches level'
        'Stats_Analyzing' = 'Analyzing...'
        'Stats_Summary' = 'SUMMARY'
        'Stats_Preparing' = 'Preparing analysis...'
        'Stats_Calculating' = 'Calculating...'
        'Stats_Reference' = 'reference'
        'Stats_Unavailable' = 'Diagnostics unavailable'
        'Stats_CouldNotComplete' = 'Analysis could not complete.'
        'Stats_Text_Line1' = 'Temp/caches: {0} GB.'
        'Stats_Text_Line2' = 'Disk: {0}.'
        'Stats_Text_Line3' = 'Power: {0}.'
        'Stats_Free_Format' = '{0}% free ({1}/{2} GB)'
        'Stats_NA' = 'n/a'
        'Rec_LowDisk' = 'Low disk space. Prioritize cleanup.'
        'Rec_LowDiskMid' = 'Disk space is somewhat low; cleanup recommended.'
        'Rec_JunkDetected' = '~{0} GB detected in temp/caches.'
        'Rec_LittleJunk' = 'Little temp content; cleanup not urgent.'
        'Rec_DeepCleanHint' = 'Deep Clean can recover more space.'
        'Rec_Battery' = 'On battery: High Performance increases consumption.'
        'Rec_AC' = 'High Performance available.'
        'Basic_RepairHeading' = 'ðŸ› ï¸ Repair my PC'
        'Label_TargetDisk' = 'ðŸŽ¯ Drive to check:'
        'Btn_Refresh' = 'â†º Refresh'
        'Sub_Repair' = 'ðŸ”§ Repair'
        'Btn_RepairWindows' = 'Repair Windows'
        'Btn_RecoverSystem' = 'Recover System'
        'Btn_CheckDisk' = 'Check Disk'
        'Btn_DefragDisk' = 'Order Disk'
        'Btn_MaxPerformance' = 'âš¡ Performance Mode'
        'Sub_Security' = 'ðŸ›¡ï¸ Safety'
        'Btn_RestorePoint' = 'Create Restore Point'
        'Btn_StartupManager' = 'Manage Startup Programs'
        'Btn_RepairAll' = 'âš¡ Repair All'
        'Basic_CleanHeading' = 'ðŸ§¹ Cleanup'
        'Btn_TempCleanup' = 'Delete Temp Files'
        'Btn_DeepClean' = 'Full Cleanup'
        'Btn_ClearHistory' = 'Clear History'
        'Sub_Internet' = 'ðŸŒ Fix Internet'
        'Btn_FixInternet' = 'Fix Internet'
        'Btn_RestartNetwork' = 'Restart Network'
        'Btn_SpeedNetwork' = 'ðŸš€ Speed Up Network'
        'Btn_CleanAll' = 'ðŸ§¹ 1-Click Cleanup'
        'Tip_Heading' = 'ðŸ’¡ Tip'
        'Tip_Text' = "If nothing works, try 'Restart Network'. Some changes may require a reboot."
        'Adv_SystemHeading' = 'ðŸ› ï¸ System & Performance'
        'Label_TargetDiskAdv' = 'ðŸŽ¯ Target drive:'
        'Btn_RefreshDrives' = 'â†º Refresh drives'
        'Btn_RunSFC' = 'Run SFC /Scannow'
        'Btn_RepairDISM' = 'Repair Image DISM'
        'Btn_RepairCHKDSK' = 'Repair Disk (CHKDSK /f)'
        'Btn_DefragUnit' = 'ðŸ’½ Defragment Drive'
        'Btn_HighPerf' = 'âš¡ Enable High Performance'
        'Adv_NetworkHeading' = 'ðŸŒ Network & Connection'
        'Btn_ClearDNSCache' = 'Clear DNS Cache'
        'Btn_ResetWinsock' = 'Reset Winsock / IP'
        'Btn_ConfigQoS' = 'ðŸš€ Set QoS to 0%'
        'Sub_Share' = 'ðŸ“¡ Share Files'
        'Btn_ShareFiles' = 'ðŸ”— Connect to another PC / Mobile'
        'Share_Desc' = 'Share files between PC and mobile over LAN (Robocopy / FTP).'
        'Sub_SystemTools' = 'ðŸ›¡ï¸ System Tools'
        'Btn_AnalyzeUpdates' = 'Analyze Updates'
        'Adv_MaintHeading' = 'ðŸ§¹ Maintenance'
        'Btn_TempCleanAdv' = 'Clean Basic Temp Files'
        'Btn_DeepCleanWinUpd' = 'ðŸ§¹ Deep Clean / WinUpdate'
        'Btn_CleanLogsWinSxS' = 'ðŸ—‘ï¸ Clean Logs & WinSxS'
        'Sub_AdvancedTools' = 'ðŸ› ï¸ Advanced Tools'
        'Btn_LockedFiles' = 'Locked Files Handler'
        'Btn_DriverCleanup' = 'Clean Obsolete Drivers'
        'Btn_OneClickRepair' = 'âš¡ 1-Click Repair'
        'Btn_OneClickClean' = 'ðŸ§¹ 1-Click Cleanup'
        'Rec_Heading' = 'ðŸ’¡ Personalized Recommendations'
        'Rec_Placeholder' = 'Analyzing system state...'
        'Log_Heading' = 'ðŸ“œ Activity Log'
        'Footer_Notice' = 'Reversible changes are stored locally on this device.'
        'Btn_AnalyzePC' = 'ðŸ” Analyze PC'
        'Btn_Manual' = 'ðŸ“– Detailed Manual'
        'Btn_Revert' = 'â†© Revert Changes'
        'Update_Badge' = 'â¬† New version: {0}'
        'Update_Tooltip' = 'Click to open download page'
        'UpdateCheck_Tooltip' = 'Check GitHub for updates'
        'Drive_NoLabel' = 'No label'
        'Drive_ActiveWindows' = 'Active Windows'
        'Drive_OfflineWindows' = 'Offline Windows'
        'Drive_Data' = 'Data'
        'Drive_NoSelected' = 'No drive selected.'
        'Drive_SFC_Online' = '{0}: Active Windows. SFC/DISM Online mode.'
        'Drive_SFC_Offline' = '{0}: Offline Windows. SFC/DISM Offline mode.'
        'Drive_DataOnly' = '{0}: data. Only CHKDSK applies.'
        'Drive_NoDrivesDetected' = 'No drives detected.'
        'Drive_DetectedCount' = 'Drives detected: {0}.'
        'Drive_DetectError' = 'Error detecting drives: {0}'
        'Drive_HDDDetected' = 'ðŸ’½ {0} HDD detected. Optimization enabled.'
        'Drive_SSDDetected' = 'ðŸ›¡ï¸ {0} SSD detected. Optimization blocked.'
        'Drive_CouldNotDetermine' = 'Could not determine disk type.'
        'Btn_Defrag_NoDrive' = 'ðŸ’½ (No drive)'
        'Btn_Defrag_HDD' = 'Order disk'
        'Btn_Defrag_SSD_Blocked' = 'Order disk (SSD - Blocked)'
        'Btn_Defrag_Unknown' = 'Order disk (Not detected)'
        'Btn_DefragAdv_HDD' = 'ðŸ’½ Defragment Drive'
        'Btn_DefragAdv_SSD_Blocked' = 'ðŸ’½ Defragment (SSD - Blocked)'
        'Btn_DefragAdv_Unknown' = 'ðŸ’½ Defragment (Not detected)'
        'Drive_Tooltip_HDD' = 'Optimize {0} (HDD detected).'
        'Drive_Tooltip_SSD' = 'Blocked for safety: {0} is an SSD.'
        'Drive_Tooltip_Unknown' = 'Could not determine disk type.'
        'Repair_NotApplicable_SFC' = 'âš ï¸ SFC not applicable.'
        'Repair_NotApplicable_DISM' = 'âš ï¸ DISM not applicable.'
        'Repair_SFC_Online' = 'ðŸ› ï¸ SFC: repairing active Windows...'
        'Repair_SFC_Offline' = 'ðŸ› ï¸ SFC: repairing offline Windows...'
        'Repair_DISM_Online' = 'ðŸ› ï¸ DISM: repairing active image...'
        'Repair_DISM_Offline' = 'ðŸ› ï¸ DISM: repairing offline image...'
        'Repair_CHKDSK_Checking' = 'ðŸ’¾ CHKDSK: checking {0}...'
        'Clean_Basic_Start' = '[+] Cleaning basic temp files...'
        'Clean_Basic_Done' = 'âœ… Basic temp files removed.'
        'Clean_Error' = 'âš ï¸ Error: {0}'
        'Clean_Logs_Start' = '[+] Cleaning logs and WinSxS...'
        'Clean_Deep_Disabling' = '[+] Disabling hibernation...'
        'Clean_Deep_StoppingServices' = '[+] Stopping services...'
        'Clean_Deep_CleaningCaches' = '[+] Cleaning caches and temp...'
        'Clean_1Click_Start' = 'ðŸ§¹ Starting 1-Click Cleanup...'
        'Clean_1Click_Done' = 'âœ… Cleanup complete. Temp files: {0} GB.'
        'Revert_Confirm_Title' = 'Revert Changes'
        'Revert_Confirm_Message' = 'Restore saved settings for power, QoS and services?'
        'Revert_Start' = '[+] Reverting changes...'
        'Revert_PowerRestored' = 'â†© Power plan restored.'
        'Revert_QoSRestored' = 'â†© QoS restored.'
        'Revert_QoSRemoved' = 'â†© QoS removed.'
        'Revert_Hibernation' = 'â†© Hibernation re-enabled.'
        'Revert_Done' = 'âœ… Restore completed.'
        'Update_Checking' = 'Checking updates...'
        'Update_CheckGitHub' = 'ðŸ”„ Checking GitHub for updates...'
        'Update_Available_Log' = 'â¬† New version available: v{0} (current: v{1})'
        'Update_Latest_Log' = 'You are on the latest version (v{0}).'
        'Update_Offline_Log' = 'No internet connection â€” cannot check for updates.'
        'Update_RepoNotFound_Log' = 'GitHub repo not found.'
        'Update_Error_Log' = 'Error: {0}'
        'Update_Dialog_Title' = 'Update Available'
        'Update_Dialog_Message' = 'New version available!`n`nCurrent: v{0}`nLatest: v{1}`n`nOpen download page?'
        'Update_NoUpdates_Title' = 'No Updates'
        'Update_NoUpdates_Message' = 'You are on the latest version (v{0}).'
        'Update_Offline_Title' = 'Offline'
        'Update_Offline_Message' = 'Could not check for updates. No internet connection.'
        'Update_Error_Title' = 'Error'
        'Update_Error_Message' = 'Could not check updates.`n`n{0}'
        'Update_StatusLine' = 'ðŸ”„ Update check: {0}'
        'Update_FailedLog' = 'âš ï¸ Update check failed: {0}'
        'Update_UIError' = 'âš ï¸ Update check UI error: {0}'
        'LowMode_Enabled' = 'ðŸ¢ Low Mode ENABLED â€” effects reduced for low-resource PCs.'
        'LowMode_Disabled' = 'âš¡ Low Mode DISABLED â€” effects restored.'
        'LowMode_Error' = 'âš ï¸ Error applying Low Mode: {0}'
        'Restore_Enabled' = 'ðŸ”§ System protection enabled.'
        'Restore_CouldNotEnable' = 'âš ï¸ Could not enable protection (may already be active).'
        'Restore_Created' = 'âœ… Restore point created: {0}'
        'Restore_Success' = 'Restore point created successfully.'
        'Restore_Error' = 'âš ï¸ Error creating restore point: {0}'
        'Restore_ErrorDlg' = 'Could not create restore point.`n`nError: {0}'
        'Restore_SuccessTitle' = 'Success'
        'Restore_ErrorTitle' = 'Error'
        'Startup_Analyzing' = 'ðŸ” Analyzing startup programs...'
        'Startup_NoPrograms' = 'No startup programs found.'
        'Startup_Title' = 'Startup Manager'
        'Startup_Found' = 'Found {0} startup programs.`n`nSee ''Recommendations'' for details.'
        'Startup_Header' = '=== STARTUP PROGRAMS ({0} found) ==='
        'Startup_Location' = 'Location'
        'Startup_Command' = 'Command'
        'Startup_Error' = 'âš ï¸ Error analyzing startup: {0}'
        'Updates_Analyzing' = 'ðŸ” Analyzing installed updates...'
        'Updates_Header' = '=== INSTALLED UPDATES (last 15) ==='
        'Updates_Found' = 'âœ… Found {0} updates.'
        'Updates_Error' = 'âš ï¸ Error getting updates: {0}'
        'LockedFile_Title' = 'Select locked file to delete'
        'LockedFile_Filter' = 'All files (*.*)|*.*'
        'LockedFile_ConfirmTitle' = 'Delete Locked File'
        'LockedFile_Confirm' = 'Force delete:`n`n{0}`n`nâš  IRREVERSIBLE.'
        'LockedFile_Attempting' = 'ðŸ”¨ Attempting to delete: {0}'
        'LockedFile_Deleted' = 'âœ… File deleted: {0}'
        'LockedFile_Success' = 'File deleted.'
        'LockedFile_CouldNotDelete' = 'âš ï¸ Could not delete: {0}'
        'LockedFile_ErrorDlg' = 'Could not delete.`n`nError: {0}'
        'LockedFile_HandlerError' = 'âš ï¸ Error in file handler: {0}'
        'LockedFile_SuccessTitle' = 'Success'
        'LockedFile_ErrorTitle' = 'Error'
        'Drivers_Start' = 'ðŸ§¹ Starting obsolete driver cleanup...'
        'Drivers_Saved' = 'ðŸ“‹ Driver list saved: {0}'
        'Drivers_Hint' = 'â„¹ To remove a driver: pnputil /delete-driver <oemXX.inf> /uninstall /force'
        'Drivers_Error' = 'âš ï¸ Driver cleanup error: {0}'
        'Confirm_SFC_Title' = 'SFC'
        'Confirm_SFC_Message' = 'SFC will run on {0}. Continue?'
        'Confirm_DISM_Title' = 'DISM'
        'Confirm_DISM_Message' = 'DISM will run on {0}. Continue?'
        'Confirm_CHKDSK_Title' = 'CHKDSK'
        'Confirm_CHKDSK_Message' = 'CHKDSK /f will run on {0}. May require reboot. Continue?'
        'Confirm_Optimize_Title' = 'Optimize Disk'
        'Confirm_Optimize_Message' = 'Opening Defragmenter for {0}.`n`nSelect the drive and click ''Optimize''.`n`nContinue?'
        'Confirm_ResetNet_Title' = 'Reset Network'
        'Confirm_ResetNet_Message' = 'Winsock will be reset. May require reboot. Continue?'
        'Confirm_DeepClean_Title' = 'Deep Clean'
        'Confirm_DeepClean_Message' = 'System caches and Windows Update downloads will be deleted. Continue?'
        'Confirm_LogsClean_Title' = 'Clear Logs & WinSxS'
        'Confirm_LogsClean_Message' = 'Event logs and system logs will be cleared. Continue?'
        'Confirm_FullRepair_Title' = 'Full Repair'
        'Confirm_FullRepair_Message' = 'Run automatic full maintenance?`n`nChain: cleanup â†’ flushdns â†’ SFC â†’ DISM.'
        'Confirm_FullClean_Title' = '1-Click Cleanup'
        'Confirm_FullClean_Message' = 'Run quick cleanup?`n`nRemoves: temp, prefetch, DNS cache, browser caches, recycle bin.'
        'Confirm_RestorePoint_Title' = 'Restore Point'
        'Confirm_RestorePoint_Message' = 'A restore point will be created. May take 1-3 minutes. Continue?'
        'Confirm_CleanDrivers_Title' = 'Clean Drivers'
        'Confirm_CleanDrivers_Message' = 'Obsolete components will be cleaned via DISM.`n`nA restore point is recommended first.`nContinue?'
        'SSD_Blocked_Title' = 'Blocked'
        'SSD_Blocked_Message' = 'Drive {0} is an SSD.`n`nDefragmenting an SSD shortens its lifespan.`nWindows already uses TRIM.`n`nAction blocked for safety.'
        'SSD_Blocked_Log' = 'ðŸ›¡ï¸ Blocked: {0} is SSD.'
        'Unknown_Blocked_Message' = 'Could not determine disk type for {0}. Blocked for safety.'
        'Unknown_Blocked_Title' = 'Unknown'
        'Log_System' = 'ðŸ’» {0} Â· {1} Â· PS {2}.'
        'Log_Diagnostics' = 'ðŸ” Diagnostics: {0} GB Â· {1}% Â· {2}.'
        'Log_DiagFailed' = 'âš ï¸ Diagnostic failed: {0}'
        'Log_NoDisks' = 'âš ï¸ No disks detected: {0}'
        'Log_Window' = 'ðŸ“ Window: {0}x{1} (screen {2}x{3} Â· pos {4},{5})'
        'Log_WindowError' = 'âš ï¸ Could not adjust window: {0}'
        'Log_ThemeRestored' = 'ðŸŽ¨ Theme restored: {0}'
        'Log_ThemeError' = 'âš ï¸ Error restoring theme: {0}'
        'Log_LowModeRestored' = 'ðŸ¢ Low Mode restored.'
        'Log_AppStart' = 'OmegaSolver V4.3 started (Basic 2-col Balanced / Advanced 3-col Â· DPI Adaptive Â· Update Checker Â· Low Mode Â· ES/EN/PT).'
        'Log_InitialDiag' = 'âœ… Initial diagnostics completed.'
        'Log_DiagError' = 'âš ï¸ Diagnostics error: {0}'
        'Log_CheckUpdates' = 'ðŸ”„ Checking GitHub for updates...'
        'Log_EcmFailed' = 'âš ï¸ ECM check failed: {0}'
        'Log_LangChanged' = 'ðŸŒ Language changed to: {0}'
        'Log_LangError' = 'Error changing language: {0}'
        'Log_AdvancedOn' = 'ðŸ”§ Advanced Mode ON (3 columns).'
        'Log_BasicOn' = 'ðŸŽ¯ Basic Mode ON (2 balanced columns).'
        'Log_OmegaOn' = 'ðŸ›¸ OMEGASOLVER STYLE ON Â· sub-color: {0}'
        'Log_OmegaRestored' = 'ðŸ›¸ OMEGASOLVER STYLE restored Â· sub-color: {0}'
        'Log_ThemeApplied' = 'ðŸŽ¨ Theme applied: {0}'
        'Log_ThemeApplyError' = 'âš ï¸ Error applying theme: {0}'
        'Log_OriginalPlan' = 'â†³ Original plan saved.'
        'Log_ReversibleSaved' = 'â†³ Reversible state saved.'
        'Log_TaskError' = 'Task error: {0}'
        'Log_OmegaEffectError' = 'âš ï¸ Error applying OMEGASOLVER effects: {0}'
        'Log_UpdateError' = 'Update error: {0}'
        'Loading_SubMessage' = 'This may take a few minutes...'
        'Loading_DoNotClose' = 'âš  Please do not close this window while the process is running.'
        'Task_AnalyzePC_Title' = 'Analyzing PC'
        'Task_AnalyzePC_Step1' = 'Collecting system info...'
        'Task_AnalyzePC_Step2' = 'Calculating temp/caches...'
        'Task_AnalyzePC_Step3' = 'Evaluating drives & battery...'
        'Task_AnalyzePC_Step4' = 'Generating recommendations...'
        'Task_Starting_Title' = 'Starting OmegaSolver V4.3'
        'Task_Starting_Step1' = 'Preparing initial diagnostics...'
        'Task_Starting_Step2' = 'Analyzing system...'
        'Task_Starting_Step3' = 'Calculating temp/caches...'
        'Task_Starting_Step4' = 'Evaluating drives & battery...'
        'Task_Starting_Step5' = 'Generating recommendations...'
        'Task_Starting_Step6' = 'Almost ready...'
        'Task_SFC_Title' = 'Repairing System'
        'Task_SFC_Step1' = 'Preparing file verification...'
        'Task_SFC_Step2' = 'Running SFC /Scannow on {0}...'
        'Task_SFC_Step3' = 'This may take several minutes...'
        'Task_SFC_Step4' = 'Please do not close the app...'
        'Task_DISM_Title' = 'Repairing Image'
        'Task_DISM_Step1' = 'Preparing image repair...'
        'Task_DISM_Step2' = 'Running DISM /RestoreHealth on {0}...'
        'Task_DISM_Step3' = 'This may take several minutes...'
        'Task_DISM_Step4' = 'Please do not close the app...'
        'Task_CHKDSK_Title' = 'Checking Disk'
        'Task_CHKDSK_Step1' = 'Preparing disk check...'
        'Task_CHKDSK_Step2' = 'Running CHKDSK /f on {0}...'
        'Task_CHKDSK_Step3' = 'This may take several minutes...'
        'Task_CHKDSK_Step4' = 'Please do not close the app...'
        'Task_MaxPower_Title' = 'Optimizing Energy'
        'Task_MaxPower_Step1' = 'Analyzing current power plan...'
        'Task_MaxPower_Step2' = 'Activating high performance mode...'
        'Task_MaxPower_Step3' = 'Applying changes...'
        'Task_FlushDNS_Title' = 'Clearing DNS'
        'Task_FlushDNS_Step1' = 'Accessing DNS cache...'
        'Task_FlushDNS_Step2' = 'Removing old DNS records...'
        'Task_ResetNet_Title' = 'Resetting Network'
        'Task_ResetNet_Step1' = 'Resetting network sockets...'
        'Task_ResetNet_Step2' = 'Restarting TCP/IP interfaces...'
        'Task_ResetNet_Step3' = 'May require reboot...'
        'Task_QoS_Title' = 'Optimizing Network'
        'Task_QoS_Step1' = 'Accessing network policies...'
        'Task_QoS_Step2' = 'Setting QoS limit to 0%...'
        'Task_QoS_Step3' = 'Applying registry changes...'
        'Task_Temp_Title' = 'Cleaning Temp Files'
        'Task_Temp_Step1' = 'Accessing temp folders...'
        'Task_Temp_Step2' = 'Removing junk files...'
        'Task_Temp_Step3' = 'Freeing disk space...'
        'Task_DeepClean_Title' = 'Deep Clean'
        'Task_DeepClean_Step1' = 'Stopping update services...'
        'Task_DeepClean_Step2' = 'Cleaning Windows Update caches...'
        'Task_DeepClean_Step3' = 'Removing temp files and logs...'
        'Task_DeepClean_Step4' = 'Restoring services...'
        'Task_DeepClean_Step5' = 'Almost done...'
        'Task_LogsClean_Title' = 'Cleaning Logs'
        'Task_LogsClean_Step1' = 'Clearing event logs...'
        'Task_LogsClean_Step2' = 'Removing system logs...'
        'Task_LogsClean_Step3' = 'Running WinSxS cleanup...'
        'Task_LogsClean_Step4' = 'This may take several minutes...'
        'Task_FullRepair_Title' = 'Full Repair'
        'Task_FullRepair_Step1' = 'Starting automatic maintenance...'
        'Task_FullRepair_Step2' = 'Cleaning temp files...'
        'Task_FullRepair_Step3' = 'Optimizing network...'
        'Task_FullRepair_Step4' = 'Running SFC...'
        'Task_FullRepair_Step5' = 'Running DISM...'
        'Task_FullRepair_Step6' = 'Finalizing repair...'
        'Task_FullClean_Title' = '1-Click Cleanup'
        'Task_FullClean_Step1' = 'Removing user temp...'
        'Task_FullClean_Step2' = 'Removing Windows temp...'
        'Task_FullClean_Step3' = 'Cleaning prefetch...'
        'Task_FullClean_Step4' = 'Flushing DNS cache...'
        'Task_FullClean_Step5' = 'Cleaning browser caches...'
        'Task_FullClean_Step6' = 'Emptying recycle bin...'
        'Task_FullClean_Step7' = 'Finalizing...'
        'Task_RestorePoint_Title' = 'Creating Restore Point'
        'Task_RestorePoint_Step1' = 'Checking system protection...'
        'Task_RestorePoint_Step2' = 'Enabling if needed...'
        'Task_RestorePoint_Step3' = 'Creating restore point...'
        'Task_RestorePoint_Step4' = 'Please wait...'
        'Task_Startup_Title' = 'Startup Manager'
        'Task_Startup_Step1' = 'Querying startup registry...'
        'Task_Startup_Step2' = 'Analyzing programs...'
        'Task_Startup_Step3' = 'Generating report...'
        'Task_Updates_Title' = 'Analyzing Updates'
        'Task_Updates_Step1' = 'Querying update history...'
        'Task_Updates_Step2' = 'Sorting by date...'
        'Task_Updates_Step3' = 'Generating report...'
        'Task_Drivers_Title' = 'Cleaning Drivers'
        'Task_Drivers_Step1' = 'Enumerating drivers...'
        'Task_Drivers_Step2' = 'Analyzing obsolete components...'
        'Task_Drivers_Step3' = 'Running DISM cleanup...'
        'Task_Drivers_Step4' = 'This may take several minutes...'
        'Task_Revert_Title' = 'Reverting Changes'
        'Task_Revert_Step1' = 'Restoring power plan...'
        'Task_Revert_Step2' = 'Restoring QoS config...'
        'Task_Revert_Step3' = 'Restoring service states...'
        'Task_Revert_Step4' = 'Finalizing restore...'
        'Ecm_Detected_Log' = 'âœ… Easy Context Menu detected: {0}'
        'Ecm_OpenLog' = 'ðŸš€ Opening Easy Context Menu...'
        'Ecm_CouldNotOpen' = 'âš ï¸ Could not open ECM: {0}'
        'Ecm_NotDetected_Log' = 'â„¹ï¸ Easy Context Menu not detected.'
        'Ecm_DownloadLog' = 'ðŸŒ Opening ECM download page...'
        'Ecm_BrowserError' = 'âš ï¸ Could not open browser: {0}'
        'Ecm_IntegrationError' = 'âš ï¸ ECM integration error: {0}'
        'Ecm_Detected_Title' = 'Easy Context Menu detected'
        'Ecm_NotInstalled_Title' = 'Easy Context Menu not installed'
        'Share_WindowTitle' = 'Share Files - OmegaSolver V4.3'
        'Share_Header' = 'ðŸ“¡ Share Files over Network'
        'Share_SubHeader' = 'Connect your PC with another device on the same LAN'
        'Share_YourIPs' = 'ðŸ–¥ï¸ Your local IPs (for the other device to connect):'
        'Share_CopyIP' = 'ðŸ“‹ Copy main IP'
        'Share_Method' = 'ðŸ”§ Transfer method:'
        'Share_Method_Robocopy' = 'ðŸ“‚ Robocopy (SMB) â€” Windows â†” Windows'
        'Share_Method_FTP' = 'ðŸŒ FTP â€” Windows â†” Android / iOS / Smart TV'
        'Share_Hint_Robocopy' = 'Recommended: create a shared folder on the other device.'
        'Share_Hint_FTP' = "Install an FTP Server app on your mobile (e.g. 'WiFi FTP Server')."
        'Share_RemoteDetails' = 'ðŸŽ¯ Remote device details:'
        'Share_RemoteIP' = 'Remote IP:'
        'Share_ShareName' = 'Shared folder name:'
        'Share_FtpPort' = 'FTP Port:'
        'Share_FtpPath' = 'Remote FTP path:'
        'Share_FtpUser' = 'FTP User:'
        'Share_FtpPass' = 'FTP Password:'
        'Share_LocalFolder' = 'ðŸ“ Local folder (send or receive):'
        'Share_Browse' = 'ðŸ“‚ Browse...'
        'Share_Direction' = 'â¬†ï¸â¬‡ï¸ Direction:'
        'Share_Send' = 'â¬† Send (me â†’ other device)'
        'Share_Receive' = 'â¬‡ Receive (other â†’ me)'
        'Share_Status' = 'ðŸ“œ Status:'
        'Share_StartTransfer' = 'ðŸš€ Start Transfer'
        'Share_Cancel' = 'Cancel'
        'Share_NoIPs' = '  (No local IPs detected)'
        'Share_SelectFolder' = 'Select local folder'
        'Share_MissingRemoteIP' = 'âš  Missing remote IP.'
        'Share_LocalFolderMissing' = 'âš  Local folder does not exist: {0}'
        'Share_RobocopyMode' = 'ðŸ”— Robocopy (SMB) Mode'
        'Share_UncPath' = '   UNC path: {0}'
        'Share_LocalPath' = '   Local:    {0}'
        'Share_CannotAccess' = 'âŒ Cannot access {0}'
        'Share_CheckShare' = '   â€¢ Check the shared folder on the other device.'
        'Share_CheckFirewall' = '   â€¢ Check firewall allows file sharing.'
        'Share_Sending' = 'â¬† Sending...'
        'Share_Receiving' = 'â¬‡ Receiving...'
        'Share_TransferComplete' = 'âœ… Transfer complete (code {0}).'
        'Share_TransferErrors' = 'âš  Robocopy errors (code {0}).'
        'Share_FtpMode' = 'ðŸ”— FTP Mode: {0}'
        'Share_Uploading' = 'â¬† Uploading {0} files...'
        'Share_UploadDone' = 'âœ… Upload done. OK: {0} Â· Fail: {1}'
        'Share_FtpDownload_NotSupported' = 'â„¹ FTP download not supported in this version. Use Robocopy.'
        'Share_Error' = 'âš  Error: {0}'
        'Share_RobocopyDone' = 'ðŸ“¡ Robocopy done.'
        'Share_LoadError' = 'âš ï¸ Error loading share window: {0}'
        'Share_LoadErrorDlg' = 'Could not open share window.`n`n{0}'
        'Share_WindowError' = 'âš ï¸ Share window error: {0}'
        'Share_Close' = 'Close'
        'Manual_Title' = 'Manual Â· Manual Â· Manual'
        'Manual_AppLine' = 'OmegaSolver V4.3'
        'Manual_Mode_Advanced' = 'Advanced Â· Avanzado Â· AvanÃ§ado'
        'Manual_Mode_Basic' = 'Basic Â· BÃ¡sico Â· BÃ¡sico'
        'Manual_Badge' = 'ðŸ”„  Auto-detected: {0}  |  3 languages Â· 3 idiomas Â· 3 idiomas'
        'Manual_EsTitle' = 'ðŸ‡ªðŸ‡¸  ESPAÃ‘OL'
        'Manual_EnTitle' = 'ðŸ‡ºðŸ‡¸  ENGLISH'
        'Manual_PtTitle' = 'ðŸ‡§ðŸ‡·  PORTUGUÃŠS'
        'Manual_Footer' = 'â„¹  BAS = Basic Â· TEC = Technical  |  Info applies to current version.'
        'Manual_CloseBtn' = 'Close Â· Cerrar Â· Fechar'
        'Error_Title' = 'Error'
        'Success_Title' = 'Success'
        'Warning_Title' = 'Warning'
        'Info_Title' = 'Information'
        'SingleInstance_Title' = 'OmegaSolver V4.3 â€” Single Instance'
        'SingleInstance_Message' = 'An instance of OmegaSolver V4.3 is already running.`n`nClose the open window before starting another.'
        'Admin_Required' = 'OmegaSolver V4.3 requires administrator privileges.'
        'Save_As_Ps1' = 'Save the script as .ps1 and run it again.'
        'Components_OK' = 'âœ… OK Â· {0}'
        'Components_Missing' = 'âš ï¸ Missing: {0}'
        'App_Title' = 'OmegaSolver'
        'App_Version' = ' V4.3'
        'Omega_Title' = 'â—¤ OMEGASOLVER â—¢'
        'Omega_Version' = '  // v4.3 //'
        'Omega_Pattern' = 'PATTERN:'
        'Omega_Warning_Title' = 'OMEGASOLVER STYLE â€” Warning'
        'Omega_Warning_Message' = "âš  WARNING â€” OMEGASOLVER STYLE`n`nThis theme TRANSFORMS the UI with alien aesthetics inspired by Murder Drones.`n`nONLY RECOMMENDED FOR ADVANCED USERS.`n`nActivate OMEGASOLVER mode?"
        'Omega_SubColor_Tooltip' = 'Neon sub-color for OMEGASOLVER style'
    }
    'PT' = @{
        'Lang_Caption' = 'Idioma:'
        'Theme_Caption' = 'Tema:'
        'Check_Advanced' = 'AvanÃ§ado'
        'Check_LowMode' = 'Modo Low'
        'Status_Prefix' = 'Status: '
        'Status_Ready' = 'Pronto'
        'Status_Starting' = 'Iniciando...'
        'Status_Analyzing' = 'Analisando...'
        'Status_Checking_Updates' = 'Verificando atualizaÃ§Ãµes...'
        'Status_Checking' = 'Verificando...'
        'Status_Detecting' = 'Detectando...'
        'Detecting' = 'Detectando...'
        'Checking' = 'Verificando...'
        'Lbl_PC' = 'EQUIPAMENTO'
        'Lbl_Windows' = 'WINDOWS'
        'Lbl_PowerShell' = 'POWERSHELL'
        'Lbl_Components' = 'COMPONENTES'
        'Stats_Heading' = 'ðŸ” DiagnÃ³stico Detalhado'
        'Stats_Subtitle' = 'NÃ­vel de temporÃ¡rios e caches'
        'Stats_Analyzing' = 'Analisando...'
        'Stats_Summary' = 'RESUMO'
        'Stats_Preparing' = 'Preparando anÃ¡lise...'
        'Stats_Calculating' = 'Calculando...'
        'Stats_Reference' = 'referÃªncia'
        'Stats_Unavailable' = 'DiagnÃ³stico indisponÃ­vel'
        'Stats_CouldNotComplete' = 'NÃ£o foi possÃ­vel completar a anÃ¡lise.'
        'Stats_Text_Line1' = 'Temp/caches: {0} GB.'
        'Stats_Text_Line2' = 'Disco: {0}.'
        'Stats_Text_Line3' = 'Energia: {0}.'
        'Stats_Free_Format' = '{0}% livre ({1}/{2} GB)'
        'Stats_NA' = 'n/d'
        'Rec_LowDisk' = 'EspaÃ§o em disco baixo. Priorize a limpeza.'
        'Rec_LowDiskMid' = 'EspaÃ§o em disco um pouco baixo; limpeza recomendada.'
        'Rec_JunkDetected' = '~{0} GB detectados em temp/caches.'
        'Rec_LittleJunk' = 'Pouco conteÃºdo temporÃ¡rio; limpeza nÃ£o urgente.'
        'Rec_DeepCleanHint' = 'A Limpeza Profunda pode recuperar mais espaÃ§o.'
        'Rec_Battery' = 'Na bateria: Alto Desempenho aumenta o consumo.'
        'Rec_AC' = 'Alto Desempenho disponÃ­vel.'
        'Basic_RepairHeading' = 'ðŸ› ï¸ Reparar meu PC'
        'Label_TargetDisk' = 'ðŸŽ¯ Disco a verificar:'
        'Btn_Refresh' = 'â†º Atualizar'
        'Sub_Repair' = 'ðŸ”§ Reparo'
        'Btn_RepairWindows' = 'Reparar Windows'
        'Btn_RecoverSystem' = 'Recuperar sistema'
        'Btn_CheckDisk' = 'Verificar disco'
        'Btn_DefragDisk' = 'Organizar disco'
        'Btn_MaxPerformance' = 'âš¡ Modo desempenho'
        'Sub_Security' = 'ðŸ›¡ï¸ SeguranÃ§a'
        'Btn_RestorePoint' = 'Criar Ponto de RestauraÃ§Ã£o'
        'Btn_StartupManager' = 'Gerenciar Programas de InicializaÃ§Ã£o'
        'Btn_RepairAll' = 'âš¡ Reparar tudo'
        'Basic_CleanHeading' = 'ðŸ§¹ Limpeza'
        'Btn_TempCleanup' = 'Apagar temporÃ¡rios'
        'Btn_DeepClean' = 'Limpeza completa'
        'Btn_ClearHistory' = 'Apagar histÃ³rico'
        'Sub_Internet' = 'ðŸŒ Corrigir Internet'
        'Btn_FixInternet' = 'Corrigir internet'
        'Btn_RestartNetwork' = 'Reiniciar rede'
        'Btn_SpeedNetwork' = 'ðŸš€ Acelerar rede'
        'Btn_CleanAll' = 'ðŸ§¹ Limpeza em 1-Clique'
        'Tip_Heading' = 'ðŸ’¡ Dica'
        'Tip_Text' = "Se nada funcionar, tente 'Reiniciar rede'. Algumas mudanÃ§as exigem reinÃ­cio."
        'Adv_SystemHeading' = 'ðŸ› ï¸ Sistema e Desempenho'
        'Label_TargetDiskAdv' = 'ðŸŽ¯ Disco alvo:'
        'Btn_RefreshDrives' = 'â†º Atualizar discos'
        'Btn_RunSFC' = 'Executar SFC /Scannow'
        'Btn_RepairDISM' = 'Reparar Imagem DISM'
        'Btn_RepairCHKDSK' = 'Reparar Disco (CHKDSK /f)'
        'Btn_DefragUnit' = 'ðŸ’½ Desfragmentar Unidade'
        'Btn_HighPerf' = 'âš¡ Ativar Alto Desempenho'
        'Adv_NetworkHeading' = 'ðŸŒ Rede e ConexÃ£o'
        'Btn_ClearDNSCache' = 'Limpar Cache DNS'
        'Btn_ResetWinsock' = 'Redefinir Winsock / IP'
        'Btn_ConfigQoS' = 'ðŸš€ Configurar QoS em 0%'
        'Sub_Share' = 'ðŸ“¡ Compartilhar Arquivos'
        'Btn_ShareFiles' = 'ðŸ”— Conectar com outro PC / Celular'
        'Share_Desc' = 'Compartilhe arquivos entre PC e celular via rede local (Robocopy / FTP).'
        'Sub_SystemTools' = 'ðŸ›¡ï¸ Ferramentas do Sistema'
        'Btn_AnalyzeUpdates' = 'Analisar AtualizaÃ§Ãµes'
        'Adv_MaintHeading' = 'ðŸ§¹ ManutenÃ§Ã£o'
        'Btn_TempCleanAdv' = 'Limpar TemporÃ¡rios BÃ¡sicos'
        'Btn_DeepCleanWinUpd' = 'ðŸ§¹ Limpeza Profunda / WinUpdate'
        'Btn_CleanLogsWinSxS' = 'ðŸ—‘ï¸ Limpar Logs e WinSxS'
        'Sub_AdvancedTools' = 'ðŸ› ï¸ Ferramentas AvanÃ§adas'
        'Btn_LockedFiles' = 'Gerenciador de Arquivos Bloqueados'
        'Btn_DriverCleanup' = 'Limpar Drivers Obsoletos'
        'Btn_OneClickRepair' = 'âš¡ Reparo em 1-Clique'
        'Btn_OneClickClean' = 'ðŸ§¹ Limpeza em 1-Clique'
        'Rec_Heading' = 'ðŸ’¡ RecomendaÃ§Ãµes Personalizadas'
        'Rec_Placeholder' = 'Analisando o estado do sistema...'
        'Log_Heading' = 'ðŸ“œ Registro de Atividade'
        'Footer_Notice' = 'As mudanÃ§as reversÃ­veis sÃ£o salvas localmente neste dispositivo.'
        'Btn_AnalyzePC' = 'ðŸ” Analisar PC'
        'Btn_Manual' = 'ðŸ“– Manual Detalhado'
        'Btn_Revert' = 'â†© Reverter MudanÃ§as'
        'Update_Badge' = 'â¬† Nova versÃ£o: {0}'
        'Update_Tooltip' = 'Clique para abrir a pÃ¡gina de download'
        'UpdateCheck_Tooltip' = 'Verificar atualizaÃ§Ãµes no GitHub'
        'Drive_NoLabel' = 'Sem rÃ³tulo'
        'Drive_ActiveWindows' = 'Windows ativo'
        'Drive_OfflineWindows' = 'Windows offline'
        'Drive_Data' = 'Dados'
        'Drive_NoSelected' = 'Nenhuma unidade selecionada.'
        'Drive_SFC_Online' = '{0}: Windows ativo. Modo SFC/DISM Online.'
        'Drive_SFC_Offline' = '{0}: Windows offline. Modo SFC/DISM Offline.'
        'Drive_DataOnly' = '{0}: dados. Somente CHKDSK se aplica.'
        'Drive_NoDrivesDetected' = 'Nenhuma unidade detectada.'
        'Drive_DetectedCount' = 'Unidades detectadas: {0}.'
        'Drive_DetectError' = 'Erro detectando unidades: {0}'
        'Drive_HDDDetected' = 'ðŸ’½ {0} HDD detectado. OtimizaÃ§Ã£o habilitada.'
        'Drive_SSDDetected' = 'ðŸ›¡ï¸ {0} SSD detectado. OtimizaÃ§Ã£o bloqueada.'
        'Drive_CouldNotDetermine' = 'NÃ£o foi possÃ­vel determinar o tipo de disco.'
        'Btn_Defrag_NoDrive' = 'ðŸ’½ (Sem unidade)'
        'Btn_Defrag_HDD' = 'Organizar disco'
        'Btn_Defrag_SSD_Blocked' = 'Organizar disco (SSD - Bloqueado)'
        'Btn_Defrag_Unknown' = 'Organizar disco (NÃ£o detectado)'
        'Btn_DefragAdv_HDD' = 'ðŸ’½ Desfragmentar Unidade'
        'Btn_DefragAdv_SSD_Blocked' = 'ðŸ’½ Desfragmentar (SSD - Bloqueado)'
        'Btn_DefragAdv_Unknown' = 'ðŸ’½ Desfragmentar (NÃ£o detectado)'
        'Drive_Tooltip_HDD' = 'Otimizar {0} (HDD detectado).'
        'Drive_Tooltip_SSD' = 'Bloqueado por seguranÃ§a: {0} Ã© um SSD.'
        'Drive_Tooltip_Unknown' = 'NÃ£o foi possÃ­vel determinar o tipo de disco.'
        'Repair_NotApplicable_SFC' = 'âš ï¸ SFC nÃ£o aplicÃ¡vel.'
        'Repair_NotApplicable_DISM' = 'âš ï¸ DISM nÃ£o aplicÃ¡vel.'
        'Repair_SFC_Online' = 'ðŸ› ï¸ SFC: reparando Windows ativo...'
        'Repair_SFC_Offline' = 'ðŸ› ï¸ SFC: reparando Windows offline...'
        'Repair_DISM_Online' = 'ðŸ› ï¸ DISM: reparando imagem ativa...'
        'Repair_DISM_Offline' = 'ðŸ› ï¸ DISM: reparando imagem offline...'
        'Repair_CHKDSK_Checking' = 'ðŸ’¾ CHKDSK: verificando {0}...'
        'Clean_Basic_Start' = '[+] Limpando arquivos temporÃ¡rios bÃ¡sicos...'
        'Clean_Basic_Done' = 'âœ… Arquivos temporÃ¡rios bÃ¡sicos removidos.'
        'Clean_Error' = 'âš ï¸ Erro: {0}'
        'Clean_Logs_Start' = '[+] Limpando logs e WinSxS...'
        'Clean_Deep_Disabling' = '[+] Desabilitando hibernaÃ§Ã£o...'
        'Clean_Deep_StoppingServices' = '[+] Parando serviÃ§os...'
        'Clean_Deep_CleaningCaches' = '[+] Limpando caches e temporÃ¡rios...'
        'Clean_1Click_Start' = 'ðŸ§¹ Iniciando Limpeza em 1-Clique...'
        'Clean_1Click_Done' = 'âœ… Limpeza completa. Arquivos temporÃ¡rios: {0} GB.'
        'Revert_Confirm_Title' = 'Reverter MudanÃ§as'
        'Revert_Confirm_Message' = 'Restaurar configuraÃ§Ãµes salvas de energia, QoS e serviÃ§os?'
        'Revert_Start' = '[+] Revertendo mudanÃ§as...'
        'Revert_PowerRestored' = 'â†© Plano de energia restaurado.'
        'Revert_QoSRestored' = 'â†© QoS restaurado.'
        'Revert_QoSRemoved' = 'â†© QoS removido.'
        'Revert_Hibernation' = 'â†© HibernaÃ§Ã£o reativada.'
        'Revert_Done' = 'âœ… RestauraÃ§Ã£o completa.'
        'Update_Checking' = 'Verificando atualizaÃ§Ãµes...'
        'Update_CheckGitHub' = 'ðŸ”„ Verificando atualizaÃ§Ãµes no GitHub...'
        'Update_Available_Log' = 'â¬† Nova versÃ£o disponÃ­vel: v{0} (atual: v{1})'
        'Update_Latest_Log' = 'VocÃª estÃ¡ na versÃ£o mais recente (v{0}).'
        'Update_Offline_Log' = 'Sem conexÃ£o Ã  Internet â€” nÃ£o Ã© possÃ­vel verificar atualizaÃ§Ãµes.'
        'Update_RepoNotFound_Log' = 'RepositÃ³rio GitHub nÃ£o encontrado.'
        'Update_Error_Log' = 'Erro: {0}'
        'Update_Dialog_Title' = 'AtualizaÃ§Ã£o DisponÃ­vel'
        'Update_Dialog_Message' = 'Nova versÃ£o disponÃ­vel!`n`nAtual: v{0}`nÃšltima: v{1}`n`nAbrir pÃ¡gina de download?'
        'Update_NoUpdates_Title' = 'Sem AtualizaÃ§Ãµes'
        'Update_NoUpdates_Message' = 'VocÃª estÃ¡ na versÃ£o mais recente (v{0}).'
        'Update_Offline_Title' = 'Offline'
        'Update_Offline_Message' = 'NÃ£o foi possÃ­vel verificar atualizaÃ§Ãµes. Sem conexÃ£o Ã  Internet.'
        'Update_Error_Title' = 'Erro'
        'Update_Error_Message' = 'NÃ£o foi possÃ­vel verificar atualizaÃ§Ãµes.`n`n{0}'
        'Update_StatusLine' = 'ðŸ”„ VerificaÃ§Ã£o: {0}'
        'Update_FailedLog' = 'âš ï¸ VerificaÃ§Ã£o de atualizaÃ§Ãµes falhou: {0}'
        'Update_UIError' = 'âš ï¸ Erro na UI de atualizaÃ§Ã£o: {0}'
        'LowMode_Enabled' = 'ðŸ¢ Modo Low ATIVADO â€” efeitos reduzidos para PCs de baixos recursos.'
        'LowMode_Disabled' = 'âš¡ Modo Low DESATIVADO â€” efeitos restaurados.'
        'LowMode_Error' = 'âš ï¸ Erro aplicando Modo Low: {0}'
        'Restore_Enabled' = 'ðŸ”§ ProteÃ§Ã£o do sistema habilitada.'
        'Restore_CouldNotEnable' = 'âš ï¸ NÃ£o foi possÃ­vel habilitar a proteÃ§Ã£o (pode jÃ¡ estar ativa).'
        'Restore_Created' = 'âœ… Ponto de restauraÃ§Ã£o criado: {0}'
        'Restore_Success' = 'Ponto de restauraÃ§Ã£o criado com sucesso.'
        'Restore_Error' = 'âš ï¸ Erro criando ponto de restauraÃ§Ã£o: {0}'
        'Restore_ErrorDlg' = 'NÃ£o foi possÃ­vel criar o ponto de restauraÃ§Ã£o.`n`nErro: {0}'
        'Restore_SuccessTitle' = 'Sucesso'
        'Restore_ErrorTitle' = 'Erro'
        'Startup_Analyzing' = 'ðŸ” Analisando programas de inicializaÃ§Ã£o...'
        'Startup_NoPrograms' = 'Nenhum programa de inicializaÃ§Ã£o encontrado.'
        'Startup_Title' = 'Gerenciador de InicializaÃ§Ã£o'
        'Startup_Found' = 'Encontrados {0} programas de inicializaÃ§Ã£o.`n`nVeja ''RecomendaÃ§Ãµes'' para detalhes.'
        'Startup_Header' = '=== PROGRAMAS DE INICIALIZAÃ‡ÃƒO ({0} encontrados) ==='
        'Startup_Location' = 'LocalizaÃ§Ã£o'
        'Startup_Command' = 'Comando'
        'Startup_Error' = 'âš ï¸ Erro analisando inicializaÃ§Ã£o: {0}'
        'Updates_Analyzing' = 'ðŸ” Analisando atualizaÃ§Ãµes instaladas...'
        'Updates_Header' = '=== ATUALIZAÃ‡Ã•ES INSTALADAS (Ãºltimas 15) ==='
        'Updates_Found' = 'âœ… Encontradas {0} atualizaÃ§Ãµes.'
        'Updates_Error' = 'âš ï¸ Erro obtendo atualizaÃ§Ãµes: {0}'
        'LockedFile_Title' = 'Selecione arquivo bloqueado para excluir'
        'LockedFile_Filter' = 'Todos os arquivos (*.*)|*.*'
        'LockedFile_ConfirmTitle' = 'Excluir Arquivo Bloqueado'
        'LockedFile_Confirm' = 'ForÃ§ar exclusÃ£o:`n`n{0}`n`nâš  IRREVERSÃVEL.'
        'LockedFile_Attempting' = 'ðŸ”¨ Tentando excluir: {0}'
        'LockedFile_Deleted' = 'âœ… Arquivo excluÃ­do: {0}'
        'LockedFile_Success' = 'Arquivo excluÃ­do.'
        'LockedFile_CouldNotDelete' = 'âš ï¸ NÃ£o foi possÃ­vel excluir: {0}'
        'LockedFile_ErrorDlg' = 'NÃ£o foi possÃ­vel excluir.`n`nErro: {0}'
        'LockedFile_HandlerError' = 'âš ï¸ Erro no gerenciador de arquivos: {0}'
        'LockedFile_SuccessTitle' = 'Sucesso'
        'LockedFile_ErrorTitle' = 'Erro'
        'Drivers_Start' = 'ðŸ§¹ Iniciando limpeza de drivers obsoletos...'
        'Drivers_Saved' = 'ðŸ“‹ Lista de drivers salva: {0}'
        'Drivers_Hint' = 'â„¹ Para remover um driver: pnputil /delete-driver <oemXX.inf> /uninstall /force'
        'Drivers_Error' = 'âš ï¸ Erro limpando drivers: {0}'
        'Confirm_SFC_Title' = 'SFC'
        'Confirm_SFC_Message' = 'SFC serÃ¡ executado em {0}. Continuar?'
        'Confirm_DISM_Title' = 'DISM'
        'Confirm_DISM_Message' = 'DISM serÃ¡ executado em {0}. Continuar?'
        'Confirm_CHKDSK_Title' = 'CHKDSK'
        'Confirm_CHKDSK_Message' = 'CHKDSK /f serÃ¡ executado em {0}. Pode exigir reinicializaÃ§Ã£o. Continuar?'
        'Confirm_Optimize_Title' = 'Otimizar Disco'
        'Confirm_Optimize_Message' = 'Abrindo Desfragmentador para {0}.`n`nSelecione a unidade e clique em ''Otimizar''.`n`nContinuar?'
        'Confirm_ResetNet_Title' = 'Redefinir Rede'
        'Confirm_ResetNet_Message' = 'Winsock serÃ¡ redefinido. Pode exigir reinicializaÃ§Ã£o. Continuar?'
        'Confirm_DeepClean_Title' = 'Limpeza Profunda'
        'Confirm_DeepClean_Message' = 'Caches do sistema e downloads do Windows Update serÃ£o excluÃ­dos. Continuar?'
        'Confirm_LogsClean_Title' = 'Limpar Logs e WinSxS'
        'Confirm_LogsClean_Message' = 'Logs de eventos e do sistema serÃ£o limpos. Continuar?'
        'Confirm_FullRepair_Title' = 'Reparo Completo'
        'Confirm_FullRepair_Message' = 'Executar manutenÃ§Ã£o completa automÃ¡tica?`n`nCadeia: limpeza â†’ flushdns â†’ SFC â†’ DISM.'
        'Confirm_FullClean_Title' = 'Limpeza em 1-Clique'
        'Confirm_FullClean_Message' = 'Executar limpeza rÃ¡pida?`n`nRemove: temp, prefetch, cache DNS, caches de navegadores, lixeira.'
        'Confirm_RestorePoint_Title' = 'Ponto de RestauraÃ§Ã£o'
        'Confirm_RestorePoint_Message' = 'Um ponto de restauraÃ§Ã£o serÃ¡ criado. Pode levar 1-3 minutos. Continuar?'
        'Confirm_CleanDrivers_Title' = 'Limpar Drivers'
        'Confirm_CleanDrivers_Message' = 'Componentes obsoletos serÃ£o limpos via DISM.`n`nUm ponto de restauraÃ§Ã£o Ã© recomendado primeiro.`nContinuar?'
        'SSD_Blocked_Title' = 'Bloqueado'
        'SSD_Blocked_Message' = 'A unidade {0} Ã© um SSD.`n`nDesfragmentar um SSD encurta sua vida Ãºtil.`nWindows jÃ¡ usa TRIM.`n`nAÃ§Ã£o bloqueada por seguranÃ§a.'
        'SSD_Blocked_Log' = 'ðŸ›¡ï¸ Bloqueado: {0} Ã© SSD.'
        'Unknown_Blocked_Message' = 'NÃ£o foi possÃ­vel determinar o tipo de disco de {0}. Bloqueado por seguranÃ§a.'
        'Unknown_Blocked_Title' = 'Desconhecido'
        'Log_System' = 'ðŸ’» {0} Â· {1} Â· PS {2}.'
        'Log_Diagnostics' = 'ðŸ” DiagnÃ³stico: {0} GB Â· {1}% Â· {2}.'
        'Log_DiagFailed' = 'âš ï¸ DiagnÃ³stico falhou: {0}'
        'Log_NoDisks' = 'âš ï¸ Nenhum disco detectado: {0}'
        'Log_Window' = 'ðŸ“ Janela: {0}x{1} (tela {2}x{3} Â· pos {4},{5})'
        'Log_WindowError' = 'âš ï¸ NÃ£o foi possÃ­vel ajustar a janela: {0}'
        'Log_ThemeRestored' = 'ðŸŽ¨ Tema restaurado: {0}'
        'Log_ThemeError' = 'âš ï¸ Erro restaurando tema: {0}'
        'Log_LowModeRestored' = 'ðŸ¢ Modo Low restaurado.'
        'Log_AppStart' = 'OmegaSolver V4.3 iniciado (2-col BÃ¡sico / 3-col AvanÃ§ado Â· DPI Adaptativo Â· Verificador de AtualizaÃ§Ãµes Â· Modo Low Â· ES/EN/PT).'
        'Log_InitialDiag' = 'âœ… DiagnÃ³stico inicial completo.'
        'Log_DiagError' = 'âš ï¸ Erro no diagnÃ³stico: {0}'
        'Log_CheckUpdates' = 'ðŸ”„ Verificando atualizaÃ§Ãµes no GitHub...'
        'Log_EcmFailed' = 'âš ï¸ VerificaÃ§Ã£o ECM falhou: {0}'
        'Log_LangChanged' = 'ðŸŒ Idioma alterado para: {0}'
        'Log_LangError' = 'Erro alterando idioma: {0}'
        'Log_AdvancedOn' = 'ðŸ”§ Modo AvanÃ§ado ATIVADO (3 colunas).'
        'Log_BasicOn' = 'ðŸŽ¯ Modo BÃ¡sico ATIVADO (2 colunas balanceadas).'
        'Log_OmegaOn' = 'ðŸ›¸ ESTILO OMEGASOLVER ATIVADO Â· sub-cor: {0}'
        'Log_OmegaRestored' = 'ðŸ›¸ ESTILO OMEGASOLVER restaurado Â· sub-cor: {0}'
        'Log_ThemeApplied' = 'ðŸŽ¨ Tema aplicado: {0}'
        'Log_ThemeApplyError' = 'âš ï¸ Erro aplicando tema: {0}'
        'Log_OriginalPlan' = 'â†³ Plano original salvo.'
        'Log_ReversibleSaved' = 'â†³ Estado reversÃ­vel salvo.'
        'Log_TaskError' = 'Erro na tarefa: {0}'
        'Log_OmegaEffectError' = 'âš ï¸ Erro aplicando efeitos OMEGASOLVER: {0}'
        'Log_UpdateError' = 'Erro de atualizaÃ§Ã£o: {0}'
        'Loading_SubMessage' = 'Isso pode levar alguns minutos...'
        'Loading_DoNotClose' = 'âš  Por favor nÃ£o feche esta janela enquanto o processo estÃ¡ em execuÃ§Ã£o.'
        'Task_AnalyzePC_Title' = 'Analisando PC'
        'Task_AnalyzePC_Step1' = 'Coletando informaÃ§Ãµes do sistema...'
        'Task_AnalyzePC_Step2' = 'Calculando temporÃ¡rios/caches...'
        'Task_AnalyzePC_Step3' = 'Avaliando discos e bateria...'
        'Task_AnalyzePC_Step4' = 'Gerando recomendaÃ§Ãµes...'
        'Task_Starting_Title' = 'Iniciando OmegaSolver V4.3'
        'Task_Starting_Step1' = 'Preparando diagnÃ³stico inicial...'
        'Task_Starting_Step2' = 'Analisando sistema...'
        'Task_Starting_Step3' = 'Calculando temporÃ¡rios/caches...'
        'Task_Starting_Step4' = 'Avaliando discos e bateria...'
        'Task_Starting_Step5' = 'Gerando recomendaÃ§Ãµes...'
        'Task_Starting_Step6' = 'Quase pronto...'
        'Task_SFC_Title' = 'Reparando Sistema'
        'Task_SFC_Step1' = 'Preparando verificaÃ§Ã£o de arquivos...'
        'Task_SFC_Step2' = 'Executando SFC /Scannow em {0}...'
        'Task_SFC_Step3' = 'Isso pode levar vÃ¡rios minutos...'
        'Task_SFC_Step4' = 'Por favor nÃ£o feche o aplicativo...'
        'Task_DISM_Title' = 'Reparando Imagem'
        'Task_DISM_Step1' = 'Preparando reparo da imagem...'
        'Task_DISM_Step2' = 'Executando DISM /RestoreHealth em {0}...'
        'Task_DISM_Step3' = 'Isso pode levar vÃ¡rios minutos...'
        'Task_DISM_Step4' = 'Por favor nÃ£o feche o aplicativo...'
        'Task_CHKDSK_Title' = 'Verificando Disco'
        'Task_CHKDSK_Step1' = 'Preparando verificaÃ§Ã£o de disco...'
        'Task_CHKDSK_Step2' = 'Executando CHKDSK /f em {0}...'
        'Task_CHKDSK_Step3' = 'Isso pode levar vÃ¡rios minutos...'
        'Task_CHKDSK_Step4' = 'Por favor nÃ£o feche o aplicativo...'
        'Task_MaxPower_Title' = 'Otimizando Energia'
        'Task_MaxPower_Step1' = 'Analisando plano de energia atual...'
        'Task_MaxPower_Step2' = 'Ativando modo alto desempenho...'
        'Task_MaxPower_Step3' = 'Aplicando mudanÃ§as...'
        'Task_FlushDNS_Title' = 'Limpando DNS'
        'Task_FlushDNS_Step1' = 'Acessando cache DNS...'
        'Task_FlushDNS_Step2' = 'Removendo registros DNS antigos...'
        'Task_ResetNet_Title' = 'Redefinindo Rede'
        'Task_ResetNet_Step1' = 'Redefinindo sockets de rede...'
        'Task_ResetNet_Step2' = 'Reiniciando interfaces TCP/IP...'
        'Task_ResetNet_Step3' = 'Pode exigir reinicializaÃ§Ã£o...'
        'Task_QoS_Title' = 'Otimizando Rede'
        'Task_QoS_Step1' = 'Acessando polÃ­ticas de rede...'
        'Task_QoS_Step2' = 'Definindo limite QoS para 0%...'
        'Task_QoS_Step3' = 'Aplicando mudanÃ§as no registro...'
        'Task_Temp_Title' = 'Limpando TemporÃ¡rios'
        'Task_Temp_Step1' = 'Acessando pastas temporÃ¡rias...'
        'Task_Temp_Step2' = 'Removendo arquivos inÃºteis...'
        'Task_Temp_Step3' = 'Liberando espaÃ§o em disco...'
        'Task_DeepClean_Title' = 'Limpeza Profunda'
        'Task_DeepClean_Step1' = 'Parando serviÃ§os de atualizaÃ§Ã£o...'
        'Task_DeepClean_Step2' = 'Limpando caches do Windows Update...'
        'Task_DeepClean_Step3' = 'Removendo temporÃ¡rios e logs...'
        'Task_DeepClean_Step4' = 'Restaurando serviÃ§os...'
        'Task_DeepClean_Step5' = 'Quase pronto...'
        'Task_LogsClean_Title' = 'Limpando Logs'
        'Task_LogsClean_Step1' = 'Limpando logs de eventos...'
        'Task_LogsClean_Step2' = 'Removendo logs do sistema...'
        'Task_LogsClean_Step3' = 'Executando limpeza de WinSxS...'
        'Task_LogsClean_Step4' = 'Isso pode levar vÃ¡rios minutos...'
        'Task_FullRepair_Title' = 'Reparo Completo'
        'Task_FullRepair_Step1' = 'Iniciando manutenÃ§Ã£o automÃ¡tica...'
        'Task_FullRepair_Step2' = 'Limpando arquivos temporÃ¡rios...'
        'Task_FullRepair_Step3' = 'Otimizando rede...'
        'Task_FullRepair_Step4' = 'Executando SFC...'
        'Task_FullRepair_Step5' = 'Executando DISM...'
        'Task_FullRepair_Step6' = 'Finalizando reparo...'
        'Task_FullClean_Title' = 'Limpeza em 1-Clique'
        'Task_FullClean_Step1' = 'Removendo temp do usuÃ¡rio...'
        'Task_FullClean_Step2' = 'Removendo temp do Windows...'
        'Task_FullClean_Step3' = 'Limpando prefetch...'
        'Task_FullClean_Step4' = 'Limpando cache DNS...'
        'Task_FullClean_Step5' = 'Limpando caches de navegadores...'
        'Task_FullClean_Step6' = 'Esvaziando lixeira...'
        'Task_FullClean_Step7' = 'Finalizando...'
        'Task_RestorePoint_Title' = 'Criando Ponto de RestauraÃ§Ã£o'
        'Task_RestorePoint_Step1' = 'Verificando proteÃ§Ã£o do sistema...'
        'Task_RestorePoint_Step2' = 'Habilitando se necessÃ¡rio...'
        'Task_RestorePoint_Step3' = 'Criando ponto de restauraÃ§Ã£o...'
        'Task_RestorePoint_Step4' = 'Por favor aguarde...'
        'Task_Startup_Title' = 'Gerenciador de InicializaÃ§Ã£o'
        'Task_Startup_Step1' = 'Consultando registro de inicializaÃ§Ã£o...'
        'Task_Startup_Step2' = 'Analisando programas...'
        'Task_Startup_Step3' = 'Gerando relatÃ³rio...'
        'Task_Updates_Title' = 'Analisando AtualizaÃ§Ãµes'
        'Task_Updates_Step1' = 'Consultando histÃ³rico de atualizaÃ§Ãµes...'
        'Task_Updates_Step2' = 'Ordenando por data...'
        'Task_Updates_Step3' = 'Gerando relatÃ³rio...'
        'Task_Drivers_Title' = 'Limpando Drivers'
        'Task_Drivers_Step1' = 'Enumerando drivers...'
        'Task_Drivers_Step2' = 'Analisando componentes obsoletos...'
        'Task_Drivers_Step3' = 'Executando limpeza DISM...'
        'Task_Drivers_Step4' = 'Isso pode levar vÃ¡rios minutos...'
        'Task_Revert_Title' = 'Revertendo MudanÃ§as'
        'Task_Revert_Step1' = 'Restaurando plano de energia...'
        'Task_Revert_Step2' = 'Restaurando configuraÃ§Ã£o QoS...'
        'Task_Revert_Step3' = 'Restaurando estados de serviÃ§os...'
        'Task_Revert_Step4' = 'Finalizando restauraÃ§Ã£o...'
        'Ecm_Detected_Log' = 'âœ… Easy Context Menu detectado: {0}'
        'Ecm_OpenLog' = 'ðŸš€ Abrindo Easy Context Menu...'
        'Ecm_CouldNotOpen' = 'âš ï¸ NÃ£o foi possÃ­vel abrir o ECM: {0}'
        'Ecm_NotDetected_Log' = 'â„¹ï¸ Easy Context Menu nÃ£o detectado.'
        'Ecm_DownloadLog' = 'ðŸŒ Abrindo pÃ¡gina de download do ECM...'
        'Ecm_BrowserError' = 'âš ï¸ NÃ£o foi possÃ­vel abrir o navegador: {0}'
        'Ecm_IntegrationError' = 'âš ï¸ Erro na integraÃ§Ã£o ECM: {0}'
        'Ecm_Detected_Title' = 'Easy Context Menu detectado'
        'Ecm_NotInstalled_Title' = 'Easy Context Menu nÃ£o instalado'
        'Share_WindowTitle' = 'Compartilhar Arquivos - OmegaSolver V4.3'
        'Share_Header' = 'ðŸ“¡ Compartilhar Arquivos pela Rede'
        'Share_SubHeader' = 'Conecte seu PC com outro dispositivo na mesma LAN'
        'Share_YourIPs' = 'ðŸ–¥ï¸ Seus IPs locais (para o outro dispositivo se conectar):'
        'Share_CopyIP' = 'ðŸ“‹ Copiar IP principal'
        'Share_Method' = 'ðŸ”§ MÃ©todo de transferÃªncia:'
        'Share_Method_Robocopy' = 'ðŸ“‚ Robocopy (SMB) â€” Windows â†” Windows'
        'Share_Method_FTP' = 'ðŸŒ FTP â€” Windows â†” Android / iOS / Smart TV'
        'Share_Hint_Robocopy' = 'Recomendado: crie uma pasta compartilhada no outro dispositivo.'
        'Share_Hint_FTP' = "Instale um app de Servidor FTP no seu celular (ex. 'WiFi FTP Server')."
        'Share_RemoteDetails' = 'ðŸŽ¯ Detalhes do dispositivo remoto:'
        'Share_RemoteIP' = 'IP remoto:'
        'Share_ShareName' = 'Nome da pasta compartilhada:'
        'Share_FtpPort' = 'Porta FTP:'
        'Share_FtpPath' = 'Caminho FTP remoto:'
        'Share_FtpUser' = 'UsuÃ¡rio FTP:'
        'Share_FtpPass' = 'Senha FTP:'
        'Share_LocalFolder' = 'ðŸ“ Pasta local (enviar ou receber):'
        'Share_Browse' = 'ðŸ“‚ Procurar...'
        'Share_Direction' = 'â¬†ï¸â¬‡ï¸ DireÃ§Ã£o:'
        'Share_Send' = 'â¬† Enviar (eu â†’ outro dispositivo)'
        'Share_Receive' = 'â¬‡ Receber (outro â†’ eu)'
        'Share_Status' = 'ðŸ“œ Status:'
        'Share_StartTransfer' = 'ðŸš€ Iniciar TransferÃªncia'
        'Share_Cancel' = 'Cancelar'
        'Share_NoIPs' = '  (Nenhum IP local detectado)'
        'Share_SelectFolder' = 'Selecionar pasta local'
        'Share_MissingRemoteIP' = 'âš  IP remoto ausente.'
        'Share_LocalFolderMissing' = 'âš  Pasta local nÃ£o existe: {0}'
        'Share_RobocopyMode' = 'ðŸ”— Modo Robocopy (SMB)'
        'Share_UncPath' = '   Caminho UNC: {0}'
        'Share_LocalPath' = '   Local:        {0}'
        'Share_CannotAccess' = 'âŒ NÃ£o Ã© possÃ­vel acessar {0}'
        'Share_CheckShare' = '   â€¢ Verifique a pasta compartilhada no outro dispositivo.'
        'Share_CheckFirewall' = '   â€¢ Verifique se o firewall permite compartilhamento.'
        'Share_Sending' = 'â¬† Enviando...'
        'Share_Receiving' = 'â¬‡ Recebendo...'
        'Share_TransferComplete' = 'âœ… TransferÃªncia completa (cÃ³digo {0}).'
        'Share_TransferErrors' = 'âš  Erros do Robocopy (cÃ³digo {0}).'
        'Share_FtpMode' = 'ðŸ”— Modo FTP: {0}'
        'Share_Uploading' = 'â¬† Enviando {0} arquivos...'
        'Share_UploadDone' = 'âœ… Envio completo. OK: {0} Â· Falhas: {1}'
        'Share_FtpDownload_NotSupported' = 'â„¹ Download FTP nÃ£o suportado nesta versÃ£o. Use Robocopy.'
        'Share_Error' = 'âš  Erro: {0}'
        'Share_RobocopyDone' = 'ðŸ“¡ Robocopy concluÃ­do.'
        'Share_LoadError' = 'âš ï¸ Erro carregando janela de compartilhamento: {0}'
        'Share_LoadErrorDlg' = 'NÃ£o foi possÃ­vel abrir a janela de compartilhamento.`n`n{0}'
        'Share_WindowError' = 'âš ï¸ Erro na janela de compartilhamento: {0}'
        'Share_Close' = 'Fechar'
        'Manual_Title' = 'Manual Â· Manual Â· Manual'
        'Manual_AppLine' = 'OmegaSolver V4.3'
        'Manual_Mode_Advanced' = 'Advanced Â· Avanzado Â· AvanÃ§ado'
        'Manual_Mode_Basic' = 'Basic Â· BÃ¡sico Â· BÃ¡sico'
        'Manual_Badge' = 'ðŸ”„  Auto-detectado: {0}  |  3 idiomas Â· 3 languages Â· 3 idiomas'
        'Manual_EsTitle' = 'ðŸ‡ªðŸ‡¸  ESPAÃ‘OL'
        'Manual_EnTitle' = 'ðŸ‡ºðŸ‡¸  ENGLISH'
        'Manual_PtTitle' = 'ðŸ‡§ðŸ‡·  PORTUGUÃŠS'
        'Manual_Footer' = 'â„¹  BAS = BÃ¡sico Â· TEC = TÃ©cnico  |  Info aplica Ã  versÃ£o atual.'
        'Manual_CloseBtn' = 'Fechar Â· Cerrar Â· Close'
        'Error_Title' = 'Erro'
        'Success_Title' = 'Sucesso'
        'Warning_Title' = 'Aviso'
        'Info_Title' = 'InformaÃ§Ã£o'
        'SingleInstance_Title' = 'OmegaSolver V4.3 â€” InstÃ¢ncia Ãºnica'
        'SingleInstance_Message' = 'JÃ¡ existe uma instÃ¢ncia do OmegaSolver V4.3 em execuÃ§Ã£o.`n`nFeche a janela aberta antes de iniciar outra.'
        'Admin_Required' = 'OmegaSolver V4.3 requer privilÃ©gios de administrador.'
        'Save_As_Ps1' = 'Salve o script como .ps1 e execute novamente.'
        'Components_OK' = 'âœ… OK Â· {0}'
        'Components_Missing' = 'âš ï¸ Faltando: {0}'
        'App_Title' = 'OmegaSolver'
        'App_Version' = ' V4.3'
        'Omega_Title' = 'â—¤ OMEGASOLVER â—¢'
        'Omega_Version' = '  // v4.3 //'
        'Omega_Pattern' = 'PADRÃƒO:'
        'Omega_Warning_Title' = 'OMEGASOLVER STYLE â€” Aviso'
        'Omega_Warning_Message' = "âš  AVISO â€” OMEGASOLVER STYLE`n`nEste tema TRANSFORMA a UI com estÃ©tica alienÃ­gena inspirada em Murder Drones.`n`nSOMENTE RECOMENDADO PARA USUÃRIOS AVANÃ‡ADOS.`n`nAtivar o modo OMEGASOLVER?"
        'Omega_SubColor_Tooltip' = 'Sub-cor neon para o estilo OMEGASOLVER'
    }
}

function Get-OmegaLanguage {
    try {
        if (Test-Path $script:OmegaLanguagePath) {
            $saved = (Get-Content -Path $script:OmegaLanguagePath -Raw -ErrorAction Stop).Trim().ToUpper()
            if ($script:OmegaStrings.ContainsKey($saved)) { return $saved }
        }
    } catch { }
    return 'ES'
}

function Save-OmegaLanguage {
    param([string]$Lang)
    try { Set-Content -Path $script:OmegaLanguagePath -Value $Lang -Encoding UTF8 -Force } catch { }
}

function Get-OmegaString {
    param([string]$Key, $FormatArgs = $null)
    $lang = Get-OmegaLanguage
    $str = $null
    if ($script:OmegaStrings.ContainsKey($lang) -and $script:OmegaStrings[$lang].ContainsKey($Key)) {
        $str = $script:OmegaStrings[$lang][$Key]
    } elseif ($script:OmegaStrings['ES'].ContainsKey($Key)) {
        $str = $script:OmegaStrings['ES'][$Key]
    } else {
        $str = $Key
    }
    if ($FormatArgs -ne $null) {
        try { return ($str -f $FormatArgs) } catch { return $str }
    }
    return $str
}

function Apply-OmegaLanguage {
    try {
        # Title bar
        $global:lblLangCaption.Text = Get-OmegaString 'Lang_Caption'
        $global:lblThemeCaption.Text = Get-OmegaString 'Theme_Caption'
        $global:chkAdvanced.Content = Get-OmegaString 'Check_Advanced'
        $global:chkLowMode.Content = Get-OmegaString 'Check_LowMode'
        $global:btnCheckUpdate.ToolTip = Get-OmegaString 'UpdateCheck_Tooltip'

        # Info bar
        $global:lblLblPC.Text = Get-OmegaString 'Lbl_PC'
        $global:lblLblWindows.Text = Get-OmegaString 'Lbl_Windows'
        $global:lblLblPowerShell.Text = Get-OmegaString 'Lbl_PowerShell'
        $global:lblLblComponents.Text = Get-OmegaString 'Lbl_Components'

        # Stats panel
        $global:lblStatsHeading.Text = Get-OmegaString 'Stats_Heading'
        $global:lblStatsSubtitle.Text = Get-OmegaString 'Stats_Subtitle'
        $global:lblStatsSummary.Text = Get-OmegaString 'Stats_Summary'

        # Basic mode
        $global:lblBasicRepairHeading.Text = Get-OmegaString 'Basic_RepairHeading'
        $global:lblTargetDiskBasic.Text = Get-OmegaString 'Label_TargetDisk'
        $global:btnRefreshDrivesBasic.Content = Get-OmegaString 'Btn_Refresh'
        $global:lblSubRepair.Text = Get-OmegaString 'Sub_Repair'
        $global:btnSfcBasic.Content = Get-OmegaString 'Btn_RepairWindows'
        $global:btnDismBasic.Content = Get-OmegaString 'Btn_RecoverSystem'
        $global:btnChkDskBasic.Content = Get-OmegaString 'Btn_CheckDisk'
        $global:btnDefragBasic.Content = Get-OmegaString 'Btn_DefragDisk'
        $global:btnMaxPowerBasic.Content = Get-OmegaString 'Btn_MaxPerformance'
        $global:lblSubSecurity.Text = Get-OmegaString 'Sub_Security'
        $global:btnCreateRestorePointBasic.Content = Get-OmegaString 'Btn_RestorePoint'
        $global:btnStartupManagerBasic.Content = Get-OmegaString 'Btn_StartupManager'
        $global:btnFullRepairBasic.Content = Get-OmegaString 'Btn_RepairAll'
        $global:lblBasicCleanHeading.Text = Get-OmegaString 'Basic_CleanHeading'
        $global:btnTempBasic.Content = Get-OmegaString 'Btn_TempCleanup'
        $global:btnDeepCleanBasic.Content = Get-OmegaString 'Btn_DeepClean'
        $global:btnLogCleanBasic.Content = Get-OmegaString 'Btn_ClearHistory'
        $global:lblSubInternet.Text = Get-OmegaString 'Sub_Internet'
        $global:btnFlushDnsBasic.Content = Get-OmegaString 'Btn_FixInternet'
        $global:btnResetNetBasic.Content = Get-OmegaString 'Btn_RestartNetwork'
        $global:btnQoSBasic.Content = Get-OmegaString 'Btn_SpeedNetwork'
        $global:btnFullCleanBasic.Content = Get-OmegaString 'Btn_CleanAll'
        $global:lblTipHeading.Text = Get-OmegaString 'Tip_Heading'
        $global:lblTipText.Text = Get-OmegaString 'Tip_Text'

        # Advanced mode
        $global:lblAdvSystemHeading.Text = Get-OmegaString 'Adv_SystemHeading'
        $global:lblTargetDiskAdv.Text = Get-OmegaString 'Label_TargetDiskAdv'
        $global:btnRefreshDrivesAdv.Content = Get-OmegaString 'Btn_RefreshDrives'
        $global:btnSfcAdv.Content = Get-OmegaString 'Btn_RunSFC'
        $global:btnDismAdv.Content = Get-OmegaString 'Btn_RepairDISM'
        $global:btnChkDskAdv.Content = Get-OmegaString 'Btn_RepairCHKDSK'
        $global:btnDefragAdv.Content = Get-OmegaString 'Btn_DefragUnit'
        $global:btnMaxPowerAdv.Content = Get-OmegaString 'Btn_HighPerf'
        $global:lblAdvNetworkHeading.Text = Get-OmegaString 'Adv_NetworkHeading'
        $global:btnFlushDnsAdv.Content = Get-OmegaString 'Btn_ClearDNSCache'
        $global:btnResetNetAdv.Content = Get-OmegaString 'Btn_ResetWinsock'
        $global:btnQoSAdv.Content = Get-OmegaString 'Btn_ConfigQoS'
        $global:lblSubShare.Text = Get-OmegaString 'Sub_Share'
        $global:btnShareFilesAdv.Content = Get-OmegaString 'Btn_ShareFiles'
        $global:lblShareDesc.Text = Get-OmegaString 'Share_Desc'
        $global:lblSubSystemTools.Text = Get-OmegaString 'Sub_SystemTools'
        $global:btnCreateRestorePointAdv.Content = Get-OmegaString 'Btn_RestorePoint'
        $global:btnStartupManagerAdv.Content = Get-OmegaString 'Btn_StartupManager'
        $global:btnAnalyzeUpdatesAdv.Content = Get-OmegaString 'Btn_AnalyzeUpdates'
        $global:lblAdvMaintHeading.Text = Get-OmegaString 'Adv_MaintHeading'
        $global:btnTempAdv.Content = Get-OmegaString 'Btn_TempCleanAdv'
        $global:btnDeepCleanAdv.Content = Get-OmegaString 'Btn_DeepCleanWinUpd'
        $global:btnLogCleanAdv.Content = Get-OmegaString 'Btn_CleanLogsWinSxS'
        $global:lblSubAdvancedTools.Text = Get-OmegaString 'Sub_AdvancedTools'
        $global:btnDeleteLockedFileAdv.Content = Get-OmegaString 'Btn_LockedFiles'
        $global:btnCleanupDriversAdv.Content = Get-OmegaString 'Btn_DriverCleanup'
        $global:btnFullRepairAdv.Content = Get-OmegaString 'Btn_OneClickRepair'
        $global:btnFullCleanAdv.Content = Get-OmegaString 'Btn_OneClickClean'

        # Recommendations + Log + Footer
        $global:lblRecHeading.Text = Get-OmegaString 'Rec_Heading'
        $global:lblLogHeading.Text = Get-OmegaString 'Log_Heading'
        $global:lblFooterNotice.Text = Get-OmegaString 'Footer_Notice'
        $global:btnDiagnose.Content = Get-OmegaString 'Btn_AnalyzePC'
        $global:btnManual.Content = Get-OmegaString 'Btn_Manual'
        $global:btnRevert.Content = Get-OmegaString 'Btn_Revert'

        # Refresh drive state to relabel defrag buttons in new language
        Update-OmegaRepairDriveState

        # Estado listo (localizado)
        Set-OmegaStatus (Get-OmegaString 'Status_Ready')
    } catch {
        Write-OmegaLog "âš ï¸ Error aplicando idioma: $($_.Exception.Message)"
    }
}

# ---------- 3. ELEVACIÃ“N + INSTANCIA ÃšNICA -----------------------------------
function Test-OmegaAdministrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

$script:OmegaMutex = $null
$script:OmegaMutexOwned = $false
try {
    $script:OmegaMutex = New-Object System.Threading.Mutex($false, 'Local\OmegaSolverV43_SingleInstance')
    try { $script:OmegaMutexOwned = $script:OmegaMutex.WaitOne(0, $false) }
    catch [System.Threading.AbandonedMutexException] { $script:OmegaMutexOwned = $true }
} catch { $script:OmegaMutexOwned = $false }

if (-not $script:OmegaMutexOwned) {
    [System.Windows.MessageBox]::Show(
        (Get-OmegaString 'SingleInstance_Message'),
        (Get-OmegaString 'SingleInstance_Title'), 'OK', 'Warning') | Out-Null
    if ($script:OmegaMutex) { try { $script:OmegaMutex.Dispose() } catch { } }
    exit 0
}

if (-not (Test-OmegaAdministrator)) {
    try {
        $scriptPath = $MyInvocation.MyCommand.Path
        if (-not $scriptPath) {
            [System.Windows.MessageBox]::Show((Get-OmegaString 'Save_As_Ps1'), "OmegaSolver V4.3", 'OK', 'Warning') | Out-Null
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
        try { $script:OmegaMutex.ReleaseMutex() } catch { }
        try { $script:OmegaMutex.Dispose() } catch { }
        $script:OmegaMutexOwned = $false
        Start-Process $hostExe -Verb RunAs -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', "`"$scriptPath`"") | Out-Null
        exit 0
    } catch {
        [System.Windows.MessageBox]::Show((Get-OmegaString 'Admin_Required'), "OmegaSolver V4.3", 'OK', 'Warning') | Out-Null
        try { $script:OmegaMutex.ReleaseMutex() } catch { }
        try { $script:OmegaMutex.Dispose() } catch { }
        exit 1
    }
}

# ---------- 4. XAML PRINCIPAL ------------------------------------------------
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="OmegaSolver V4.3" Height="860" Width="1180"
        MinHeight="640" MinWidth="1024"
        WindowStartupLocation="Manual" ResizeMode="CanResize"
        WindowStyle="None" AllowsTransparency="True" SizeToContent="Manual"
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
        <SolidColorBrush x:Key="ThemeCleanBackground" Color="#166534"/>
        <SolidColorBrush x:Key="ThemeCleanBorder" Color="#22C55E"/>
        <SolidColorBrush x:Key="ThemeCleanHover" Color="#15803D"/>
        <SolidColorBrush x:Key="ThemeCleanPressed" Color="#14532D"/>
        <SolidColorBrush x:Key="ThemeLogForeground" Color="#63F28B"/>
        <SolidColorBrush x:Key="ThemeUpdateBg" Color="#7C2D12"/>
        <SolidColorBrush x:Key="ThemeUpdateBorder" Color="#FB923C"/>
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
        <Style x:Key="CleanButton" TargetType="Button" BasedOn="{StaticResource {x:Type Button}}">
            <Setter Property="Background" Value="{DynamicResource ThemeCleanBackground}"/>
            <Setter Property="BorderBrush" Value="{DynamicResource ThemeCleanBorder}"/>
            <Setter Property="FontWeight" Value="Bold"/>
        </Style>
        <Style x:Key="UpdateButton" TargetType="Button" BasedOn="{StaticResource {x:Type Button}}">
            <Setter Property="Background" Value="{DynamicResource ThemeUpdateBg}"/>
            <Setter Property="BorderBrush" Value="{DynamicResource ThemeUpdateBorder}"/>
            <Setter Property="FontWeight" Value="Bold"/>
        </Style>
        <Style x:Key="HeroButton" TargetType="Button" BasedOn="{StaticResource PrimaryButton}">
            <Setter Property="Height" Value="56"/>
            <Setter Property="FontSize" Value="15.5"/>
            <Setter Property="FontWeight" Value="Black"/>
            <Setter Property="Margin" Value="5,10,5,5"/>
        </Style>
        <Style x:Key="HeroCleanButton" TargetType="Button" BasedOn="{StaticResource CleanButton}">
            <Setter Property="Height" Value="56"/>
            <Setter Property="FontSize" Value="15.5"/>
            <Setter Property="FontWeight" Value="Black"/>
            <Setter Property="Margin" Value="5,5,5,10"/>
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
        <Style x:Key="MinimalScrollThumb" TargetType="Thumb">
            <Setter Property="OverridesDefaultStyle" Value="True"/>
            <Setter Property="IsTabStop" Value="False"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Thumb">
                        <Border x:Name="ThumbBorder" Background="{DynamicResource ThemeBorderStrong}"
                                CornerRadius="4" Margin="3,0,3,0"/>
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
            BorderBrush="{DynamicResource ThemeAccent}" BorderThickness="2" CornerRadius="10">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <Border x:Name="TitleBar" Grid.Row="0"
                    Background="{DynamicResource ThemePanelBackground}"
                    BorderBrush="{DynamicResource ThemeAccent}"
                    BorderThickness="0,0,0,2" CornerRadius="8,8,0,0" Padding="16,10,12,10">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="Auto"/>
                    </Grid.ColumnDefinitions>
                    <StackPanel x:Name="DragArea" Grid.Column="0" Background="Transparent" VerticalAlignment="Center">
                        <StackPanel Orientation="Horizontal">
                            <TextBlock x:Name="lblAppTitle" Text="OmegaSolver" FontSize="18" FontWeight="Bold"
                                       Foreground="{DynamicResource ThemeAccent}" VerticalAlignment="Center"/>
                            <TextBlock x:Name="lblAppVersion" Text=" V4.3" FontSize="13"
                                       Foreground="{DynamicResource ThemeMutedText}"
                                       VerticalAlignment="Bottom" Margin="5,0,0,2"/>
                            <Button x:Name="btnUpdateBadge" Content="â¬† Update available"
                                    Visibility="Collapsed" Margin="10,0,0,0"
                                    Padding="10,3" FontSize="10.5" FontWeight="Bold"
                                    Style="{StaticResource UpdateButton}"
                                    VerticalAlignment="Center"
                                    ToolTip="New OmegaSolver version available"/>
                        </StackPanel>
                        <TextBlock x:Name="lblStatus" Text="Estado: Iniciando..." FontSize="11"
                                   Foreground="{DynamicResource ThemeSecondaryText}" Margin="0,2,0,0"/>
                    </StackPanel>
                    <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Center">
                        <TextBlock x:Name="lblLangCaption" Text="Idioma:" Foreground="{DynamicResource ThemeMutedText}"
                                   VerticalAlignment="Center" Margin="0,0,6,0" FontSize="12"/>
                        <ComboBox x:Name="cmbLanguage" Width="90" Height="32" Margin="0,0,14,0" FontSize="12"/>
                        <TextBlock x:Name="lblThemeCaption" Text="Tema:" Foreground="{DynamicResource ThemeMutedText}"
                                   VerticalAlignment="Center" Margin="0,0,6,0" FontSize="12"/>
                        <ComboBox x:Name="cmbTheme" Width="140" Height="32" Margin="0,0,10,0" FontSize="12"/>
                        <ComboBox x:Name="cmbOmegaColor" Width="220" Height="32" Margin="0,0,10,0" FontSize="12"
                                  Visibility="Collapsed" ToolTip="Neon sub-color for OMEGASOLVER style"/>
                        <CheckBox x:Name="chkLowMode" Content="Modo Low" Foreground="{DynamicResource ThemeSecondaryText}"
                                  VerticalAlignment="Center" FontSize="12" Margin="0,0,10,0"
                                  ToolTip="Reduce visual effects and heavy processes (for low-resource PCs)"/>
                        <CheckBox x:Name="chkAdvanced" Content="Avanzado" Foreground="{DynamicResource ThemeSecondaryText}"
                                  VerticalAlignment="Center" FontSize="12" Margin="0,0,12,0"/>
                        <Button x:Name="btnCheckUpdate" Content="ðŸ”„" Width="34" Height="30"
                                FontSize="14" Background="Transparent" BorderThickness="0"
                                Foreground="{DynamicResource ThemeMutedText}" Cursor="Hand"
                                ToolTip="Check GitHub for updates"/>
                        <Button x:Name="btnMin" Content="â”€" Style="{StaticResource WindowControlButton}" ToolTip="Minimize"/>
                        <Button x:Name="btnMax" Content="â–¡" Style="{StaticResource WindowControlButton}" ToolTip="Maximize"/>
                        <Button x:Name="btnClose" Content="âœ•" Style="{StaticResource CloseButton}" ToolTip="Close"/>
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
                                <TextBlock x:Name="lblLblPC" Text="EQUIPO" FontSize="10" Foreground="{DynamicResource ThemeLabelText}"/>
                                <TextBlock x:Name="lblPCName" Text="Detectando..." FontSize="13" FontWeight="Bold"
                                           Foreground="{DynamicResource ThemeMainText}" TextTrimming="CharacterEllipsis"/>
                            </StackPanel>
                            <StackPanel Grid.Column="1" Margin="2,0,10,0">
                                <TextBlock x:Name="lblLblWindows" Text="WINDOWS" FontSize="10" Foreground="{DynamicResource ThemeLabelText}"/>
                                <TextBlock x:Name="lblWindowsInfo" Text="Detectando..." FontSize="12"
                                           Foreground="{DynamicResource ThemeSecondaryText}" TextTrimming="CharacterEllipsis"/>
                            </StackPanel>
                            <StackPanel Grid.Column="2" Margin="2,0,10,0">
                                <TextBlock x:Name="lblLblPowerShell" Text="POWERSHELL" FontSize="10" Foreground="{DynamicResource ThemeLabelText}"/>
                                <TextBlock x:Name="lblPowerShellInfo" Text="Detectando..." FontSize="12"
                                           Foreground="{DynamicResource ThemeSecondaryText}" TextTrimming="CharacterEllipsis"/>
                            </StackPanel>
                            <StackPanel Grid.Column="3" Margin="2,0,2,0">
                                <TextBlock x:Name="lblLblComponents" Text="COMPONENTES" FontSize="10" Foreground="{DynamicResource ThemeLabelText}"/>
                                <TextBlock x:Name="lblComponentsInfo" Text="Comprobando..." FontSize="11"
                                           Foreground="{DynamicResource ThemeSecondaryText}" TextWrapping="Wrap"/>
                            </StackPanel>
                        </Grid>
                    </Border>

                    <Border x:Name="statsPanel" Grid.Row="1" Background="{DynamicResource ThemePanelBackground}"
                            CornerRadius="8" Padding="14" Margin="0,0,0,14"
                            BorderBrush="{DynamicResource ThemeBorder}" BorderThickness="1" Visibility="Collapsed">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="1.4*"/>
                                <ColumnDefinition Width="2*"/>
                            </Grid.ColumnDefinitions>
                            <StackPanel Grid.Column="0" Margin="2,0,18,0" VerticalAlignment="Center">
                                <TextBlock x:Name="lblStatsHeading" Text="ðŸ” DiagnÃ³stico detallado" FontSize="14" FontWeight="Bold" Foreground="{DynamicResource ThemeAccent}"/>
                                <TextBlock x:Name="lblStatsSubtitle" Text="Nivel de temporales y cachÃ©s" FontSize="11" Foreground="{DynamicResource ThemeMutedText}" Margin="0,3,0,6"/>
                                <ProgressBar x:Name="pbJunkLevel" Height="18" Minimum="0" Maximum="100" Value="0"
                                             Background="{DynamicResource ThemeInputBackground}"
                                             Foreground="{DynamicResource ThemeAccent}"
                                             BorderBrush="{DynamicResource ThemeBorderStrong}"/>
                                <TextBlock x:Name="lblJunkPercent" Text="Analizando..." FontSize="12" FontWeight="Bold"
                                           Foreground="{DynamicResource ThemeMainText}" Margin="0,6,0,0"/>
                            </StackPanel>
                            <StackPanel Grid.Column="1" Margin="2,0,2,0" VerticalAlignment="Center">
                                <TextBlock x:Name="lblStatsSummary" Text="RESUMEN" FontSize="10" Foreground="{DynamicResource ThemeLabelText}"/>
                                <TextBlock x:Name="lblJunkDetails" Text="Preparando anÃ¡lisis..." FontSize="12"
                                           Foreground="{DynamicResource ThemeSecondaryText}" TextWrapping="Wrap" Margin="0,4,0,0"/>
                            </StackPanel>
                        </Grid>
                    </Border>

                    <Grid Grid.Row="2">
                        <Grid x:Name="gridBasic" Visibility="Visible">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="14"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            <Border Grid.Column="0" Background="{DynamicResource ThemeCardBackground}"
                                    CornerRadius="8" Padding="14"
                                    BorderBrush="{DynamicResource ThemeBorder}" BorderThickness="1">
                                <StackPanel>
                                    <TextBlock x:Name="lblBasicRepairHeading" Text="ðŸ› ï¸ Reparar mi PC" Style="{StaticResource SectionHeading}" FontSize="15"/>
                                    <Border Background="{DynamicResource ThemeInputBackground}"
                                            BorderBrush="{DynamicResource ThemeBorder}"
                                            BorderThickness="1" CornerRadius="6" Padding="8" Margin="4,0,4,8">
                                        <StackPanel>
                                            <TextBlock x:Name="lblTargetDiskBasic" Text="ðŸŽ¯ Disco a revisar:" FontSize="11"
                                                       Foreground="{DynamicResource ThemeLabelText}" Margin="0,0,0,5"/>
                                            <ComboBox x:Name="cmbRepairDriveBasic" Height="32" Margin="0,0,0,7" FontSize="12"/>
                                            <Button x:Name="btnRefreshDrivesBasic" Content="â†º Actualizar"
                                                    Style="{StaticResource PrimaryButton}" Margin="0" FontSize="12"/>
                                        </StackPanel>
                                    </Border>
                                    <TextBlock x:Name="lblDiskInfoBasic" Text="Detectando discos..." FontSize="11"
                                               Foreground="{DynamicResource ThemeMutedText}" TextWrapping="Wrap" Margin="4,0,4,8"/>
                                    <TextBlock x:Name="lblSubRepair" Text="ðŸ”§ ReparaciÃ³n" Style="{StaticResource SubHeading}"/>
                                    <Button x:Name="btnSfcBasic" Content="Reparar Windows"/>
                                    <Button x:Name="btnDismBasic" Content="Recuperar sistema"/>
                                    <Button x:Name="btnChkDskBasic" Content="Comprobar disco"/>
                                    <Button x:Name="btnDefragBasic" Content="Ordenar disco"/>
                                    <Button x:Name="btnMaxPowerBasic" Content="âš¡ Modo rendimiento"/>
                                    <TextBlock x:Name="lblSubSecurity" Text="ðŸ›¡ï¸ Seguridad" Style="{StaticResource SubHeading}"/>
                                    <Button x:Name="btnCreateRestorePointBasic" Content="Crear Punto de RestauraciÃ³n"/>
                                    <Button x:Name="btnStartupManagerBasic" Content="Gestionar Programas de Inicio"/>
                                    <Button x:Name="btnFullRepairBasic" Content="âš¡ Reparar todo" Style="{StaticResource HeroButton}"/>
                                </StackPanel>
                            </Border>
                            <Border Grid.Column="2" Background="{DynamicResource ThemeCardBackground}"
                                    CornerRadius="8" Padding="14"
                                    BorderBrush="{DynamicResource ThemeBorder}" BorderThickness="1">
                                <StackPanel>
                                    <TextBlock x:Name="lblBasicCleanHeading" Text="ðŸ§¹ Limpieza" Style="{StaticResource SectionHeading}" FontSize="15"/>
                                    <Button x:Name="btnTempBasic" Content="Borrar temporales"/>
                                    <Button x:Name="btnDeepCleanBasic" Content="Limpieza completa"/>
                                    <Button x:Name="btnLogCleanBasic" Content="Borrar historial"/>
                                    <Border Height="1" Background="{DynamicResource ThemeBorder}" Margin="8,14,8,4" Opacity="0.5"/>
                                    <TextBlock x:Name="lblSubInternet" Text="ðŸŒ Arreglar Internet" Style="{StaticResource SubHeading}"/>
                                    <Button x:Name="btnFlushDnsBasic" Content="Arreglar internet"/>
                                    <Button x:Name="btnResetNetBasic" Content="Reiniciar la red"/>
                                    <Button x:Name="btnQoSBasic" Content="ðŸš€ Acelerar red"/>
                                    <Button x:Name="btnFullCleanBasic" Content="ðŸ§¹ Limpieza en 1-Clic" Style="{StaticResource HeroCleanButton}"/>
                                    <Border Height="1" Background="{DynamicResource ThemeBorder}" Margin="8,14,8,4" Opacity="0.35"/>
                                    <TextBlock x:Name="lblTipHeading" Text="ðŸ’¡ Consejo" FontSize="11" FontWeight="Bold"
                                               Foreground="{DynamicResource ThemeMutedText}" Margin="5,0,0,5"/>
                                    <TextBlock x:Name="lblTipText" Text="Si nada funciona, prueba 'Reiniciar la red'. Algunos cambios requieren reiniciar el equipo."
                                               FontSize="11" Foreground="{DynamicResource ThemeMutedText}"
                                               TextWrapping="Wrap" Margin="5,0,5,0" LineHeight="17"/>
                                </StackPanel>
                            </Border>
                        </Grid>

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
                                    <TextBlock x:Name="lblAdvSystemHeading" Text="ðŸ› ï¸ Sistema y Rendimiento" Style="{StaticResource SectionHeading}"/>
                                    <Border Background="{DynamicResource ThemeInputBackground}"
                                            BorderBrush="{DynamicResource ThemeBorder}"
                                            BorderThickness="1" CornerRadius="6" Padding="7" Margin="4,0,4,8">
                                        <StackPanel>
                                            <TextBlock x:Name="lblTargetDiskAdv" Text="ðŸŽ¯ Disco objetivo:" FontSize="11"
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
                                    <TextBlock x:Name="lblAdvNetworkHeading" Text="ðŸŒ Red y ConexiÃ³n" Style="{StaticResource SectionHeading}"/>
                                    <Button x:Name="btnFlushDnsAdv" Content="Limpiar CachÃ© DNS"/>
                                    <Button x:Name="btnResetNetAdv" Content="Restablecer Winsock / IP"/>
                                    <Button x:Name="btnQoSAdv" Content="ðŸš€ Configurar QoS a 0%"/>
                                    <Border Height="1" Background="{DynamicResource ThemeBorder}" Margin="8,14,8,4" Opacity="0.5"/>
                                    <TextBlock x:Name="lblSubShare" Text="ðŸ“¡ Compartir Archivos" Style="{StaticResource SubHeading}"/>
                                    <Button x:Name="btnShareFilesAdv" Content="ðŸ”— Conectar con otra PC / MÃ³vil"
                                            Style="{StaticResource PrimaryButton}" FontSize="13"/>
                                    <TextBlock x:Name="lblShareDesc" Text="Comparte archivos entre PC y mÃ³vil vÃ­a red local (Robocopy / FTP)."
                                               FontSize="10.5" Foreground="{DynamicResource ThemeMutedText}"
                                               TextWrapping="Wrap" Margin="5,3,5,8"/>
                                    <Border Height="1" Background="{DynamicResource ThemeBorder}" Margin="8,14,8,4" Opacity="0.5"/>
                                    <TextBlock x:Name="lblSubSystemTools" Text="ðŸ›¡ï¸ Herramientas del Sistema" Style="{StaticResource SubHeading}"/>
                                    <Button x:Name="btnCreateRestorePointAdv" Content="Crear Punto de RestauraciÃ³n"/>
                                    <Button x:Name="btnStartupManagerAdv" Content="Gestionar Programas de Inicio"/>
                                    <Button x:Name="btnAnalyzeUpdatesAdv" Content="Analizar Actualizaciones"/>
                                </StackPanel>
                            </Border>
                            <Border Grid.Column="4" Background="{DynamicResource ThemeCardBackground}"
                                    CornerRadius="8" Padding="14"
                                    BorderBrush="{DynamicResource ThemeBorder}" BorderThickness="1">
                                <StackPanel>
                                    <TextBlock x:Name="lblAdvMaintHeading" Text="ðŸ§¹ Mantenimiento" Style="{StaticResource SectionHeading}"/>
                                    <Button x:Name="btnTempAdv" Content="Limpiar Temporales BÃ¡sicos"/>
                                    <Button x:Name="btnDeepCleanAdv" Content="ðŸ§¹ Limpieza Profunda / WinUpdate"/>
                                    <Button x:Name="btnLogCleanAdv" Content="ðŸ—‘ï¸ Limpiar Logs y WinSxS"/>
                                    <Border Height="1" Background="{DynamicResource ThemeBorder}" Margin="8,14,8,4" Opacity="0.5"/>
                                    <TextBlock x:Name="lblSubAdvancedTools" Text="ðŸ› ï¸ Herramientas Avanzadas" Style="{StaticResource SubHeading}"/>
                                    <Button x:Name="btnDeleteLockedFileAdv" Content="Gestor de Archivos Bloqueados"/>
                                    <Button x:Name="btnCleanupDriversAdv" Content="Limpiar Controladores Obsoletos"/>
                                    <Button x:Name="btnFullRepairAdv" Style="{StaticResource PrimaryButton}"
                                            Content="âš¡ ReparaciÃ³n 1-Clic" Margin="5,10,5,3"/>
                                    <Button x:Name="btnFullCleanAdv" Style="{StaticResource CleanButton}"
                                            Content="ðŸ§¹ Limpieza en 1-Clic" Margin="5,3,5,5"/>
                                </StackPanel>
                            </Border>
                        </Grid>
                    </Grid>

                    <Border Grid.Row="3" Background="{DynamicResource ThemePanelBackground}" CornerRadius="8" Padding="14"
                            Margin="0,14,0,0" BorderBrush="{DynamicResource ThemeBorder}" BorderThickness="1">
                        <StackPanel>
                            <TextBlock x:Name="lblRecHeading" Text="ðŸ’¡ Recomendaciones personalizadas" FontSize="14" FontWeight="Bold"
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

                    <Border x:Name="logPanel" Grid.Row="4" Background="{DynamicResource ThemePanelBackground}"
                            CornerRadius="8" Padding="12" Margin="0,14,0,0"
                            BorderBrush="{DynamicResource ThemeBorder}" BorderThickness="1" Visibility="Collapsed">
                        <StackPanel>
                            <TextBlock x:Name="lblLogHeading" Text="ðŸ“œ Registro de Actividad" FontSize="12" FontWeight="Bold"
                                       Foreground="{DynamicResource ThemeMutedText}" Margin="0,0,0,6"/>
                            <TextBox x:Name="txtLog" Height="130" Background="{DynamicResource ThemeInputBackground}"
                                     Foreground="{DynamicResource ThemeLogForeground}"
                                     BorderBrush="{DynamicResource ThemeBorder}"
                                     FontFamily="Consolas" FontSize="11" IsReadOnly="True"
                                     TextWrapping="Wrap" VerticalScrollBarVisibility="Auto"/>
                        </StackPanel>
                    </Border>

                    <Border Grid.Row="5" Background="{DynamicResource ThemePanelBackground}" CornerRadius="8"
                            Padding="8" Margin="0,14,0,0" BorderBrush="{DynamicResource ThemeBorder}" BorderThickness="1">
                        <DockPanel>
                            <StackPanel Orientation="Horizontal" DockPanel.Dock="Right">
                                <Button x:Name="btnDiagnose" Content="ðŸ” Analizar PC" Width="160" Style="{StaticResource ManualButton}"/>
                                <Button x:Name="btnManual" Content="ðŸ“– Manual detallado" Width="180" Style="{StaticResource ManualButton}"/>
                                <Button x:Name="btnRevert" Content="â†© Revertir cambios" Width="180" Style="{StaticResource RevertButton}"/>
                            </StackPanel>
                            <TextBlock x:Name="lblFooterNotice" Text="Los cambios reversibles se guardan localmente en el equipo."
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
$global:lblLangCaption    = $window.FindName("lblLangCaption")
$global:cmbLanguage       = $window.FindName("cmbLanguage")
$global:btnMin            = $window.FindName("btnMin")
$global:btnMax            = $window.FindName("btnMax")
$global:btnClose          = $window.FindName("btnClose")
$global:btnCheckUpdate    = $window.FindName("btnCheckUpdate")
$global:btnUpdateBadge    = $window.FindName("btnUpdateBadge")
$global:chkLowMode        = $window.FindName("chkLowMode")
$global:txtLog            = $window.FindName("txtLog")
$global:lblStatus         = $window.FindName("lblStatus")
$global:lblPCName         = $window.FindName("lblPCName")
$global:lblWindowsInfo    = $window.FindName("lblWindowsInfo")
$global:lblPowerShellInfo = $window.FindName("lblPowerShellInfo")
$global:lblComponentsInfo = $window.FindName("lblComponentsInfo")
$global:lblLblPC          = $window.FindName("lblLblPC")
$global:lblLblWindows     = $window.FindName("lblLblWindows")
$global:lblLblPowerShell  = $window.FindName("lblLblPowerShell")
$global:lblLblComponents  = $window.FindName("lblLblComponents")
$global:pbJunkLevel       = $window.FindName("pbJunkLevel")
$global:lblJunkPercent    = $window.FindName("lblJunkPercent")
$global:lblJunkDetails    = $window.FindName("lblJunkDetails")
$global:lblStatsHeading   = $window.FindName("lblStatsHeading")
$global:lblStatsSubtitle  = $window.FindName("lblStatsSubtitle")
$global:lblStatsSummary   = $window.FindName("lblStatsSummary")
$global:txtRecommendations= $window.FindName("txtRecommendations")
$global:lblRecHeading     = $window.FindName("lblRecHeading")
$global:lblLogHeading     = $window.FindName("lblLogHeading")
$global:lblFooterNotice   = $window.FindName("lblFooterNotice")
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

# Basic mode refs
$global:lblBasicRepairHeading = $window.FindName("lblBasicRepairHeading")
$global:lblTargetDiskBasic    = $window.FindName("lblTargetDiskBasic")
$global:lblSubRepair          = $window.FindName("lblSubRepair")
$global:lblSubSecurity        = $window.FindName("lblSubSecurity")
$global:lblBasicCleanHeading  = $window.FindName("lblBasicCleanHeading")
$global:lblSubInternet        = $window.FindName("lblSubInternet")
$global:lblTipHeading         = $window.FindName("lblTipHeading")
$global:lblTipText            = $window.FindName("lblTipText")
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
$global:btnFullCleanBasic     = $window.FindName("btnFullCleanBasic")
$global:btnFlushDnsBasic      = $window.FindName("btnFlushDnsBasic")
$global:btnResetNetBasic      = $window.FindName("btnResetNetBasic")
$global:btnQoSBasic           = $window.FindName("btnQoSBasic")
$global:btnCreateRestorePointBasic = $window.FindName("btnCreateRestorePointBasic")
$global:btnStartupManagerBasic     = $window.FindName("btnStartupManagerBasic")

# Advanced mode refs
$global:lblAdvSystemHeading   = $window.FindName("lblAdvSystemHeading")
$global:lblTargetDiskAdv      = $window.FindName("lblTargetDiskAdv")
$global:lblAdvNetworkHeading  = $window.FindName("lblAdvNetworkHeading")
$global:lblSubShare           = $window.FindName("lblSubShare")
$global:lblShareDesc          = $window.FindName("lblShareDesc")
$global:lblSubSystemTools     = $window.FindName("lblSubSystemTools")
$global:lblAdvMaintHeading    = $window.FindName("lblAdvMaintHeading")
$global:lblSubAdvancedTools   = $window.FindName("lblSubAdvancedTools")
$global:cmbRepairDriveAdv     = $window.FindName("cmbRepairDriveAdv")
$global:btnRefreshDrivesAdv   = $window.FindName("btnRefreshDrivesAdv")
$global:lblDiskInfoAdv        = $window.FindName("lblDiskInfoAdv")
$global:btnSfcAdv             = $window.FindName("btnSfcAdv")
$global:btnDismAdv            = $window.FindName("btnDismAdv")
$global:btnChkDskAdv          = $window.FindName("btnChkDskAdv")
$global:btnDefragAdv          = $window.FindName("btnDefragAdv")
$global:btnMaxPowerAdv        = $window.FindName("btnMaxPowerAdv")
$global:btnTempAdv            = $window.FindName("btnTempAdv")
$global:btnDeepCleanAdv       = $window.FindName("btnDeepCleanAdv")
$global:btnLogCleanAdv        = $window.FindName("btnLogCleanAdv")
$global:btnFullRepairAdv      = $window.FindName("btnFullRepairAdv")
$global:btnFullCleanAdv       = $window.FindName("btnFullCleanAdv")
$global:btnFlushDnsAdv        = $window.FindName("btnFlushDnsAdv")
$global:btnResetNetAdv        = $window.FindName("btnResetNetAdv")
$global:btnQoSAdv             = $window.FindName("btnQoSAdv")
$global:btnCreateRestorePointAdv = $window.FindName("btnCreateRestorePointAdv")
$global:btnStartupManagerAdv     = $window.FindName("btnStartupManagerAdv")
$global:btnAnalyzeUpdatesAdv     = $window.FindName("btnAnalyzeUpdatesAdv")
$global:btnDeleteLockedFileAdv   = $window.FindName("btnDeleteLockedFileAdv")
$global:btnCleanupDriversAdv     = $window.FindName("btnCleanupDriversAdv")
$global:btnShareFilesAdv         = $window.FindName("btnShareFilesAdv")

# ---------- 5. FUNCIONES AUXILIARES ------------------------------------------
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
    try {
        if (-not $global:lblStatus) { return }
        if ([string]::IsNullOrWhiteSpace($Text)) { $Text = Get-OmegaString 'Status_Ready' }
        $prefix = Get-OmegaString 'Status_Prefix'
        $global:lblStatus.Text = "$prefix$Text"
    } catch { }
}

function Get-ActiveRepairCombo {
    try { if ($global:gridAdvanced.Visibility -eq 'Visible') { return $global:cmbRepairDriveAdv } } catch { }
    return $global:cmbRepairDriveBasic
}

function Get-ActiveDiskInfoLabel {
    try { if ($global:gridAdvanced.Visibility -eq 'Visible') { return $global:lblDiskInfoAdv } } catch { }
    return $global:lblDiskInfoBasic
}

# ==============================================================================
# CONVERSOR DE BRUSH
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
    $commands = [ordered]@{ 'SFC'='sfc.exe'; 'DISM'='dism.exe'; 'CHKDSK'='chkdsk.exe'; 'PowerCfg'='powercfg.exe'; 'Netsh'='netsh.exe'; 'IPConfig'='ipconfig.exe'; 'CleanMgr'='cleanmgr.exe'; 'Defrag'='dfrgui.exe'; 'PnPUtil'='pnputil.exe'; 'Robocopy'='robocopy.exe' }
    foreach ($key in $commands.Keys) { $sysProfile.Components[$key] = [bool](Get-Command $commands[$key] -ErrorAction SilentlyContinue) }
    $sysProfile.Components['WPF'] = $true
    return [pscustomobject]$sysProfile
}

function Initialize-OmegaSystemProfile {
    param([object]$SysProfile)
    try { $global:lblPCName.Text = "ðŸ”¹ $($SysProfile.ComputerName)" } catch { }
    $edition = if ($SysProfile.PowerShellEdition -eq 'Core') { 'Core' } else { 'Desktop' }
    try { $global:lblPowerShellInfo.Text = "$($SysProfile.PowerShellVersion) ($edition)" } catch { }
    $winVersion = if ($SysProfile.WindowsDisplayVersion) { $SysProfile.WindowsDisplayVersion } elseif ($SysProfile.WindowsVersion) { $SysProfile.WindowsVersion } else { 'desconocida' }
    $buildText = if ($SysProfile.WindowsBuild) { "Build $($SysProfile.WindowsBuild)" } else { '' }
    try { $global:lblWindowsInfo.Text = "$($SysProfile.WindowsName) $winVersion $buildText".Trim() } catch { }
    $available = @($SysProfile.Components.GetEnumerator() | Where-Object { $_.Value } | ForEach-Object { $_.Key })
    $missing = @($SysProfile.Components.GetEnumerator() | Where-Object { -not $_.Value } | ForEach-Object { $_.Key })
    try {
        if ($missing.Count -eq 0) {
            $global:lblComponentsInfo.Text = Get-OmegaString 'Components_OK' ($available -join ', ')
            $global:lblComponentsInfo.Foreground = [System.Windows.Media.Brushes]::LightGreen
        } else {
            $global:lblComponentsInfo.Text = Get-OmegaString 'Components_Missing' ($missing -join ', ')
            $global:lblComponentsInfo.Foreground = [System.Windows.Media.Brushes]::Khaki
        }
    } catch { }
    Write-OmegaLog (Get-OmegaString 'Log_System' @($SysProfile.ComputerName, $SysProfile.WindowsName, $SysProfile.PowerShellVersion))
}

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
        'Temporales'    = $env:TEMP
        'Windows Temp'  = Join-Path $env:SystemRoot 'Temp'
        'WinUpdate'     = Join-Path $env:SystemRoot 'SoftwareDistribution\Download'
        'DeliveryOpt'   = Join-Path $env:SystemRoot 'ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache'
        'Edge Cache'    = Join-Path $env:LOCALAPPDATA 'Microsoft\Edge\User Data\Default\Cache'
        'Chrome Cache'  = Join-Path $env:LOCALAPPDATA 'Google\Chrome\User Data\Default\Cache'
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
    $batteryState = 'Desktop/AC'
    try {
        $battery = @(Get-CimInstance Win32_Battery -ErrorAction Stop)
        if ($battery.Count -gt 0) {
            $discharging = $battery | Where-Object { $_.BatteryStatus -eq 1 }
            $batteryState = $(if ($discharging) { 'Battery' } else { 'AC' })
        }
    } catch { }
    $recommendations = [System.Collections.Generic.List[string]]::new()
    if ($freePct -ne $null -and $freePct -lt 15) { [void]$recommendations.Add((Get-OmegaString 'Rec_LowDisk')) }
    elseif ($freePct -ne $null -and $freePct -lt 25) { [void]$recommendations.Add((Get-OmegaString 'Rec_LowDiskMid')) }
    if ($junkGB -ge 1) { [void]$recommendations.Add((Get-OmegaString 'Rec_JunkDetected' $junkGB)) }
    else { [void]$recommendations.Add((Get-OmegaString 'Rec_LittleJunk')) }
    if ($junkGB -ge 3) { [void]$recommendations.Add((Get-OmegaString 'Rec_DeepCleanHint')) }
    if ($batteryState -eq 'Battery') { [void]$recommendations.Add((Get-OmegaString 'Rec_Battery')) }
    else { [void]$recommendations.Add((Get-OmegaString 'Rec_AC')) }
    [pscustomobject]@{
        JunkBytes = $junkBytes; JunkGB = $junkGB; JunkLevel = $junkLevel
        FreePct = $freePct
        FreeGB = $(if ($freeBytes) { [math]::Round($freeBytes / 1GB, 1) } else { $null })
        TotalGB = $(if ($totalBytes) { [math]::Round($totalBytes / 1GB, 1) } else { $null })
        BatteryState = $batteryState; Recommendations = @($recommendations)
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
        $global:txtRecommendations.Text = Get-OmegaString 'Stats_Analyzing'
        $global:pbJunkLevel.Value = 0
        $global:lblJunkPercent.Text = Get-OmegaString 'Stats_Analyzing'
        $global:lblJunkDetails.Text = Get-OmegaString 'Stats_Calculating'
        $diag = Get-OmegaSmartDiagnostics
        $global:pbJunkLevel.Value = [double]$diag.JunkLevel
        Set-OmegaProgressAppearance -Value $diag.JunkLevel
        $freeText = if ($null -ne $diag.FreePct) {
            Get-OmegaString 'Stats_Free_Format' @($diag.FreePct, $diag.FreeGB, $diag.TotalGB)
        } else { Get-OmegaString 'Stats_NA' }
        $global:lblJunkPercent.Text = "$($diag.JunkLevel)% Â· " + (Get-OmegaString 'Stats_Reference')
        $line1 = Get-OmegaString 'Stats_Text_Line1' $diag.JunkGB
        $line2 = Get-OmegaString 'Stats_Text_Line2' $freeText
        $line3 = Get-OmegaString 'Stats_Text_Line3' $diag.BatteryState
        $global:lblJunkDetails.Text = "$line1`n$line2`n$line3"
        $global:txtRecommendations.Text = ($diag.Recommendations -join "`n")
        Write-OmegaLog (Get-OmegaString 'Log_Diagnostics' @($diag.JunkGB, $diag.JunkLevel, $freeText))
    } catch {
        $global:pbJunkLevel.Value = 0
        $global:lblJunkPercent.Text = Get-OmegaString 'Stats_Unavailable'
        $global:lblJunkDetails.Text = $_.Exception.Message
        $global:txtRecommendations.Text = Get-OmegaString 'Stats_CouldNotComplete'
        Write-OmegaLog (Get-OmegaString 'Log_DiagFailed' $_.Exception.Message)
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
            $label = if ([string]::IsNullOrWhiteSpace($disk.VolumeName)) { Get-OmegaString 'Drive_NoLabel' } else { $disk.VolumeName }
            $role = if ($isSystemDrive) { Get-OmegaString 'Drive_ActiveWindows' }
                    elseif ($hasWindows) { Get-OmegaString 'Drive_OfflineWindows' }
                    else { Get-OmegaString 'Drive_Data' }
            $results += [pscustomobject]@{
                Drive=$drive; Root=$root; HasWindows=$hasWindows; IsSystemDrive=$isSystemDrive
                Display="$drive â€” $role â€” $label ($freeGB/$sizeGB GB)"
                VolumeName=$label; SizeGB=$sizeGB; FreeGB=$freeGB
            }
        }
    } catch { Write-OmegaLog (Get-OmegaString 'Log_NoDisks' $_.Exception.Message) }
    return $results
}

function Get-SelectedOmegaDriveInfo {
    $combo = Get-ActiveRepairCombo
    if (-not $combo -or -not $combo.SelectedItem) { return $null }
    return $combo.SelectedItem.Tag
}

function Get-OmegaDriveMediaType {
    param([string]$DriveLetter)
    $key = $DriveLetter.TrimEnd(':').ToUpperInvariant()
    if ($script:OmegaMediaTypeCache.ContainsKey($key)) { return $script:OmegaMediaTypeCache[$key] }
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
        $isAdv = $global:gridAdvanced.Visibility -eq 'Visible'
        $btnDefrag = $(if ($isAdv) { $global:btnDefragAdv } else { $global:btnDefragBasic })
        $btnSfc    = $(if ($isAdv) { $global:btnSfcAdv }    else { $global:btnSfcBasic })
        $btnDism   = $(if ($isAdv) { $global:btnDismAdv }   else { $global:btnDismBasic })
        $btnChkDsk = $(if ($isAdv) { $global:btnChkDskAdv } else { $global:btnChkDskBasic })
        if (-not $info) {
            $lblInfo.Text = Get-OmegaString 'Drive_NoSelected'
            $btnSfc.IsEnabled = $false; $btnDism.IsEnabled = $false; $btnChkDsk.IsEnabled = $false
            $btnDefrag.IsEnabled = $false
            $btnDefrag.Content = Get-OmegaString 'Btn_Defrag_NoDrive'
            return
        }
        if ($info.IsSystemDrive) {
            $lblInfo.Text = Get-OmegaString 'Drive_SFC_Online' $info.Drive
            $btnSfc.IsEnabled  = [bool]$script:OmegaSystemProfile.Components['SFC']
            $btnDism.IsEnabled = [bool]$script:OmegaSystemProfile.Components['DISM']
        } elseif ($info.HasWindows) {
            $lblInfo.Text = Get-OmegaString 'Drive_SFC_Offline' $info.Drive
            $btnSfc.IsEnabled  = [bool]$script:OmegaSystemProfile.Components['SFC']
            $btnDism.IsEnabled = [bool]$script:OmegaSystemProfile.Components['DISM']
        } else {
            $lblInfo.Text = Get-OmegaString 'Drive_DataOnly' $info.Drive
            $btnSfc.IsEnabled = $false; $btnDism.IsEnabled = $false
        }
        $btnChkDsk.IsEnabled = [bool]$script:OmegaSystemProfile.Components['CHKDSK']
        $mediaType = Get-OmegaDriveMediaType -DriveLetter $info.Drive
        switch ($mediaType) {
            'HDD' {
                $btnDefrag.IsEnabled = $true
                $btnDefrag.Content = $(if ($isAdv) { Get-OmegaString 'Btn_DefragAdv_HDD' } else { Get-OmegaString 'Btn_Defrag_HDD' })
                $btnDefrag.ToolTip = Get-OmegaString 'Drive_Tooltip_HDD' $info.Drive
                Write-OmegaLog (Get-OmegaString 'Drive_HDDDetected' $info.Drive)
            }
            'SSD' {
                $btnDefrag.IsEnabled = $false
                $btnDefrag.Content = $(if ($isAdv) { Get-OmegaString 'Btn_DefragAdv_SSD_Blocked' } else { Get-OmegaString 'Btn_Defrag_SSD_Blocked' })
                $btnDefrag.ToolTip = Get-OmegaString 'Drive_Tooltip_SSD' $info.Drive
                Write-OmegaLog (Get-OmegaString 'Drive_SSDDetected' $info.Drive)
            }
            default {
                $btnDefrag.IsEnabled = $false
                $btnDefrag.Content = $(if ($isAdv) { Get-OmegaString 'Btn_DefragAdv_Unknown' } else { Get-OmegaString 'Btn_Defrag_Unknown' })
                $btnDefrag.ToolTip = Get-OmegaString 'Drive_Tooltip_Unknown'
            }
        }
    } catch { }
}

function Refresh-OmegaRepairDrives {
    try {
        $script:OmegaMediaTypeCache = @{}
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
            try { $global:lblDiskInfoBasic.Text = Get-OmegaString 'Drive_NoDrivesDetected' } catch { }
            try { $global:lblDiskInfoAdv.Text = Get-OmegaString 'Drive_NoDrivesDetected' } catch { }
            return
        }
        Update-OmegaRepairDriveState
        Write-OmegaLog (Get-OmegaString 'Drive_DetectedCount' $driveInfos.Count)
    } catch { Write-OmegaLog (Get-OmegaString 'Drive_DetectError' $_.Exception.Message) }
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
        if ($current) { $script:OmegaState.PowerPlan.OriginalSchemeGuid = $current; Write-OmegaLog (Get-OmegaString 'Log_OriginalPlan') }
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
    Write-OmegaLog (Get-OmegaString 'Log_ReversibleSaved')
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
    if (-not $DriveInfo -or -not $DriveInfo.HasWindows) { Write-OmegaLog (Get-OmegaString 'Repair_NotApplicable_SFC'); return $null }
    if ($DriveInfo.IsSystemDrive) {
        Write-OmegaLog (Get-OmegaString 'Repair_SFC_Online')
        return Start-Process -FilePath "cmd.exe" -ArgumentList @('/c', 'sfc /scannow') -WindowStyle Hidden -PassThru
    } else {
        Write-OmegaLog (Get-OmegaString 'Repair_SFC_Offline')
        return Start-Process -FilePath "cmd.exe" -ArgumentList @('/c', "sfc /scannow /offbootdir=$($DriveInfo.Root) /offwindir=$($DriveInfo.Root)Windows") -WindowStyle Hidden -PassThru
    }
}

function Start-OmegaDismRepair {
    param([object]$DriveInfo)
    if (-not $DriveInfo -or -not $DriveInfo.HasWindows) { Write-OmegaLog (Get-OmegaString 'Repair_NotApplicable_DISM'); return $null }
    if ($DriveInfo.IsSystemDrive) {
        Write-OmegaLog (Get-OmegaString 'Repair_DISM_Online')
        return Start-Process -FilePath "cmd.exe" -ArgumentList @('/c', 'DISM /Online /Cleanup-Image /RestoreHealth') -WindowStyle Hidden -PassThru
    } else {
        Write-OmegaLog (Get-OmegaString 'Repair_DISM_Offline')
        return Start-Process -FilePath "cmd.exe" -ArgumentList @('/c', "DISM /Image:$($DriveInfo.Root) /Cleanup-Image /RestoreHealth") -WindowStyle Hidden -PassThru
    }
}

function Start-OmegaChkdskRepair {
    param([object]$DriveInfo)
    if (-not $DriveInfo) { return $null }
    Write-OmegaLog (Get-OmegaString 'Repair_CHKDSK_Checking' $DriveInfo.Drive)
    return Start-Process -FilePath "cmd.exe" -ArgumentList @('/c', "chkdsk $($DriveInfo.Drive) /f") -WindowStyle Hidden -PassThru
}

function Start-BasicTempCleanup {
    Write-OmegaLog (Get-OmegaString 'Clean_Basic_Start')
    try {
        Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:SystemRoot\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-OmegaLog (Get-OmegaString 'Clean_Basic_Done')
    } catch { Write-OmegaLog (Get-OmegaString 'Clean_Error' $_.Exception.Message) }
    return $null
}

function Start-LogAndWinSxSCleanup {
    Write-OmegaLog (Get-OmegaString 'Clean_Logs_Start')
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
    Write-OmegaLog (Get-OmegaString 'Clean_Deep_Disabling')
    powercfg -h off | Out-Null
    Write-OmegaLog (Get-OmegaString 'Clean_Deep_StoppingServices')
    Stop-Service -Name wuauserv, FontCache, UsoSvc -Force -ErrorAction SilentlyContinue
    Write-OmegaLog (Get-OmegaString 'Clean_Deep_CleaningCaches')
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

function Start-OmegaOneClickCleanup {
    Write-OmegaLog (Get-OmegaString 'Clean_1Click_Start')
    try {
        Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:SystemRoot\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:SystemRoot\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
        ipconfig /flushdns | Out-Null
        Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
        Clear-RecycleBin -Force -ErrorAction SilentlyContinue
        $diag = Get-OmegaSmartDiagnostics
        Write-OmegaLog (Get-OmegaString 'Clean_1Click_Done' $diag.JunkGB)
        return $null
    } catch { Write-OmegaLog (Get-OmegaString 'Clean_Error' $_.Exception.Message); return $null }
}

function Start-OmegaRevertChanges {
    if (-not (Confirm-OmegaAction -Title (Get-OmegaString 'Revert_Confirm_Title') -Message (Get-OmegaString 'Revert_Confirm_Message'))) { return $null }
    Write-OmegaLog (Get-OmegaString 'Revert_Start')
    try {
        if (-not [string]::IsNullOrWhiteSpace($script:OmegaState.PowerPlan.OriginalSchemeGuid)) {
            powercfg -setactive $script:OmegaState.PowerPlan.OriginalSchemeGuid | Out-Null
            Write-OmegaLog (Get-OmegaString 'Revert_PowerRestored')
        }
        $regPath = $script:OmegaState.QoS.RegistryPath
        if (Test-Path $regPath) {
            if ($script:OmegaState.QoS.OriginalValueExists -and $null -ne $script:OmegaState.QoS.OriginalValue) {
                Set-ItemProperty -Path $regPath -Name "NonBestEffortLimit" -Value $script:OmegaState.QoS.OriginalValue -Type DWord
                Write-OmegaLog (Get-OmegaString 'Revert_QoSRestored')
            } else {
                Remove-ItemProperty -Path $regPath -Name "NonBestEffortLimit" -ErrorAction SilentlyContinue
                Write-OmegaLog (Get-OmegaString 'Revert_QoSRemoved')
            }
        }
        if ($script:OmegaState.FastStartup.OriginalHibernationEnabled -eq $true) {
            powercfg -h on | Out-Null
            Write-OmegaLog (Get-OmegaString 'Revert_Hibernation')
        }
        Restore-OmegaServiceStates
        Write-OmegaLog (Get-OmegaString 'Revert_Done')
    } catch { Write-OmegaLog (Get-OmegaString 'Clean_Error' $_.Exception.Message) }
    return $null
}

# ==============================================================================
# Update Checker (GitHub)
# ==============================================================================
function Test-OmegaUpdate {
    param([string]$CurrentVersion = $script:OmegaCurrentVersion, [switch]$Silent)
    $result = [ordered]@{
        HasUpdate = $false; LatestVersion = $null; DownloadUrl = $null
        ReleaseNotes = $null; Status = 'unknown'; Message = ''
    }
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        if ([string]::IsNullOrWhiteSpace($script:OmegaGitHubRepo)) {
            $result.Status = 'error'; $result.Message = Get-OmegaString 'Update_Error_Log' 'GitHub repo not configured.'; return [pscustomobject]$result
        }
        $apiUrl = "https://api.github.com/repos/$($script:OmegaGitHubRepo)/releases/latest"
        $headers = @{ 'User-Agent' = 'OmegaSolver-UpdateChecker'; 'Accept' = 'application/vnd.github+json' }
        $response = Invoke-RestMethod -Uri $apiUrl -Method Get -Headers $headers -TimeoutSec $script:OmegaUpdateTimeout -ErrorAction Stop
        $latestTag = [string]$response.tag_name -replace '^v', ''
        $result.LatestVersion = $latestTag
        $result.DownloadUrl   = [string]$response.html_url
        $result.ReleaseNotes  = [string]$response.body
        try { $isNewer = ([version]$latestTag) -gt ([version]$CurrentVersion) } catch { $isNewer = $false }
        if ($isNewer) {
            $result.HasUpdate = $true; $result.Status = 'update-available'
            $result.Message = Get-OmegaString 'Update_Available_Log' @($latestTag, $CurrentVersion)
        } else {
            $result.Status = 'latest'
            $result.Message = Get-OmegaString 'Update_Latest_Log' $CurrentVersion
        }
    } catch {
        $errMsg = $_.Exception.Message
        if ($errMsg -match 'connection|network|timeout|unable|resolution|remote name|remota') {
            $result.Status = 'offline'; $result.Message = Get-OmegaString 'Update_Offline_Log'
        } elseif ($errMsg -match '404|Not Found') {
            $result.Status = 'error'; $result.Message = Get-OmegaString 'Update_RepoNotFound_Log'
        } else {
            $result.Status = 'error'; $result.Message = Get-OmegaString 'Update_Error_Log' $errMsg
        }
    }
    if (-not $Silent) { Write-OmegaLog (Get-OmegaString 'Update_StatusLine' $result.Message) }
    return [pscustomobject]$result
}

function Invoke-OmegaUpdateCheckUI {
    param([switch]$Manual)
    try {
        Set-OmegaStatus (Get-OmegaString 'Update_Checking')
        if ($Manual) { Write-OmegaLog (Get-OmegaString 'Update_CheckGitHub') }
        Start-Sleep -Milliseconds 200
        $upd = Test-OmegaUpdate
        switch ($upd.Status) {
            'update-available' {
                $global:btnUpdateBadge.Content = Get-OmegaString 'Update_Badge' $upd.LatestVersion
                $global:btnUpdateBadge.Visibility = 'Visible'
                $global:btnUpdateBadge.ToolTip = Get-OmegaString 'Update_Tooltip'
                Write-OmegaLog (Get-OmegaString 'Update_Available_Log' @($upd.LatestVersion, $script:OmegaCurrentVersion))
                if ($Manual) {
                    $r = [System.Windows.MessageBox]::Show(
                        (Get-OmegaString 'Update_Dialog_Message' @($script:OmegaCurrentVersion, $upd.LatestVersion)),
                        (Get-OmegaString 'Update_Dialog_Title'), 'YesNo', 'Information')
                    if ($r -eq [System.Windows.MessageBoxResult]::Yes -and $upd.DownloadUrl) {
                        Start-Process $upd.DownloadUrl | Out-Null
                    }
                }
            }
            'latest' {
                $global:btnUpdateBadge.Visibility = 'Collapsed'
                if ($Manual) {
                    [System.Windows.MessageBox]::Show((Get-OmegaString 'Update_NoUpdates_Message' $script:OmegaCurrentVersion), (Get-OmegaString 'Update_NoUpdates_Title'), 'OK', 'Information') | Out-Null
                }
            }
            'offline' {
                $global:btnUpdateBadge.Visibility = 'Collapsed'
                if ($Manual) {
                    [System.Windows.MessageBox]::Show((Get-OmegaString 'Update_Offline_Message'), (Get-OmegaString 'Update_Offline_Title'), 'OK', 'Warning') | Out-Null
                }
            }
            'error' {
                $global:btnUpdateBadge.Visibility = 'Collapsed'
                if ($Manual) {
                    [System.Windows.MessageBox]::Show((Get-OmegaString 'Update_Error_Message' $upd.Message), (Get-OmegaString 'Update_Error_Title'), 'OK', 'Warning') | Out-Null
                }
            }
        }
    } catch { Write-OmegaLog (Get-OmegaString 'Update_UIError' $_.Exception.Message) }
    finally { Set-OmegaStatus (Get-OmegaString 'Status_Ready') }
}

# ==============================================================================
# Low Mode
# ==============================================================================
function Get-OmegaLowModeState {
    try {
        if (Test-Path $script:OmegaLowModePath) {
            $saved = (Get-Content -Path $script:OmegaLowModePath -Raw -ErrorAction Stop).Trim()
            return ($saved -eq '1')
        }
    } catch { }
    return $false
}

function Save-OmegaLowModeState {
    param([bool]$Enabled)
    try {
        $val = if ($Enabled) { '1' } else { '0' }
        Set-Content -Path $script:OmegaLowModePath -Value $val -Encoding UTF8 -Force
    } catch { }
}

function Apply-OmegaLowMode {
    param([bool]$Enable)
    try {
        if ($Enable) {
            $global:MainBorder.Effect = $null
            $global:lblAppTitle.Effect = $null
            $global:MainBorder.BorderThickness = New-Object System.Windows.Thickness(1)
            $global:TitleBar.BorderThickness = New-Object System.Windows.Thickness(0,0,0,1)
            Write-OmegaLog (Get-OmegaString 'LowMode_Enabled')
        } else {
            $currentTheme = [string]$global:cmbTheme.SelectedItem
            if ($currentTheme -eq 'OMEGASOLVER style') { Apply-OmegaSolverEffects }
            $global:MainBorder.BorderThickness = New-Object System.Windows.Thickness(2)
            $global:TitleBar.BorderThickness = New-Object System.Windows.Thickness(0,0,0,2)
            Write-OmegaLog (Get-OmegaString 'LowMode_Disabled')
        }
        Save-OmegaLowModeState -Enabled $Enable
    } catch { Write-OmegaLog (Get-OmegaString 'LowMode_Error' $_.Exception.Message) }
}

function Test-OmegaLowModeActive {
    try { return [bool]$global:chkLowMode.IsChecked } catch { return $false }
}

# ==============================================================================
# Dism++ Inspired â€” Restore Point Â· Startup Manager Â· Locked Files Â· Drivers
# ==============================================================================
function New-OmegaRestorePoint {
    try {
        try { Enable-ComputerRestore -Drive "$env:SystemDrive\" -ErrorAction Stop; Write-OmegaLog (Get-OmegaString 'Restore_Enabled') }
        catch { Write-OmegaLog (Get-OmegaString 'Restore_CouldNotEnable') }
        Checkpoint-Computer -Description "OmegaSolver V4.3 â€” Manual Restore Point" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
        Write-OmegaLog (Get-OmegaString 'Restore_Created' $env:SystemDrive)
        [System.Windows.MessageBox]::Show((Get-OmegaString 'Restore_Success'), (Get-OmegaString 'Restore_SuccessTitle'), 'OK', 'Information') | Out-Null
    } catch {
        Write-OmegaLog (Get-OmegaString 'Restore_Error' $_.Exception.Message)
        [System.Windows.MessageBox]::Show((Get-OmegaString 'Restore_ErrorDlg' $_.Exception.Message), (Get-OmegaString 'Restore_ErrorTitle'), 'OK', 'Error') | Out-Null
    }
    return $null
}

function Show-OmegaStartupManager {
    try {
        Write-OmegaLog (Get-OmegaString 'Startup_Analyzing')
        $items = Get-CimInstance Win32_StartupCommand -ErrorAction Stop |
            Select-Object Name, Command, Location, User | Sort-Object Name
        if ($items.Count -eq 0) {
            [System.Windows.MessageBox]::Show((Get-OmegaString 'Startup_NoPrograms'), (Get-OmegaString 'Startup_Title'), 'OK', 'Information') | Out-Null
            return
        }
        $header = Get-OmegaString 'Startup_Header' $items.Count
        $locLbl = Get-OmegaString 'Startup_Location'
        $cmdLbl = Get-OmegaString 'Startup_Command'
        $report = "$header`n`n"
        foreach ($it in $items) {
            $report += "â€¢ $($it.Name)`n  ${locLbl}: $($it.Location)`n  ${cmdLbl}:  $($it.Command)`n`n"
            Write-OmegaLog "â€¢ $($it.Name) [$($it.Location)]"
        }
        $global:txtRecommendations.Dispatcher.Invoke([Action]{ $global:txtRecommendations.Text = $report })
        [System.Windows.MessageBox]::Show((Get-OmegaString 'Startup_Found' $items.Count), (Get-OmegaString 'Startup_Title'), 'OK', 'Information') | Out-Null
    } catch { Write-OmegaLog (Get-OmegaString 'Startup_Error' $_.Exception.Message) }
    return $null
}

function Get-OmegaUpdatesReport {
    Write-OmegaLog (Get-OmegaString 'Updates_Analyzing')
    try {
        $updates = Get-WmiObject -Class Win32_QuickFixEngineering -ErrorAction Stop |
            Select-Object HotFixID, Description, InstalledOn | Sort-Object InstalledOn -Descending
        $report = (Get-OmegaString 'Updates_Header') + "`n`n"
        $report += ($updates | Select-Object -First 15 | Format-Table -AutoSize | Out-String)
        $global:txtRecommendations.Dispatcher.Invoke([Action]{ $global:txtRecommendations.Text = $report })
        Write-OmegaLog (Get-OmegaString 'Updates_Found' $updates.Count)
    } catch { Write-OmegaLog (Get-OmegaString 'Updates_Error' $_.Exception.Message) }
    return $null
}

function Remove-OmegaLockedFile {
    try {
        $dlg = New-Object System.Windows.Forms.OpenFileDialog
        $dlg.Title = Get-OmegaString 'LockedFile_Title'
        $dlg.Filter = Get-OmegaString 'LockedFile_Filter'
        if ($dlg.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) { return }
        $filePath = $dlg.FileName
        if (-not (Confirm-OmegaAction -Title (Get-OmegaString 'LockedFile_ConfirmTitle') -Message (Get-OmegaString 'LockedFile_Confirm' $filePath))) { return }
        Write-OmegaLog (Get-OmegaString 'LockedFile_Attempting' $filePath)
        try {
            & takeown.exe /f "$filePath" /a 2>&1 | Out-Null
            & icacls.exe "$filePath" /grant "Administrators:F" /T /C 2>&1 | Out-Null
            Remove-Item -LiteralPath $filePath -Force -ErrorAction Stop
            Write-OmegaLog (Get-OmegaString 'LockedFile_Deleted' $filePath)
            [System.Windows.MessageBox]::Show((Get-OmegaString 'LockedFile_Success'), (Get-OmegaString 'LockedFile_SuccessTitle'), 'OK', 'Information') | Out-Null
        } catch {
            Write-OmegaLog (Get-OmegaString 'LockedFile_CouldNotDelete' $_.Exception.Message)
            [System.Windows.MessageBox]::Show((Get-OmegaString 'LockedFile_ErrorDlg' $_.Exception.Message), (Get-OmegaString 'LockedFile_ErrorTitle'), 'OK', 'Error') | Out-Null
        }
    } catch { Write-OmegaLog (Get-OmegaString 'LockedFile_HandlerError' $_.Exception.Message) }
    return $null
}

function Start-OmegaDriverCleanup {
    Save-ReversibleStateBeforeDeepClean
    Write-OmegaLog (Get-OmegaString 'Drivers_Start')
    try {
        try { Checkpoint-Computer -Description "Before driver cleanup" -RestorePointType "DEVICE_DRIVER_INSTALL" -ErrorAction SilentlyContinue } catch { }
        $proc = Start-Process -FilePath "pnputil.exe" -ArgumentList "/enum-drivers" -WindowStyle Hidden -PassThru -RedirectStandardOutput "$env:TEMP\OmegaDrivers.txt"
        $proc.WaitForExit(20000) | Out-Null
        Write-OmegaLog (Get-OmegaString 'Drivers_Saved' "$env:TEMP\OmegaDrivers.txt")
        Write-OmegaLog (Get-OmegaString 'Drivers_Hint')
        return Start-Process -FilePath "dism.exe" -ArgumentList "/Online /Cleanup-Image /StartComponentCleanup /ResetBase" -WindowStyle Hidden -PassThru
    } catch { Write-OmegaLog (Get-OmegaString 'Drivers_Error' $_.Exception.Message); return $null }
}

# ==============================================================================
# â˜… Easy Context Menu Detection & Integration
# ==============================================================================
function Test-OmegaEasyContextMenu {
    $ecm = [ordered]@{
        Installed = $false
        ExePath = $null
        ConfigPath = $null
        Version = $null
    }

    $possiblePaths = @(
        "${env:ProgramFiles}\Easy Context Menu",
        "${env:ProgramFiles(x86)}\Easy Context Menu",
        "${env:ProgramFiles}\Sordum\Easy Context Menu",
        "${env:ProgramFiles(x86)}\Sordum\Easy Context Menu",
        "C:\Program Files\Easy Context Menu",
        "C:\Program Files (x86)\Easy Context Menu"
    )
    foreach ($p in $possiblePaths) {
        if ($null -eq $p -or [string]::IsNullOrWhiteSpace($p)) { continue }
        if (Test-Path $p) {
            $exe = Get-ChildItem -Path $p -Filter "EcMenu*.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($exe) {
                $ecm.Installed = $true
                $ecm.ExePath = $exe.FullName
                try {
                    $ver = (Get-Item $exe.FullName).VersionInfo
                    $ecm.Version = "$($ver.FileVersion)".Trim()
                } catch { }
                break
            }
        }
    }

    if (-not $ecm.Installed) {
        $regPaths = @(
            'HKLM:\SOFTWARE\Sordum\EasyContextMenu',
            'HKLM:\SOFTWARE\WOW6432Node\Sordum\EasyContextMenu',
            'HKCU:\Software\Sordum\EasyContextMenu'
        )
        foreach ($rp in $regPaths) {
            if (Test-Path $rp) {
                $ecm.Installed = $true
                try { $ecm.ConfigPath = $rp } catch { }
                break
            }
        }
    }

    return [pscustomobject]$ecm
}

function Invoke-OmegaEcmIntegration {
    try {
        $ecm = Test-OmegaEasyContextMenu

        if ($ecm.Installed) {
            Write-OmegaLog (Get-OmegaString 'Ecm_Detected_Log' $ecm.ExePath)
            $msg = @"
Easy Context Menu (ECM) detected on your system.

Detected:
  â€¢ Version: $(if ($ecm.Version) { $ecm.Version } else { 'unknown' })
  â€¢ Path:    $($ecm.ExePath)

To add OmegaSolver to your right-click menu:

  1. Click "Yes" below to open Easy Context Menu.
  2. Click the "List Editor" button in the toolbar.
  3. Click "Add" â†’ fill:
       â€¢ Menu Text: Open OmegaSolver
       â€¢ Command:   [path to your OmegaSolver.exe]
       â€¢ Icon:      (optional) browse to icon.ico
  4. Click "Save", close the editor.
  5. Check the box next to your new entry.
  6. Click "Apply Changes" in the main window.

Do you want to open Easy Context Menu now?
"@
            $r = [System.Windows.MessageBox]::Show($msg, (Get-OmegaString 'Ecm_Detected_Title'), 'YesNo', 'Information')
            if ($r -eq [System.Windows.MessageBoxResult]::Yes -and $ecm.ExePath) {
                try {
                    Start-Process -FilePath $ecm.ExePath -Verb RunAs | Out-Null
                    Write-OmegaLog (Get-OmegaString 'Ecm_OpenLog')
                } catch {
                    Write-OmegaLog (Get-OmegaString 'Ecm_CouldNotOpen' $_.Exception.Message)
                }
            }
        } else {
            Write-OmegaLog (Get-OmegaString 'Ecm_NotDetected_Log')
            $msg = @"
Easy Context Menu (ECM) was NOT found on your system.

ECM is a free tool that lets you add OmegaSolver to the Windows right-click menu.

Would you like to open the official download page in your browser?

https://www.sordum.org/7615/easy-context-menu-v1-6/
"@
            $r = [System.Windows.MessageBox]::Show($msg, (Get-OmegaString 'Ecm_NotInstalled_Title'), 'YesNo', 'Question')
            if ($r -eq [System.Windows.MessageBoxResult]::Yes) {
                try {
                    Start-Process "https://www.sordum.org/7615/easy-context-menu-v1-6/" | Out-Null
                    Write-OmegaLog (Get-OmegaString 'Ecm_DownloadLog')
                } catch {
                    Write-OmegaLog (Get-OmegaString 'Ecm_BrowserError' $_.Exception.Message)
                }
            }
        }
    } catch {
        Write-OmegaLog (Get-OmegaString 'Ecm_IntegrationError' $_.Exception.Message)
    }
}

# ==============================================================================
# Compartir Archivos por Red (Robocopy + FTP)
# ==============================================================================
function Get-OmegaLocalIPs {
    $ips = @()
    try {
        $adapters = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
            Where-Object { $_.IPAddress -notmatch '^127\.' -and $_.IPAddress -notmatch '^169\.254\.' }
        foreach ($a in $adapters) {
            $ips += [pscustomobject]@{ IPAddress = $a.IPAddress; Interface = $a.InterfaceAlias; PrefixLen = $a.PrefixLength }
        }
    } catch {
        try {
            $wmi = Get-WmiObject Win32_NetworkAdapterConfiguration -Filter "IPEnabled=TRUE" -ErrorAction Stop
            foreach ($a in $wmi) {
                foreach ($ip in $a.IPAddress) {
                    if ($ip -notmatch ':' -and $ip -notmatch '^127\.' -and $ip -notmatch '^169\.254\.') {
                        $ips += [pscustomobject]@{ IPAddress = $ip; Interface = $a.Description; PrefixLen = 24 }
                    }
                }
            }
        } catch { }
    }
    return $ips
}

function Show-OmegaShareFilesWindow {
    $currentTheme = [string]$global:cmbTheme.SelectedItem
    if (-not $currentTheme) { $currentTheme = "Spotify Neon" }
    $palette = $null
    if ($currentTheme -eq 'OMEGASOLVER style') {
        $subColor = [string]$global:cmbOmegaColor.SelectedItem
        if ($subColor -and $script:OmegaSolverPalettes.Contains($subColor)) { $palette = $script:OmegaSolverPalettes[$subColor] }
    }
    if (-not $palette) { $palette = $script:OmegaThemes[$currentTheme] }

    $localIPs = @(Get-OmegaLocalIPs)
    $ipListStr = if ($localIPs.Count -gt 0) {
        ($localIPs | ForEach-Object { "  â€¢ $($_.IPAddress)  ($($_.Interface))" }) -join "`n"
    } else { Get-OmegaString 'Share_NoIPs' }
    $primaryIP = if ($localIPs.Count -gt 0) { $localIPs[0].IPAddress } else { "127.0.0.1" }

    $shareWindowTitle = Get-OmegaString 'Share_WindowTitle'
    $shareHeader = Get-OmegaString 'Share_Header'
    $shareSubHeader = Get-OmegaString 'Share_SubHeader'
    $shareYourIPs = Get-OmegaString 'Share_YourIPs'
    $shareCopyIP = Get-OmegaString 'Share_CopyIP'
    $shareMethod = Get-OmegaString 'Share_Method'
    $shareMethod_Robocopy = Get-OmegaString 'Share_Method_Robocopy'
    $shareMethod_FTP = Get-OmegaString 'Share_Method_FTP'
    $shareHintRobocopy = Get-OmegaString 'Share_Hint_Robocopy'
    $shareRemoteDetails = Get-OmegaString 'Share_RemoteDetails'
    $shareRemoteIP = Get-OmegaString 'Share_RemoteIP'
    $shareShareName = Get-OmegaString 'Share_ShareName'
    $shareFtpPort = Get-OmegaString 'Share_FtpPort'
    $shareFtpPath = Get-OmegaString 'Share_FtpPath'
    $shareFtpUser = Get-OmegaString 'Share_FtpUser'
    $shareFtpPass = Get-OmegaString 'Share_FtpPass'
    $shareLocalFolder = Get-OmegaString 'Share_LocalFolder'
    $shareBrowse = Get-OmegaString 'Share_Browse'
    $shareDirection = Get-OmegaString 'Share_Direction'
    $shareSend = Get-OmegaString 'Share_Send'
    $shareReceive = Get-OmegaString 'Share_Receive'
    $shareStatus = Get-OmegaString 'Share_Status'
    $shareStartTransfer = Get-OmegaString 'Share_StartTransfer'
    $shareCancel = Get-OmegaString 'Share_Cancel'
    $shareClose = Get-OmegaString 'Share_Close'

    $shareXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="$shareWindowTitle"
        Height="720" Width="780"
        WindowStartupLocation="CenterOwner" ResizeMode="NoResize"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent">
    <Border Background="{DynamicResource SFPanelBg}" BorderBrush="{DynamicResource SFAccent}"
            BorderThickness="2" CornerRadius="10">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="Auto"/>
            </Grid.RowDefinitions>
            <Border Grid.Row="0" Background="{DynamicResource SFPanelBg}"
                    BorderBrush="{DynamicResource SFAccent}" BorderThickness="0,0,0,2"
                    CornerRadius="8,8,0,0" Padding="16,10,12,10">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="Auto"/>
                    </Grid.ColumnDefinitions>
                    <StackPanel Grid.Column="0">
                        <TextBlock Text="$shareHeader" FontSize="17" FontWeight="Bold"
                                   Foreground="{DynamicResource SFAccent}"/>
                        <TextBlock Text="$shareSubHeader"
                                   FontSize="11" Foreground="{DynamicResource SFMuted}" Margin="0,2,0,0"/>
                    </StackPanel>
                    <Button x:Name="btnShareClose" Grid.Column="1" Content="âœ•"
                            Width="40" Height="30" FontSize="13" FontWeight="Bold"
                            Foreground="{DynamicResource SFMainText}" Background="Transparent"
                            BorderThickness="0" Cursor="Hand" ToolTip="$shareClose"/>
                </Grid>
            </Border>
            <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto" Margin="16">
                <StackPanel>
                    <Border Background="{DynamicResource SFCardBg}" CornerRadius="8" Padding="12"
                            BorderBrush="{DynamicResource SFBorder}" BorderThickness="1" Margin="0,0,0,12">
                        <StackPanel>
                            <TextBlock Text="$shareYourIPs"
                                       FontSize="12" FontWeight="Bold" Foreground="{DynamicResource SFAccent}" Margin="0,0,0,6"/>
                            <TextBox x:Name="txtMyIP" IsReadOnly="True"
                                     Background="{DynamicResource SFInputBg}"
                                     Foreground="{DynamicResource SFMainText}"
                                     BorderBrush="{DynamicResource SFBorder}"
                                     Padding="8" FontFamily="Consolas" FontSize="12"
                                     Text="$ipListStr" TextWrapping="Wrap" MinHeight="50"/>
                            <Button x:Name="btnCopyIP" Content="$shareCopyIP"
                                    HorizontalAlignment="Left" Margin="0,6,0,0" Padding="10,5"
                                    Background="{DynamicResource SFInputBg}"
                                    Foreground="{DynamicResource SFMainText}"
                                    BorderBrush="{DynamicResource SFBorder}" BorderThickness="1"
                                    Cursor="Hand" FontSize="12"/>
                        </StackPanel>
                    </Border>
                    <Border Background="{DynamicResource SFCardBg}" CornerRadius="8" Padding="12"
                            BorderBrush="{DynamicResource SFBorder}" BorderThickness="1" Margin="0,0,0,12">
                        <StackPanel>
                            <TextBlock Text="$shareMethod" FontSize="12" FontWeight="Bold"
                                       Foreground="{DynamicResource SFAccent}" Margin="0,0,0,6"/>
                            <ComboBox x:Name="cmbShareMethod" Height="34" FontSize="12">
                                <ComboBoxItem Content="$shareMethod_Robocopy" IsSelected="True"/>
                                <ComboBoxItem Content="$shareMethod_FTP"/>
                            </ComboBox>
                            <TextBlock x:Name="lblMethodHint"
                                       Text="$shareHintRobocopy"
                                       FontSize="10.5" Foreground="{DynamicResource SFMuted}"
                                       TextWrapping="Wrap" Margin="0,6,0,0"/>
                        </StackPanel>
                    </Border>
                    <Border Background="{DynamicResource SFCardBg}" CornerRadius="8" Padding="12"
                            BorderBrush="{DynamicResource SFBorder}" BorderThickness="1" Margin="0,0,0,12">
                        <StackPanel>
                            <TextBlock Text="$shareRemoteDetails" FontSize="12" FontWeight="Bold"
                                       Foreground="{DynamicResource SFAccent}" Margin="0,0,0,6"/>
                            <TextBlock Text="$shareRemoteIP" FontSize="11" Foreground="{DynamicResource SFMuted}" Margin="0,0,0,3"/>
                            <TextBox x:Name="txtRemoteIP"
                                     Background="{DynamicResource SFInputBg}"
                                     Foreground="{DynamicResource SFMainText}"
                                     BorderBrush="{DynamicResource SFBorder}"
                                     Padding="8" FontFamily="Consolas" FontSize="12" Text="192.168.1.100"/>
                            <StackPanel x:Name="panelSMB">
                                <TextBlock Text="$shareShareName" FontSize="11"
                                           Foreground="{DynamicResource SFMuted}" Margin="0,8,0,3"/>
                                <TextBox x:Name="txtShareName"
                                         Background="{DynamicResource SFInputBg}"
                                         Foreground="{DynamicResource SFMainText}"
                                         BorderBrush="{DynamicResource SFBorder}"
                                         Padding="8" FontFamily="Consolas" FontSize="12" Text="Users"/>
                            </StackPanel>
                            <StackPanel x:Name="panelFTP" Visibility="Collapsed">
                                <Grid Margin="0,8,0,0">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="10"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <StackPanel Grid.Column="0">
                                        <TextBlock Text="$shareFtpPort" FontSize="11"
                                                   Foreground="{DynamicResource SFMuted}" Margin="0,0,0,3"/>
                                        <TextBox x:Name="txtFtpPort"
                                                 Background="{DynamicResource SFInputBg}"
                                                 Foreground="{DynamicResource SFMainText}"
                                                 BorderBrush="{DynamicResource SFBorder}"
                                                 Padding="8" FontFamily="Consolas" FontSize="12" Text="2121"/>
                                    </StackPanel>
                                    <StackPanel Grid.Column="2">
                                        <TextBlock Text="$shareFtpPath" FontSize="11"
                                                   Foreground="{DynamicResource SFMuted}" Margin="0,0,0,3"/>
                                        <TextBox x:Name="txtFtpPath"
                                                 Background="{DynamicResource SFInputBg}"
                                                 Foreground="{DynamicResource SFMainText}"
                                                 BorderBrush="{DynamicResource SFBorder}"
                                                 Padding="8" FontFamily="Consolas" FontSize="12" Text="/"/>
                                    </StackPanel>
                                </Grid>
                                <TextBlock Text="$shareFtpUser" FontSize="11"
                                           Foreground="{DynamicResource SFMuted}" Margin="0,8,0,3"/>
                                <TextBox x:Name="txtFtpUser"
                                         Background="{DynamicResource SFInputBg}"
                                         Foreground="{DynamicResource SFMainText}"
                                         BorderBrush="{DynamicResource SFBorder}"
                                         Padding="8" FontFamily="Consolas" FontSize="12" Text="anonymous"/>
                                <TextBlock Text="$shareFtpPass" FontSize="11"
                                           Foreground="{DynamicResource SFMuted}" Margin="0,8,0,3"/>
                                <PasswordBox x:Name="txtFtpPass"
                                             Background="{DynamicResource SFInputBg}"
                                             Foreground="{DynamicResource SFMainText}"
                                             BorderBrush="{DynamicResource SFBorder}"
                                             Padding="8" FontSize="12"/>
                            </StackPanel>
                        </StackPanel>
                    </Border>
                    <Border Background="{DynamicResource SFCardBg}" CornerRadius="8" Padding="12"
                            BorderBrush="{DynamicResource SFBorder}" BorderThickness="1" Margin="0,0,0,12">
                        <StackPanel>
                            <TextBlock Text="$shareLocalFolder" FontSize="12" FontWeight="Bold"
                                       Foreground="{DynamicResource SFAccent}" Margin="0,0,0,6"/>
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="Auto"/>
                                </Grid.ColumnDefinitions>
                                <TextBox x:Name="txtLocalFolder" Grid.Column="0"
                                         Background="{DynamicResource SFInputBg}"
                                         Foreground="{DynamicResource SFMainText}"
                                         BorderBrush="{DynamicResource SFBorder}"
                                         Padding="8" FontFamily="Consolas" FontSize="12"
                                         Text="$env:USERPROFILE\Desktop"/>
                                <Button x:Name="btnBrowseFolder" Grid.Column="1" Content="$shareBrowse"
                                        Margin="6,0,0,0" Padding="10,8"
                                        Background="{DynamicResource SFInputBg}"
                                        Foreground="{DynamicResource SFMainText}"
                                        BorderBrush="{DynamicResource SFBorder}" BorderThickness="1"
                                        Cursor="Hand" FontSize="12"/>
                            </Grid>
                        </StackPanel>
                    </Border>
                    <Border Background="{DynamicResource SFCardBg}" CornerRadius="8" Padding="12"
                            BorderBrush="{DynamicResource SFBorder}" BorderThickness="1" Margin="0,0,0,12">
                        <StackPanel>
                            <TextBlock Text="$shareDirection" FontSize="12" FontWeight="Bold"
                                       Foreground="{DynamicResource SFAccent}" Margin="0,0,0,6"/>
                            <RadioButton x:Name="radSend" Content="$shareSend" IsChecked="True"
                                         Foreground="{DynamicResource SFMainText}" FontSize="12" Margin="0,4,0,4"/>
                            <RadioButton x:Name="radReceive" Content="$shareReceive"
                                         Foreground="{DynamicResource SFMainText}" FontSize="12" Margin="0,4,0,4"/>
                        </StackPanel>
                    </Border>
                    <Border Background="{DynamicResource SFCardBg}" CornerRadius="8" Padding="12"
                            BorderBrush="{DynamicResource SFBorder}" BorderThickness="1" Margin="0,0,0,12">
                        <StackPanel>
                            <TextBlock Text="$shareStatus" FontSize="12" FontWeight="Bold"
                                       Foreground="{DynamicResource SFAccent}" Margin="0,0,0,6"/>
                            <TextBox x:Name="txtShareLog" Height="120" IsReadOnly="True"
                                     Background="{DynamicResource SFInputBg}"
                                     Foreground="{DynamicResource SFAccent}"
                                     BorderBrush="{DynamicResource SFBorder}"
                                     FontFamily="Consolas" FontSize="11"
                                     TextWrapping="Wrap" VerticalScrollBarVisibility="Auto" Padding="8"/>
                        </StackPanel>
                    </Border>
                </StackPanel>
            </ScrollViewer>
            <Border Grid.Row="2" Background="{DynamicResource SFPanelBg}"
                    BorderBrush="{DynamicResource SFBorder}" BorderThickness="0,2,0,0"
                    CornerRadius="0,0,8,8" Padding="12">
                <Grid>
                    <Button x:Name="btnShareStart" Content="$shareStartTransfer"
                            HorizontalAlignment="Right" MinWidth="200" Height="42"
                            FontSize="14" FontWeight="Bold" Foreground="#FFFFFF"
                            Background="{DynamicResource SFAccent}"
                            BorderThickness="0" Cursor="Hand"/>
                    <Button x:Name="btnShareCancel" Content="$shareCancel"
                            HorizontalAlignment="Left" MinWidth="120" Height="42" FontSize="13"
                            Foreground="{DynamicResource SFMainText}" Background="Transparent"
                            BorderBrush="{DynamicResource SFBorder}" BorderThickness="1" Cursor="Hand"/>
                </Grid>
            </Border>
        </Grid>
    </Border>
</Window>
"@

    try { $sw = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader ([xml]$shareXaml))) }
    catch {
        Write-OmegaLog (Get-OmegaString 'Share_LoadError' $_.Exception.Message)
        [System.Windows.MessageBox]::Show((Get-OmegaString 'Share_LoadErrorDlg' $_.Exception.Message), (Get-OmegaString 'Error_Title'), 'OK', 'Error') | Out-Null
        return
    }

    Set-OmegaResourceSafe -Win $sw -Key "SFPanelBg"  -Value $palette.PanelBg
    Set-OmegaResourceSafe -Win $sw -Key "SFCardBg"   -Value $palette.CardBg
    Set-OmegaResourceSafe -Win $sw -Key "SFInputBg"  -Value $palette.InputBg
    Set-OmegaResourceSafe -Win $sw -Key "SFAccent"   -Value $palette.Accent
    Set-OmegaResourceSafe -Win $sw -Key "SFMainText" -Value $palette.MainText
    Set-OmegaResourceSafe -Win $sw -Key "SFMuted"    -Value $palette.MutedText
    Set-OmegaResourceSafe -Win $sw -Key "SFBorder"   -Value $palette.Border

    $sfBtnCopyIP  = $sw.FindName("btnCopyIP")
    $sfMethod     = $sw.FindName("cmbShareMethod")
    $sfMethodHint = $sw.FindName("lblMethodHint")
    $sfRemoteIP   = $sw.FindName("txtRemoteIP")
    $sfShareName  = $sw.FindName("txtShareName")
    $sfFtpPort    = $sw.FindName("txtFtpPort")
    $sfFtpPath    = $sw.FindName("txtFtpPath")
    $sfFtpUser    = $sw.FindName("txtFtpUser")
    $sfFtpPass    = $sw.FindName("txtFtpPass")
    $sfPanelSMB   = $sw.FindName("panelSMB")
    $sfPanelFTP   = $sw.FindName("panelFTP")
    $sfLocalDir   = $sw.FindName("txtLocalFolder")
    $sfBrowse     = $sw.FindName("btnBrowseFolder")
    $sfRadSend    = $sw.FindName("radSend")
    $sfLog        = $sw.FindName("txtShareLog")
    $sfBtnStart   = $sw.FindName("btnShareStart")
    $sfBtnCancel  = $sw.FindName("btnShareCancel")
    $sfBtnClose   = $sw.FindName("btnShareClose")

    function Write-SFLog {
        param([string]$msg)
        try {
            $ts = Get-Date -Format "HH:mm:ss"
            $sfLog.Dispatcher.Invoke([Action]{
                $sfLog.AppendText("[$ts] $msg`n")
                $sfLog.ScrollToEnd()
            })
        } catch { }
    }

    $sfMethod.Add_SelectionChanged({
        try {
            if ($sfMethod.SelectedIndex -eq 0) {
                $sfPanelSMB.Visibility = 'Visible'; $sfPanelFTP.Visibility = 'Collapsed'
                $sfMethodHint.Text = Get-OmegaString 'Share_Hint_Robocopy'
            } else {
                $sfPanelSMB.Visibility = 'Collapsed'; $sfPanelFTP.Visibility = 'Visible'
                $sfMethodHint.Text = Get-OmegaString 'Share_Hint_FTP'
            }
        } catch { }
    })

    $sfBtnCopyIP.Add_Click({
        try { if ($localIPs.Count -gt 0) { [System.Windows.Clipboard]::SetText($localIPs[0].IPAddress); Write-SFLog "ðŸ“‹ IP: $($localIPs[0].IPAddress)" } } catch { }
    })

    $sfBrowse.Add_Click({
        try {
            $dlg = New-Object System.Windows.Forms.FolderBrowserDialog
            $dlg.Description = Get-OmegaString 'Share_SelectFolder'
            if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) { $sfLocalDir.Text = $dlg.SelectedPath }
        } catch { }
    })

    $sfBtnClose.Add_Click({ $sw.Close() })
    $sfBtnCancel.Add_Click({ $sw.Close() })

    $sfBtnStart.Add_Click({
        try {
            $method   = $sfMethod.SelectedIndex
            $remoteIP = $sfRemoteIP.Text.Trim()
            $localDir = $sfLocalDir.Text.Trim()
            $send     = $sfRadSend.IsChecked -eq $true
            if ([string]::IsNullOrWhiteSpace($remoteIP)) { Write-SFLog (Get-OmegaString 'Share_MissingRemoteIP'); return }
            if ([string]::IsNullOrWhiteSpace($localDir) -or -not (Test-Path -LiteralPath $localDir)) { Write-SFLog (Get-OmegaString 'Share_LocalFolderMissing' $localDir); return }
            $sfBtnStart.IsEnabled = $false
            if ($method -eq 0) {
                $shareName = $sfShareName.Text.Trim().TrimEnd('\')
                if ([string]::IsNullOrWhiteSpace($shareName)) { $shareName = 'Users' }
                $unc = "\\$remoteIP\$shareName"
                Write-SFLog (Get-OmegaString 'Share_RobocopyMode')
                Write-SFLog (Get-OmegaString 'Share_UncPath' $unc)
                Write-SFLog (Get-OmegaString 'Share_LocalPath' $localDir)
                if (-not (Test-Path -LiteralPath $unc)) {
                    Write-SFLog (Get-OmegaString 'Share_CannotAccess' $unc)
                    Write-SFLog (Get-OmegaString 'Share_CheckShare')
                    Write-SFLog (Get-OmegaString 'Share_CheckFirewall')
                    $sfBtnStart.IsEnabled = $true
                    return
                }
                $args = if ($send) { @($localDir, $unc, '/E', '/Z', '/R:1', '/W:1', '/NP', '/TEE', '/NJH', '/NJS') }
                        else { @($unc, $localDir, '/E', '/Z', '/R:1', '/W:1', '/NP', '/TEE', '/NJH', '/NJS') }
                Write-SFLog $(if ($send) { Get-OmegaString 'Share_Sending' } else { Get-OmegaString 'Share_Receiving' })
                $proc = Start-Process -FilePath "robocopy.exe" -ArgumentList $args -WindowStyle Hidden -PassThru -RedirectStandardOutput "$env:TEMP\OmegaRobo.txt"
                $proc.WaitForExit(600000) | Out-Null
                Get-Content "$env:TEMP\OmegaRobo.txt" -ErrorAction SilentlyContinue | ForEach-Object { Write-SFLog $_ }
                if ($proc.ExitCode -lt 8) { Write-SFLog ""; Write-SFLog (Get-OmegaString 'Share_TransferComplete' $proc.ExitCode); Write-OmegaLog (Get-OmegaString 'Share_RobocopyDone') }
                else { Write-SFLog ""; Write-SFLog (Get-OmegaString 'Share_TransferErrors' $proc.ExitCode) }
            } else {
                $port = $sfFtpPort.Text.Trim(); $path = $sfFtpPath.Text.Trim()
                if (-not $path.StartsWith('/')) { $path = "/$path" }
                if (-not $port) { $port = "21" }
                $user = $sfFtpUser.Text.Trim(); $pass = $sfFtpPass.Password
                if (-not $user) { $user = "anonymous" }
                $baseUrl = "ftp://${remoteIP}:${port}${path}"
                Write-SFLog (Get-OmegaString 'Share_FtpMode' $baseUrl)
                $wc = New-Object System.Net.WebClient
                $wc.Credentials = New-Object System.Net.NetworkCredential($user, $pass)
                if ($send) {
                    $files = @(Get-ChildItem -LiteralPath $localDir -File -Recurse -ErrorAction SilentlyContinue)
                    Write-SFLog (Get-OmegaString 'Share_Uploading' $files.Count)
                    $ok = 0; $fail = 0
                    foreach ($f in $files) {
                        try {
                            $rel = $f.FullName.Substring($localDir.Length).TrimStart('\').Replace('\','/')
                            $wc.UploadFile("$baseUrl/$rel", $f.FullName) | Out-Null
                            $ok++
                        } catch { $fail++ }
                    }
                    Write-SFLog ""; Write-SFLog (Get-OmegaString 'Share_UploadDone' @($ok, $fail))
                } else { Write-SFLog (Get-OmegaString 'Share_FtpDownload_NotSupported') }
            }
        } catch { Write-SFLog (Get-OmegaString 'Share_Error' $_.Exception.Message) }
        finally { try { $sfBtnStart.IsEnabled = $true } catch { } }
    })

    $sw.Owner = $window
    [void]$sw.ShowDialog()
}

# ==============================================================================
# MANUAL 3-COLUMN (ES / EN / PT) â€” BASIC + TECHNICAL
# ==============================================================================
function Show-OmegaManual {
    $currentTheme = [string]$global:cmbTheme.SelectedItem
    if (-not $currentTheme) { $currentTheme = "Spotify Neon" }
    $palette = $null
    if ($currentTheme -eq 'OMEGASOLVER style') {
        $subColor = [string]$global:cmbOmegaColor.SelectedItem
        if ($subColor -and $script:OmegaSolverPalettes.Contains($subColor)) { $palette = $script:OmegaSolverPalettes[$subColor] }
    }
    if (-not $palette) { $palette = $script:OmegaThemes[$currentTheme] }
    $isAdvanced = [bool]$global:chkAdvanced.IsChecked

    if ($isAdvanced) {
        $esItems = @(
            'H|ðŸ› ï¸  SISTEMA Y RENDIMIENTO',
            'I|SFC /Scannow|BAS: Escanea y repara archivos daÃ±ados del sistema.',
            'I|SFC /Scannow|TEC: Verifica cada archivo protegido contra la copia oficial en WinSxS. Modo online/offline segÃºn disco.',
            'I|DISM /RestoreHealth|BAS: Repara la imagen interna de Windows.',
            'I|DISM /RestoreHealth|TEC: Repara el Component Store (WinSxS) usando Windows Update como fuente de archivos sanos.',
            'I|CHKDSK /f|BAS: Revisa el disco duro por errores.',
            'I|CHKDSK /f|TEC: Verifica integridad NTFS (MFT, Ã­ndice, sectores) y repara errores lÃ³gicos con /f. /r analiza sectores.',
            'I|Desfragmentar|BAS: Ordena archivos para ir mÃ¡s rÃ¡pido. Solo HDD.',
            'I|Desfragmentar|TEC: Reordena clusters y compacta MFT. Bloqueado en SSD (TRIM hace el trabajo, fragmentar acorta vida Ãºtil).',
            'I|Alto Rendimiento|BAS: Cambia el plan de energÃ­a a mÃ¡ximo rendimiento.',
            'I|Alto Rendimiento|TEC: powercfg /setactive al GUID 8c5e7fda-... Aumenta consumo; no recomendado en laptop con baterÃ­a.',
            'H|ðŸŒ  RED Y CONEXIÃ“N',
            'I|CachÃ© DNS|BAS: Borra registros viejos de sitios web.',
            'I|CachÃ© DNS|TEC: ipconfig /flushdns â€” limpia el resolver cache. Ãštil tras cambios DNS o pÃ¡ginas que no cargan.',
            'I|Winsock / IP|BAS: Reinicia la conexiÃ³n de red completa.',
            'I|Winsock / IP|TEC: netsh winsock reset reinicia la pila TCP/IP. Requiere reinicio del equipo.',
            'I|QoS|BAS: Libera ancho de banda reservado por Windows.',
            'I|QoS|TEC: NonBestEffortLimit=0 en HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched. Valor por defecto: 20%.',
            'I|Compartir Archivos|BAS: EnvÃ­a archivos a otra PC o celular por la red local.',
            'I|Compartir Archivos|TEC: Robocopy (SMB) con /E /Z /R:1 /W:1 para Windowsâ†”Windows. FTP anÃ³nimo para mÃ³viles.',
            'H|ðŸ§¹  MANTENIMIENTO',
            'I|Temporales|BAS: Borra archivos temporales de Windows y programas.',
            'I|Temporales|TEC: EnumeraciÃ³n recursiva de %TEMP% y %SystemRoot%\Temp. Los archivos en uso se omiten.',
            'I|Limpieza Profunda|BAS: Borra cachÃ©s grandes de Windows Update y navegadores.',
            'I|Limpieza Profunda|TEC: Purga SoftwareDistribution\Download, DeliveryOptimization, FontCache, cachÃ©s de Edge y Chrome.',
            'I|Limpieza 1-Clic|BAS: Limpieza rÃ¡pida con un clic.',
            'I|Limpieza 1-Clic|TEC: Temp + Prefetch + flushdns + cachÃ©s navegadores + papelera. NO requiere detener servicios.',
            'I|Logs y WinSxS|BAS: Borra registros antiguos del sistema.',
            'I|Logs y WinSxS|TEC: VacÃ­a EventLogs vÃ­a EventLogSession + DISM /StartComponentCleanup /ResetBase.',
            'I|ReparaciÃ³n 1-Clic|BAS: Hace todo el mantenimiento de una vez.',
            'I|ReparaciÃ³n 1-Clic|TEC: Cadena automatizada: limpieza bÃ¡sica â†’ flushdns â†’ SFC â†’ DISM. Puede tardar 20-60 min.',
            'H|ðŸ›¡ï¸  HERRAMIENTAS DEL SISTEMA',
            'I|Punto de RestauraciÃ³n|BAS: Crea un punto de rescate por si algo falla.',
            'I|Punto de RestauraciÃ³n|TEC: Checkpoint-Computer vÃ­a VSS. Requiere protecciÃ³n del sistema activa en C:.',
            'I|Programas de Inicio|BAS: Muestra quÃ© se abre al encender Windows.',
            'I|Programas de Inicio|TEC: WMI Win32_StartupCommand. Lista de HKCU/HKLM + carpeta Startup.',
            'I|Analizar Actualizaciones|BAS: Muestra las Ãºltimas actualizaciones instaladas.',
            'I|Analizar Actualizaciones|TEC: WMI Win32_QuickFixEngineering ordenado por InstalledOn.',
            'I|Archivos Bloqueados|BAS: Fuerza borrar archivos que Windows no deja eliminar.',
            'I|Archivos Bloqueados|TEC: takeown + icacls /grant + Remove-Item -Force. IRREVERSIBLE. Puede romper apps si se elimina algo crÃ­tico.',
            'I|Drivers Obsoletos|BAS: Limpia controladores viejos que ya no usas.',
            'I|Drivers Obsoletos|TEC: pnputil /enum-drivers â†’ DISM /StartComponentCleanup. Crea punto de restauraciÃ³n antes.',
            'H|ðŸŽ¨  TEMAS Y MODOS',
            'I|Layout adaptativo|BAS: Elige entre vista simple (2 columnas) o detallada (3 columnas).',
            'I|Layout adaptativo|TEC: gridBasic (2 col balanceadas) o gridAdvanced (3 col por categorÃ­a).',
            'I|OMEGASOLVER style|BAS: Tema alienÃ­gena con colores neÃ³n.',
            'I|OMEGASOLVER style|TEC: 6 sub-paletas con LinearGradientBrush dinÃ¡mico. Aplica fuente Rajdhani y DropShadowEffect.',
            'I|Modo Low|BAS: Para PCs lentas â€” reduce efectos y consumo.',
            'I|Modo Low|TEC: Desactiva DropShadowEffect (costoso en WPF). Reduce BorderThickness. Se persiste.',
            'H|ðŸ”„  ACTUALIZACIONES',
            'I|VerificaciÃ³n automÃ¡tica|BAS: La app te avisa si hay nueva versiÃ³n.',
            'I|VerificaciÃ³n automÃ¡tica|TEC: Consulta GitHub API /releases/latest cada inicio. Compara versiones semÃ¡nticas.',
            'I|VerificaciÃ³n manual|BAS: Icono ðŸ”„ en la barra superior.',
            'I|VerificaciÃ³n manual|TEC: Muestra diÃ¡logo con estado (update/latest/offline/error) y abre URL si aceptas.',
            'H|ðŸ”’  SEGURIDAD',
            'I|ProtecciÃ³n SSD|BAS: Bloquea desfragmentar en SSD por seguridad.',
            'I|ProtecciÃ³n SSD|TEC: Detecta MediaType vÃ­a Get-PhysicalDisk. Bloqueado si SSD. Motivo: TRIM ya optimiza.',
            'I|Persistencia|BAS: Los cambios reversibles se guardan solos.',
            'I|Persistencia|TEC: JSON en %ProgramData%\OmegaSolver\reversible-state.json.'
        )
        $enItems = @(
            'H|ðŸ› ï¸  SYSTEM &amp; PERFORMANCE',
            'I|SFC /Scannow|BAS: Scans and repairs damaged system files.',
            'I|SFC /Scannow|TEC: Verifies each protected file against official WinSxS copy. Online/offline mode per drive.',
            'I|DISM /RestoreHealth|BAS: Repairs the internal Windows image.',
            'I|DISM /RestoreHealth|TEC: Repairs Component Store (WinSxS) using Windows Update as healthy source.',
            'I|CHKDSK /f|BAS: Checks the disk for errors.',
            'I|CHKDSK /f|TEC: NTFS integrity check (MFT, index, sectors) + /f repairs logical errors. /r scans sectors.',
            'I|Defragment|BAS: Orders files for speed. HDD only.',
            'I|Defragment|TEC: Reorders clusters and compacts MFT. Blocked on SSD (TRIM handles it, fragmenting shortens lifespan).',
            'I|High Performance|BAS: Switches to max performance power plan.',
            'I|High Performance|TEC: powercfg /setactive to GUID 8c5e7fda-... Higher consumption; not for battery.',
            'H|ðŸŒ  NETWORK &amp; CONNECTION',
            'I|DNS Cache|BAS: Clears old website records.',
            'I|DNS Cache|TEC: ipconfig /flushdns â€” clears resolver cache. Useful after DNS changes or page load issues.',
            'I|Winsock / IP|BAS: Resets the entire network connection.',
            'I|Winsock / IP|TEC: netsh winsock reset restarts TCP/IP stack. Requires reboot.',
            'I|QoS|BAS: Frees bandwidth reserved by Windows.',
            'I|QoS|TEC: NonBestEffortLimit=0 in HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched. Default: 20%.',
            'I|Share Files|BAS: Send files to another PC or mobile over LAN.',
            'I|Share Files|TEC: Robocopy (SMB) with /E /Z /R:1 /W:1 for Windowsâ†”Windows. Anonymous FTP for mobiles.',
            'H|ðŸ§¹  MAINTENANCE',
            'I|Temp Files|BAS: Removes Windows and programs temp files.',
            'I|Temp Files|TEC: Recursive enumeration of %TEMP% and %SystemRoot%\Temp. In-use files skipped.',
            'I|Deep Clean|BAS: Removes large Windows Update and browser caches.',
            'I|Deep Clean|TEC: Purges SoftwareDistribution\Download, DeliveryOptimization, FontCache, Edge/Chrome caches.',
            'I|1-Click Cleanup|BAS: Quick one-click cleanup.',
            'I|1-Click Cleanup|TEC: Temp + Prefetch + flushdns + browser caches + recycle bin. No service stopping needed.',
            'I|Logs &amp; WinSxS|BAS: Removes old system logs.',
            'I|Logs &amp; WinSxS|TEC: Clears EventLogs via EventLogSession + DISM /StartComponentCleanup /ResetBase.',
            'I|1-Click Repair|BAS: Does all maintenance at once.',
            'I|1-Click Repair|TEC: Chain: basic cleanup â†’ flushdns â†’ SFC â†’ DISM. Can take 20-60 min.',
            'H|ðŸ›¡ï¸  SYSTEM TOOLS',
            'I|Restore Point|BAS: Creates a rescue point in case something fails.',
            'I|Restore Point|TEC: Checkpoint-Computer via VSS. Requires system protection enabled on C:.',
            'I|Startup Programs|BAS: Shows what opens when Windows starts.',
            'I|Startup Programs|TEC: WMI Win32_StartupCommand. Lists HKCU/HKLM + Startup folder.',
            'I|Analyze Updates|BAS: Shows recently installed updates.',
            'I|Analyze Updates|TEC: WMI Win32_QuickFixEngineering sorted by InstalledOn.',
            'I|Locked Files|BAS: Force-deletes files Windows won''t let you delete.',
            'I|Locked Files|TEC: takeown + icacls /grant + Remove-Item -Force. IRREVERSIBLE. Can break apps.',
            'I|Obsolete Drivers|BAS: Cleans old unused drivers.',
            'I|Obsolete Drivers|TEC: pnputil /enum-drivers â†’ DISM /StartComponentCleanup. Creates restore point first.',
            'H|ðŸŽ¨  THEMES &amp; MODES',
            'I|Adaptive Layout|BAS: Choose simple view (2 columns) or detailed (3 columns).',
            'I|Adaptive Layout|TEC: gridBasic (2 col balanced) or gridAdvanced (3 col by category).',
            'I|OMEGASOLVER style|BAS: Alien theme with neon colors.',
            'I|OMEGASOLVER style|TEC: 6 sub-palettes with dynamic LinearGradientBrush. Applies Rajdhani font + DropShadowEffect.',
            'I|Low Mode|BAS: For slow PCs â€” reduces effects and consumption.',
            'I|Low Mode|TEC: Disables DropShadowEffect (expensive in WPF). Reduces BorderThickness. Persisted.',
            'H|ðŸ”„  UPDATES',
            'I|Auto check|BAS: App tells you if a new version exists.',
            'I|Auto check|TEC: Queries GitHub API /releases/latest at startup. Compares semantic versions.',
            'I|Manual check|BAS: ðŸ”„ icon in top bar.',
            'I|Manual check|TEC: Shows dialog with status (update/latest/offline/error) and opens URL if accepted.',
            'H|ðŸ”’  SAFETY',
            'I|SSD Protection|BAS: Blocks defragmenting on SSD for safety.',
            'I|SSD Protection|TEC: Detects MediaType via Get-PhysicalDisk. Blocked if SSD. Reason: TRIM already optimizes.',
            'I|Persistence|BAS: Reversible changes are saved automatically.',
            'I|Persistence|TEC: JSON in %ProgramData%\OmegaSolver\reversible-state.json.'
        )
        $ptItems = @(
            'H|ðŸ› ï¸  SISTEMA E DESEMPENHO',
            'I|SFC /Scannow|BAS: Escaneia e repara arquivos de sistema danificados.',
            'I|SFC /Scannow|TEC: Verifica cada arquivo protegido contra a cÃ³pia oficial no WinSxS. Modo online/offline por disco.',
            'I|DISM /RestoreHealth|BAS: Repara a imagem interna do Windows.',
            'I|DISM /RestoreHealth|TEC: Repara o Component Store (WinSxS) usando Windows Update como fonte sadia.',
            'I|CHKDSK /f|BAS: Verifica o disco por erros.',
            'I|CHKDSK /f|TEC: VerificaÃ§Ã£o de integridade NTFS (MFT, Ã­ndice, setores) + /f repara erros lÃ³gicos.',
            'I|Desfragmentar|BAS: Organiza arquivos para mais velocidade. Somente HDD.',
            'I|Desfragmentar|TEC: Reordena clusters e compacta MFT. Bloqueado em SSD (TRIM jÃ¡ faz, fragmentar reduz vida Ãºtil).',
            'I|Alto Desempenho|BAS: Muda o plano de energia para mÃ¡ximo desempenho.',
            'I|Alto Desempenho|TEC: powercfg /setactive para GUID 8c5e7fda-... Maior consumo; nÃ£o recomendado com bateria.',
            'H|ðŸŒ  REDE E CONEXÃƒO',
            'I|Cache DNS|BAS: Apaga registros antigos de sites.',
            'I|Cache DNS|TEC: ipconfig /flushdns â€” limpa o cache resolvedor. Ãštil apÃ³s mudanÃ§as DNS.',
            'I|Winsock / IP|BAS: Reinicia toda a conexÃ£o de rede.',
            'I|Winsock / IP|TEC: netsh winsock reset reinicia a pilha TCP/IP. Requer reinicializaÃ§Ã£o.',
            'I|QoS|BAS: Libera largura de banda reservada pelo Windows.',
            'I|QoS|TEC: NonBestEffortLimit=0 em HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched. PadrÃ£o: 20%.',
            'I|Compartilhar Arquivos|BAS: Envia arquivos para outro PC ou celular via rede local.',
            'I|Compartilhar Arquivos|TEC: Robocopy (SMB) com /E /Z /R:1 /W:1 para Windowsâ†”Windows. FTP anÃ´nimo para celulares.',
            'H|ðŸ§¹  MANUTENÃ‡ÃƒO',
            'I|TemporÃ¡rios|BAS: Remove arquivos temporÃ¡rios do Windows e programas.',
            'I|TemporÃ¡rios|TEC: EnumeraÃ§Ã£o recursiva de %TEMP% e %SystemRoot%\Temp. Arquivos em uso sÃ£o ignorados.',
            'I|Limpeza Profunda|BAS: Remove grandes caches do Windows Update e navegadores.',
            'I|Limpeza Profunda|TEC: Purga SoftwareDistribution\Download, DeliveryOptimization, FontCache, caches Edge/Chrome.',
            'I|Limpeza 1-Clique|BAS: Limpeza rÃ¡pida com um clique.',
            'I|Limpeza 1-Clique|TEC: Temp + Prefetch + flushdns + caches de navegadores + lixeira. NÃ£o para serviÃ§os.',
            'I|Logs e WinSxS|BAS: Remove logs antigos do sistema.',
            'I|Logs e WinSxS|TEC: Limpa EventLogs via EventLogSession + DISM /StartComponentCleanup /ResetBase.',
            'I|Reparo 1-Clique|BAS: Faz toda a manutenÃ§Ã£o de uma vez.',
            'I|Reparo 1-Clique|TEC: Cadeia: limpeza bÃ¡sica â†’ flushdns â†’ SFC â†’ DISM. Pode levar 20-60 min.',
            'H|ðŸ›¡ï¸  FERRAMENTAS DO SISTEMA',
            'I|Ponto de RestauraÃ§Ã£o|BAS: Cria um ponto de resgate caso algo falhe.',
            'I|Ponto de RestauraÃ§Ã£o|TEC: Checkpoint-Computer via VSS. Requer proteÃ§Ã£o do sistema ativa em C:.',
            'I|Programas de InicializaÃ§Ã£o|BAS: Mostra o que abre ao ligar o Windows.',
            'I|Programas de InicializaÃ§Ã£o|TEC: WMI Win32_StartupCommand. Lista HKCU/HKLM + pasta Startup.',
            'I|Analisar AtualizaÃ§Ãµes|BAS: Mostra as atualizaÃ§Ãµes instaladas recentemente.',
            'I|Analisar AtualizaÃ§Ãµes|TEC: WMI Win32_QuickFixEngineering ordenado por InstalledOn.',
            'I|Arquivos Bloqueados|BAS: ForÃ§a apagar arquivos que o Windows nÃ£o deixa excluir.',
            'I|Arquivos Bloqueados|TEC: takeown + icacls /grant + Remove-Item -Force. IRREVERSÃVEL. Pode quebrar apps.',
            'I|Drivers Obsoletos|BAS: Limpa drivers antigos nÃ£o usados.',
            'I|Drivers Obsoletos|TEC: pnputil /enum-drivers â†’ DISM /StartComponentCleanup. Cria ponto de restauraÃ§Ã£o antes.',
            'H|ðŸŽ¨  TEMAS E MODOS',
            'I|Layout Adaptativo|BAS: Escolha visÃ£o simples (2 colunas) ou detalhada (3 colunas).',
            'I|Layout Adaptativo|TEC: gridBasic (2 col balanceadas) ou gridAdvanced (3 col por categoria).',
            'I|OMEGASOLVER style|BAS: Tema alienÃ­gena com cores neon.',
            'I|OMEGASOLVER style|TEC: 6 sub-paletas com LinearGradientBrush dinÃ¢mico. Aplica fonte Rajdhani + DropShadowEffect.',
            'I|Modo Low|BAS: Para PCs lentos â€” reduz efeitos e consumo.',
            'I|Modo Low|TEC: Desativa DropShadowEffect (caro em WPF). Reduz BorderThickness. Persistido.',
            'H|ðŸ”„  ATUALIZAÃ‡Ã•ES',
            'I|VerificaÃ§Ã£o automÃ¡tica|BAS: O app avisa se hÃ¡ nova versÃ£o.',
            'I|VerificaÃ§Ã£o automÃ¡tica|TEC: Consulta GitHub API /releases/latest na inicializaÃ§Ã£o. Compara versÃµes semÃ¢nticas.',
            'I|VerificaÃ§Ã£o manual|BAS: Ãcone ðŸ”„ na barra superior.',
            'I|VerificaÃ§Ã£o manual|TEC: Mostra diÃ¡logo com status (update/latest/offline/error) e abre URL se aceito.',
            'H|ðŸ”’  SEGURANÃ‡A',
            'I|ProteÃ§Ã£o SSD|BAS: Bloqueia desfragmentaÃ§Ã£o em SSD por seguranÃ§a.',
            'I|ProteÃ§Ã£o SSD|TEC: Detecta MediaType via Get-PhysicalDisk. Bloqueado se SSD. Motivo: TRIM jÃ¡ otimiza.',
            'I|PersistÃªncia|BAS: MudanÃ§as reversÃ­veis sÃ£o salvas automaticamente.',
            'I|PersistÃªncia|TEC: JSON em %ProgramData%\OmegaSolver\reversible-state.json.'
        )
    } else {
        $esItems = @(
            'H|ðŸ› ï¸  REPARAR MI PC',
            'I|Reparar Windows|Escanea y repara archivos daÃ±ados del sistema. Puede tardar 10-30 min.',
            'I|Recuperar sistema|Repara la imagen interna de Windows. Ãštil si hay errores que SFC no arregla.',
            'I|Comprobar disco|Revisa que tu disco duro no tenga errores. Puede pedir reinicio.',
            'I|Ordenar disco|Ordena archivos para ir mÃ¡s rÃ¡pido. SOLO discos duros (no SSD).',
            'I|Modo rendimiento|Ajusta tu PC para mÃ¡xima velocidad. Consume mÃ¡s baterÃ­a.',
            'I|Reparar todo|Hace TODO automÃ¡ticamente: limpieza â†’ internet â†’ SFC â†’ DISM.',
            'H|ðŸ§¹  LIMPIEZA',
            'I|Borrar temporales|Elimina archivos basura que se acumulan con el tiempo.',
            'I|Limpieza completa|Barre cachÃ©s de Windows, actualizaciones y navegadores.',
            'I|Borrar historial|Elimina registros viejos del sistema.',
            'I|Limpieza 1-Clic|Limpieza rÃ¡pida: temporales + DNS + cachÃ©s + papelera.',
            'H|ðŸŒ  ARREGLAR INTERNET',
            'I|Arreglar internet|Borra la memoria de sitios web para que carguen bien.',
            'I|Reiniciar la red|Restaura la conexiÃ³n de red completa. Puede requerir reinicio.',
            'I|Acelerar red|Libera ancho de banda que Windows se reserva.',
            'H|ðŸ›¡ï¸  SEGURIDAD Y CONTROL',
            'I|Punto de RestauraciÃ³n|Crea un punto de rescate por si algo falla despuÃ©s.',
            'I|Programas de Inicio|Muestra quÃ© se abre al encender Windows. Ãštil para desactivar cosas.',
            'H|ðŸŽ¨  TEMAS Y MODOS',
            'I|Temas visuales|Elige entre 18 estilos de color. Incluye OMEGASOLVER alienÃ­gena.',
            'I|Modo avanzado|Vista detallada de 3 columnas con info tÃ©cnica.',
            'I|Modo Low|Para PCs lentas â€” reduce efectos visuales pesados.',
            'I|Compartir Archivos|(Solo Avanzado) Conecta con otra PC o mÃ³vil por la red.',
            'H|ðŸ”„  ACTUALIZACIONES',
            'I|VerificaciÃ³n auto|Al iniciar, la app comprueba si hay nueva versiÃ³n en GitHub.',
            'I|VerificaciÃ³n manual|Icono ðŸ”„ arriba para comprobar manualmente.',
            'H|ðŸ”’  SEGURIDAD',
            'I|ProtecciÃ³n SSD|La app NUNCA desfragmenta un SSD (los daÃ±a).',
            'I|Todo reversible|Los cambios (energÃ­a, QoS, servicios) se pueden deshacer.',
            'I|Idiomas|EspaÃ±ol, English, PortuguÃªs. Cambia desde la barra superior.'
        )
        $enItems = @(
            'H|ðŸ› ï¸  REPAIR MY PC',
            'I|Repair Windows|Scans and repairs damaged system files. May take 10-30 min.',
            'I|Recover System|Repairs the internal Windows image. Useful if SFC doesn''t fix errors.',
            'I|Check Disk|Verifies your hard drive has no errors. May require a reboot.',
            'I|Order Disk|Orders files for speed. HDD ONLY (not SSD).',
            'I|Performance Mode|Tunes your PC for max speed. Uses more battery.',
            'I|Repair All|Does EVERYTHING automatically: cleanup â†’ internet â†’ SFC â†’ DISM.',
            'H|ðŸ§¹  CLEANUP',
            'I|Delete Temp Files|Removes junk files that accumulate over time.',
            'I|Full Cleanup|Sweeps Windows, updates and browser caches.',
            'I|Clear History|Removes old system logs.',
            'I|1-Click Cleanup|Quick cleanup: temp + DNS + caches + recycle bin.',
            'H|ðŸŒ  FIX INTERNET',
            'I|Fix Internet|Clears website memory so pages load properly.',
            'I|Restart Network|Restores full network connection. May require reboot.',
            'I|Speed Up Network|Releases bandwidth reserved by Windows.',
            'H|ðŸ›¡ï¸  SAFETY &amp; CONTROL',
            'I|Restore Point|Creates a rescue point in case something fails later.',
            'I|Startup Programs|Shows what opens on Windows startup. Useful to disable things.',
            'H|ðŸŽ¨  THEMES &amp; MODES',
            'I|Visual Themes|Choose from 18 color styles. Includes alien OMEGASOLVER.',
            'I|Advanced Mode|Detailed 3-column view with technical info.',
            'I|Low Mode|For slow PCs â€” reduces heavy visual effects.',
            'I|Share Files|(Advanced only) Connect to another PC or mobile over LAN.',
            'H|ðŸ”„  UPDATES',
            'I|Auto check|On startup, the app checks GitHub for a new version.',
            'I|Manual check|ðŸ”„ icon above to check manually.',
            'H|ðŸ”’  SAFETY',
            'I|SSD Protection|The app NEVER defragments an SSD (damages it).',
            'I|Fully Reversible|Changes (power, QoS, services) can be undone.',
            'I|Languages|Spanish, English, Portuguese. Change from the top bar.'
        )
        $ptItems = @(
            'H|ðŸ› ï¸  REPARAR MEU PC',
            'I|Reparar Windows|Escaneia e repara arquivos de sistema danificados. Pode levar 10-30 min.',
            'I|Recuperar sistema|Repara a imagem interna do Windows. Ãštil se SFC nÃ£o resolver.',
            'I|Verificar disco|Verifica se o disco nÃ£o tem erros. Pode exigir reinicializaÃ§Ã£o.',
            'I|Organizar disco|Organiza arquivos para mais velocidade. SOMENTE HDD (nÃ£o SSD).',
            'I|Modo Desempenho|Ajusta o PC para velocidade mÃ¡xima. Usa mais bateria.',
            'I|Reparar tudo|Faz TUDO automaticamente: limpeza â†’ internet â†’ SFC â†’ DISM.',
            'H|ðŸ§¹  LIMPEZA',
            'I|Apagar temporÃ¡rios|Remove arquivos inÃºteis acumulados com o tempo.',
            'I|Limpeza completa|Varre caches do Windows, atualizaÃ§Ãµes e navegadores.',
            'I|Apagar histÃ³rico|Remove logs antigos do sistema.',
            'I|Limpeza 1-Clique|Limpeza rÃ¡pida: temp + DNS + caches + lixeira.',
            'H|ðŸŒ  CORRIGIR INTERNET',
            'I|Corrigir internet|Apaga memÃ³ria de sites para carregarem corretamente.',
            'I|Reiniciar rede|Restaura toda a conexÃ£o de rede. Pode exigir reinicializaÃ§Ã£o.',
            'I|Acelerar rede|Libera largura de banda reservada pelo Windows.',
            'H|ðŸ›¡ï¸  SEGURANÃ‡A E CONTROLE',
            'I|Ponto de RestauraÃ§Ã£o|Cria um ponto de resgate caso algo falhe depois.',
            'I|Programas de InicializaÃ§Ã£o|Mostra o que abre ao ligar. Ãštil para desabilitar.',
            'H|ðŸŽ¨  TEMAS E MODOS',
            'I|Temas visuais|Escolha entre 18 estilos de cor. Inclui OMEGASOLVER alienÃ­gena.',
            'I|Modo AvanÃ§ado|VisÃ£o detalhada de 3 colunas com info tÃ©cnica.',
            'I|Modo Low|Para PCs lentos â€” reduz efeitos visuais pesados.',
            'I|Compartilhar Arquivos|(SÃ³ AvanÃ§ado) Conecta com outro PC ou celular via rede.',
            'H|ðŸ”„  ATUALIZAÃ‡Ã•ES',
            'I|VerificaÃ§Ã£o auto|Ao iniciar, o app verifica nova versÃ£o no GitHub.',
            'I|VerificaÃ§Ã£o manual|Ãcone ðŸ”„ acima para verificar manualmente.',
            'H|ðŸ”’  SEGURANÃ‡A',
            'I|ProteÃ§Ã£o SSD|O app NUNCA desfragmenta um SSD (danifica).',
            'I|Totalmente reversÃ­vel|MudanÃ§as (energia, QoS, serviÃ§os) podem ser desfeitas.',
            'I|Idiomas|Espanhol, InglÃªs, PortuguÃªs. Mude na barra superior.'
        )
    }

    $manualTitle = Get-OmegaString 'Manual_Title'
    $manualAppLine = Get-OmegaString 'Manual_AppLine'
    $manualEsTitle = Get-OmegaString 'Manual_EsTitle'
    $manualEnTitle = Get-OmegaString 'Manual_EnTitle'
    $manualPtTitle = Get-OmegaString 'Manual_PtTitle'
    $manualFooter = Get-OmegaString 'Manual_Footer'
    $manualCloseBtn = Get-OmegaString 'Manual_CloseBtn'

    $manualXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="$manualTitle"
        Height="820" Width="1480"
        WindowStartupLocation="CenterOwner" ResizeMode="NoResize"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent">
    <Border Background="{DynamicResource ManualPanelBg}"
            BorderBrush="{DynamicResource ManualAccent}"
            BorderThickness="2" CornerRadius="12">
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
                            <TextBlock Text="$manualTitle" FontSize="24" FontWeight="Bold" Foreground="White"/>
                            <TextBlock x:Name="lblManualMode" Text="$manualAppLine" FontSize="13" Foreground="White" Opacity="0.85"/>
                        </StackPanel>
                    </StackPanel>
                    <Button x:Name="btnManualX" Content="âœ•" HorizontalAlignment="Right" VerticalAlignment="Top"
                            Width="42" Height="42" Margin="0,8,10,0" FontSize="18" FontWeight="Bold"
                            Foreground="White" Background="Transparent" BorderThickness="0"
                            Cursor="Hand" ToolTip="$manualCloseBtn"/>
                </Grid>
            </Border>
            <Border Grid.Row="1" Background="{DynamicResource ManualCardBg}" Padding="22,10">
                <TextBlock x:Name="lblModeBadge" FontSize="12" FontWeight="SemiBold"
                           Foreground="{DynamicResource ManualAccent}" HorizontalAlignment="Center"/>
            </Border>
            <Grid Grid.Row="2" Margin="22,14,22,14">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="14"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="14"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <Border Grid.Column="0" Background="{DynamicResource ManualCardBg}"
                        BorderBrush="{DynamicResource ManualBorder}" BorderThickness="1"
                        CornerRadius="8" Padding="16">
                    <ScrollViewer VerticalScrollBarVisibility="Auto" Padding="0,0,8,0">
                        <StackPanel>
                            <TextBlock Text="$manualEsTitle" FontSize="16" FontWeight="Bold"
                                       Foreground="{DynamicResource ManualAccent}" Margin="0,0,0,14"/>
                            <StackPanel x:Name="stackEs"/>
                        </StackPanel>
                    </ScrollViewer>
                </Border>
                <Border Grid.Column="2" Background="{DynamicResource ManualCardBg}"
                        BorderBrush="{DynamicResource ManualBorder}" BorderThickness="1"
                        CornerRadius="8" Padding="16">
                    <ScrollViewer VerticalScrollBarVisibility="Auto" Padding="0,0,8,0">
                        <StackPanel>
                            <TextBlock Text="$manualEnTitle" FontSize="16" FontWeight="Bold"
                                       Foreground="{DynamicResource ManualAccent}" Margin="0,0,0,14"/>
                            <StackPanel x:Name="stackEn"/>
                        </StackPanel>
                    </ScrollViewer>
                </Border>
                <Border Grid.Column="4" Background="{DynamicResource ManualCardBg}"
                        BorderBrush="{DynamicResource ManualBorder}" BorderThickness="1"
                        CornerRadius="8" Padding="16">
                    <ScrollViewer VerticalScrollBarVisibility="Auto" Padding="0,0,8,0">
                        <StackPanel>
                            <TextBlock Text="$manualPtTitle" FontSize="16" FontWeight="Bold"
                                       Foreground="{DynamicResource ManualAccent}" Margin="0,0,0,14"/>
                            <StackPanel x:Name="stackPt"/>
                        </StackPanel>
                    </ScrollViewer>
                </Border>
            </Grid>
            <Border Grid.Row="3" Background="{DynamicResource ManualCardBg}" CornerRadius="0,0,10,10" Padding="25,0">
                <Grid>
                    <TextBlock Text="$manualFooter"
                               FontSize="11" Foreground="{DynamicResource ManualMuted}"
                               VerticalAlignment="Center" HorizontalAlignment="Left"/>
                    <Button x:Name="btnManualClose" Content="$manualCloseBtn" Width="220" Height="36"
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

    $modeText = if ($isAdvanced) { Get-OmegaString 'Manual_Mode_Advanced' } else { Get-OmegaString 'Manual_Mode_Basic' }
    $mw.FindName("lblManualMode").Text = "$manualAppLine Â· $modeText"
    $mw.FindName("lblModeBadge").Text  = Get-OmegaString 'Manual_Badge' $modeText

    function Add-ManualContent {
        param($StackPanel, $Items, $AccentB, $TextB, $MutedB)
        foreach ($raw in $Items) {
            $parts = $raw -split '\|'
            $type = $parts[0]
            if ($type -eq 'H') {
                $tb = New-Object System.Windows.Controls.TextBlock
                $tb.Text = $parts[1]; $tb.FontSize = 13; $tb.FontWeight = 'Bold'
                $tb.Foreground = $AccentB
                $tb.Margin = New-Object System.Windows.Thickness(0,12,0,6)
                $tb.TextWrapping = 'Wrap'
                [void]$StackPanel.Children.Add($tb)
            } elseif ($type -eq 'I') {
                $label = $parts[1]; $desc = $parts[2]
                $tb = New-Object System.Windows.Controls.TextBlock
                $tb.FontSize = 10.5; $tb.LineHeight = 17; $tb.TextWrapping = 'Wrap'
                $tb.Margin = New-Object System.Windows.Thickness(0,0,0,5)
                $r1 = New-Object System.Windows.Documents.Run('â€¢ ')
                $r1.Foreground = $AccentB; $r1.FontWeight = 'Bold'
                $r2 = New-Object System.Windows.Documents.Run("$label`n")
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
    Add-ManualContent -StackPanel $mw.FindName("stackPt") -Items $ptItems -AccentB $accentBrush -TextB $textBrush -MutedB $mutedBrush

    $mw.FindName("btnManualX").Add_Click({ $mw.Close() })
    $mw.FindName("btnManualClose").Add_Click({ $mw.Close() })

    $mw.Owner = $window
    [void]$mw.ShowDialog()
}

# ---------------- TEMAS ----------------
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
        ThemeCleanBackground='CleanBg'; ThemeCleanBorder='CleanBorder'
        ThemeCleanHover='CleanHover'; ThemeCleanPressed='CleanPressed'
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
        } else { Set-Content -Path $script:OmegaSolverSubPath -Value $Name -Encoding UTF8 -Force }
    } catch { }
}

# ---------- RUTAS Y ESTADO ------------------------------------------------
$script:OmegaStateDir       = Join-Path $env:ProgramData "OmegaSolver"
$script:OmegaStatePath      = Join-Path $script:OmegaStateDir "reversible-state.json"
$script:OmegaThemePath      = Join-Path $script:OmegaStateDir "theme.txt"
$script:OmegaSolverSubPath  = Join-Path $script:OmegaStateDir "omega-subcolor.txt"
$script:OmegaWarningAckPath = Join-Path $script:OmegaStateDir "omega-warning.ack"
$script:OmegaLowModePath    = Join-Path $script:OmegaStateDir "low-mode.txt"
$script:OmegaLanguagePath   = Join-Path $script:OmegaStateDir "language.txt"
if (-not (Test-Path $script:OmegaStateDir)) { New-Item -Path $script:OmegaStateDir -ItemType Directory -Force | Out-Null }

$script:OmegaMediaTypeCache = @{}

# ==============================================================================
# PALETAS OMEGASOLVER
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
        CleanBg="#3A3A00"; CleanBorder="#FFEB3B"; CleanHover="#4A4A00"; CleanPressed="#2A2A00"
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
        CleanBg="#3A3000"; CleanBorder="#FFC107"; CleanHover="#4A3E00"; CleanPressed="#2A2200"
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
        CleanBg="#2A2A00"; CleanBorder="#7CFC00"; CleanHover="#3A3A00"; CleanPressed="#1A1A00"
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
        CleanBg="#0F3A1A"; CleanBorder="#22C55E"; CleanHover="#1A5525"; CleanPressed="#0A2A12"
    }
    "ðŸŸ£â†’ðŸŸ¡ Gradiente (Uzi Post-Cyn)" = @{
        WindowBg="#050208"; PanelBg="#0A0510"; CardBg="#120818"; InputBg="#020004"
        MainText="#F8E8FF"; SecondaryText="#F0C870"; MutedText="#9A6FB0"; LabelText="#C026D3"
        Accent="#C026D3|#FACC15"; AccentAlt="#FACC15|#C026D3"
        Border="#7A1F8A|#8A7500"; BorderStrong="#C026D3|#FACC15"
        BorderHover="#C026D3|#FACC15"; BorderPressed="#FACC15|#C026D3"
        PrimaryBg="#5C1468|#5C4D00"; PrimaryHover="#7A1F8A|#8A7500"
        PrimaryPressed="#3A0A44|#3A3000"
        ButtonBg="#0A0510"; ButtonHover="#150A1C"; ButtonPressed="#050208"
        RevertBg="#3A0000"; RevertBorder="#FF2A2A"; RevertHover="#550000"; RevertPressed="#220000"
        ManualBg="#120818"; ManualHover="#221040"; ManualPressed="#0A0510"; Log="#FACC15"
        CleanBg="#2A4020|#5C4D00"; CleanBorder="#22C55E|#FACC15"
        CleanHover="#3A5030|#7A1F8A"; CleanPressed="#1A3015|#3A3000"
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
        CleanBg="#0F3A1A"; CleanBorder="#22C55E"; CleanHover="#1A5525"; CleanPressed="#0A2A12"
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
        CleanBg="#166534"; CleanBorder="#22C55E"; CleanHover="#15803D"; CleanPressed="#14532D"
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
        CleanBg="#16A34A"; CleanBorder="#22C55E"; CleanHover="#15803D"; CleanPressed="#14532D"
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
        CleanBg="#166534"; CleanBorder="#22C55E"; CleanHover="#15803D"; CleanPressed="#14532D"
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
        CleanBg="#216E2A"; CleanBorder="#7CFF6B"; CleanHover="#2E8B39"; CleanPressed="#164B1C"
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
        CleanBg="#0F5132"; CleanBorder="#00BA7C"; CleanHover="#12633E"; CleanPressed="#083D26"
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
        CleanBg="#1A7A4F"; CleanBorder="#57F287"; CleanHover="#1F8F5C"; CleanPressed="#145237"
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
        CleanBg="#008069"; CleanBorder="#25D366"; CleanHover="#006E5A"; CleanPressed="#005C4B"
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
        CleanBg="#169C46"; CleanBorder="#1ED760"; CleanHover="#1DB954"; CleanPressed="#0E6B32"
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
        CleanBg="#166534"; CleanBorder="#4EC9B0"; CleanHover="#15803D"; CleanPressed="#14532D"
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
        CleanBg="#1B5E20"; CleanBorder="#66C0F4"; CleanHover="#2E7D32"; CleanPressed="#0D3D13"
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
        CleanBg="#166534"; CleanBorder="#22C55E"; CleanHover="#15803D"; CleanPressed="#14532D"
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
        CleanBg="#2E7D32"; CleanBorder="#50FA7B"; CleanHover="#388E3C"; CleanPressed="#1B5E20"
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
        CleanBg="#0F5132"; CleanBorder="#34A853"; CleanHover="#166534"; CleanPressed="#083D26"
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
        CleanBg="#22543D"; CleanBorder="#48BB78"; CleanHover="#2F855A"; CleanPressed="#1A3F2A"
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
        CleanBg="#0E8C6D"; CleanBorder="#10A37F"; CleanHover="#0A6E55"; CleanPressed="#084F3D"
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
        CleanBg="#2E7D32"; CleanBorder="#22C55E"; CleanHover="#388E3C"; CleanPressed="#1B5E20"
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
        CleanBg="#166534"; CleanBorder="#22C55E"; CleanHover="#15803D"; CleanPressed="#14532D"
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
        CleanBg="#3A3A00"; CleanBorder="#FFEB3B"; CleanHover="#4A4A00"; CleanPressed="#2A2A00"
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
    } else { $script:OmegaState = (Get-DefaultOmegaState | ConvertTo-Json -Depth 8 | ConvertFrom-Json) }
} catch { $script:OmegaState = (Get-DefaultOmegaState | ConvertTo-Json -Depth 8 | ConvertFrom-Json) }

$script:OmegaSystemProfile = Get-OmegaSystemProfile

# ==============================================================================
# EFECTOS OMEGASOLVER STYLE
# ==============================================================================
function Apply-OmegaSolverEffects {
    if (Test-OmegaLowModeActive) {
        try {
            $alienFont = New-Object System.Windows.Media.FontFamily("Rajdhani, Orbitron, Michroma, Consolas, Lucida Console, Segoe UI")
            $window.FontFamily = $alienFont
            $global:lblAppTitle.Text = Get-OmegaString 'Omega_Title'
            $global:lblAppTitle.FontSize = 17
            $global:lblAppTitle.FontWeight = 'Black'
            $global:lblAppVersion.Text = Get-OmegaString 'Omega_Version'
            $global:lblThemeCaption.Text = Get-OmegaString 'Omega_Pattern'
            $global:lblAppTitle.Effect = $null
            $global:MainBorder.Effect = $null
            $global:MainBorder.BorderThickness = New-Object System.Windows.Thickness(1)
        } catch { }
        return
    }
    try {
        $alienFont = New-Object System.Windows.Media.FontFamily("Rajdhani, Orbitron, Michroma, Consolas, Lucida Console, Segoe UI")
        $window.FontFamily = $alienFont
        $global:lblAppTitle.Text = Get-OmegaString 'Omega_Title'
        $global:lblAppTitle.FontSize = 17
        $global:lblAppTitle.FontWeight = 'Black'
        $global:lblAppVersion.Text = Get-OmegaString 'Omega_Version'
        $global:lblThemeCaption.Text = Get-OmegaString 'Omega_Pattern'
        $glowColor = [System.Windows.Media.Colors]::Yellow
        try {
            $accentBrush = $window.Resources['ThemeAccent']
            if ($accentBrush -is [System.Management.Automation.PSObject]) { $accentBrush = $accentBrush.PSObject.BaseObject }
            if ($accentBrush -is [System.Windows.Media.SolidColorBrush]) { $glowColor = $accentBrush.Color }
            elseif ($accentBrush -is [System.Windows.Media.LinearGradientBrush] -and $accentBrush.GradientStops.Count -gt 0) { $glowColor = $accentBrush.GradientStops[0].Color }
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
    } catch { Write-OmegaLog (Get-OmegaString 'Log_OmegaEffectError' $_.Exception.Message) }
}

function Reset-OmegaSolverEffects {
    try {
        $window.FontFamily = New-Object System.Windows.Media.FontFamily("Segoe UI")
        $global:lblAppTitle.Text = Get-OmegaString 'App_Title'
        $global:lblAppTitle.FontSize = 18
        $global:lblAppTitle.FontWeight = 'Bold'
        $global:lblAppTitle.Effect = $null
        $global:lblAppVersion.Text = Get-OmegaString 'App_Version'
        $global:lblThemeCaption.Text = Get-OmegaString 'Theme_Caption'
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
        } else {
            $global:gridBasic.Visibility = 'Visible'
            $global:gridAdvanced.Visibility = 'Collapsed'
            $global:statsPanel.Visibility = 'Collapsed'; $global:logPanel.Visibility = 'Collapsed'
        }
        Update-OmegaRepairDriveState
    } catch { }
}

function Set-OmegaWindowBounds {
    try {
        $sw = 0; $sh = 0; $waLeft = 0; $waTop = 0
        try {
            $wa = [System.Windows.SystemParameters]::WorkArea
            $sw = [int]$wa.Width; $sh = [int]$wa.Height
            $waLeft = [int]$wa.Left; $waTop = [int]$wa.Top
        } catch { }
        if ($sw -lt 800 -or $sh -lt 600) {
            try {
                $sw = [int][System.Windows.SystemParameters]::PrimaryScreenWidth
                $sh = [int][System.Windows.SystemParameters]::PrimaryScreenHeight
                $waLeft = 0; $waTop = 0
            } catch { }
        }
        if ($sw -lt 800 -or $sh -lt 600) {
            try {
                $screen = [System.Windows.Forms.Screen]::PrimaryScreen
                $sw = $screen.WorkingArea.Width; $sh = $screen.WorkingArea.Height
                $waLeft = $screen.WorkingArea.Left; $waTop = $screen.WorkingArea.Top
            } catch { }
        }
        if ($sw -lt 800) { $sw = 1024; $sh = 768 }
        $targetW = [int][math]::Floor($sw * 0.94)
        $targetH = [int][math]::Floor($sh * 0.92)
        if ($targetW -lt 900)  { $targetW = 900 }
        if ($targetW -gt 1400) { $targetW = 1400 }
        if ($targetH -lt 600)  { $targetH = 600 }
        if ($targetH -gt 1050) { $targetH = 1050 }
        if ($targetW -lt $window.MinWidth)  { $targetW = [int]$window.MinWidth }
        if ($targetH -lt $window.MinHeight) { $targetH = [int]$window.MinHeight }
        $window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::Manual
        $window.Width  = $targetW
        $window.Height = $targetH
        $window.Left = $waLeft + [math]::Floor(($sw - $targetW) / 2)
        $window.Top  = $waTop  + [math]::Floor(($sh - $targetH) / 2)
        if ($window.Top -lt 0) { $window.Top = 0 }
        if ($window.Left -lt 0) { $window.Left = 0 }
        Write-OmegaLog (Get-OmegaString 'Log_Window' @($targetW, $targetH, $sw, $sh, $window.Left, $window.Top))
    } catch {
        Write-OmegaLog (Get-OmegaString 'Log_WindowError' $_.Exception.Message)
        try { $window.Width = 1100; $window.Height = 720; $window.Left = 50; $window.Top = 50 } catch { }
    }
}

Initialize-OmegaSystemProfile -SysProfile $script:OmegaSystemProfile

# Poblar ComboBoxes
$themeList = $script:OmegaThemes.Keys | Sort-Object
foreach ($themeKey in $themeList) { [void]$global:cmbTheme.Items.Add($themeKey) }
foreach ($colorKey in ($script:OmegaSolverPalettes.Keys | Sort-Object)) { [void]$global:cmbOmegaColor.Items.Add($colorKey) }

# Poblar ComboBox de idiomas
[void]$global:cmbLanguage.Items.Add("ES")
[void]$global:cmbLanguage.Items.Add("EN")
[void]$global:cmbLanguage.Items.Add("PT")

$script:__Initializing = $true

# Cargar idioma guardado
$savedLang = Get-OmegaLanguage
if ($savedLang -eq 'ES' -or $savedLang -eq 'EN' -or $savedLang -eq 'PT') { $global:cmbLanguage.SelectedItem = $savedLang }
else { $global:cmbLanguage.SelectedItem = 'ES' }

# Cargar Low Mode
$savedLowMode = Get-OmegaLowModeState
if ($savedLowMode) { $global:chkLowMode.IsChecked = $true }

# Cargar sub-color OMEGASOLVER
$savedSubColor = $null
try {
    if (Test-Path $script:OmegaSolverSubPath) {
        $savedSubColor = (Get-Content -Path $script:OmegaSolverSubPath -Raw -ErrorAction Stop).Trim()
    }
} catch { }
if ($savedSubColor -and $script:OmegaSolverPalettes.Contains($savedSubColor)) { $global:cmbOmegaColor.SelectedItem = $savedSubColor }
elseif ($global:cmbOmegaColor.Items.Count -gt 0) { $global:cmbOmegaColor.SelectedIndex = 0 }

# Cargar tema
$savedTheme = Get-OmegaThemeName
if ($themeList -contains $savedTheme -or $savedTheme -eq 'OMEGASOLVER style') { $global:cmbTheme.SelectedItem = $savedTheme }
else { $savedTheme = "Spotify Neon"; $global:cmbTheme.SelectedItem = $savedTheme }

try {
    if ($savedTheme -eq 'OMEGASOLVER style') {
        $subColor = [string]$global:cmbOmegaColor.SelectedItem
        if ($subColor -and $script:OmegaSolverPalettes.Contains($subColor)) { Set-OmegaThemeResources -Palette $script:OmegaSolverPalettes[$subColor] }
        $global:cmbOmegaColor.Visibility = 'Visible'
        Apply-OmegaSolverEffects
        Write-OmegaLog (Get-OmegaString 'Log_OmegaRestored' $subColor)
    } elseif ($script:OmegaThemes.ContainsKey($savedTheme)) {
        Set-OmegaThemeResources -Palette $script:OmegaThemes[$savedTheme]
        Write-OmegaLog (Get-OmegaString 'Log_ThemeRestored' $savedTheme)
    }
} catch { Write-OmegaLog (Get-OmegaString 'Log_ThemeError' $_.Exception.Message) }

if ($savedLowMode) {
    Apply-OmegaLowMode -Enable $true
    Write-OmegaLog (Get-OmegaString 'Log_LowModeRestored')
}

# Aplicar idioma guardado
Apply-OmegaLanguage

$script:__Initializing = $false

Set-OmegaModeUI -Advanced $false
Refresh-OmegaRepairDrives
Write-OmegaLog (Get-OmegaString 'Log_AppStart')

# ==============================================================================
# PANTALLA DE CARGA
# ==============================================================================
$script:OmegaLoadingXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Processing..." Height="450" Width="700"
        WindowStartupLocation="CenterScreen" ResizeMode="NoResize"
        WindowStyle="None" AllowsTransparency="True" Topmost="True"
        ShowInTaskbar="False" Background="Transparent">
    <Border Background="{DynamicResource ThemePanelBackground}"
            BorderBrush="{DynamicResource ThemeAccent}"
            BorderThickness="3" CornerRadius="14">
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
                        <TextBlock x:Name="lblTitle" Text="Processing..." FontSize="26" FontWeight="Bold" Foreground="White"/>
                        <TextBlock Text="OmegaSolver V4.3" FontSize="13" Foreground="White" Opacity="0.85"/>
                    </StackPanel>
                </StackPanel>
            </Border>
            <StackPanel Grid.Row="1" Margin="45,35,45,35" VerticalAlignment="Center">
                <TextBlock x:Name="lblMainMessage" Text="Starting..." FontSize="20" FontWeight="SemiBold"
                           Foreground="{DynamicResource ThemeMainText}" TextWrapping="Wrap" Margin="0,0,0,25"/>
                <ProgressBar x:Name="pbLoading" Height="18" IsIndeterminate="True"
                             Background="{DynamicResource ThemeInputBackground}"
                             Foreground="{DynamicResource ThemeAccent}"
                             BorderThickness="0" Margin="0,0,0,25"/>
                <TextBlock x:Name="lblSubMessage" Text="Please wait..." FontSize="14"
                           Foreground="{DynamicResource ThemeMutedText}" TextWrapping="Wrap"/>
            </StackPanel>
            <Border Grid.Row="2" Background="{DynamicResource ThemeCardBackground}" CornerRadius="0,0,12,12" Padding="25,0">
                <TextBlock x:Name="lblDoNotClose" Text="Please do not close this window while the process is running."
                           FontSize="12" Foreground="{DynamicResource ThemeMutedText}"
                           HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
        </Grid>
    </Border>
</Window>
"@

function Invoke-OmegaTask {
    param([string]$Title, [string[]]$Steps, [ScriptBlock]$Action)
    $currentTheme = [string]$global:cmbTheme.SelectedItem
    $palette = $null
    if ($currentTheme -eq 'OMEGASOLVER style') {
        $subColor = [string]$global:cmbOmegaColor.SelectedItem
        if ($subColor -and $script:OmegaSolverPalettes.Contains($subColor)) { $palette = $script:OmegaSolverPalettes[$subColor] }
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
    $lw.FindName("lblSubMessage").Text = Get-OmegaString 'Loading_SubMessage'
    $lw.FindName("lblDoNotClose").Text = Get-OmegaString 'Loading_DoNotClose'
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
    try { $result = $Action.Invoke() } catch { Write-OmegaLog (Get-OmegaString 'Log_TaskError' $_.Exception.Message) }
    $script:__OProcs = @()
    if ($null -ne $result) {
        if ($result -is [array]) { $script:__OProcs = @($result | Where-Object { $_ -ne $null -and $_ -is [System.Diagnostics.Process] }) }
        elseif ($result -is [System.Diagnostics.Process]) { $script:__OProcs = @($result) }
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
        $script:__OPollTimer = New-Object System.Windows.Threading.DispatcherTimer
        $script:__OPollTimer.Interval = [TimeSpan]::FromMilliseconds(500)
        $script:__OPollTimeout = [DateTime]::UtcNow.AddMinutes(15)
        $script:__OPollTimer.Add_Tick({
            $allDone = $true
            foreach ($p in $script:__OProcs) { try { if (-not $p.HasExited) { $allDone = $false; break } } catch { } }
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
# EVENTOS
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

$global:btnCheckUpdate.Add_Click({ try { Invoke-OmegaUpdateCheckUI -Manual } catch { Write-OmegaLog (Get-OmegaString 'Log_UpdateError' $_.Exception.Message) } })

$global:btnUpdateBadge.Add_Click({
    try {
        $upd = Test-OmegaUpdate -Silent
        if ($upd.HasUpdate -and $upd.DownloadUrl) { Start-Process $upd.DownloadUrl | Out-Null }
    } catch { }
})

# â˜… Cambio de idioma
$global:cmbLanguage.Add_SelectionChanged({
    try {
        if ($script:__Initializing) { return }
        $newLang = [string]$global:cmbLanguage.SelectedItem
        if ([string]::IsNullOrWhiteSpace($newLang)) { return }
        Save-OmegaLanguage -Lang $newLang
        Apply-OmegaLanguage
        Write-OmegaLog (Get-OmegaString 'Log_LangChanged' $newLang)
    } catch { Write-OmegaLog (Get-OmegaString 'Log_LangError' $_.Exception.Message) }
})

$global:chkLowMode.Add_Checked({ try { Apply-OmegaLowMode -Enable $true } catch { } })
$global:chkLowMode.Add_Unchecked({ try { Apply-OmegaLowMode -Enable $false } catch { } })

$global:chkAdvanced.Add_Checked({ try { Set-OmegaModeUI -Advanced $true; Write-OmegaLog (Get-OmegaString 'Log_AdvancedOn') } catch { } })
$global:chkAdvanced.Add_Unchecked({ try { Set-OmegaModeUI -Advanced $false; Write-OmegaLog (Get-OmegaString 'Log_BasicOn') } catch { } })

$global:cmbTheme.Add_SelectionChanged({
    try {
        if ($script:__Initializing) { return }
        $selected = [string]$global:cmbTheme.SelectedItem
        if ([string]::IsNullOrWhiteSpace($selected)) { return }
        Save-OmegaThemeName -Name $selected
        if ($selected -eq 'OMEGASOLVER style') {
            if (-not (Test-Path $script:OmegaWarningAckPath)) {
                $result = [System.Windows.MessageBox]::Show(
                    (Get-OmegaString 'Omega_Warning_Message'),
                    (Get-OmegaString 'Omega_Warning_Title'), 'YesNo', 'Warning')
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
                if (-not $restored -and $global:cmbOmegaColor.Items.Count -gt 0) { $global:cmbOmegaColor.SelectedIndex = 0 }
            }
            $subColor = [string]$global:cmbOmegaColor.SelectedItem
            if ($subColor) { Save-OmegaSubColor -Name $subColor }
            if ($subColor -and $script:OmegaSolverPalettes.Contains($subColor)) { Set-OmegaThemeResources -Palette $script:OmegaSolverPalettes[$subColor] }
            Apply-OmegaSolverEffects
            Write-OmegaLog (Get-OmegaString 'Log_OmegaOn' $subColor)
        } else {
            $global:cmbOmegaColor.Visibility = 'Collapsed'
            Save-OmegaSubColor -Name $null
            Reset-OmegaSolverEffects
            if ($script:OmegaThemes.ContainsKey($selected)) { Set-OmegaThemeResources -Palette $script:OmegaThemes[$selected] }
            Write-OmegaLog (Get-OmegaString 'Log_ThemeApplied' $selected)
        }
    } catch { Write-OmegaLog (Get-OmegaString 'Log_ThemeApplyError' $_.Exception.Message) }
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
        Write-OmegaLog (Get-OmegaString 'Log_OmegaOn' $subColor)
    } catch { }
})

$global:cmbRepairDriveBasic.Add_SelectionChanged({ try { Update-OmegaRepairDriveState } catch { } })
$global:cmbRepairDriveAdv.Add_SelectionChanged({ try { Update-OmegaRepairDriveState } catch { } })
$global:btnRefreshDrivesBasic.Add_Click({ try { Refresh-OmegaRepairDrives } catch { } })
$global:btnRefreshDrivesAdv.Add_Click({ try { Refresh-OmegaRepairDrives } catch { } })

$global:btnDiagnose.Add_Click({
    try {
        Set-OmegaStatus (Get-OmegaString 'Status_Analyzing')
        Invoke-OmegaTask -Title (Get-OmegaString 'Task_AnalyzePC_Title') -Steps @(
            (Get-OmegaString 'Task_AnalyzePC_Step1'),
            (Get-OmegaString 'Task_AnalyzePC_Step2'),
            (Get-OmegaString 'Task_AnalyzePC_Step3'),
            (Get-OmegaString 'Task_AnalyzePC_Step4')
        ) -Action { Start-OmegaDiagnostics; return $null }
        Set-OmegaStatus (Get-OmegaString 'Status_Ready')
    } catch { }
})

# Handlers
$sfcHandler = {
    try {
        $info = Get-SelectedOmegaDriveInfo
        if (-not $info) { return }
        if (-not (Confirm-OmegaAction -Title (Get-OmegaString 'Confirm_SFC_Title') -Message (Get-OmegaString 'Confirm_SFC_Message' $info.Drive) -Image 'Information')) { return }
        Invoke-OmegaTask -Title (Get-OmegaString 'Task_SFC_Title') -Steps @(
            (Get-OmegaString 'Task_SFC_Step1'),
            (Get-OmegaString 'Task_SFC_Step2' $info.Drive),
            (Get-OmegaString 'Task_SFC_Step3'),
            (Get-OmegaString 'Task_SFC_Step4')
        ) -Action { return Start-OmegaSfcRepair $info }
    } catch { Write-OmegaLog (Get-OmegaString 'Clean_Error' $_.Exception.Message) }
}
$global:btnSfcBasic.Add_Click($sfcHandler)
$global:btnSfcAdv.Add_Click($sfcHandler)

$dismHandler = {
    try {
        $info = Get-SelectedOmegaDriveInfo
        if (-not $info) { return }
        if (-not (Confirm-OmegaAction -Title (Get-OmegaString 'Confirm_DISM_Title') -Message (Get-OmegaString 'Confirm_DISM_Message' $info.Drive) -Image 'Information')) { return }
        Invoke-OmegaTask -Title (Get-OmegaString 'Task_DISM_Title') -Steps @(
            (Get-OmegaString 'Task_DISM_Step1'),
            (Get-OmegaString 'Task_DISM_Step2' $info.Drive),
            (Get-OmegaString 'Task_DISM_Step3'),
            (Get-OmegaString 'Task_DISM_Step4')
        ) -Action { return Start-OmegaDismRepair $info }
    } catch { }
}
$global:btnDismBasic.Add_Click($dismHandler)
$global:btnDismAdv.Add_Click($dismHandler)

$chkdskHandler = {
    try {
        $info = Get-SelectedOmegaDriveInfo
        if (-not $info) { return }
        if (-not (Confirm-OmegaAction -Title (Get-OmegaString 'Confirm_CHKDSK_Title') -Message (Get-OmegaString 'Confirm_CHKDSK_Message' $info.Drive))) { return }
        Invoke-OmegaTask -Title (Get-OmegaString 'Task_CHKDSK_Title') -Steps @(
            (Get-OmegaString 'Task_CHKDSK_Step1'),
            (Get-OmegaString 'Task_CHKDSK_Step2' $info.Drive),
            (Get-OmegaString 'Task_CHKDSK_Step3'),
            (Get-OmegaString 'Task_CHKDSK_Step4')
        ) -Action { return Start-OmegaChkdskRepair $info }
    } catch { }
}
$global:btnChkDskBasic.Add_Click($chkdskHandler)
$global:btnChkDskAdv.Add_Click($chkdskHandler)

$defragHandler = {
    try {
        $info = Get-SelectedOmegaDriveInfo
        if (-not $info) { return }
        $mediaType = Get-OmegaDriveMediaType -DriveLetter $info.Drive
        if ($mediaType -eq 'SSD') {
            [System.Windows.MessageBox]::Show((Get-OmegaString 'SSD_Blocked_Message' $info.Drive), (Get-OmegaString 'SSD_Blocked_Title'), 'OK', 'Warning') | Out-Null
            Write-OmegaLog (Get-OmegaString 'SSD_Blocked_Log' $info.Drive)
            return
        }
        if ($mediaType -eq 'Unknown') {
            [System.Windows.MessageBox]::Show((Get-OmegaString 'Unknown_Blocked_Message' $info.Drive), (Get-OmegaString 'Unknown_Blocked_Title'), 'OK', 'Warning') | Out-Null
            return
        }
        if (-not (Confirm-OmegaAction -Title (Get-OmegaString 'Confirm_Optimize_Title') -Message (Get-OmegaString 'Confirm_Optimize_Message' $info.Drive) -Image 'Information')) { return }
        Write-OmegaLog "ðŸ’½ dfrgui.exe..."
        Start-Process -FilePath "dfrgui.exe" | Out-Null
    } catch { }
}
$global:btnDefragBasic.Add_Click($defragHandler)
$global:btnDefragAdv.Add_Click($defragHandler)

$maxPowerHandler = {
    try {
        Invoke-OmegaTask -Title (Get-OmegaString 'Task_MaxPower_Title') -Steps @(
            (Get-OmegaString 'Task_MaxPower_Step1'),
            (Get-OmegaString 'Task_MaxPower_Step2'),
            (Get-OmegaString 'Task_MaxPower_Step3')
        ) -Action {
            Save-ReversibleStateBeforePowerPlanChange
            powercfg -setactive $script:OmegaState.PowerPlan.TargetSchemeGuid | Out-Null
            return $null
        }
    } catch { }
}
$global:btnMaxPowerBasic.Add_Click($maxPowerHandler)
$global:btnMaxPowerAdv.Add_Click($maxPowerHandler)

$flushDnsHandler = {
    try { Invoke-OmegaTask -Title (Get-OmegaString 'Task_FlushDNS_Title') -Steps @(
        (Get-OmegaString 'Task_FlushDNS_Step1'),
        (Get-OmegaString 'Task_FlushDNS_Step2')
    ) -Action { ipconfig /flushdns | Out-Null; return $null } } catch { }
}
$global:btnFlushDnsBasic.Add_Click($flushDnsHandler)
$global:btnFlushDnsAdv.Add_Click($flushDnsHandler)

$resetNetHandler = {
    try {
        if (-not (Confirm-OmegaAction -Title (Get-OmegaString 'Confirm_ResetNet_Title') -Message (Get-OmegaString 'Confirm_ResetNet_Message'))) { return }
        Invoke-OmegaTask -Title (Get-OmegaString 'Task_ResetNet_Title') -Steps @(
            (Get-OmegaString 'Task_ResetNet_Step1'),
            (Get-OmegaString 'Task_ResetNet_Step2'),
            (Get-OmegaString 'Task_ResetNet_Step3')
        ) -Action { netsh winsock reset | Out-Null; return $null }
    } catch { }
}
$global:btnResetNetBasic.Add_Click($resetNetHandler)
$global:btnResetNetAdv.Add_Click($resetNetHandler)

$qosHandler = {
    try {
        Invoke-OmegaTask -Title (Get-OmegaString 'Task_QoS_Title') -Steps @(
            (Get-OmegaString 'Task_QoS_Step1'),
            (Get-OmegaString 'Task_QoS_Step2'),
            (Get-OmegaString 'Task_QoS_Step3')
        ) -Action {
            Save-ReversibleStateBeforeQoSChange
            $regPath = $script:OmegaState.QoS.RegistryPath
            if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
            Set-ItemProperty -Path $regPath -Name "NonBestEffortLimit" -Value 0 -Type DWord
            return $null
        }
    } catch { }
}
$global:btnQoSBasic.Add_Click($qosHandler)
$global:btnQoSAdv.Add_Click($qosHandler)

$tempHandler = {
    try { Invoke-OmegaTask -Title (Get-OmegaString 'Task_Temp_Title') -Steps @(
        (Get-OmegaString 'Task_Temp_Step1'),
        (Get-OmegaString 'Task_Temp_Step2'),
        (Get-OmegaString 'Task_Temp_Step3')
    ) -Action { Start-BasicTempCleanup; return $null } } catch { }
}
$global:btnTempBasic.Add_Click($tempHandler)
$global:btnTempAdv.Add_Click($tempHandler)

$deepCleanHandler = {
    try {
        if (-not (Confirm-OmegaAction -Title (Get-OmegaString 'Confirm_DeepClean_Title') -Message (Get-OmegaString 'Confirm_DeepClean_Message'))) { return }
        Invoke-OmegaTask -Title (Get-OmegaString 'Task_DeepClean_Title') -Steps @(
            (Get-OmegaString 'Task_DeepClean_Step1'),
            (Get-OmegaString 'Task_DeepClean_Step2'),
            (Get-OmegaString 'Task_DeepClean_Step3'),
            (Get-OmegaString 'Task_DeepClean_Step4'),
            (Get-OmegaString 'Task_DeepClean_Step5')
        ) -Action { return Start-DeepCleaningRoutine }
    } catch { }
}
$global:btnDeepCleanBasic.Add_Click($deepCleanHandler)
$global:btnDeepCleanAdv.Add_Click($deepCleanHandler)

$logCleanHandler = {
    try {
        if (-not (Confirm-OmegaAction -Title (Get-OmegaString 'Confirm_LogsClean_Title') -Message (Get-OmegaString 'Confirm_LogsClean_Message'))) { return }
        Invoke-OmegaTask -Title (Get-OmegaString 'Task_LogsClean_Title') -Steps @(
            (Get-OmegaString 'Task_LogsClean_Step1'),
            (Get-OmegaString 'Task_LogsClean_Step2'),
            (Get-OmegaString 'Task_LogsClean_Step3'),
            (Get-OmegaString 'Task_LogsClean_Step4')
        ) -Action { return Start-LogAndWinSxSCleanup }
    } catch { }
}
$global:btnLogCleanBasic.Add_Click($logCleanHandler)
$global:btnLogCleanAdv.Add_Click($logCleanHandler)

$fullRepairHandler = {
    try {
        if (-not (Confirm-OmegaAction -Title (Get-OmegaString 'Confirm_FullRepair_Title') -Message (Get-OmegaString 'Confirm_FullRepair_Message'))) { return }
        $info = Get-SelectedOmegaDriveInfo
        Invoke-OmegaTask -Title (Get-OmegaString 'Task_FullRepair_Title') -Steps @(
            (Get-OmegaString 'Task_FullRepair_Step1'),
            (Get-OmegaString 'Task_FullRepair_Step2'),
            (Get-OmegaString 'Task_FullRepair_Step3'),
            (Get-OmegaString 'Task_FullRepair_Step4'),
            (Get-OmegaString 'Task_FullRepair_Step5'),
            (Get-OmegaString 'Task_FullRepair_Step6')
        ) -Action {
            Start-BasicTempCleanup
            ipconfig /flushdns | Out-Null
            $procs = @()
            if ($info) {
                $p1 = Start-OmegaSfcRepair $info; if ($p1) { $procs += $p1 }
                $p2 = Start-OmegaDismRepair $info; if ($p2) { $procs += $p2 }
            }
            return $procs
        }
    } catch { }
}
$global:btnFullRepairBasic.Add_Click($fullRepairHandler)
$global:btnFullRepairAdv.Add_Click($fullRepairHandler)

$fullCleanHandler = {
    try {
        if (-not (Confirm-OmegaAction -Title (Get-OmegaString 'Confirm_FullClean_Title') -Message (Get-OmegaString 'Confirm_FullClean_Message'))) { return }
        Invoke-OmegaTask -Title (Get-OmegaString 'Task_FullClean_Title') -Steps @(
            (Get-OmegaString 'Task_FullClean_Step1'),
            (Get-OmegaString 'Task_FullClean_Step2'),
            (Get-OmegaString 'Task_FullClean_Step3'),
            (Get-OmegaString 'Task_FullClean_Step4'),
            (Get-OmegaString 'Task_FullClean_Step5'),
            (Get-OmegaString 'Task_FullClean_Step6'),
            (Get-OmegaString 'Task_FullClean_Step7')
        ) -Action { Start-OmegaOneClickCleanup; return $null }
    } catch { }
}
$global:btnFullCleanBasic.Add_Click($fullCleanHandler)
$global:btnFullCleanAdv.Add_Click($fullCleanHandler)

$restorePointHandler = {
    try {
        if (-not (Confirm-OmegaAction -Title (Get-OmegaString 'Confirm_RestorePoint_Title') -Message (Get-OmegaString 'Confirm_RestorePoint_Message'))) { return }
        Invoke-OmegaTask -Title (Get-OmegaString 'Task_RestorePoint_Title') -Steps @(
            (Get-OmegaString 'Task_RestorePoint_Step1'),
            (Get-OmegaString 'Task_RestorePoint_Step2'),
            (Get-OmegaString 'Task_RestorePoint_Step3'),
            (Get-OmegaString 'Task_RestorePoint_Step4')
        ) -Action { New-OmegaRestorePoint; return $null }
    } catch { }
}
$global:btnCreateRestorePointBasic.Add_Click($restorePointHandler)
$global:btnCreateRestorePointAdv.Add_Click($restorePointHandler)

$startupManagerHandler = {
    try { Invoke-OmegaTask -Title (Get-OmegaString 'Task_Startup_Title') -Steps @(
        (Get-OmegaString 'Task_Startup_Step1'),
        (Get-OmegaString 'Task_Startup_Step2'),
        (Get-OmegaString 'Task_Startup_Step3')
    ) -Action { Show-OmegaStartupManager; return $null } } catch { }
}
$global:btnStartupManagerBasic.Add_Click($startupManagerHandler)
$global:btnStartupManagerAdv.Add_Click($startupManagerHandler)

$global:btnAnalyzeUpdatesAdv.Add_Click({
    try { Invoke-OmegaTask -Title (Get-OmegaString 'Task_Updates_Title') -Steps @(
        (Get-OmegaString 'Task_Updates_Step1'),
        (Get-OmegaString 'Task_Updates_Step2'),
        (Get-OmegaString 'Task_Updates_Step3')
    ) -Action { Get-OmegaUpdatesReport; return $null } } catch { }
})

$global:btnDeleteLockedFileAdv.Add_Click({
    try { Remove-OmegaLockedFile } catch { Write-OmegaLog (Get-OmegaString 'Clean_Error' $_.Exception.Message) }
})

$global:btnCleanupDriversAdv.Add_Click({
    try {
        if (-not (Confirm-OmegaAction -Title (Get-OmegaString 'Confirm_CleanDrivers_Title') -Message (Get-OmegaString 'Confirm_CleanDrivers_Message'))) { return }
        Invoke-OmegaTask -Title (Get-OmegaString 'Task_Drivers_Title') -Steps @(
            (Get-OmegaString 'Task_Drivers_Step1'),
            (Get-OmegaString 'Task_Drivers_Step2'),
            (Get-OmegaString 'Task_Drivers_Step3'),
            (Get-OmegaString 'Task_Drivers_Step4')
        ) -Action { return Start-OmegaDriverCleanup }
    } catch { }
})

$global:btnShareFilesAdv.Add_Click({
    try { Show-OmegaShareFilesWindow } catch { Write-OmegaLog (Get-OmegaString 'Share_WindowError' $_.Exception.Message) }
})

$global:btnManual.Add_Click({ try { Show-OmegaManual } catch { Write-OmegaLog (Get-OmegaString 'Clean_Error' $_.Exception.Message) } })

$global:btnRevert.Add_Click({
    try { Invoke-OmegaTask -Title (Get-OmegaString 'Task_Revert_Title') -Steps @(
        (Get-OmegaString 'Task_Revert_Step1'),
        (Get-OmegaString 'Task_Revert_Step2'),
        (Get-OmegaString 'Task_Revert_Step3'),
        (Get-OmegaString 'Task_Revert_Step4')
    ) -Action { Start-OmegaRevertChanges; return $null } } catch { }
})

# ==============================================================================
# INICIO â€” Auto-diagnÃ³stico + Update check + ECM check
# ==============================================================================
$window.Add_Loaded({
    Set-OmegaWindowBounds

    # Auto-diagnÃ³stico inicial
    $script:__AutoDiagTimer = New-Object System.Windows.Threading.DispatcherTimer
    $script:__AutoDiagTimer.Interval = [TimeSpan]::FromMilliseconds(800)
    $script:__AutoDiagTimer.Add_Tick({
        $script:__AutoDiagTimer.Stop()
        try {
            Invoke-OmegaTask -Title (Get-OmegaString 'Task_Starting_Title') -Steps @(
                (Get-OmegaString 'Task_Starting_Step1'),
                (Get-OmegaString 'Task_Starting_Step2'),
                (Get-OmegaString 'Task_Starting_Step3'),
                (Get-OmegaString 'Task_Starting_Step4'),
                (Get-OmegaString 'Task_Starting_Step5'),
                (Get-OmegaString 'Task_Starting_Step6')
            ) -Action { Start-OmegaDiagnostics; return $null }
            Write-OmegaLog (Get-OmegaString 'Log_InitialDiag')
        } catch { Write-OmegaLog (Get-OmegaString 'Log_DiagError' $_.Exception.Message) }
    })
    $script:__AutoDiagTimer.Start()

    # Update check (silencioso, en background)
    $script:__UpdateTimer = New-Object System.Windows.Threading.DispatcherTimer
    $script:__UpdateTimer.Interval = [TimeSpan]::FromSeconds(3)
    $script:__UpdateTimer.Add_Tick({
        $script:__UpdateTimer.Stop()
        try {
            Write-OmegaLog (Get-OmegaString 'Log_CheckUpdates')
            Invoke-OmegaUpdateCheckUI
        } catch { Write-OmegaLog (Get-OmegaString 'Update_FailedLog' $_.Exception.Message) }
    })
    $script:__UpdateTimer.Start()

    # ECM detection (despuÃ©s de 6 seg)
    $script:__EcmTimer = New-Object System.Windows.Threading.DispatcherTimer
    $script:__EcmTimer.Interval = [TimeSpan]::FromSeconds(6)
    $script:__EcmTimer.Add_Tick({
        $script:__EcmTimer.Stop()
        try { Invoke-OmegaEcmIntegration } catch { Write-OmegaLog (Get-OmegaString 'Log_EcmFailed' $_.Exception.Message) }
    })
    $script:__EcmTimer.Start()
})

Set-OmegaStatus (Get-OmegaString 'Status_Ready')

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
    try {
        if ($script:OmegaMutexOwned -and $script:OmegaMutex) { try { $script:OmegaMutex.ReleaseMutex() } catch { } }
    } catch { }
    try { if ($script:OmegaMutex) { $script:OmegaMutex.Dispose() } } catch { }
}
