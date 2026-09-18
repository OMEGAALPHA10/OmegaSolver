# ⚡ OmegaSolver V4.0

[![Versión](https://img.shields.io/badge/versi%C3%B3n-V4.0-blue)](https://github.com/OMEGAALPHA10/OmegaSolver/releases/latest)
[![Plataforma](https://img.shields.io/badge/plataforma-Windows%2010%20%7C%2011-0078D4)](https://www.microsoft.com/windows)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%20%7C%207.x-blue)](https://microsoft.com/powershell)
[![PS2EXE](https://img.shields.io/badge/compilado%20con-PS2EXE-purple)](https://github.com/MScholtes/PS2EXE)
[![Licencia](https://img.shields.io/badge/licencia-MIT-green)](LICENSE)
[![Estado](https://img.shields.io/badge/estado-estable-success)](https://github.com/OMEGAALPHA10/OmegaSolver/releases/latest)

**OmegaSolver V4.0** es una suite gráfica (GUI) desarrollada en **PowerShell + WPF** y compilada a `.exe` mediante **PS2EXE**. Diseñada para simplificar el diagnóstico, mantenimiento profundo y optimización integral de sistemas Windows, combina herramientas nativas en una interfaz moderna con **17 temas visuales**, **Doble Modo (Básico y Avanzado)**, **Manual Adaptativo Bilingüe**, **Protección Automática para SSD** y un **Sistema de Reversión de Cambios**.

---

## ✨ Novedades y Características Principales (V4.0)

### 🎯 Doble Modo de Uso
- **Modo Básico** (predeterminado): Interfaz limpia con terminología accesible para usuarios sin experiencia técnica.
- **Modo Avanzado**: Habilita la consola de registro en vivo (*Live Logging*), indicadores técnicos explícitos y el panel de estadísticas del sistema.

### 🛡️ Detección Inteligente y Protección de SSD
- **Identificación de Hardware**: Detecta automáticamente la tecnología de almacenamiento (`SSD` o `HDD`).
- **Bloqueo Preventivo**: Inhabilita la opción de desfragmentación en unidades SSD para evitar ciclos de escritura innecesarios y proteger la vida útil del disco.

### 📖 Manual de Usuario Adaptativo (ES / EN)
- **Interfaz Bilingüe Integrada**: Ventana modal en español e inglés dentro de la propia aplicación.
- **Explicación Dinámica**: El manual ajusta sus descripciones y terminología dependiendo de si se consulta en Modo Básico o Modo Avanzado.

### 🎨 17 Temas Visuales
Cambio de apariencia en tiempo real con motor de renderizado WPF:
- **Temas disponibles**: Oscuro, Claro, Spotify Neon, GitHub Dark, Retro (verde fósforo), Twitter X, Discord, WhatsApp, entre otros.
- **Persistencia**: Recuerda la paleta seleccionada guardándola localmente en la configuración.

### 🔍 Diagnóstico Automático en Tiempo Real
- **Análisis de Residuos**: Mide el espacio acumulado en `%TEMP%`, `%SystemRoot%\Temp`, descargas de Windows Update, Delivery Optimization y cachés de navegadores Chromium (Edge y Chrome).
- **Lectura del Sistema**: Muestra espacio libre en disco, estado de alimentación (Batería vs. Corriente AC) y emite recomendaciones dinámicas personalizadas.

### 🛠️ Reparación y Mantenimiento Integrado
- **Reparación del Sistema**: Ejecución de **SFC** (`/scannow`), **DISM** (`/RestoreHealth` o `/StartComponentCleanup`) y **CHKDSK** (`/f`) con selector automático para instalaciones activas u offline.
- **Optimización de Red**: Vaciado de caché DNS (`ipconfig /flushdns`), restablecimiento de la pila TCP/IP/Winsock y liberación del límite de ancho de banda QoS (`NonBestEffortLimit = 0`).
- **Limpieza de Archivos**: Eliminación de temporales básicos, purgado de registros del Visor de Eventos (*EventLogs*) y limpieza profunda de componentes WinSxS (`/ResetBase`).
- **Reparación 1-Clic**: Ejecuta de forma automática una secuencia optimizada de diagnóstico, limpieza de red, purga de temporales y escaneo del sistema.

### 🔄 Sistema de Reversión de Cambios
Guarda el estado previo en `%ProgramData%\OmegaSolver\reversible-state.json` antes de realizar modificaciones críticas:
1. Plan de energía activo antes de aplicar "Alto Rendimiento".
2. Configuración de Hibernación y Fast Startup antes de la Limpieza Profunda.
3. Valor original del registro de QoS.
4. Estado de servicios del sistema (`wuauserv`, `FontCache`, `UsoSvc`).

---

## 📊 Comparativa de Ediciones y Evolución

| Característica / Función | 📦 V3.2.2 | ⚡ V3.9 / ALT | 🚀 V4.0 (Actual) |
|---|---|---|---|
| **Interfaz Gráfica** | Windows Forms | WPF (7 temas) | **WPF Avanzado (17 temas)** |
| **Protección SSD (TRIM)** | No | No | **Sí (Bloqueo automático de defrag en SSD)** |
| **Manual de Usuario** | No | No | **Sí (Integrado, Bilingüe ES/EN y Adaptativo)** |
| **Modos de Usuario** | Único | Doble | **Doble (Básico / Avanzado con Live Log)** |
| **Diagnóstico** | Manual | Estático | **Detección en tiempo real + Recomendaciones** |
| **Reversión de Cambios** | No | Incluido | **Incluido (`json` persistente)** |

---

## 📥 Instalación y Ejecución

### Opción 1 — Ejecución directa (Recomendado)

1. Descarga **`OmegaSolver V4.0.exe`** desde la sección [Releases](https://github.com/OMEGAALPHA10/OmegaSolver/releases/latest).
2. Haz clic derecho sobre el archivo → **Ejecutar como administrador**.
3. Acepta la solicitud de elevación de UAC.
4. La interfaz de OmegaSolver V4.0 se abrirá automáticamente.

> ⚠️ **Nota de Administrador:** El programa requiere permisos elevados para interactuar con servicios del sistema, registro y herramientas nativas (SFC/DISM/CHKDSK). Si se ejecuta sin elevación, el script solicitará permisos automáticamente.

### Opción 2 — Desde la consola

```cmd
"OmegaSolver V4.0.exe"
```

### Opción 3 — Verificación de integridad SHA256

```powershell
Get-FileHash "OmegaSolver V4.0.exe" -Algorithm SHA256
```

---

## 📋 Requisitos del Sistema

- **Sistema Operativo**: Windows 10 (build 1809 o superior) o Windows 11 (64-bit).
- **Entorno**: .NET Framework 4.7.2 o superior (incluido en Windows actualizado).
- **Permisos**: Privilegios de Administrador.
- **Dependencias**: No requiere instalación previa de PowerShell (el ejecutable `.exe` incluye el runtime empaquetado).

---

## 🗂️ Estructura de Archivos Generados

```
%ProgramData%\OmegaSolver\
├── reversible-state.json    # Estado guardado para la reversión de cambios
└── theme.txt                # Preferencia del tema visual seleccionado
```

OmegaSolver es **100% offline y privado**: no recolecta, transmite ni envía telemetría a servidores externos.

---

---

## 🗂️ Historial de Versiones

| Versión | Estado | Descripción |
|---|---|---|
| **V4.0** | ✅ Release Estable | WPF completo, 17 temas, manual bilingüe adaptativo, protección SSD y diagnósticos en vivo. |
| **V3.9 / ALT** | 📦 Versión Anterior | Introducción de WPF, 7 temas visuales, doble modo y sistema de reversión. |
| **V3.2.2** | 📦 Legacy | Mantenimiento profundo y desbloqueo de QoS en Windows Forms. |
| **V3.0.0** | 📦 Legacy | Interfaz gráfica inicial en Windows Forms (OmegaOpti + OmegaFix). |
| **V2.0** | 🧪 Antecedente | Scripts empaquetados WinSuite (.exe / .bat). |

---

## 🧑‍💻 Autoría y Créditos

- **Desarrollador Principal:** OMEGA_ALPHA
- **Colaboración y Optimización:** Gemini & DeepSeek
- **Propósito:** Ofrecer herramientas transparentes, potentes y gratuitas de mantenimiento para la comunidad.

---

## 🤝 Contribuciones y Licencia

Las contribuciones son bien recibidas. Puedes abrir un *Issue* o enviar un *Pull Request* en el repositorio oficial.

Este proyecto se distribuye bajo la **Licencia MIT**. Consulta el archivo [LICENSE](LICENSE) para más detalles.
---

# 🚀 Última versión: OmegaSolver V3.9 (Edición Estándar & ALT)

La versión V3.9 se distribuye en dos variantes oficiales: la versión **Estándar** (mantenimiento profundo completo) y la versión **ALT** (optimizada para máxima estabilidad y prevención de inestabilidad del sistema).

## 📊 Comparativa de versiones: ¿Cuál elegir?

| Característica / Función | ⚡ V3.9 (Estándar) | 🛡️ V3.9 ALT (Edición Recomendada) |
|---|---|---|
| **Punto de Restauración Automático** | Manual | **Automático** (`Checkpoint-Computer` previo a reparaciones) |
| **Mantenimiento WinSxS** | Profundo (`/ResetBase`) | **Seguro** (Preserva la capacidad de desinstalar actualizaciones) |
| **Manejo de Caché de Fuentes** | Modificación en registro | **Reinicio seguro de servicio** (`Restart-Service -Name FontCache`) |
| **Verificación de Reinicio Pendiente** | No | **Sí** (Detecta `RebootPending` / `RebootRequired` antes de limpiar) |
| **Interfaz y Temas Visuales** | 7 temas + Doble Modo | 7 temas + Doble Modo |
| **Sistema de Reversión de Cambios** | Incluido (`json`) | Incluido (`json`) |

---

## ✨ Características principales

### 🎯 Doble modo de uso
- **Modo Básico** (predeterminado): interfaz limpia con nombres simples para usuarios sin experiencia técnica. Oculta estadísticas y registro.
- **Modo Avanzado**: activable con el checkbox superior derecho. Muestra nombres técnicos, panel de estadísticas y registro de actividad en tiempo real.

Los botones mantienen **la misma funcionalidad completa** en ambos modos; solo cambia la etiqueta visible.

### 🎨 7 temas visuales
Cambia el aspecto en tiempo real sin reiniciar:

| Tema | Paleta |
|---|---|
| **Oscuro** | Tema por defecto (azul/negro) |
| **Claro** | Alto contraste para entornos iluminados |
| **GitHub** | Inspirado en GitHub Dark |
| **Retro** | Verde fósforo sobre negro |
| **Twitter X** | Negro puro + azul oficial `#1D9BF0` |
| **Discord** | Blurple `#5865F2` sobre gris oscuro |
| **WhatsApp** | Verde `#00A884` sobre fondo teal |

El tema elegido se **persiste** en `%ProgramData%\OmegaSolver\theme.txt`.

### 🔄 Sistema de reversión de cambios
Antes de cada modificación, guarda el estado original en `%ProgramData%\OmegaSolver\reversible-state.json`:

1. Plan de energía activo antes de aplicar "Alto Rendimiento".
2. Hibernación e Inicio rápido antes de la Limpieza Profunda.
3. Valor original de QoS (`NonBestEffortLimit`).
4. Estado de servicios (`wuauserv`, `FontCache`, `UsoSvc`).

El botón **"Revertir cambios"** restaura exactamente lo que se guardó.

### 🔍 Diagnóstico inteligente
- Analiza tamaño de `%TEMP%`, `%SystemRoot%\Temp`, descargas de Windows Update, caché de Delivery Optimization, cachés de Edge y Chrome.
- Nivel orientativo de residuos (5 GB = 100%).
- Espacio libre del disco del sistema.
- Estado de alimentación (batería / corriente).
- Genera recomendaciones personalizadas (en la versión ALT incluye detección de reinicios pendientes).

### 🛠️ Reparación completa
- **SFC** (`/scannow`) online u offline según disco seleccionado.
- **DISM** (`/RestoreHealth` o `/StartComponentCleanup`) online u offline.
- **CHKDSK** (`/f`) en cualquier volumen.
- **Reparación 1-Clic** que combina todo lo anterior + limpieza profunda.

### 🌐 Red y conexión
- Limpieza de caché DNS.
- Restablecimiento de Winsock / IP.
- Ajuste de límite QoS (`NonBestEffortLimit = 0`).

### 🧹 Mantenimiento
- Limpieza de temporales básicos.
- Limpieza profunda (Windows Update, cachés Chromium, residuos de instaladores, papelera).
- Limpieza avanzada de Logs + WinSxS.
- Liberador de espacio nativo (`cleanmgr /sagerun:1`).

### 💽 Selector de disco inteligente
Detecta automáticamente todas las unidades y su rol:

- **Windows activo** (SFC/DISM online).
- **Windows offline** (SFC/DISM en modo offline).
- **Volumen de datos** (solo CHKDSK aplica).

---

## 📥 Instalación de la V3.9 / V3.9 ALT

### Opción 1 — Ejecución directa (recomendado)

1. Descarga **`OmegaSolver V3.9.exe`** o **`OmegaSolver V3.9 ALT.exe`** desde la sección [Releases](https://github.com/OMEGAALPHA10/OmegaSolver/releases/latest).
2. Guarda el archivo en cualquier carpeta (por ejemplo, el Escritorio).
3. **Clic derecho → Ejecutar como administrador**.
4. Acepta la solicitud de elevación de UAC.
5. Listo. La ventana de OmegaSolver se abrirá automáticamente.

> ⚠️ **Importante:** el `.exe` requiere permisos de administrador para modificar el registro, servicios y ejecutar SFC/DISM/CHKDSK. Si lo ejecutas sin permisos de admin, el propio programa te pedirá elevación.

### Opción 2 — Desde consola

cmd
"OmegaSolver V3.9 ALT.exe"

### Opción 3 - verificar integridad 

powershell
Get-FileHash "OmegaSolver V3.9 ALT.exe" -Algorithm SHA256

---

🛡️ Nota sobre antivirus y SmartScreen
Como el .exe está generado con PS2EXE, algunos antivirus pueden mostrar falsos positivos al ejecutarlo por primera vez. Esto es un comportamiento habitual en ejecutables PowerShell empaquetados. Si Windows SmartScreen lo bloquea:

Clic en "Más información".

Clic en "Ejecutar de todos modos".

Si tu antivirus lo pone en cuarentena, añade una exclusión para el archivo o la carpeta donde lo guardaste.

📋 Requisitos
Windows 10 (build 1809 o superior) o Windows 11 (64-bit).

.NET Framework 4.7.2 o superior (incluido por defecto en Windows actualizado).

Permisos de administrador (para modificar registro, servicios y ejecutar SFC/DISM/CHKDSK).

No requiere instalar PowerShell — el ejecutable lleva embebido el runtime.

⚠️ Advertencias importantes
🔴 Ejecuta siempre como administrador. Varias funciones modifican el registro y servicios del sistema.

🔴 La limpieza de WinSxS con /ResetBase (solo en edición V3.9 Estándar) es irreversible. Impide desinstalar actualizaciones anteriores de Windows. Si buscas mayor seguridad, utiliza la edición V3.9 ALT.

🔴 "Revertir cambios" no recupera archivos eliminados. Solo restaura configuración guardada de servicios y registro.

🟡 Cierra juegos y programas pesados antes de ejecutar rutinas de limpieza.

🟡 Haz copia de seguridad o un punto de restauración antes de aplicar cambios masivos (automatizado en la versión ALT).

---

## 🗂️ Estructura de archivos generados

```
%ProgramData%\OmegaSolver\
├── reversible-state.json   # Estado guardado para reversión
└── theme.txt                # Tema visual seleccionado
```

Ninguno de estos archivos sale del equipo. OmegaSolver **no envía telemetría ni datos a Internet**.

---

🔐 Privacidad
OmegaSolver no recolecta, transmite ni comparte ningún dato del usuario. Toda la información del sistema se muestra localmente en la interfaz y nunca se envía a servidores externos.

---

## 🗂️ Historial de versiones

| Versión | Tipo | Destacado |
|---|---|---|
| **V3.9 & R.9 ALT** | ✅ Release estable | 7 temas, Modo Básico/Avanzado, correcciones |
| V3.3 – V3.8 | ⚠️ Pre-release (histórico) | Reversión, diagnóstico inteligente, selector de disco |
| V3.2.2 | 📦 Versión anterior | Mantenimiento profundo y desbloqueo QoS |
| V3.0.0 | 📦 Stable Release | Windows Forms, OmegaOpti + OmegaFix |
| V2.0 | 🧪 Betas | WinSuite v3 (.exe) y .bat |

Consulta el [CHANGELOG](CHANGELOG.md) para más detalle.

---

## 🧰 Compilación desde el código fuente

Si prefieres compilar el `.exe` tú mismo a partir del script `.ps1`:

1. Instala el módulo **PS2EXE** desde PowerShell (como administrador):

   ```powershell
   Install-Module -Name ps2exe -Scope CurrentUser -Force
   ```

2. Ejecuta el comando de compilación:

   ```powershell
   Invoke-PS2EXE -InputFile "OmegaSolver V3.9.ps1" `
                 -OutputFile "OmegaSolver V3.9.exe" `
                 -NoConsole `
                 -Title "OmegaSolver V3.9" `
                 -Description "Diagnóstico, mantenimiento y optimización de Windows" `
                 -Company "OMEGA ALPHA" `
                 -Product "OmegaSolver" `
                 -Version "3.9.0.0" `
                 -RequireAdmin `
                 -x64
   ```

3. El archivo `OmegaSolver V3.9.exe` aparecerá en la misma carpeta.

> 💡 El flag `-NoConsole` oculta la ventana de consola de PowerShell para que solo se vea la GUI.
> El flag `-RequireAdmin` hace que el `.exe` pida elevación automáticamente mediante un manifiesto embebido.

si usaras la version ALT, solo recuerda colocar "ALT" justo despues de la version.

---

# 📦 Versiones anteriores

## ⚡ OmegaSolver V3.2.2

**OmegaSolver** es una herramienta gráfica (GUI) desarrollada en PowerShell y WPF diseñada para simplificar el diagnóstico, mantenimiento profundo y optimización de red en sistemas Windows.

![OmegaSolver GUI](https://raw.githubusercontent.com/OMEGAALPHA10/OmegaSolver/main/preview.png) <!-- Reemplaza con la ruta de una captura de tu interfaz si la tienes -->

---

### 🌟 Características Principales

#### 🛠️ Diagnostic & Sistema
* **SFC /Scannow:** Escaneo y reparación de archivos dañados del sistema.
* **DISM /RestoreHealth:** Reparación de la imagen base de Windows.
* **CHKDSK:** Diagnóstico y verificación del estado del disco duro.

#### 🌐 Red y Conexión
* **Limpieza DNS:** Vaciado de la caché DNS (`ipconfig /flushdns`).
* **Reset de Red:** Restablecimiento de sockets Winsock e IP.
* **🚀 Desbloqueo de Ancho de Banda QoS:** Ajusta el *Límite de ancho de banda reservable* al `0%` directamente en el registro (`HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched`) para liberar la reserva del sistema.

#### 🚀 Mantenimiento & Limpieza Profunda
* **Limpieza de Windows Update:** Vaciado seguro de descargas temporales (`SoftwareDistribution\Download`).
* **Depuración WinSxS:** Eliminación de componentes antiguos e innecesarios (`DISM /StartComponentCleanup /ResetBase`).
* **Depuración de Temporales:** Limpieza de registros CBS, cachés de navegadores Chromium (Edge / Chrome) y archivos temporales de usuario/sistema.
* **Papelera y Mantenimiento:** Vaciado automático de la Papelera de Reciclaje y ejecución del Liberador de Espacio nativo (`cleanmgr`).

#### ⚡ Reparación 1-Clic
* Ejecución automatizada en secuencia: **Flush DNS ➡️ Limpieza Profunda ➡️ Análisis SFC**.

---

## OmegaSolver v3.0 - Centro de Mantenimiento Avanzado

¡Bienvenido a OmegaSolver! Una suite de optimización, limpieza y reparación profunda de Windows diseñada en PowerShell y estructurada bajo una interfaz gráfica interactiva utilizando Windows Forms. Este es un proyecto de código abierto enfocado en brindar transparencia técnica total tanto a usuarios comunes como a administradores de sistemas.

---

### 🚀 Módulos y Características Principales

El Toolkit se divide en dos grandes enfoques operativos basados en scripts híbridos avanzados:

| Módulo | Operación Técnica | Beneficio Real |
|---|---|---|
| OmegaOpti (Limpieza) | Purgado de Temporales, Caché DNS, Prefetch y Papelera de Reciclaje | Libera gigabytes de almacenamiento residual de forma inmediata. |
| OmegaOpti Advanced | Mantenimiento Multidisco Automatizado (D:, E:, etc.) | Escanea de forma inteligente unidades secundarias para vaciar carpetas $Recycle.Bin. |
| OmegaFix (Reparación) | Verificación SFC, Reparación de Imagen DISM y Reseteo Winsock/IP | Soluciona archivos corruptos del sistema y restablece la pila de red ante fallas. |
| OmegaFix 1-Clic | Diagnóstico Integral Secuencial Automatizado | Ejecuta todo el protocolo de reparación en un solo bloque con reportes en tiempo real. |

---

### 🛠️ Requisitos Técnicos de Ejecución

Debido a que las herramientas nativas modifican registros y dependencias del sistema, el script cuenta con las siguientes políticas:

1. **Privilegios de Administrador Obligatorios:** El script incluye un sistema de auto-elevación nativo. Si no se ejecuta con privilegios elevados, solicitará de forma transparente el Control de Cuentas de Usuario (UAC).
2. **Registro en Tiempo Real (Live Logging):** Todas las acciones se imprimen en una terminal interactiva dentro de la interfaz y se guardan localmente para auditorías.

---

### ⚠️ Advertencias y Seguridad Técnica

* **Uso de DISM:** La velocidad de reparación de la imagen del sistema dependerá directamente del tipo de hardware del usuario (unidades SSD procesarán el cambio de forma veloz, mientras que unidades HDD mecánicas tomarán notablemente más tiempo).
* **Análisis de Disco (CHKDSK):** Al solicitar un examen en la unidad activa C:, el script programará de forma segura la revisión interactiva para el próximo reinicio del sistema operativo.
* **Seguridad de Código:** Al ser Open Source, puedes revisar cada línea antes de presionar el botón de inicio. El software cuenta con una capa de confirmación previa antes de alterar cualquier archivo.

---

## 🧑‍💻 Autor del Proyecto

* **Desarrollador Principal:** OMEGA_ALPHA
* **Edad de inicio del desarrollo:** 16 años
* **Propósito:** Crear herramientas libres, transparentes y potentes para la comunidad.

[![Descargar OmegaSolver](https://shields.io)](https://github.com/OMEGAALPHA10/OmegaSolver/releases/latest)

---

## 🤝 Contribuir

Las contribuciones son bienvenidas. Abre un issue o un pull request.

---

## ⚖️ Licencia

Este proyecto está registrado bajo la **Licencia MIT**. Eres libre de usar, modificar y distribuir este software siempre y cuando mantengas los créditos del autor original. Consulta el archivo [LICENSE](LICENSE) para ver los términos legales de exención de responsabilidad.

---

## 🙏 Agradecimientos

A todos los usuarios que probaron las versiones V2.0 → V3.8, reportaron bugs y sugirieron mejoras. Este release estable es el resultado directo de ese feedback.

---

## 🔗 Enlaces rápidos

- 📦 [Última versión (V3.9)](https://github.com/OMEGAALPHA10/OmegaSolver/releases/latest)
- 🗃️ [Todas las releases](https://github.com/OMEGAALPHA10/OmegaSolver/releases)
- 📄 [CHANGELOG](CHANGELOG.md)
- 🐛 [Reportar un bug](https://github.com/OMEGAALPHA10/OmegaSolver/issues)
