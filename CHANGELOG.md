# Historial de Cambios - OmegaSolver

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

### Conocido (pendiente para V4.4.1)
- **Winget Live**: al hacer clic en una tarjeta de resultado de la búsqueda en vivo, no se abre el panel de detalle de la app. La navegación normal por catálogo (categorías y tienda predefinida) funciona correctamente.

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
