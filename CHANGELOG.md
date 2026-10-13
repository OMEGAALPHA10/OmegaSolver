# Historial de Cambios - OmegaSolver

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
