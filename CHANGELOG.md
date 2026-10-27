# Historial de Cambios - OmegaSolver

## [4.4.4] - 2026-10-25

### Añadido
- **Instalador de Office (modo avanzado)**: descarga e instala Microsoft Office con la **Office Deployment Tool oficial**, directo desde los servidores de Microsoft.
  - Suites disponibles: **Microsoft 365, Office LTSC 2024, Office 2021, Office 2019 y Office 2016**.
  - En **Windows 7 / 8.x** solo se ofrece Office 2016 (la última compatible con ese sistema).
  - **Aplicaciones individuales**: elige una a una entre Word, Excel, PowerPoint, Outlook, OneNote, Publisher, Access, OneDrive y Teams — las no elegidas se excluyen de la instalación.
  - Arquitectura **x64 / x86**, canal de actualización (365) e idioma (es-es / en-us / pt-br).
  - La activación de Office requiere la **licencia propia** del usuario (cuenta o clave de Microsoft).
- **Panel de Ajustes** (botón ⚙ junto a "Analizar PC"):
  - **Botones personalizados**: crea botones con el nombre que quieras que ejecutan tus scripts `.ps1`, `.cmd` o `.bat`.
  - **Rutas de limpieza personalizadas**: carpetas del usuario que se limpian con cualquier botón de limpieza existente.
  - **Autolimpieza programada**: cada X minutos (a elección del usuario), con opción de ejecución en **segundo plano** sin ventanas.
  - **Log a disco** con botón para abrir la carpeta de logs.
- **Perfil del equipo al primer inicio**: elige entre equipo **EMPRESARIAL** o **DE HOGAR**. Con perfil empresarial se desactivan las acciones que pueden chocar con las políticas de dominio (GPO): restablecer red, QoS, plan de energía, limpiezas profundas, CHKDSK /f y DISM /ResetBase. La elección se recuerda.
  - **Cambiar el perfil desde Ajustes**: nuevo botón **"Cambiar perfil..."** que vuelve a mostrar el diálogo EMPRESARIAL / HOGAR en caliente y re-aplica el gating GPO al instante, sin reiniciar la app.
  - **Volver a preguntar al iniciar**: botón **"Preguntar al iniciar"** en la misma tarjeta. Borra la elección guardada para que el diálogo inicial EMPRESARIAL / HOGAR vuelva a aparecer en el próximo arranque.
- **Barra de basura real**: el panel principal muestra la cantidad real de basura detectada (medida, no estimada) y se refresca tras cada limpieza.
- **Acciones rápidas** junto a la barra de basura: *Limpieza en 1-Clic*, *Reparar todo* y **Todo-en-1-Clic** (limpieza + DNS + papelera + SFC + DISM + Winsock + re-análisis en una sola acción).
- **Sub-diálogos de opciones para DISM y CHKDSK** (modo avanzado): elige exactamente qué hará cada herramienta antes de ejecutarla.
- **`OmegaSolver.exe`**: nuevo ejecutable compilado con PS12EXE que actúa como lanzador de la versión modular. Solicita UAC al abrir y requiere los archivos del `.zip` extraídos junto a él.

### Cambiado
- **Código fuente 100% modular**: el script monolítico se reorganizó en un árbol de **170 archivos** (`App.ps1` + `Core/`, `UI/`, `Modules/`, `Workers/`, `Features/`) cargados por dot-sourcing en el orden exacto del original. La app se distribuye como `.zip` con el árbol completo y su ejecutable.
- Versión actualizada a **4.4.4** en toda la interfaz, títulos de ventana y punto de restauración.

### Corregido
- **Icono de PowerShell en la barra de tareas**: al ejecutarse dentro de `powershell.exe`, Windows mostraba el icono genérico de PowerShell. La ventana ahora declara un **AppUserModelID propio** (`OMEGA_ALPHA.OmegaSolver`) y asigna `Window.Icon` al **logo embebido de OmegaSolver**, por lo que la barra de tareas muestra el logo de la app.
- **`OmegaSolver.exe` no abría / mostraba error de script**: el lanzador usaba `[System.Windows.MessageBox]` sin cargar WPF, tipo que no existe en el runspace interno de PS12EXE — el aviso de error fallaba y el `.exe` se cerraba con una excepción en lugar de mostrar la app. Ahora el lanzador carga `PresentationFramework` antes de cualquier diálogo y arranca `powershell.exe` con ruta absoluta, `-STA` y **sin consola negra** (`CreateNoWindow`).
- **Exe suelto fuera del zip**: `_release\OmegaSolver.exe` es sólo una copia para revisar propiedades; **no funciona solo** porque necesita `App.ps1` y las carpetas `Core/ UI/ Modules/ Workers/ Features/` a su lado. Ahora, si falta `App.ps1`, el exe muestra un aviso claro en vez de fallar.
- **Advertencia de locale en la compilación** (`Failed to load locale data C`): se compila con `-Locale en`, eliminando el aviso y el riesgo de errores de parseo en sistemas con locale no-inglés.

### Documentación
- **README con la arquitectura modular explicada**: nueva sección especial que detalla por qué se pasó del `.ps1` único al árbol de 170 archivos, por qué ahora es **obligatorio descargar el `.zip` completo** y por qué el `.exe` debe estar **junto a `App.ps1`**.
- **Benchmark real V4.4.1 vs V4.4.4**: se ejecutaron los **`.exe` oficiales** de ambas versiones en frío, en el mismo equipo y sesión elevada. Bajo la misma carga, la V4.4.4 abrió en **346,9 s** frente a **1120,0 s** del `.exe` final de V4.4.1 (−69,0 %; el otro build de V4.4.1 midió **754,5 s**). Con el equipo descargado, la V4.4.4 arrancó en **27,75 s y 57,2 s**. Metodología, intentos fallidos y limitaciones quedan documentados en el README.

### Licencia
- Distribuido bajo la licencia GNU General Public License v3.0 (GPL-3.0).

---

## [4.4.1] - 2026-10-12

### Añadido
- **Motor asíncrono (`Invoke-OmegaAsync`)**: todas las operaciones pesadas (diagnóstico, unidades, update check, detección de ECM, limpieza, restore point, startup manager, informe de hotfixes, tienda winget) corren en **runspaces de fondo**. La UI nunca se congela.
- **Overlay de carga no bloqueante (`Invoke-OmegaTaskAsync`)**: los pasos del overlay rotan de verdad mientras el trabajo pesado se ejecuta en segundo plano, con reloj en vivo y mensaje real leído desde archivo de progreso.
- **Errores visibles (`Show-OmegaTaskError`)**: cuando una tarea de botón falla (sync o async), ahora se muestra un diálogo con tipo de excepción, código HResult y detalle — además del registro en el log.
- **Limpieza detallada con reporte por ubicación**: cada limpieza indica exactamente qué eliminó — por cada path: número de archivos y MB liberados + total general.
- **`Invoke-OmegaHiddenCmd`**: helper para lanzar comandos nativos (`ipconfig`, `netsh`, `powercfg`, `takeown`, `icacls`) sin ventanas de consola. Compatible con `ps12exe -noConsole`.
- **Modo Watchdog**: si una tarea asíncrona excede su límite de tiempo, el overlay se cierra forzosamente y se libera la UI.

### Cambiado
- **CPU idle**: reducido de 66-75 % a **menos del 10 %** en gráficos modestos. Las 5 ventanas WPF (principal, carga, tienda, compartir, manual) ahora usan `AllowsTransparency="False"` — sin layered window = sin coste de composición.
- **Cold start**: reducido **casi a la mitad** en hardware modesto. Medido en Celeron N3350: **61.35 s → 33.61 s (-45.2 %)**.
- **Consistencia de arranque**: la varianza bajó **-74 %** (σ ±22.03 s → ±5.74 s). El arranque ahora es predecible.
- **`Get-HotFix` → registro CBS** para el informe de actualizaciones. De 8-11 s (medido en N3350) a **<0.5 s**.
- **`SystemProfile`** por `Test-Path` a System32 en vez de `Get-Command` — **10× más rápido** (~0.6 s ahorrado).
- **`Win32_OperatingSystem` eliminado** del perfil inicial — el registro ya provee `ProductName`, `DisplayVersion`, `Build` y `UBR`.
- **Favicons de la tienda** a 44/96 px (`DecodePixelWidth`) en vez de 128/256 px — menos RAM y menos CPU de decodificación.
- **Logo de carga** decodificado una sola vez y cacheado con `Freeze()`.
- **Brushes con `Freeze()`** y `GC.Collect()` tras diagnóstico/limpieza para liberar memoria.

### Corregido
- **🛒 Winget Live — panel de detalle**: el bug crítico de V4.4 está **resuelto**. Al hacer clic en una tarjeta de resultado de la búsqueda en vivo, el panel de detalle ahora se abre correctamente. El fallo estaba en el fallback del icono, que escribía `.Text` sobre un control `<Image>`.
  - Fallback de icono ahora distingue entre `TextBlock` e `Image`.
  - `Show-OmegaAppDetailFn` blindada con try/catch + error visible.
  - Soporte completo para `PSCustomObject` **y** `hashtable` en el panel de detalle.
  - Los resultados live heredan la descripción del catálogo curado.
  - `winget list` ya no bloquea la apertura de la tienda: la caché se calienta en segundo plano y se re-renderiza al terminar.
- **Bug de Limpieza 1-Clic**: en V4.4 reportaba como "eliminados" los GB de basura **restante** (medidos después de borrar). Ahora mide **antes** de borrar y reporta los GB realmente liberados.
- **Runspaces de fondo cancelados al cerrar la ventana** — sin hangs al salir de la app.
- **Hilos y handles residuales** liberados tras cada tarea asíncrona.

### Licencia
- Distribuido bajo la licencia GNU General Public License v3.0 (GPL-3.0).

---

## [4.4] - 2026-10-03

### Añadido
- **Logo embebido** en pantalla de carga (Base64 PNG transparente, sin dependencias externas).
- **Emblema OmegaSolver** en el encabezado del manual de usuario.
- **Emojis contextuales** en los ítems del manual según su función: 🔧 reparación, 🔍 escaneo/diagnóstico, 🗑️ limpieza, 🌐 red, 🛡️ seguridad, 💾 disco, ⚡ rendimiento, 🧹 mantenimiento, 📁 compartir, 🔄 actualizar, 🔒 bloqueados, ⚙️ controladores.
- **Botones de actualización** con icono refresh (🔄) en lugar de la flecha ASCII `<-`.
- **Flecha Unicode ↔** en las descripciones de métodos de transferencia (Robocopy / FTP) para evitar corrupción de caracteres.
- **Tema Gradiente (Uzi Post-Cyn)** reparado con símbolo Unicode limpio (`⚪`) consistente con el resto de sub-paletas.

### Cambiado
- **Compilador migrado de PS2EXE a PS12EXE** (v0.6.9+). Ahora el proyecto requiere **PowerShell 7.x** como entorno de compilación.
- **Firma digital con SHA256 + Timestamp DigiCert** aplicada después de la compilación, evitando bugs del sub-intérprete de ps12exe con `SecureString`.
- **Codificación estricta UTF-8 con BOM** en todos los archivos `.ps1` para preservar acentos, eñes y caracteres especiales al compilar.
- **Función `Get-OmegaString`** reescrita con acceso seguro por índice en lugar de `.ContainsKey()`, evitando crashes por conversión de hashtables a `PSCustomObject` durante el empaquetado.
- **Funciones de idioma** (`Get-OmegaLanguage`, `Save-OmegaLanguage`, `Apply-OmegaLanguage`) restauradas tras haber sido eliminadas por scripts de procesamiento agresivos.

### Corregido
- **Crashes al abrir** causados por funciones de idioma faltantes en el script principal.
- **Mojibake** en el manual de usuario (tildes corruptas → caracteres Unicode válidos).
- **XML malformado** en la ventana de Compartir Archivos por Red (caracteres `<` y `>` sin escapar).
- **Placeholders residuales** (`Search`, `Web`, `Cart`, `Dev`) eliminados de las cadenas i18n ES/EN/PT.
- **Asteriscos flotantes** en títulos de manual, badges y prefijos de ítems reemplazados por símbolos ASCII/Unicode limpios.

### Conocido (resuelto en 4.4.1)
- ~~**Winget Live**: al hacer clic en una tarjeta de resultado de la búsqueda en vivo, no se abre el panel de detalle.~~ **Corregido en 4.4.1.**

### Licencia
- Distribuido bajo la licencia GNU General Public License v3.0 (GPL-3.0).

---

## [4.3] - 2026

### Añadido
- Firma digital integrada con certificado público `.cer` disponible en el repositorio.
- Compilado optimizado mediante PS2EXE.
- Reparación automatizada para fallos de Windows Update en Windows 10 y 11.
- Limpieza profunda del almacén de componentes `WinSxS`.

### Mejoras
- Optimización del procesamiento de archivos temporales del sistema y de usuario.
- Mejoras de rendimiento en la ejecución de scripts PowerShell base.

### Licencia
- Distribuido bajo la licencia GNU General Public License v3.0 (GPL-3.0).

---

## [4.2] - 2026

### Añadido
- Tema visual "OMEGASOLVER style" con 6 sub-paletas neón.
- Custom Chrome (barra de título personalizada sin decoración nativa).
- Layout balanceado en Modo Básico (2 columnas).
- Instancia única (Mutex).

### Mejoras
- Enumeración rápida de archivos (10-50x más rápido).
- Detección DPI con triple fallback.

---

## [4.0] - 2026

### Añadido
- Interfaz WPF completa con 17 temas visuales.
- Manual de usuario bilingüe adaptativo.
- Protección SSD (bloqueo de desfragmentación en discos sólidos).
- Sistema de reversión de cambios.

---

## [3.9] y anteriores
Ver releases previas en el repositorio.
