# ⚡ OmegaSolver V4.4

**OmegaSolver** es una suite gráfica (GUI) de diagnóstico, mantenimiento y optimización para Windows, desarrollada íntegramente en **PowerShell + WPF** y compilada a `.exe` mediante **PS12EXE**. Diseñada para simplificar tareas técnicas complejas sin sacrificar la potencia para usuarios avanzados.

> 🇻🇪 Proyecto personal de código abierto desarrollado desde Venezuela.

---

## 🛠️ Código Abierto y Compilación Universal

Los scripts en PowerShell se encuentran organizados dentro de la carpeta [`open source`](open%20source). Para transformar manualmente los archivos `.ps1` en ejecutables `.exe` independientes utilizando la terminal de Windows en cualquier versión actual o futura del proyecto, sigue estos pasos:

1. **Instalar PowerShell 7+ y el compilador**: Abre una consola de PowerShell 7 como Administrador y ejecuta:

   ```powershell
   Install-Module -Name ps12exe -Scope CurrentUser -Force
   ```

2. **Compilar el script**:

   ```powershell
   ps12exe -inputFile "open source\OmegaSolver.ps1" `
           -outputFile "OmegaSolver.exe" `
           -App @{ Windowed = $true; VisualStyles = $true; DpiAware = $true } `
           -Os @{ Admin = $true; ModernOS = $true } `
           -Build @{ Platform = 'x64'; Target = 'Framework4.0'; Apartment = 'STA' } `
           -Resources @{
               Icon        = 'icon.ico'
               Title       = 'OmegaSolver V4.4'
               Description = 'OmegaSolver - Suite de diagnostico, mantenimiento y optimizacion para Windows.'
               Company     = 'OMEGA_ALPHA'
               Product     = 'OmegaSolver V4.4'
               Copyright   = '(c) 2026 OMEGA_ALPHA'
               Version     = '4.4.0.0'
           }
   ```

3. **Firmar el ejecutable** (requiere certificado `.pfx` propio):

   ```powershell
   $pfx = Read-Host "Contraseña del .pfx" -AsSecureString
   $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pfx)
   $plain = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
   [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
   $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2(
       (Resolve-Path "OmegaSolver_OMEGA_ALPHA.pfx").Path, $plain)
   Set-AuthenticodeSignature -FilePath "OmegaSolver.exe" `
       -Certificate $cert -HashAlgorithm SHA256 `
       -TimestampServer "http://timestamp.digicert.com"
   ```

---

## 🆕 Última versión: V4.4 — "Polish & Stability"

### 🖼️ Identidad visual reforzada

- **Logo embebido** en pantalla de carga (Base64, 100% offline, sin archivos externos).
- **Emblema OmegaSolver** en el encabezado del manual.
- **Emojis contextuales** en el manual: cada función identificada por su icono según su categoría.

### 📖 Manual de usuario mejorado

- **3 idiomas en paralelo** (ES / EN / PT) con dos niveles de explicación:
  - **`BAS`** — Amigable para usuarios sin experiencia técnica.
  - **`TEC`** — Técnica (parámetros, comandos, GUIDs, registro).
- **Emojis por función**:
  - 🔧 Reparación / recuperación
  - 🔍 Escaneo / diagnóstico (SFC, DISM, CHKDSK)
  - 💾 Almacenamiento / desfragmentación
  - ⚡ Rendimiento / energía
  - 🗑️ Limpieza de temporales
  - 🧹 Mantenimiento profundo
  - 🌐 Red / DNS / Internet
  - 🚀 Aceleración de red
  - 🛡️ Seguridad / punto de restauración / protección SSD
  - 📁 Compartir archivos
  - 🔄 Actualizaciones
  - 🔒 Archivos bloqueados
  - ⚙️ Controladores obsoletos

### 🎨 Compilación profesional

- **Migración a PS12EXE** (v0.6.9+): mejor manejo de scripts grandes y caracteres Unicode.
- **Codificación UTF-8 con BOM** estricta en todos los `.ps1`.
- **Firma digital SHA256 con Timestamp DigiCert** aplicada por separado.
- **Codificación segura de strings** para que acentos, eñes y emojis sobrevivan al empaquetado.

### 🔧 Estabilidad

- Reparación de crashes causados por funciones ausentes en el script compilado.
- Reescritura de la función `Get-OmegaString` con acceso seguro por índice.
- Eliminación de caracteres residuales (`*`, `<->`, `Search`, `Web`, `Cart`) en strings i18n y XAML.

### ⚠️ Bug conocido

- **Winget Live**: al hacer clic en una tarjeta de resultado de la búsqueda en vivo, no se abre el panel de detalle. La navegación por catálogo predefinido funciona correctamente.
- **Workaround**: navega por las categorías del catálogo (Navegadores, Utilidades, Desarrollo, etc.) en lugar de usar la búsqueda live.

---

## 🎨 Versión anterior: V4.3 — "Multilingual & Network"

### 🌐 Sistema multilenguaje (ES / EN / PT)

Menú desplegable en la barra superior para cambiar el idioma **en caliente, sin reiniciar**. Persiste en `%ProgramData%\OmegaSolver\language.txt`.

### 📖 Manual de usuario en 3 columnas

Ventana modal con los 3 idiomas en paralelo, dos niveles de explicación (`BAS` / `TEC`). Se adapta a Modo Básico o Avanzado.

### 📡 Compartir Archivos por Red (solo Modo Avanzado)

- **Robocopy / SMB** para PC a PC.
- **FTP** para móviles Android / iOS / Smart TV.
- Detección automática de IPs locales.
- Registro de progreso en vivo.

### 🔄 Auto-Update Checker (GitHub Releases)

Consulta la API de GitHub al iniciar. Si hay nueva versión → badge naranja. Si no hay red → aviso amigable sin bloquear.

### 🐢 Modo Low (bajos recursos)

Para PCs con hardware limitado. Desactiva efectos costosos y persiste entre sesiones.

### 🛠️ Herramientas inspiradas en Dism++

- Crear Punto de Restauración (`Checkpoint-Computer`).
- Gestionar Programas de Inicio (`Win32_StartupCommand`).
- Analizar Actualizaciones (`Win32_QuickFixEngineering`).
- Gestor de Archivos Bloqueados (`takeown + icacls`).
- Limpiar Controladores Obsoletos (`pnputil + DISM`).

---

## 📊 Tabla comparativa de versiones

| Característica | V4.0 | V4.2 | V4.3 | **V4.4** |
|---|:---:|:---:|:---:|:---:|
| Interfaz WPF moderna | ✅ | ✅ | ✅ | ✅ |
| Temas visuales | 17 | 17 + **OMEGA style (6 sub)** | 17 + **OMEGA style (6 sub)** | 17 + **OMEGA style (6 sub)** |
| Layout Básico / Avanzado | 3 col / 3 col | 2 col / 3 col | 2 col / 3 col | 2 col / 3 col |
| Protección SSD | ✅ | ✅ | ✅ | ✅ |
| Manual integrado | Bilingüe | Bilingüe | 3 idiomas + BAS/TEC | **3 idiomas + BAS/TEC + emojis** |
| Idiomas UI | ES | ES | ES / EN / PT | ES / EN / PT |
| Sistema de Reversión | ✅ | ✅ | ✅ | ✅ |
| Instancia única | ❌ | ✅ | ✅ | ✅ |
| Custom Chrome | ❌ | ✅ | ✅ | ✅ |
| Detección DPI robusta | Básica | Básica | Triple fallback | Triple fallback |
| Modo Low | ❌ | ❌ | ✅ | ✅ |
| Auto-Update (GitHub) | ❌ | ❌ | ✅ | ✅ |
| Compartir Archivos (Red) | ❌ | ❌ | ✅ | ✅ |
| Easy Context Menu | ❌ | ❌ | ✅ | ✅ |
| Herramientas Dism++ | ❌ | ❌ | ✅ | ✅ |
| Limpieza 1-Clic separada | ❌ | ❌ | ✅ | ✅ |
| **Logo embebido (Base64)** | ❌ | ❌ | ❌ | ✅ |
| **Emojis contextuales en manual** | ❌ | ❌ | ❌ | ✅ |
| **Compilación con PS12EXE** | ❌ | ❌ | ❌ | ✅ |
| **Codificación UTF-8 con BOM** | ❌ | ❌ | ❌ | ✅ |
| **Firma SHA256 + Timestamp** | ❌ | ❌ | ❌ | ✅ |

---

## 📥 Instalación y ejecución

### Opción 1 — Ejecución directa (recomendado)

1. Descarga **`OmegaSolver V4.4.exe`** desde la sección [Releases](https://github.com/OMEGAALPHA10/OmegaSolver/releases).
2. Clic derecho → **Ejecutar como administrador**.
3. Acepta la solicitud de elevación de UAC.

> ⚠️ **Nota de Administrador**: el programa requiere permisos elevados para interactuar con servicios, registro y herramientas nativas (SFC/DISM/CHKDSK).

### Opción 2 — Desde consola

```cmd
"OmegaSolver V4.4.exe"
```

### Opción 3 — Verificación de integridad SHA256

```powershell
Get-FileHash "OmegaSolver V4.4.exe" -Algorithm SHA256
```

---

## 🔐 Verificación de firma

### ¿Qué es el archivo `OmegaSolver.cer`?

Es la **clave pública** del certificado con el que se firman los ejecutables. Permite verificar que un `.exe` fue publicado legítimamente por **OMEGA_ALPHA** y no ha sido alterado desde su firma.

### Método gráfico (Windows)

Clic derecho sobre el `.exe` → **Propiedades** → pestaña **Firmas digitales**. Debe aparecer: **OMEGA_ALPHA**.

### Método técnico (PowerShell)

```powershell
Import-Certificate -FilePath "OmegaSolver.cer" `
                   -CertStoreLocation "Cert:\CurrentUser\TrustedPublisher"

Get-AuthenticodeSignature "OmegaSolver V4.4.exe" |
    Format-List Status, @{N='Firmado por';E={$_.SignerCertificate.Subject}}
```

Resultado esperado:

```
Status      : Valid
Firmado por : CN=OMEGA_ALPHA
```

---

## 📋 Requisitos del sistema

| Requisito | Detalle |
|---|---|
| **SO** | Windows 10 (build 1809+) o Windows 11 (64-bit) |
| **.NET Framework** | 4.7.2 o superior |
| **Permisos** | Administrador |
| **PowerShell** | No requiere instalación (runtime empaquetado en el `.exe`) |

---

## 🗂️ Estructura de archivos generados

```
%ProgramData%\OmegaSolver
├── reversible-state.json      # Estado para reversión de cambios
├── theme.txt                  # Tema visual seleccionado
├── omega-subcolor.txt         # Sub-paleta de OMEGA style
├── low-mode.txt               # Estado del Modo Low
├── language.txt               # Idioma seleccionado (ES/EN/PT)
└── omega-warning.ack          # Confirmación de advertencia OMEGA style
```

OmegaSolver es **100% offline y privado**: no recolecta ni transmite telemetría. La única conexión a internet es la comprobación de actualizaciones en GitHub (puedes ignorarla si no hay red).

---

## 🗂️ Historial de versiones

| Versión | Tipo | Destacado |
|---|---|---|
| **V4.4** | ✅ **Release actual** | Logo embebido, emojis contextuales en manual, PS12EXE, firma SHA256 |
| **V4.3** | 📦 Release estable | Multilenguaje ES/EN/PT, Easy Context Menu, Auto-Update, Compartir Archivos, Dism++ tools |
| **V4.2** | 📦 Release estable | OMEGA style (6 sub-paletas), Custom Chrome, layout balanceado |
| V4.1 / ALT | 📦 Histórico | Rediseño del layout, enumeración rápida |
| V4.0 | 📦 Histórico | WPF completo, 17 temas, manual bilingüe adaptativo |
| V3.9 y anteriores | 📦 Legacy | Windows Forms y scripts base |

Consulta el [CHANGELOG](CHANGELOG.md) para detalles completos.

---

## 🧑‍💻 Autoría

- **Desarrollador principal**: OMEGA_ALPHA
- **Colaboración técnica**: Gemini & DeepSeek
- **Filosofía del proyecto**: Herramientas libres, transparentes y gratuitas para la comunidad, con un enfoque especial en la **reversibilidad** de todos los cambios.

> *"El trabajo de limpieza y optimización nunca termina. Por eso, Omega — el inicio — y no Alpha — el final."*

---

## 🤝 Contribuciones

Las contribuciones son bienvenidas:

- 🐛 [Reportar un bug](https://github.com/OMEGAALPHA10/OmegaSolver/issues)
- 💡 [Sugerir una mejora](https://github.com/OMEGAALPHA10/OmegaSolver/issues)
- 🔧 Enviar un Pull Request

---

## ⚖ Licencia

Distribuido bajo **GNU General Public License v3 (GPLv3)**. Consulta [LICENSE](LICENSE) para los términos completos.

---

## 📢 Nota sobre el uso del código y atribución

Con base en los términos de la licencia **GNU GPLv3**, cualquier persona es libre de estudiar, modificar y redistribuir este software. Sin embargo, se **exige estrictamente** que:

1. Se mantengan intactos todos los encabezados de créditos y avisos de Copyright (`© OMEGA_ALPHA`).
2. Si el proyecto modificado incluye una interfaz gráfica, se debe conservar visible y accesible la atribución original al autor de OmegaSolver.

---

## 🔗 Enlaces rápidos

- 📦 [Última versión (V4.4)](https://github.com/OMEGAALPHA10/OmegaSolver/releases)
- 🗃️ [Todas las releases](https://github.com/OMEGAALPHA10/OmegaSolver/releases)
- 📄 [CHANGELOG](CHANGELOG.md)
- 🐛 [Reportar un bug](https://github.com/OMEGAALPHA10/OmegaSolver/issues)
