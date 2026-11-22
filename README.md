<div align="center">

<img src="docs/screenshots/logo.png" alt="OmegaSolver" width="120">

# ⚡ OmegaSolver V5.0.0

**Suite gráfica nativa de diagnóstico, mantenimiento y optimización para Windows**

[![Versión](https://img.shields.io/badge/version-5.0.0-FFD400?style=for-the-badge&logo=windowsterminal&logoColor=black)](https://github.com/OMEGAALPHA10/OmegaSolver/releases)
[![Licencia](https://img.shields.io/badge/license-GPLv3-22C55E?style=for-the-badge&logo=gnu&logoColor=white)](https://www.gnu.org/licenses/gpl-3.0)
[![Plataforma](https://img.shields.io/badge/platform-Windows%2010%20%7C%2011-0078D4?style=for-the-badge&logo=windows&logoColor=white)](https://github.com/OMEGAALPHA10/OmegaSolver)
[![.NET](https://img.shields.io/badge/.NET-10%20%7C%20C%23-512BD4?style=for-the-badge&logo=dotnet&logoColor=white)](https://dotnet.microsoft.com/)

[![Stars](https://img.shields.io/github/stars/OMEGAALPHA10/OmegaSolver?style=flat-square&color=FFD400)](https://github.com/OMEGAALPHA10/OmegaSolver/stargazers)
[![Forks](https://img.shields.io/github/forks/OMEGAALPHA10/OmegaSolver?style=flat-square&color=FFD400)](https://github.com/OMEGAALPHA10/OmegaSolver/forks)
[![Issues](https://img.shields.io/github/issues/OMEGAALPHA10/OmegaSolver?style=flat-square&color=FB923C)](https://github.com/OMEGAALPHA10/OmegaSolver/issues)
[![Último commit](https://img.shields.io/github/last-commit/OMEGAALPHA10/OmegaSolver?style=flat-square&color=38BDF8)](https://github.com/OMEGAALPHA10/OmegaSolver/commits/main)

**🇻🇪 Proyecto personal de código abierto desarrollado desde Venezuela**

[📥 Instalar](#-instalación) · [⚡ Rendimiento](#-rendimiento-verificado) · [🔁 Arquitectura](#-de-powershell-a-c-qué-cambió-en-la-v5) · [✨ Características](#-última-versión-v500) · [🔐 Firma](#-verificación-de-firma) · [🛠️ Compilar](#-código-abierto-y-compilación) · [🤝 Contribuir](#-contribuciones)

</div>

---

**OmegaSolver** es una suite gráfica (GUI) de diagnóstico, mantenimiento y optimización para Windows. La **V5 es una reescritura nativa en C# (.NET 10 + WPF)**: un único `OmegaSolver.exe` autocontenido, **sin PowerShell ni .NET que instalar**, con la **misma interfaz, módulos y flujo** que la V4.4.4, pero con un arranque **2,1× más rápido** y aproximadamente **2,6× menos CPU** en el mismo equipo.

> [!IMPORTANT]
> **La V5 ya no necesita el ZIP modular.**
> La V4.4.4 era un árbol de 170 scripts `.ps1` que tenían que viajar junto al lanzador. La V5 es **un solo archivo**: descarga el **instalador** (recomendado) o el **`.exe` portátil** y listo. No hay `App.ps1`, ni `Core\`, ni `Features\`, ni lanzador intermedio.
>
> La **V4.4.4 sigue disponible** en [Releases](https://github.com/OMEGAALPHA10/OmegaSolver/releases) como referencia histórica. No se elimina ni se altera.

---

## 🌐 Página Web Oficial

Toda la información del proyecto está disponible en el sitio web oficial: capturas interactivas, historia, changelog, roadmap público, FAQ, guías de instalación y disponibilidad en 3 idiomas (ES / EN / PT).

### 👉 **[https://omegaalpha10.github.io/OmegaSolver/](https://omegaalpha10.github.io/OmegaSolver/)**

---

## ⚡ Rendimiento Verificado

> **Misma PC, misma carga y la misma tarea: la V4.4.4 (PowerShell) tardó ~27,4 s en abrir y la V5.0.0 ~12,9 s (−53 %, 2,1× más rápida). El tiempo de CPU hasta tener la ventana bajó de ~9,8 s a ~3,6 s (≈2,6× menos).**
>
> No es una estimación: se ejecutó el **`.exe` real de cada versión**, con permisos de administrador, cronometrando hasta que la ventana principal respondió. La V4.4.4 se copió a `%TEMP%` para no escribir nada dentro de su carpeta original.

### 🖥️ Equipo de prueba

| Componente | Especificación |
|---|---|
| **Procesador** | Intel(R) Celeron(R) CPU N3350 @ 1.10 GHz |
| **Núcleos lógicos** | 2 |
| **RAM instalada** | 4,00 GB · 2133 MHz |
| **Almacenamiento** | Disco mecánico de 58 GB (≈50 GB usados) |
| **Sistema operativo** | Windows 11 Pro · build 26200 |
| **Antivirus** | Microsoft Defender activo |
| **Carga del equipo** | Aplicaciones abiertas durante la prueba (editor, navegador, etc.) |

### 🔬 Metodología

1. Se ejecuta el **`.exe` oficial de cada versión**, no un script de prueba.
2. Sesión **elevada** (administrador).
3. Antes de cada corrida se cierran las instancias previas: el **mutex de instancia única** impediría abrir una segunda ventana.
4. El cronómetro va desde `Start-Process` hasta que existe una ventana `OmegaSolver V5.0.0` **que responde**.
5. RAM: *working set* tras 4 s de inactividad.
6. Se usa la **mediana de las ejecuciones válidas** para reducir el ruido del disco y del antivirus.

### 📊 Resultados

| Métrica | V4.4.4 (PowerShell) | **V5.0.0 (C#)** | Cambio |
|---|---:|---:|---:|
| **Arranque hasta la ventana** | ~27,4 s | **~12,9 s** | 🟢 **−53 % · 2,1× más rápido** |
| **CPU hasta la ventana** | ~9,8 s | **~3,6 s** | 🟢 **≈2,6× menos** |
| **RAM en reposo (4 s)** | ~216 MB | ~271 MB | 🟡 +25 % (+55 MB) |
| **Distribución** | 170 archivos (~1,5 MB) | **1 `.exe` (59,8 MB)** | ✅ Un solo archivo |
| **Dependencias** | PowerShell 5.1 + .NET Framework | **Ninguna** (runtime incluido) | ✅ Autocontenido |

```text
ARRANQUE HASTA LA VENTANA — misma PC (menor = mejor)
══════════════════════════════════════════════════════════════

  V4.4.4  ███████████████████████████████████████  27,4 s
  V5.0.0  ███████████████████                        12,9 s
          ╰───────────────────┬──────────────────╯
                              │
                      −53 % · 2,1× más rápida  ✅
```

### 🧠 ¿Por qué arranca más rápido?

- **La V4 interpretaba y cargaba**: *dot-sourcing* de 170 archivos `.ps1` en cada inicio y compilación del C# incrustado con `csc.exe` antes de dibujar la ventana.
- **La V5 ya está compilada**: el código nativo y el runtime de .NET viajan dentro del `.exe`; al abrirlo solo se carga y se muestra la ventana.
- **Menos fricción con el antivirus**: Defender ya no escanea 170 scripts en cada arranque; escanea un único binario firmado.

> [!NOTE]
> La RAM sube ~55 MB porque el proceso incluye el runtime nativo de WPF. Es un coste fijo y estable, no acumulativo; el arranque y la CPU son las métricas que más se notan en el uso diario. En un equipo con SSD la diferencia de tiempo se reduce, pero la ventaja de CPU y de distribución se mantiene.

---

## 🔁 De PowerShell a C#: qué cambió en la V5

La V5 **no es un rediseño**: es la misma aplicación, portada pieza por pieza a C#. La interfaz se conservó **píxel a píxel** (mismos paneles, botones, textos, temas y animaciones) porque el XAML se reutilizó como recurso incrustado, con los mismos marcadores `@@clave@@` que usaba la versión scripted.

| | **V4.4.4** | **V5.0.0** |
|---|---|---|
| **Lenguaje** | PowerShell 5.1 + C# incrustado | **C# nativo** |
| **Interfaz** | XAML en archivos del árbol | **XAML incrustado** en el `.exe` |
| **Entrega** | ZIP: lanzador + 170 archivos | **1 `.exe` autocontenido** |
| **Runtime** | PowerShell del sistema + .NET Framework | **.NET 10 incluido** |
| **Traducciones** | `strings.json` + parches | **738 claves × ES/EN/PT** |
| **Temas** | `themes.json` | **18 temas + 6 subpaletas** |
| **Instalación** | Extraer ZIP y ejecutar | **Instalador con modo completo o portátil** |
| **Firma** | Solo el lanzador `.exe` | **`.exe` + instalador firmados** |

### 🗂️ Estructura del proyecto

```text
OmegaSolverV5/
├── App.xaml / App.xaml.cs        arranque, mutex de instancia única, tema inicial
├── Cli.cs                        modos de consola (--version, --selftest, ...)
├── OmegaSolver.csproj            net10.0-windows · WPF · single-file
├── app.manifest                  requireAdministrator + DPI
├── icon.ico
├── Core/                         rutas, logs, i18n, temas, ajustes, perfil,
│                                 diario de cambios, restauración, scheduler,
│                                 hardware, diagnóstico, procesos, actualizaciones
├── UI/                           MainWindow + ventana de carga
├── Modules/
│   ├── Cleanup/                  motor y destinos de limpieza
│   ├── Store/                    tienda de apps (winget)
│   ├── Share/                    compartir archivos (Robocopy / FTP)
│   ├── Manual/                   manual detallado
│   └── Toolbox/                  operaciones de reparación, reporte de limpieza
├── Features/                     Ajustes, Office ODT, herramientas de uso rápido,
│                                 acciones rápidas, autolimpieza, botones propios,
│                                 tweaks, perfiles, políticas
├── Resources/
│   ├── Views/                    XAML incrustado (Settings, Office, Store, ...)
│   ├── strings.json / strings_v5.json
│   ├── themes.json               temas y subpaletas
│   ├── store_*.json              catálogo de la tienda
│   ├── manual_*.txt              manual básico/avanzado (3 idiomas)
│   ├── winutil_manual_*.txt      manual de herramientas de uso rápido
│   └── omega-*.b64               logos
├── scripts/                      publish, instalador, firma, winget, benchmark
└── installer/                    Inno Setup, licencia, notas, manifiestos winget
```

**68 archivos C#/XAML · ~13.700 líneas.** La lógica de Windows (SFC, DISM, CHKDSK, winget, Office ODT, puntos de restauración, red, registro) se ejecuta con APIs y procesos del sistema; PowerShell del sistema solo se usa para dos tareas puntuales (puntos de restauración y botones personalizados), nunca como dependencia de la app.

---

## ✅ Lo que se mantiene y lo que mejora frente a la V4.4.4

| Se mantiene igual | Mejora en la V5 |
|---|---|
| Interfaz, paneles y flujo de trabajo | Arranque 2,1× más rápido y ~2,6× menos CPU |
| Modo básico y modo avanzado | Un único `.exe`; sin ZIP ni árbol de scripts |
| Limpieza, reparación, red, tienda, Office, manual | Instalador con elección **completa / portátil** |
| Temas (18) y subpaletas (6) | Datos y ajustes más ordenados por modo |
| Idiomas ES / EN / PT | 738 claves por idioma, sin cadenas sueltas |
| Perfil Empresa / Hogar | Firma digital en `.exe` **y** en el instalador |
| Reversión de cambios reversibles | Reporte emergente tras cada limpieza |
| Botones personalizados y rutas propias | Herramientas de uso rápido también en modo básico |
| Sin telemetría ni cuentas | Integración con winget (manifiesto preparado) |

---

## ✨ Última versión: V5.0.0

### ⚡ Reescritura nativa en C#
- **Un único `OmegaSolver.exe` autocontenido** (59,8 MB): no requiere instalar PowerShell ni .NET.
- Misma interfaz WPF que la V4.4.4: mismos módulos, mismos botones, mismo flujo.
- Arranque ~2,1× más rápido y ~2,6× menos CPU en el mismo equipo.

### 📦 Instalador con dos modos
- **Instalación completa:** accesos directos, desinstalador, tareas de Windows y datos en `%ProgramData%\OmegaSolver`.
- **Versión portátil:** sin iconos ni tareas; los datos quedan en `OmegaSolver-data` junto al `.exe`, ideal para USB o pruebas.
- Se elige desde el propio asistente o con `/PORTABLE=1`.

### 🧰 Herramientas de uso rápido
- Menú por secciones con ajustes ON/OFF, disponible **tanto en modo básico como avanzado**.
- **Manual propio** integrado, pensado para quienes vienen de WinUtil.
- **Punto de restauración** antes de aplicar cambios.

### 🗑️ Limpieza transparente
- **Reporte emergente** tras cada limpieza: qué se eliminó, cuánto espacio y dónde.
- **Autolimpieza mejorada:** por intervalo, diaria a una hora fija o al iniciar Windows; cierre opcional de navegadores.
- Rutas personalizadas y botones propios (con argumentos, confirmación, orden y prueba).

### ⚙️ Ajustes rediseñados
- Menos ruido: idioma y tema siguen en la barra principal.
- Comportamiento, perfil, autolimpieza, rutas, botones personalizados y panel avanzado en un solo lugar.

### 🔧 Reparación y diagnóstico
- SFC, DISM, CHKDSK, desfragmentación y modo de alto rendimiento.
- Diagnóstico del equipo con recomendaciones personalizadas.
- Puntos de restauración, gestor de programas de inicio y gestor de archivos bloqueados.

### 🛒 Tienda y extras
- Tienda de apps sobre **winget** con catálogo y categorías.
- Instalador de **Office** con descarga oficial (365, LTSC 2024, 2021, 2019, 2016 y apps individuales).
- Compartir archivos entre PC y móvil por red local (Robocopy / FTP).
- Limpieza de controladores obsoletos y herramientas de red (DNS, Winsock, QoS).

### 🌐 Idiomas y temas
- **Español, English y Português** (738 claves por idioma).
- **18 temas** y **6 subpaletas** de OMEGASOLVER style.

---

## 📥 Instalación

### Opción 1 — Instalador (recomendada)

1. Descarga **`OmegaSolver-Setup-5.0.0.exe`** desde [Releases](https://github.com/OMEGAALPHA10/OmegaSolver/releases/tag/v5.0.0).
2. Ejecútalo y acepta el UAC (la app requiere administrador).
3. Elige **Instalación completa** o **Versión portátil** y sigue el asistente.

Instalación silenciosa (para despliegues):

```bat
OmegaSolver-Setup-5.0.0.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
```

Modo portátil directo desde el instalador:

```bat
OmegaSolver-Setup-5.0.0.exe /PORTABLE=1
```

### Opción 2 — Portátil (un solo archivo)

1. Descarga **`OmegaSolver.exe`**.
2. Colócalo en una carpeta escribible (USB, Documentos, etc.).
3. Ejecútalo; creará `OmegaSolver-data` a su lado.

No necesita instalación, ni permisos de escritura en `Program Files`, ni el ZIP de la V4.

### Opción 3 — winget (pendiente de aprobación)

El manifiesto ya está preparado y validado (`OmegaAlpha10.OmegaSolver`, versión 5.0.0). Cuando sea aprobado en `microsoft/winget-pkgs`:

```powershell
winget install OmegaAlpha10.OmegaSolver
```

> [!NOTE]
> Hasta que el PR sea aprobado, `winget` no encontrará el paquete. Usa el instalador o el `.exe` portátil.

### Verificar integridad

Descarga también **`SHA256SUMS.txt`** desde la release y compara:

```powershell
Get-FileHash .\OmegaSolver-Setup-5.0.0.exe -Algorithm SHA256
Get-FileHash .\OmegaSolver.exe -Algorithm SHA256
```

| Archivo | Tamaño | SHA-256 |
|---|---:|---|
| `OmegaSolver-Setup-5.0.0.exe` | 57.778.968 B | `037C6E087D25148B42EA61E71FC5C237D6A5950CF0B4374A78EC4FCE76A07528` |
| `OmegaSolver.exe` | 62.705.520 B | `321A46DEDEC68AA9820002953EFEB54AA2AE96EF1E136178BE0A6E455819F1A8` |

> `SHA256SUMS.txt` incluye además el hash de `OmegaSolver-5.0.0-source.zip`. Los hashes corresponden a los binarios **ya firmados**: si firmas o recompilas por tu cuenta, cambian.

---

## 🔐 Verificación de firma

Ambos ejecutables están firmados con Authenticode (SHA-256) y sellados con timestamp:

| Dato | Valor |
|---|---|
| **Firmante** | `CN=OMEGA_ALPHA` |
| **Huella (SHA-1)** | `8FBA8DB7360958B573834E576E0F7439EB9C9FD7` |
| **Válido hasta** | 2029-09-22 |
| **Estado** | `Valid` en `.exe` y en el instalador |

Comprobación rápida:

```powershell
Get-AuthenticodeSignature .\OmegaSolver.exe | Format-List Status, SignerCertificate
Get-AuthenticodeSignature .\OmegaSolver-Setup-5.0.0.exe | Format-List Status, SignerCertificate
```

También puedes verlo desde el Explorador: clic derecho → **Propiedades** → **Firmas digitales**.

> [!WARNING]
> El certificado es **autofirmado**. La firma es criptográficamente válida, pero Windows puede mostrar **SmartScreen / "editor desconocido"** porque no hay reputación ni cadena hacia una CA pública. Eso no significa que el archivo esté alterado: comprueba el SHA-256 y, si quieres, importa `OmegaSolver.cer` en **Entidades de certificación raíz de confianza**.
>
> La firma cubre el `.exe` y el instalador. El código fuente no va firmado: descarga siempre desde este repositorio o desde Releases oficiales.

---

## 🖥️ Requisitos

| Requisito | Detalle |
|---|---|
| **Sistema operativo** | Windows 10 (build 17763 / 1809 o superior) o Windows 11 |
| **Arquitectura** | x64 |
| **Permisos** | Administrador (la app lo solicita al arrancar) |
| **Runtime** | **Ninguno**: .NET 10 va incluido en el `.exe` |
| **PowerShell** | No hay que instalarlo (Windows ya trae 5.1 para tareas puntuales) |
| **RAM** | 4 GB recomendados |
| **Disco** | ~60 MB para el `.exe` portátil; ~60 MB instalado + datos |
| **Conexión** | Solo para tienda winget, descarga de Office y comprobación de actualizaciones |

---

## 📂 Datos generados (y cómo revertir)

OmegaSolver guarda todo **localmente**; no hay cuentas ni telemetría.

| Modo | Carpeta de estado |
|---|---|
| **Instalada** | `%ProgramData%\OmegaSolver` |
| **Portátil** | `<carpeta del .exe>\OmegaSolver-data` |

Contenido habitual:

```text
OmegaSolver-data/  (o %ProgramData%\OmegaSolver)
├── settings.json           ajustes (comportamiento, autolimpieza, rutas, botones)
├── profile.txt             perfil Empresa / Hogar
├── theme.txt               tema seleccionado
├── language.txt            idioma (ES / EN / PT)
├── omega-subcolor.txt      subpaleta
├── low-mode.txt            modo de gráficos reducido
├── reversible-state.json   cambios reversibles aplicados
├── omega-warning.ack       aviso de riesgos aceptado
├── ecm-prompt.ack          aviso de energía/ECM aceptado
├── journal\                diario JSON de operaciones
├── reports\                reportes de limpieza
├── logs\                   registros y crash.txt
├── odt\                    archivos temporales del instalador de Office
└── winget-index.json       caché del catálogo de la tienda
```

- **Revertir cambios:** botón **"Revertir cambios"** en la ventana principal; usa `reversible-state.json` y el diario.
- **Desinstalar:** desde **Configuración → Aplicaciones** o el desinstalador de OmegaSolver. Los datos de `%ProgramData%\OmegaSolver` puedes conservarlos o borrarlos a mano.
- **Desde la V4:** los ajustes **no se migran automáticamente**; puedes desinstalar o borrar la carpeta antigua de la V4.4.4.

---

## 🛠️ Código abierto y compilación

OmegaSolver es **software libre bajo GPL-3.0**. El código fuente completo de esta versión se publica en el repositorio y, para esta release, como **`OmegaSolver-5.0.0-source.zip`** en los assets de [v5.0.0](https://github.com/OMEGAALPHA10/OmegaSolver/releases/tag/v5.0.0).

### Compilar el `.exe`

Requisitos: **.NET 10 SDK** y, para el instalador, **Inno Setup 6**.

```powershell
git clone https://github.com/OMEGAALPHA10/OmegaSolver.git
cd OmegaSolver
dotnet build -c Release
```

O con el script del proyecto, que además ejecuta el autotest y publica un único `.exe`:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\publish.ps1
```

Resultado: `dist\win-x64\OmegaSolver.exe`.

### Instalador

```powershell
powershell -ExecutionPolicy Bypass -File scripts\make-installer.ps1
```

Resultado: `dist\OmegaSolver-Setup-5.0.0.exe` (Inno Setup 6, modo completo/portátil, 3 idiomas).

### Firma y winget

```powershell
# Firma el .exe, reconstruye el setup con el binario firmado, firma el setup
# y actualiza el SHA-256 del manifiesto de winget.
powershell -ExecutionPolicy Bypass -File scripts\sign-release.ps1 -Pfx "D:\cert.pfx"
```

```powershell
# Recalcular el hash del instalador en el manifiesto
powershell -ExecutionPolicy Bypass -File scripts\update-winget-manifest.ps1

# Validar los manifiestos
winget validate --manifest installer\winget
```

### Modos de consola (usuarios avanzados)

```text
OmegaSolver.exe --version             muestra la versión
OmegaSolver.exe --selftest [ruta]     autotest interno y escribe un reporte
OmegaSolver.exe --uicheck             valida que el XAML incrustado carga
OmegaSolver.exe --datacheck           valida temas, idiomas y catálogos
OmegaSolver.exe --clean-safe          limpieza segura sin interfaz
OmegaSolver.exe --restore-point       crea un punto de restauración
OmegaSolver.exe --cleanup-targets     lista los destinos de limpieza
```

### Benchmarks

```powershell
powershell -ExecutionPolicy Bypass -File scripts\benchmark.ps1
```

Compara la V5 publicada contra la V4.4.4 (copiada a `%TEMP%`, sin tocar el original) y mide arranque, CPU y RAM.

---

## 🧪 Solución de problemas

| Síntoma | Causa | Solución |
|---|---|---|
| SmartScreen bloquea el `.exe` | Certificado autofirmado sin reputación | Verifica el SHA-256 y la firma; elige "Más información → Ejecutar de todas formas" |
| "OmegaSolver ya se encuentra en ejecución" | Quedó una instancia abierta o colgada | Ciérrala desde el Administrador de tareas y reintenta |
| El instalador pide administrador | Es obligatorio para SFC, DISM, servicios y tareas | Acepta el UAC |
| La versión portátil no guarda ajustes | Carpeta sin permisos de escritura | Muévela a una carpeta escribible (USB, Documentos) |
| `winget install` no encuentra el paquete | El manifiesto aún no fue aprobado | Usa el instalador o el `.exe` portátil |
| El antivirus marca el `.exe` | Binario nuevo, poca reputación | Comprueba la firma y añade una exclusión **solo si confías en el origen** |
| Office no descarga | Sin conexión o bloqueo de red | Revisa la conexión; la descarga es oficial de Microsoft |

Los registros están en `logs\` dentro de la carpeta de estado; `crash.txt` recoge errores de arranque.

---

## 📜 Historial de versiones

| Versión | Arquitectura | Destacado |
|---|---|---|
| **V5.0.0** | **C# · .NET 10 · WPF · 1 `.exe`** | Reescritura nativa, instalador dual, reporte de limpieza, herramientas de uso rápido, winget |
| V4.4.4 | PowerShell + PS12EXE | Modular (170 archivos), Office ODT, Ajustes, perfil, acciones rápidas |
| V4.4.1 | PowerShell + PS12EXE | Lanzador `.exe` + árbol modular |
| V4.4 | PowerShell + PS12EXE | Primera modular estable |
| V4.3 | PowerShell (monolítico) | Base de funciones actuales |

Las versiones anteriores se conservan en [Releases](https://github.com/OMEGAALPHA10/OmegaSolver/releases).

---

## 🤝 Contribuciones

- 🐞 **Errores:** abre un [Issue](https://github.com/OMEGAALPHA10/OmegaSolver/issues) con la versión, el idioma, los pasos y, si puedes, `logs\crash.txt`.
- 💡 **Ideas:** issues con etiqueta de mejora; describe el caso de uso, no solo el botón.
- 🔧 **Pull requests:** mantén el estilo del proyecto, prueba en modo básico y avanzado, y no rompas la paridad de idiomas.
- ⭐ **Difusión:** una estrella ayuda a que más gente lo encuentre.

---

## 📄 Licencia

Este proyecto se distribuye bajo **GNU General Public License v3.0**. Consulta [LICENSE](https://github.com/OMEGAALPHA10/OmegaSolver/blob/main/LICENSE) para el texto completo.

```text
OmegaSolver - Suite de diagnóstico, mantenimiento y optimización para Windows
Copyright (C) 2025-2026 OmegaAlpha10

Este programa es software libre: puedes redistribuirlo y/o modificarlo
bajo los términos de la GNU GPL v3 publicada por la Free Software Foundation.
Se distribuye SIN GARANTÍA, sin siquiera la garantía implícita de
COMERCIABILIDAD o IDONEIDAD PARA UN PROPÓSITO PARTICULAR.
```

Si distribuyes una versión modificada, **debes publicar también el código fuente** bajo la misma licencia.

---

## 🙏 Créditos

- **Desarrollado por:** OMEGA_ALPHA (OmegaAlpha10).
- **Interfaz y filosofía:** inspirada en la simplicidad de WinUtil y en el estilo visual de OMEGASOLVER.
- **Tecnologías:** .NET 10, WPF, System.Management, Inno Setup, winget.
- **Asistencia de IA:** port a C#, revisión de código y documentación.

<div align="center">

**Si OmegaSolver te resulta útil, deja una ⭐ en el repositorio.**

[⬆ Volver arriba](#-omegasolver-v500) · [📥 Releases](https://github.com/OMEGAALPHA10/OmegaSolver/releases) · [🌐 Sitio web](https://omegaalpha10.github.io/OmegaSolver/)

Hecho con 🇻🇪 por OmegaAlpha10

</div>
