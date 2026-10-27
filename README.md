<div align="center">

<img src="docs/screenshots/logo.png" alt="OmegaSolver" width="120">

# ⚡ OmegaSolver V4.4.4

**Suite gráfica de diagnóstico, mantenimiento y optimización para Windows**

[![Versión](https://img.shields.io/badge/version-4.4.4-FFD400?style=for-the-badge&logo=windowsterminal&logoColor=black)](https://github.com/OMEGAALPHA10/OmegaSolver/releases)
[![Licencia](https://img.shields.io/badge/license-GPLv3-22C55E?style=for-the-badge&logo=gnu&logoColor=white)](https://www.gnu.org/licenses/gpl-3.0)
[![Plataforma](https://img.shields.io/badge/platform-Windows%2010%20%7C%2011-0078D4?style=for-the-badge&logo=windows&logoColor=white)](https://github.com/OMEGAALPHA10/OmegaSolver)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%20%7C%207%2B-5391FE?style=for-the-badge&logo=powershell&logoColor=white)](https://github.com/PowerShell/PowerShell)
[![Winget](https://img.shields.io/badge/Winget-disponible-0078D4?style=for-the-badge&logo=windows&logoColor=white)](https://github.com/microsoft/winget-cli)

[![Stars](https://img.shields.io/github/stars/OMEGAALPHA10/OmegaSolver?style=flat-square&color=FFD400)](https://github.com/OMEGAALPHA10/OmegaSolver/stargazers)
[![Forks](https://img.shields.io/github/forks/OMEGAALPHA10/OmegaSolver?style=flat-square&color=FFD400)](https://github.com/OMEGAALPHA10/OmegaSolver/forks)
[![Issues](https://img.shields.io/github/issues/OMEGAALPHA10/OmegaSolver?style=flat-square&color=FB923C)](https://github.com/OMEGAALPHA10/OmegaSolver/issues)
[![Último commit](https://img.shields.io/github/last-commit/OMEGAALPHA10/OmegaSolver?style=flat-square&color=38BDF8)](https://github.com/OMEGAALPHA10/OmegaSolver/commits/main)

**🇻🇪 Proyecto personal de código abierto desarrollado desde Venezuela**

[📥 Instalar](#-instalación-y-ejecución) · [🧩 ¿Por qué modular?](#-por-qué-modular-y-por-qué-el-zip-completo) · [⚡ Rendimiento](#-rendimiento-verificado) · [✨ Características](#-última-versión-v444--modular-and-office-update) · [🔐 Firma](#-verificación-de-firma) · [🤝 Contribuir](#-contribuciones)

</div>

---

**OmegaSolver** es una suite gráfica (GUI) de diagnóstico, mantenimiento y optimización para Windows, desarrollada íntegramente en **PowerShell + WPF**, con un pequeño **lanzador `.exe`** compilado mediante **PS12EXE**. Diseñada para simplificar tareas técnicas complejas sin sacrificar la potencia para usuarios avanzados.

> [!IMPORTANT]
> **Desde la V4.4.4 la descarga obligatoria es el `.zip` completo, no solo el `.exe`.**
> `OmegaSolver.exe` ya **no contiene la aplicación**: es un lanzador de ~300 KB que busca `App.ps1` y las 170 fuentes modulares a su lado. Si descargas únicamente el `.exe`, o lo separas de `App.ps1`, la app **no arranca**. Antes de instalar, lee **[¿Por qué modular y por qué el ZIP completo?](#-por-qué-modular-y-por-qué-el-zip-completo)**.

---

## 🌐 Página Web Oficial

Toda la información del proyecto está disponible en el sitio web oficial: capturas interactivas, historia, changelog completo, roadmap público, FAQ, guías de instalación y disponibilidad en 3 idiomas (ES / EN / PT).

### 👉 **[https://omegaalpha10.github.io/OmegaSolver/](https://omegaalpha10.github.io/OmegaSolver/)**

---

## ⚡ Rendimiento Verificado

> **Misma sesión y misma carga: la V4.4.4 abrió en 346,9 s y el `.exe` final de la V4.4.1 necesitó 1120,0 s (−69,0 %).** El otro build oficial de V4.4.1 midió 754,5 s: **con cualquiera de los dos, la modular abrió primero**. No es una estimación: se lanzó el **`.exe` real de cada versión**, en frío, con permisos de administrador y sin scripts intermedios.
>
> Con el equipo descargado, la misma V4.4.4 abrió en **27,75 s y 57,2 s**. El estado de la máquina pesa más que la arquitectura; por eso aquí están **todas** las corridas, incluidas las que no abrieron.

> [!IMPORTANT]
> Esto no es un benchmark de laboratorio. Es un **Celeron N3350 con 4 GB de RAM, disco lento, Defender activo y el equipo compartido con otras aplicaciones**. Los tiempos absolutos son altos y muy variables; lo que vale es la comparación hecha **en las mismas condiciones**.

### 🖥️ Equipo de prueba

| Componente | Especificación |
|---|---|
| **Procesador** | Intel(R) Celeron(R) CPU N3350 @ 1.10 GHz |
| **Núcleos lógicos** | 2 |
| **RAM instalada** | 4,00 GB · 2133 MHz |
| **Tarjeta gráfica** | Intel(R) HD Graphics · 128 MB |
| **Almacenamiento** | 58 GB (≈50 GB usados) |
| **Sistema operativo** | Windows 11 Pro · build 26200 |
| **PowerShell** | Windows PowerShell 5.1.26100.6584 |
| **Antivirus** | Microsoft Defender activo (`MsMpEng` acumuló ≈47.900 s de CPU durante la sesión) |
| **Carga del equipo** | Qoder (~840 MB) y otras apps abiertas durante toda la prueba |

### 🔬 Metodología

1. Se ejecuta el **`.exe` oficial de cada versión**, no un `.ps1` ni un script de prueba.
2. Sesión **elevada** (administrador) y perfil **Hogar**.
3. Antes de cada corrida se cierran las instancias previas: el **mutex de instancia única** impediría abrir una segunda ventana.
4. El cronómetro va desde `Start-Process` hasta que existe la ventana principal con el título `OmegaSolver V4.4.x`. Se ignora el diálogo de "Instancia única".
5. Tras abrir: **45 s de estabilización** y **20 s de muestreo** de RAM, CPU, hilos y handles.
6. Orden alternado para repartir la deriva térmica y de carga.

Binarios medidos (prefijo del SHA-256; el hash se calculó sobre el archivo exacto que se ejecutó):

| Versión | Archivo | Tamaño | SHA-256 (inicio) |
|---|---|---:|---|
| V4.4.1 (final) | `beta\OmegaSolver V4.4.1.exe` | 673.760 B | `8f40a9d6…e5dfda` |
| V4.4.1 (build 15:21) | `OmegaSolver_v4.4.1.exe` | 666.624 B | `5966a5c7…c946f4` |
| V4.4.4 | `OmegaSolver v4.4.4.exe` (**el que va dentro del ZIP publicado**) | 309.728 B | `e7ac8a18…085862` |

### 📊 Resultados: misma sesión y misma carga

| Métrica | V4.4.1 (final) | **V4.4.4** | Cambio |
|---|---:|---:|---:|
| **Arranque en frío** | 1120,0 s | **346,9 s** | 🟢 **−69,0 % · 12 min 53 s menos** |
| RAM en reposo | 166,7 MB | 208,0 MB | 🟡 +41,3 MB (+24,8 %) |
| CPU en reposo | 0,50 % | 4,10 % | 🟡 +3,60 pp (no concluyente) |
| Hilos | 15 | 17 | 🟡 +2 |
| Handles | 510 | 652 | 🟡 +142 |

> El otro build oficial de V4.4.1 (666.624 B) midió **754,5 s**, **202,8 MB** de RAM, **4,43 %** de CPU, **13** hilos y **507** handles. Con los dos builds, la V4.4.4 abrió primero.

```text
ARRANQUE EN FRÍO — misma carga (menor = mejor)
════════════════════════════════════════════════════════════════

  V4.4.1  ████████████████████████████████████████████████  1120,0 s
  V4.4.4  ████████████████                                  346,9 s
          ╰──────────────────┬───────────────────╯
                             │
                     −69,0 % · 3,2× más rápida  ✅
```

> [!NOTE]
> En la V4.4.1 la ventana pertenece al propio `.exe` (la app va dentro del binario). En la V4.4.4 pertenece al `powershell.exe` que lanza el lanzador. Por eso la RAM, la CPU, los hilos y los handles son de **procesos distintos** y no se suman entre versiones: se compara el proceso que dibuja la ventana. La CPU, además, se midió con una muestra de 20 s y puede incluir tareas de fondo de cada app; **no debe leerse como consumo continuo**. La métrica sólida de esta prueba es el arranque.

### 🎚️ Cuánto varía el arranque (y por qué)

La **misma V4.4.4**, el mismo día y con menos carga, abrió en **27,75 s** y **57,2 s**. Con el equipo saturado necesitó **346,9 s**. Los dos builds oficiales de V4.4.1, que históricamente arrancaban en **33,61 s** (medición de su propia release, con el equipo más sano), necesitaron **754,5 s** y **1120,0 s** en esta sesión.

Esto deja dos conclusiones:

- **El estado del equipo domina el arranque en frío:** Defender escanea cada binario y `csc.exe` compila el C# de la app en cada ejecución. Con 4 GB de RAM, disco lento y `MsMpEng` activo, eso puede multiplicar el tiempo por 10 o más.
- **La modularidad no salió más lenta en la práctica:** carga 170 archivos por dot-sourcing, pero evita que un `.exe` de 674 KB cargue y compile toda la app dentro de su propio proceso. En este equipo, la diferencia entre el build final de V4.4.1 y la V4.4.4 fue de **12 minutos y 53 segundos**.

### 🧪 Todos los intentos (sin filtrar)

| # | Versión (build) | Inicio | Límite | ¿Abrió? | Tiempo | Observación |
|---|---|---|---:|---|---:|---|
| 1 | V4.4.1 (15:21) | 19:15:38 | 900 s | ✅ | **754,5 s** | Primer éxito de la sesión |
| 2 | V4.4.4 | 19:30:16 | 600 s | ❌ | >600 s | Lanzador y `powershell` activos, sin ventana |
| 3 | V4.4.1 (15:21) | 19:43:50 | 900 s | ❌ | >900 s | Proceso vivo, sin ventana |
| 4 | V4.4.4 | 20:00:18 | 600 s | ❌ | >600 s | `csc.exe` compilando; límite más corto |
| 5 | V4.4.4 | 20:15:01 | 1500 s | ✅ | **346,9 s** | Misma franja de carga que el intento 6 |
| 6 | V4.4.1 (final) | 20:38:57 | 1500 s | ✅ | **1120,0 s** | Build final; misma franja de carga que el 5 |

> [!WARNING]
> Los intentos 2 y 4 usaron un límite de **600 s**, menor que los 900 s del monolito. Se dejan en la tabla como evidencia de la variabilidad: en este equipo, **cualquier** arranque en frío puede quedar bloqueado varios minutos por el antivirus y la compilación. No se contaron como tiempo de arranque ni se usaron para calcular el −69 %.

### ✅ Veredicto

- **Arranque en frío (misma carga):** 346,9 s vs 1120,0 s → **3,2× más rápida** (−69,0 %). Frente al otro build de V4.4.1 (754,5 s) sigue siendo **2,2×** más rápida.
- **Mejor caso medido (equipo descargado):** 27,75 s con la V4.4.4.
- **Coste en reposo:** entre +5 y +41 MB de RAM según el build de V4.4.1 comparado, +2 a +4 hilos y +142 a +145 handles por el proceso lanzador adicional; la CPU no es concluyente con muestras de 20 s.
- **Coste real de la modularidad:** 170 archivos y ~1,5 MB en disco; el antivirus escanea más archivos, pero el arranque no se degradó frente al monolito.

**Conclusión:** en un equipo sano la diferencia entre ambas arquitecturas es pequeña; en un equipo limitado y con Defender activo, **el monolito es el que peor paga el arranque**. La modular gana justo donde más importa: hardware modesto.

---

## 🧩 ¿Por qué modular y por qué el ZIP completo?

Esta sección explica, sin atajos, **el cambio de arquitectura más importante del proyecto** y las tres reglas que se derivan de él. Si solo lees un apartado del README, que sea este.

> [!CAUTION]
> **REGLA DE ORO:** descarga el **`.zip` completo** desde [Releases](https://github.com/OMEGAALPHA10/OmegaSolver/releases), extrae **todo** en una carpeta propia y ejecuta el `.exe` **sin sacarlo de esa carpeta**. El `.exe` suelto no es la aplicación.

### 1. Por qué se abandonó el `.ps1` único

Hasta la V4.4.1, todo el programa vivía en **un solo archivo** de 8.756 líneas (~877 KB) que PS12EXE empaquetaba dentro de un `.exe` autosuficiente de 674 KB. Funcionaba, pero cada versión nueva se volvía más cara de mantener:

| Problema del monolito | Consecuencia real |
|---|---|
| 8.756 líneas en un archivo | Cualquier cambio obligaba a recorrer y regenerar todo el archivo |
| Sin separación por dominio | Un ajuste en Winget podía romper la limpieza o el instalador de Office |
| Sin red de seguridad | No había forma automatizada de comprobar que un cambio no alterara otra función |
| Traducciones dispersas | Cada cadena ES/EN/PT se buscaba a mano dentro del mismo archivo |
| Recompilar para todo | Probar una idea exigía volver a compilar el `.exe` completo |

La respuesta fue reconstruir el proyecto como un **árbol modular**: el mismo código, ahora dividido en **170 archivos** (`.ps1` + `.xaml`, ~11.900 líneas) agrupados por responsabilidad. Cada bloque del monolito original se colocó **una sola vez y en su orden exacto** dentro de un archivo puente generado (`Core/Exec.ps1`), de modo que la app sigue ejecutándose **como si fuera un único script**, pero el mantenimiento se hace por partes.

**Ventajas que ya se notan:**

- **Aislamiento por dominio:** `Core/` (arranque, logger, configuración, temas, idiomas), `UI/` (ventanas y XAML), `Modules/` (limpieza, red, Winget, herramientas), `Workers/` (procesos externos) y `Features/` (perfil, Ajustes, autolimpieza, log en disco, botones personalizados, Office ODT).
- **Verificación automática:** el generador reconstruye el script monolito a partir de los 170 fragmentos y un verificador compara el resultado **byte a byte**. Si un fragmento se duplica, se omite o se desordena, el build falla. (Comprobación actual: **170/170 fragmentos íntegros**.)
- **Features nuevas sin tocar el núcleo:** el perfil Empresa/Hogar, el panel de Ajustes, la autolimpieza programada o el instalador de Office se añadieron como archivos independientes.
- **Depuración localizada:** un error apunta a un archivo concreto (`Features/Feature.Profile.ps1`) en lugar de a "la línea 6.000 de un archivo gigante".

**El coste, dicho claro:** un árbol de 170 archivos ocupa más en disco y provoca más fricción con antivirus/SmartScreen, que escanean archivo por archivo. En teoría eso debería hacer el arranque en frío más lento que un único archivo; en la práctica, el coste dominante es la compilación C# y el escaneo del `.exe` monolítico, y en nuestras mediciones la V4.4.4 abrió **más rápido** que la V4.4.1 (ver [⚡ Rendimiento](#-rendimiento-verificado)). Aun así, el arranque se paga **una vez por sesión** mientras la app queda abierta.

### 2. Por qué ahora es OBLIGATORIO descargar el `.zip` entero

El cambio de arquitectura cambió también **qué es el `.exe`**. Ya no es la app empaquetada: es un **lanzador mínimo** que arranca la app real, que vive en los archivos de al lado.

| | V4.4.1 (anterior) | **V4.4.4 (actual)** |
|---|---|---|
| `.exe` | 674 KB · **la app completa** | **310 KB · solo el lanzador** |
| Código de la app | dentro del `.exe` | **170 archivos fuera del `.exe`** |
| ¿Funciona el `.exe` solo? | ✅ Sí | ❌ **No** |
| Unidad de descarga | `.exe` | **`.zip` completo** |
| Tamaño del paquete | 1 archivo | ZIP de ~648 KB → ~1,5 MB extraídos |

```text
V4.4.1:  [ OmegaSolver.exe  ← script + runtime + todo el código ]

V4.4.4:  [ OmegaSolver.exe ]  →  busca  →  [ App.ps1 ]
                                              │
                                              ├── Core\
                                              ├── UI\
                                              ├── Modules\
                                              ├── Workers\
                                              └── Features\
```

Si descargas **solo el `.exe`** de la V4.4.4, obtienes un lanzador de 310 KB sin programa que lanzar. Al ejecutarlo verás un cuadro de diálogo indicando que **no se encontró `App.ps1` junto a `OmegaSolver.exe`**, y se cerrará. No es un error de la app: es exactamente el comportamiento esperado cuando falta el árbol modular.

> [!NOTE]
> En la carpeta de publicación puede aparecer un `OmegaSolver.exe` suelto: sirve para **verificar la firma digital** y el hash. **No es** una instalación válida por sí mismo.

### 3. Por qué el `.exe` debe estar en la MISMA carpeta que `App.ps1`

No es una preferencia estética: es cómo funciona un ejecutable compilado con PS12EXE.

1. Dentro de un `.exe` de PS12EXE, `$PSScriptRoot` **no apunta a la carpeta donde está el `.exe`**, sino a un directorio temporal de extracción. Por eso el lanzador no puede usar `$PSScriptRoot` para localizar la app.
2. El lanzador obtiene su propia ruta real con `[System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName`.
3. De ahí deriva la carpeta (`$exeDir`) y busca **exactamente** `$exeDir\App.ps1`.
4. Fija `WorkingDirectory = $exeDir` y arranca el intérprete del sistema con:
   `powershell.exe -NoProfile -ExecutionPolicy Bypass -STA -File "App.ps1"`.
5. Si `App.ps1` no existe en esa carpeta, muestra el error y termina con código 1. **No hay búsqueda alternativa** en el escritorio, en `Program Files` ni en el directorio actual.

**Qué significa en la práctica:**

- ✅ **Correcto:** `C:\OmegaSolver\OmegaSolver.exe` junto a `C:\OmegaSolver\App.ps1`, `Core\`, `UI\`, etc. El acceso directo apunta al `.exe` dentro de esa carpeta.
- ❌ **Incorrecto:** mover solo el `.exe` al Escritorio.
- ❌ **Incorrecto:** dejar el `.exe` en `C:\OmegaSolver` y las fuentes en `Descargas\OmegaSolver-V4.4.4`.
- ❌ **Incorrecto:** renombrar o mover `App.ps1` "para ordenar".
- ❌ **Incorrecto:** un acceso directo con "Iniciar en" apuntando a otra carpeta (el lanzador usa su propia ubicación, pero el árbol debe seguir junto a él).

**Detalles del lanzador que conviene conocer:**

- `-STA` es obligatorio: WPF no funciona en un hilo MTA.
- `-NoProfile` evita que un perfil de PowerShell del usuario altere el entorno de la app.
- `-ExecutionPolicy Bypass` es necesario porque Windows bloquea por defecto la ejecución de scripts descargados.
- `CreateNoWindow` evita una consola negra parpadeando al iniciar.
- La app usa un **mutex de instancia única** (`Local\OmegaSolverV44_SingleInstance`). Si ya hay una instancia abierta verás el aviso **"OmegaSolver ya se encuentra en ejecución"**. Cierra la anterior (o termínala desde el Administrador de tareas) antes de abrir otra.

### 4. Cómo se ensambla la app (el mosaico)

El árbol no es una copia libre del monolito: es un **mosaico ordenado**.

```text
App.ps1 (63 líneas)
├── define $root = $PSScriptRoot
├── carga Core\Exec.ps1
├── captura errores → logs\crash.txt
└── Core\Exec.ps1  (generado)
    ├── #@@LOAD / #@@INLINE / #@@XAML  ← orden exacto del monolito
    ├── cada fragmento aparece UNA vez
    └── Features\*.ps1 se inyectan antes del último #@@LOAD
```

- `_build\generate.js` recorre el monolito de referencia y genera la secuencia de carga.
- `_build\build.ps1` reconstruye el script completo y ejecuta las comprobaciones.
- `_build\check.js` compara el resultado con el original **byte a byte**. Un solo byte de diferencia invalida el build.

Esto permite dos cosas a la vez: **desarrollar por archivos** y **garantizar que el comportamiento es idéntico** al del script validado.

### 5. Errores típicos y su causa exacta

| Síntoma | Causa | Solución |
|---|---|---|
| "No se encontró `App.ps1` junto a `OmegaSolver.exe`" | El `.exe` está separado del árbol modular | Extrae el ZIP completo en una carpeta y ejecuta el `.exe` de ahí |
| El `.exe` no hace nada o se cierra al instante | Extracción incompleta: faltan `Core\`, `UI\`, etc. | Vuelve a extraer **todo** el ZIP (no ejecutes desde dentro del ZIP) |
| "OmegaSolver ya se encuentra en ejecución" | Quedó una instancia anterior abierta o colgada | Ciérrala desde el Administrador de tareas y reintenta |
| SmartScreen bloquea el `.exe` | Ejecutable descargado de Internet sin reputación | Verifica la firma ([sección de firma](#-verificación-de-firma)) y permite la ejecución |
| Antivirus marca los `.ps1` | Son 170 scripts que se ejecutan al iniciar; heurística agresiva | Añade la carpeta extraída a exclusiones **solo si confías en el origen** |
| Errores raros tras editar un archivo | Se rompió el mosaico (fragmento duplicado/desordenado) | No edites a mano el orden de `Core\Exec.ps1`; usa `_backup` + `build.ps1` |

> [!WARNING]
> La firma digital cubre el **lanzador `.exe`**. Los `.ps1` del árbol son código local y no van firmados individualmente: descarga siempre desde el repositorio/Releases oficiales y, si quieres estar seguro, compara el **SHA256 del ZIP** publicado. Un ZIP de terceros puede contener scripts alterados.

### 6. ¿Y si quiero auditarlo o desarrollar?

Todo el código está a la vista en el ZIP. Para desarrollo local puedes ejecutar directamente `App.ps1` con PowerShell 5.1 (sin pasar por el lanzador); para **distribuir**, el formato oficial sigue siendo el ZIP con el `.exe` + árbol modular. La app **no requiere** instalar PowerShell: usa el **Windows PowerShell 5.1 que ya trae Windows 10/11**.

---

## 🛠️ Código Abierto y Compilación Universal

El **código fuente completo** de OmegaSolver es el árbol modular que viene dentro del `.zip` de cada release: `App.ps1` más las carpetas `Core/`, `UI/`, `Modules/`, `Workers/` y `Features/` (170 archivos `.ps1`/`.xaml` cargados por dot-sourcing). El `OmegaSolver.exe` incluido no es el script empaquetado: es un **lanzador** compilado con PS12EXE que localiza `App.ps1` junto a sí mismo y arranca la app con el PowerShell 5.1 del sistema. Para generar ese ejecutable tú mismo:

<details open>
<summary><b>📦 Ver pasos de compilación manual</b></summary>

<br>

**1. Instalar el compilador** — Abre **Windows PowerShell 5.1 como Administrador** (no PS 7: PS12EXE tiene un bug con el subprocess de syntax-check en PS 7) y ejecuta:

```powershell
Install-Module -Name ps12exe -Scope CurrentUser -Force -AllowClobber
```

**2. Crear el script del lanzador** (`OmegaLauncher.ps1`) — el exe compilado no sabe dónde está (`$PSScriptRoot` apunta a un temporal), así que el lanzador resuelve su propia ubicación y arranca `App.ps1` junto a él:

```powershell
$ErrorActionPreference = 'Stop'
# WPF: sin esto el .exe compilado puede no resolver [System.Windows.MessageBox]
try { Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase } catch { }
try {
    $exeFile = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
    $exeDir  = [System.IO.Path]::GetDirectoryName($exeFile)
    $app     = Join-Path $exeDir 'App.ps1'
    if (-not (Test-Path -LiteralPath $app)) {
        [System.Windows.MessageBox]::Show("No se encontro App.ps1 junto a OmegaSolver.exe.`n`nExtrae el contenido completo del .zip en una carpeta y ejecuta el .exe desde ahi.", 'OmegaSolver', 'OK', 'Error') | Out-Null
        exit 1
    }
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
    $psi.Arguments = '-NoProfile -ExecutionPolicy Bypass -STA -File "' + $app + '"'
    $psi.WorkingDirectory = $exeDir
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    [System.Diagnostics.Process]::Start($psi) | Out-Null
    exit 0
} catch {
    try { [System.Windows.MessageBox]::Show('No se pudo iniciar OmegaSolver: ' + $_.Exception.Message, 'OmegaSolver', 'OK', 'Error') | Out-Null } catch { }
    exit 1
}
```

**3. Compilar el lanzador** — desde la misma consola de PS 5.1:

```powershell
ps12exe `
  -inputFile  ".\OmegaLauncher.ps1" `
  -outputFile ".\OmegaSolver.exe" `
  -App @{
      Windowed = $true
  } `
  -Os @{
      Admin = $true
  } `
  -Resources @{
      Icon        = 'icon.ico'
      Title       = 'OmegaSolver V4.4.4'
      Description = 'OmegaSolver V4.4.4'
      Company     = 'OMEGA_ALPHA'
      Product     = 'OmegaSolver V4.4.4'
      Copyright   = '(c) 2026 OMEGA_ALPHA'
      Version     = '4.4.4.0'
  } `
  -Locale en `
  -NoUpdateCheck

Remove-Item ".\OmegaSolver.exe.config" -Force -ErrorAction SilentlyContinue
```

> **Nota sobre `-Locale en`:** corrige un bug de PS12EXE en sistemas con locale no-inglés (p. ej. `es-VE`, `pt-BR`) que hace fallar el subprocess interno de parseo. El flag fuerza el uso de la tabla i18n interna del módulo.

> **Nota sobre el `.config`:** PS12EXE lo genera automáticamente para declarar `<supportedRuntime v4.0>`. Windows 10/11 lo ignoran porque el CLR 4.x ya viene en el sistema, así que se puede borrar para dejar un `.exe` único y limpio.

> **Nota sobre la distribución:** el `.exe` debe ir **siempre dentro de la carpeta del árbol modular** (junto a `App.ps1`), tal como viene en el `.zip` del release. Copiar solo el `.exe` a otra ubicación no funcionará.

**4. Firmar el ejecutable** (requiere certificado `.pfx` propio):

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

</details>

---

## 🆕 Última versión: V4.4.4 — "Modular and Office Update"

### 📦 Instalador de Office integrado (modo avanzado)

Descarga e instala Microsoft Office con la **Office Deployment Tool oficial**, directo desde los servidores de Microsoft — sin paquetes externos de terceros.

- **5 suites**: Microsoft 365, Office LTSC 2024, Office 2021, Office 2019 y Office 2016. En Windows 7 / 8.x solo se ofrece Office 2016, la última compatible.
- **Aplicaciones individuales**: marca una a una las que necesitas — Word, Excel, PowerPoint, Outlook, OneNote, Publisher, Access, OneDrive y Teams. Las demás se excluyen automáticamente de la instalación.
- Arquitectura **x64 / x86**, canal de actualización (365) e idioma (es-es / en-us / pt-br).
- La activación requiere la **licencia propia** del usuario (cuenta o clave de Microsoft).

### ⚙ Panel de Ajustes

Nuevo botón ⚙ junto a "Analizar PC" con personalización estilo BleachBit/Wintoys:

- **Botones personalizados**: crea botones con el nombre que quieras que ejecutan tus scripts `.ps1`, `.cmd` o `.bat`.
- **Rutas de limpieza personalizadas**: carpetas que se limpian con cualquier botón de limpieza existente.
- **Autolimpieza cada X minutos** (intervalo a elección), con ejecución en **segundo plano** opcional.
- **Log a disco** y botón para abrir la carpeta de logs.

### 🏢 Perfil Empresarial / Hogar

Al primer inicio la app pregunta el tipo de equipo. Con perfil **EMPRESARIAL** se desactivan las acciones que pueden chocar con las políticas de dominio (GPO): restablecer red, QoS, plan de energía, limpiezas profundas, CHKDSK /f y DISM /ResetBase. La elección se recuerda.

¿Te equivocaste de perfil o cambió el uso del equipo? En **Ajustes → Perfil del equipo → "Cambiar perfil..."** puedes volver a abrir el diálogo y re-aplicar el gating GPO al instante, sin reiniciar la app.

¿Quieres que la pregunta inicial vuelva a aparecer? Usa **"Preguntar al iniciar"** en esa misma tarjeta: borra la elección guardada y el diálogo EMPRESARIAL / HOGAR se mostrará de nuevo en el próximo arranque.

### ⚡ Acciones rápidas y Todo-en-1-Clic

Panel de acción rápida junto a la barra de basura real (tamaño medido, no estimado): *Limpieza en 1-Clic*, *Reparar todo* y **Todo-en-1-Clic** (limpieza + DNS + papelera + SFC + DISM + Winsock + re-análisis). En el modo avanzado, DISM y CHKDSK abren un **sub-diálogo de opciones** antes de ejecutarse.

### 🧩 Código 100% modular

El monolito se reorganizó en un árbol de **170 archivos** (`App.ps1` + `Core/`, `UI/`, `Modules/`, `Workers/`, `Features/`) cargados por dot-sourcing en el orden exacto del original. El `.zip` del release incluye el árbol completo junto a `OmegaSolver.exe`, un lanzador compilado con PS12EXE que solicita UAC y arranca la app.

### 🖼️ Icono propio en la barra de tareas

La ventana principal declara un **AppUserModelID** propio (`OMEGA_ALPHA.OmegaSolver`) y usa el **logo embebido de OmegaSolver** como icono de ventana. Así Windows ya no muestra el icono genérico de PowerShell en la barra de tareas, incluso cuando la app se inicia a través del lanzador.

---

## 🎨 Versión anterior: V4.4.1 — "Absolute Async Update"

### 🚀 Núcleo asíncrono (`Invoke-OmegaAsync`)

Toda operación pesada corre ahora en **runspaces de fondo**, dejando el hilo UI siempre libre. La ventana responde al instante aunque el diagnóstico, la comprobación de actualizaciones, la limpieza profunda o la tienda winget estén trabajando por debajo.

- **`Invoke-OmegaAsync`** — motor de trabajo en background. El código de fondo nunca toca controles WPF: sólo devuelve datos y un `DispatcherTimer` los pinta al terminar.
- **`Invoke-OmegaTaskAsync`** — overlay de carga **no bloqueante**. Los pasos del overlay rotan de verdad mientras el trabajo pesado corre, con reloj y mensaje real desde archivo de progreso.

### 🐛 Fix del bug crítico — Winget Live

> **El bug de V4.4 está resuelto.** En V4.4, al hacer clic en una tarjeta de resultado de la búsqueda en vivo, el panel de detalle no se abría (excepción silenciosa al escribir `.Text` sobre un control `<Image>`).

**Corregido en V4.4.1:**
- Fallback de icono ahora distingue entre `TextBlock` e `Image` — nunca más `.Text` sobre `<Image>`.
- La función `Show-OmegaAppDetailFn` está blindada con try/catch y muestra el error visible si algo falla.
- Los resultados live heredan la descripción del catálogo curado (mejor UX).
- Soporte completo para `PSCustomObject` **y** `hashtable` en el panel de detalle (antes sólo hashtable).
- `winget list` ya no bloquea la apertura de la tienda: se calienta la caché en segundo plano y se re-renderiza automáticamente al terminar.

### 💡 Errores visibles (`Show-OmegaTaskError`)

Nueva función que **muestra un diálogo** con tipo de excepción, código HResult y detalle cuando una tarea de botón falla (sync o async). Antes los fallos sólo quedaban en el log — o ni eso.

### 🧹 Limpieza detallada y veraz

- **Reporte por ubicación**: cada limpieza indica exactamente qué eliminó — por cada path, número de archivos y MB liberados, más total general.
- **Fix del bug de Limpieza 1-Clic**: en V4.4 reportaba como "eliminados" los GB de basura **restante** (medidos después de borrar). Ahora mide ANTES de borrar y reporta los GB realmente liberados.

### 🖥️ Ventanas opacas (CPU idle -24 %)

Las 5 ventanas WPF (principal, carga, tienda, compartir, manual) usan ahora **`AllowsTransparency="False"`**. Sin layered window: **CPU idle cae de 66-75 % a <10 %** en gráficos modestos. Los temas visuales siguen intactos.

### ⚡ Micro-optimizaciones de rendimiento

- **`Get-HotFix` → registro CBS** para el informe de actualizaciones. De 8-11 s (real medido en N3350) a <0.5 s.
- **SystemProfile por `Test-Path` a System32** en vez de `Get-Command` (10× más rápido, ~0.6 s ahorrado).
- **`Win32_OperatingSystem` eliminado del perfil inicial** — el registro ya provee `ProductName`, `DisplayVersion`, `Build` y `UBR`.
- **Logo de carga decodificado una sola vez** y cacheado con `Freeze()`.
- **Favicons de la tienda a 44/96 px** (`DecodePixelWidth`) en vez de 128/256 px — menos RAM y menos CPU de decodificación.
- **`GC.Collect()` tras diagnóstico y limpieza**, y brushes con `Freeze()` para liberar memoria.
- **Runspaces cancelados al cerrar** — sin hangs al salir de la app.

### 🔧 Estabilidad

- Reparación de crashes causados por funciones ausentes en el script compilado.
- Reescritura de la función `Get-OmegaString` con acceso seguro por índice.
- Eliminación de caracteres residuales (`*`, `<->`, `Search`, `Web`, `Cart`) en strings i18n y XAML.
- `Invoke-OmegaHiddenCmd` — todos los comandos de consola (`ipconfig`, `netsh`, `powercfg`, `takeown`, `icacls`) sin ventanas emergentes.

### 🎨 Compilación profesional

- **Migración a PS12EXE** (v0.6.9+): mejor manejo de scripts grandes y caracteres Unicode.
- **Codificación UTF-8 con BOM** estricta en todos los `.ps1`.
- **Firma digital SHA256 con Timestamp DigiCert** aplicada por separado.
- **Codificación segura de strings** para que acentos, eñes y emojis sobrevivan al empaquetado.

---

## 🎨 Versión anterior: V4.4 — "Polish & Stability"

### 🖼️ Identidad visual reforzada

- **Logo embebido** en pantalla de carga (Base64, 100% offline, sin archivos externos).
- **Emblema OmegaSolver** en el encabezado del manual.
- **Emojis contextuales** en el manual: cada función identificada por su icono según su categoría.

### 📖 Manual de usuario mejorado

- **3 idiomas en paralelo** (ES / EN / PT) con dos niveles de explicación:
  - **`BAS`** — Amigable para usuarios sin experiencia técnica.
  - **`TEC`** — Técnica (parámetros, comandos, GUIDs, registro).

- **Emojis por función**:

| Emoji | Categoría |
|:---:|---|
| 🔧 | Reparación / recuperación |
| 🔍 | Escaneo / diagnóstico (SFC, DISM, CHKDSK) |
| 💾 | Almacenamiento / desfragmentación |
| ⚡ | Rendimiento / energía |
| 🗑️ | Limpieza de temporales |
| 🧹 | Mantenimiento profundo |
| 🌐 | Red / DNS / Internet |
| 🚀 | Aceleración de red |
| 🛡️ | Seguridad / punto de restauración / protección SSD |
| 📁 | Compartir archivos |
| 🔄 | Actualizaciones |
| 🔒 | Archivos bloqueados |
| ⚙️ | Controladores obsoletos |

---

## 🎨 Versión anterior: V4.3 — "Multilingual & Network"

### 🌐 Sistema multilenguaje (ES / EN / PT)

Menú desplegable en la barra superior para cambiar el idioma **en caliente, sin reiniciar**. Persiste en `%ProgramData%\OmegaSolver\language.txt`.

### 📖 Manual de usuario en 3 columnas

Ventana modal con los 3 idiomas en paralelo, dos niveles de explicación (`BAS` / `TEC`). Se adapta a Modo Básico o Avanzado.

### 📡 Compartir Archivos por Red (solo Modo Avanzado)

- **Robocopy / SMB** para PC a PC con opciones avanzadas (`/MT:16`, `/MIR`, `/MOVE`, `/XD`, `/XF`, `/MINAGE`, credenciales SMB).
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
- Analizar Actualizaciones (`Get-HotFix` / registro CBS).
- Gestor de Archivos Bloqueados (`takeown + icacls`).
- Limpiar Controladores Obsoletos (`pnputil + DISM`).

---

## 📊 Tabla comparativa de versiones

| Característica | V4.2 | V4.3 | V4.4 | V4.4.1 | **V4.4.4** |
|---|:---:|:---:|:---:|:---:|:---:|
| Interfaz WPF moderna | ✅ | ✅ | ✅ | ✅ | ✅ |
| Temas visuales | 17 + OMEGA (6 sub) | 17 + OMEGA (6 sub) | 17 + OMEGA (6 sub) | 17 + OMEGA (6 sub) | 17 + OMEGA (6 sub) |
| Layout Básico / Avanzado | 2 col / 3 col | 2 col / 3 col | 2 col / 3 col | 2 col / 3 col | 2 col / 3 col |
| Protección SSD | ✅ | ✅ | ✅ | ✅ | ✅ |
| Manual integrado | Bilingüe | 3 idiomas + BAS/TEC | + emojis | + emojis | + emojis |
| Idiomas UI | ES | ES / EN / PT | ES / EN / PT | ES / EN / PT | ES / EN / PT |
| Sistema de Reversión | ✅ | ✅ | ✅ | ✅ | ✅ |
| Instancia única | ✅ | ✅ | ✅ | ✅ | ✅ |
| Custom Chrome | ✅ | ✅ | ✅ | ✅ | ✅ |
| Modo Low | ❌ | ✅ | ✅ | ✅ | ✅ |
| Auto-Update (GitHub) | ❌ | ✅ | ✅ | ✅ | ✅ |
| Compartir Archivos (Red) | ❌ | ✅ | ✅ | ✅ | ✅ |
| Easy Context Menu | ❌ | ✅ | ✅ | ✅ | ✅ |
| Herramientas Dism++ | ❌ | ✅ | ✅ | ✅ | ✅ |
| Limpieza 1-Clic separada | ❌ | ✅ | ✅ | ✅ | ✅ |
| Logo embebido (Base64) | ❌ | ❌ | ✅ | ✅ | ✅ |
| Emojis contextuales en manual | ❌ | ❌ | ✅ | ✅ | ✅ |
| Compilación con PS12EXE | ❌ | ❌ | ✅ | ✅ | ✅ |
| Codificación UTF-8 con BOM | ❌ | ❌ | ✅ | ✅ | ✅ |
| Firma SHA256 + Timestamp | ❌ | ❌ | ✅ | ✅ | ✅ |
| Núcleo asíncrono (`Invoke-OmegaAsync`) | ❌ | ❌ | ❌ | ✅ | ✅ |
| Overlay de carga no bloqueante | ❌ | ❌ | ❌ | ✅ | ✅ |
| Ventanas opacas (`AllowsTransparency=False`) | ❌ | ❌ | ❌ | ✅ | ✅ |
| Errores visibles (`Show-OmegaTaskError`) | ❌ | ❌ | ❌ | ✅ | ✅ |
| Limpieza con reporte detallado por ubicación | ❌ | ❌ | ❌ | ✅ | ✅ |
| Fix Winget Live (panel de detalle) | ❌ | ❌ | ❌ | ✅ | ✅ |
| Cold start reducido a la mitad | ❌ | ❌ | ❌ | ✅ | ✅ |
| **Instalador de Office (ODT oficial, apps individuales)** | ❌ | ❌ | ❌ | ❌ | ✅ |
| **Panel de Ajustes (botones y rutas personalizadas)** | ❌ | ❌ | ❌ | ❌ | ✅ |
| **Autolimpieza programada + segundo plano** | ❌ | ❌ | ❌ | ❌ | ✅ |
| **Log a disco con visor** | ❌ | ❌ | ❌ | ❌ | ✅ |
| **Perfil Empresarial / Hogar con gating GPO (cambiable desde Ajustes)** | ❌ | ❌ | ❌ | ❌ | ✅ |
| **Barra de basura real + acciones rápidas** | ❌ | ❌ | ❌ | ❌ | ✅ |
| **Todo-en-1-Clic (limpieza + reparación + red)** | ❌ | ❌ | ❌ | ❌ | ✅ |
| **Sub-diálogos de opciones DISM / CHKDSK** | ❌ | ❌ | ❌ | ❌ | ✅ |
| **Código 100% modular (170 archivos) + exe lanzador** | ❌ | ❌ | ❌ | ❌ | ✅ |

---

## 📥 Instalación y ejecución

### Opción 1 — Ejecución directa (recomendado)

1. Descarga **`OmegaSolver-V4.4.4.zip`** desde la sección [Releases](https://github.com/OMEGAALPHA10/OmegaSolver/releases). **No descargues solo el `.exe`**: no funciona por sí solo.
2. **Extrae todo el contenido** del `.zip` en una carpeta (por ejemplo `C:\OmegaSolver`). El ejecutable necesita los archivos fuente (`App.ps1`, `Core/`, `UI/`, `Modules/`, `Workers/`, `Features/`) junto a él.
3. Ejecuta **`OmegaSolver.exe`** (doble clic o clic derecho → **Ejecutar como administrador**), **sin sacarlo de la carpeta**.
4. Acepta la solicitud de elevación de UAC.

> [!IMPORTANT]
> **Nota de Administrador**: el programa requiere permisos elevados para interactuar con servicios, registro y herramientas nativas (SFC/DISM/CHKDSK).
>
> **Nota**: `OmegaSolver.exe` es un lanzador que arranca la app modular con PowerShell 5.1 del sistema. Mantén siempre el `.exe` junto a `App.ps1` y las carpetas del árbol modular.

> [!WARNING]
> **No ejecutes `OmegaSolver.exe` desde dentro del `.zip`** (el explorador lo extrae a una carpeta temporal y el árbol queda incompleto), **no muevas el `.exe` al Escritorio** y **no renombres `App.ps1`**. En los tres casos el lanzador no encuentra el programa y se cierra con un aviso.

### Opción 2 — Desde consola

```cmd
cd C:\OmegaSolver
OmegaSolver.exe
```

### Opción 3 — Verificación de integridad SHA256

```powershell
Get-FileHash "OmegaSolver.exe" -Algorithm SHA256
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

Get-AuthenticodeSignature "OmegaSolver.exe" |
    Format-List Status, @{N='Firmado por';E={$_.SignerCertificate.Subject}}
```

Resultado esperado:

```text
Status      : Valid
Firmado por : CN=OMEGA_ALPHA
```

---

## 📋 Requisitos del sistema

| Requisito | Detalle |
|---|---|
| **SO** | Windows 10 (build 1809+) o Windows 11 (64-bit) |
| **.NET Framework** | 4.7.2 o superior |
| **Permisos** | Administrador (el `.exe` lo solicita al arrancar) |
| **PowerShell** | **Windows PowerShell 5.1**, incluido de serie en Windows 10/11. No hay que instalar nada: el `.exe` no lleva runtime, usa el del sistema |
| **Distribución** | **ZIP completo** (~648 KB; ~1,5 MB extraído). El `.exe` aislado no es funcional |
| **RAM mínima verificada** | 4 GB (probado en Celeron N3350 @ 1.10 GHz · 2 cores) |
| **Almacenamiento mínimo** | 60 GB (probado con 58 GB totales, 8 GB libres) |

---

## 🗂️ Estructura de archivos generados

```text
%ProgramData%\OmegaSolver
├── reversible-state.json      # Estado para reversión de cambios
├── theme.txt                  # Tema visual seleccionado
├── omega-subcolor.txt         # Sub-paleta de OMEGA style
├── low-mode.txt               # Estado del Modo Low
├── language.txt               # Idioma seleccionado (ES/EN/PT)
├── profile.txt                # Perfil del equipo (EMPRESARIAL / HOGAR)
├── settings.json              # Ajustes (botones, rutas, autolimpieza, terminal)
├── omega-warning.ack          # Confirmación de advertencia OMEGA style
├── logs\                      # Log de operaciones (omega_YYYYMMDD.log)
└── odt\                       # Caché de la Office Deployment Tool
```

> [!NOTE]
> OmegaSolver es **100% offline y privado**: no recolecta ni transmite telemetría. La única conexión a internet es la comprobación de actualizaciones en GitHub (puedes ignorarla si no hay red).

---

## 🗂️ Historial de versiones

| Versión | Tipo | Destacado |
|---|---|---|
| **V4.4.4** | ✅ **Release actual** | Instalador de Office (ODT oficial, apps individuales), panel de Ajustes, autolimpieza, perfil Empresa/Hogar, código 100% modular |
| V4.4.1 | 📦 Release estable | Async core, fix Winget Live, ventanas opacas, limpieza detallada |
| V4.4 | 📦 Release estable | Logo embebido, emojis en manual, PS12EXE, firma SHA256 |
| V4.3 | 📦 Release estable | Multilenguaje ES/EN/PT, Easy Context Menu, Auto-Update, Compartir Archivos, Dism++ tools |
| V4.2 | 📦 Release estable | OMEGA style (6 sub-paletas), Custom Chrome, layout balanceado |
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

<div align="center">

## 🔗 Enlaces rápidos

[🌐 Página Web](https://omegaalpha10.github.io/OmegaSolver/) · [📦 Última versión](https://github.com/OMEGAALPHA10/OmegaSolver/releases) · [🗃️ Todas las releases](https://github.com/OMEGAALPHA10/OmegaSolver/releases) · [📄 CHANGELOG](CHANGELOG.md) · [🐛 Reportar un bug](https://github.com/OMEGAALPHA10/OmegaSolver/issues)

---

**⭐ Si te gusta el proyecto, dale una estrella en GitHub**

[![Star](https://img.shields.io/github/stars/OMEGAALPHA10/OmegaSolver?style=social)](https://github.com/OMEGAALPHA10/OmegaSolver)

</div>
