# ⚡ OmegaSolver V4.3

**OmegaSolver** es una suite gráfica (GUI) de diagnóstico, mantenimiento y optimización para Windows, desarrollada íntegramente en **PowerShell + WPF** y compilada a `.exe` mediante **PS2EXE**. Diseñada para simplificar tareas técnicas complejas sin sacrificar la potencia para usuarios avanzados.

> 🇻🇪 Proyecto personal de código abierto desarrollado desde Venezuela.

---

## 🆕 Última versión: V4.3 — "Multilingual & Network"

![Tag V4.3](https://img.shields.io/badge/-V4.3-E11D48?style=flat-square)
![Novedad principal](https://img.shields.io/badge/-Multilenguaje%20ES%2FEN%2FPT-F43F5E?style=flat-square)
![Novedad](https://img.shields.io/badge/-Easy%20Context%20Menu-F43F5E?style=flat-square)
![Novedad](https://img.shields.io/badge/-Auto--Update-F43F5E?style=flat-square)
![Novedad](https://img.shields.io/badge/-Compartir%20Archivos-F43F5E?style=flat-square)

### 🌐 Sistema multilenguaje (ES / EN / PT)
Menú desplegable en la barra superior para cambiar el idioma **en caliente, sin reiniciar**:
- 🇪🇸 **Español** (idioma por defecto)
- 🇺🇸 **English**
- 🇧🇷 **Português**

El idioma se **persiste** en `%ProgramData%\OmegaSolver\language.txt`.

### 📖 Manual de usuario en 3 columnas (Bilingüe + Técnico)
Ventana modal que muestra **los 3 idiomas en paralelo**, con dos niveles de explicación por cada función:
- **`BAS`** — Explicación amigable para usuarios sin experiencia técnica.
- **`TEC`** — Explicación técnica (parámetros, comandos, registro, GUIDs).

Se adapta automáticamente al **Modo Básico** o **Modo Avanzado**.

### 📡 Compartir Archivos por Red (exclusivo modo Avanzado)
Nueva ventana independiente para transferir archivos entre tu PC y:
- Otra **PC con Windows** (vía **Robocopy / SMB**).
- **Móviles Android / iOS** o **Smart TV** (vía **FTP**).

Detecta automáticamente tus IPs locales, permite copiar al portapapeles, seleccionar carpeta local, y elegir dirección (Enviar / Recibir). Registro de progreso en vivo.

### 🔄 Auto-Update Checker (GitHub Releases)
Al iniciar, la app consulta la API de GitHub para verificar si hay una nueva versión publicada:
- Si hay nueva versión → badge naranja con link directo al release.
- Si estás actualizado → aviso confirmando versión actual.
- Si no hay internet → aviso amigable, sin bloquear la app.

También puedes forzar la comprobación manual con el icono **🔄** en la barra superior.

### 🐢 Modo Low (bajos recursos)
Pensado para PCs con hardware limitado (Celeron, 4GB RAM, gráficos integrados):
- Desactiva los efectos `DropShadowEffect` (costosos en WPF).
- Reduce el grosor de bordes.
- Se **persiste** entre sesiones.

### 🧩 Integración con Easy Context Menu
Al iniciar, la app detecta si tienes **Easy Context Menu** (Sordum) instalado:
- **Si está instalado** → te guía paso a paso para agregar OmegaSolver al menú contextual.
- **Si NO está instalado** → te ofrece abrir la página oficial de descarga.

### 🛠️ Herramientas inspiradas en Dism++
- **Crear Punto de Restauración** — `Checkpoint-Computer` vía VSS.
- **Gestionar Programas de Inicio** — `Win32_StartupCommand`.
- **Analizar Actualizaciones** — `Win32_QuickFixEngineering`.
- **Gestor de Archivos Bloqueados** — `takeown + icacls + Remove-Item`.
- **Limpiar Controladores Obsoletos** — `pnputil + DISM /StartComponentCleanup`.

### 🧹 Limpieza en 1-Clic
Botón verde separado de la Reparación Completa:
- Temporales de usuario y sistema.
- Prefetch.
- Caché DNS.
- Cachés de Edge y Chrome.
- Papelera de reciclaje.

### 🖥️ Detección de resolución robusta (DPI Adaptive)
Sistema de 3 fallbacks para detectar la resolución real (útil en TVs, monitores 4K, o PCs con DPI escalado):
1. `SystemParameters.WorkArea`
2. `PrimaryScreenWidth/Height`
3. `System.Windows.Forms.Screen`

La ventana se posiciona manualmente centrada y **nunca queda cortada por arriba**.

---

## 🎨 Versión anterior: V4.2 — "Balanced UX & Neon"

![Tag V4.2](https://img.shields.io/badge/-V4.2-8B5CF6?style=flat-square)
![Novedad principal](https://img.shields.io/badge/-OMEGASOLVER%20style-A855F7?style=flat-square)
![Novedad](https://img.shields.io/badge/-Custom%20Chrome-A855F7?style=flat-square)
![Novedad](https://img.shields.io/badge/-Layout%20Balanceado-A855F7?style=flat-square)

### 🎨 Tema "OMEGASOLVER style"
Tema alienígena inspirado en *Murder Drones* con **6 sub-paletas neón**:
- 🟡 Amarillo (Cyn & N)
- 🟡 Amarillo (V)
- 🔴 Rojo (Doll)
- 🟣 Morado (Uzi)
- 🟣→🟡 **Gradiente real** (Uzi Post-Cyn) — usa `LinearGradientBrush` vertical.
- 🟢 Verde (Lizzy)

Aplica fuente `Rajdhani / Orbitron` con fallback a `Consolas`, título con glow neón (`◤ OMEGASOLVER ◢`), y borde con `DropShadowEffect`.

### 🖼️ Custom Chrome
Ventana sin decoración nativa de Windows (`WindowStyle="None"`):
- Barra de título personalizada que respeta el tema activo.
- Arrastre desde cualquier zona de la barra.
- Botones de minimizar / maximizar / cerrar con hover.
- Máximo → esquinas cuadradas. Normal → esquinas redondeadas.

### ⚖️ Layout balanceado en Modo Básico (2 columnas)
Reorganización del modo simple:
- **Columna izquierda**: 🛠️ Reparar mi PC + 🛡️ Seguridad.
- **Columna derecha**: 🧹 Limpieza + 🌐 Arreglar Internet.

Elimina el hueco visual y equilibra el contenido. El **Modo Avanzado** mantiene las 3 columnas por categoría.

### 🔧 Instancia única (Mutex)
Imposible abrir dos OmegaSolver simultáneamente. Si lo intentas, te avisa que ya hay una ejecución en curso.

### 🛡️ Protección SSD (heredada de V4.0)
El botón de desfragmentación se **bloquea automáticamente** si el disco objetivo es un SSD (`Get-PhysicalDisk.MediaType`).

### 🎯 Enumeración rápida de archivos
Diagnóstico inicial **10-50x más rápido** gracias a `DirectoryInfo.EnumerateFiles` en lugar de `Get-Item` por archivo.

---

## 📊 Tabla comparativa de versiones

| Característica | V4.0 | **V4.2** | **V4.3** |
|---|:---:|:---:|:---:|
| Interfaz WPF moderna | ✅ | ✅ | ✅ |
| Temas visuales | 17 | 17 + **OMEGASOLVER style (6 sub)** | 17 + **OMEGASOLVER style (6 sub)** |
| Layout Básico / Avanzado | 3 col / 3 col | **2 col / 3 col** | 2 col / 3 col |
| Protección SSD | ✅ | ✅ | ✅ |
| Manual integrado | Bilingüe | Bilingüe | **3 idiomas + Básico/Técnico** |
| **Idiomas UI** | ES | ES | **ES / EN / PT** |
| Sistema de Reversión | ✅ | ✅ | ✅ |
| Instancia única | ❌ | ✅ | ✅ |
| **Custom Chrome** | ❌ | ✅ | ✅ |
| **Detección DPI robusta** | Básica | Básica | **Triple fallback** |
| **Modo Low** | ❌ | ❌ | ✅ |
| **Auto-Update (GitHub)** | ❌ | ❌ | ✅ |
| **Compartir Archivos (Red)** | ❌ | ❌ | ✅ |
| **Easy Context Menu** | ❌ | ❌ | ✅ |
| **Herramientas Dism++** | ❌ | ❌ | ✅ |
| **Limpieza 1-Clic separada** | ❌ | ❌ | ✅ |
| **Punto de Restauración** | ❌ | ❌ | ✅ |
| **Gestor de Inicio** | ❌ | ❌ | ✅ |
| **Gestor de Archivos Bloqueados** | ❌ | ❌ | ✅ |
| **Limpieza de Drivers** | ❌ | ❌ | ✅ |

---

## 📥 Instalación y ejecución

### Opción 1 — Ejecución directa (recomendado)

1. Descarga **`OmegaSolver V4.3.exe`** desde la sección [Releases](https://github.com/OMEGAALPHA10/OmegaSolver/releases/latest).
2. Clic derecho sobre el archivo → **Ejecutar como administrador**.
3. Acepta la solicitud de elevación de UAC.
4. La interfaz se abrirá automáticamente.

> ⚠️ **Nota de Administrador**: El programa requiere permisos elevados para interactuar con servicios, registro y herramientas nativas (SFC/DISM/CHKDSK).

### Opción 2 — Desde consola

```cmd
"OmegaSolver V4.3.exe"
```

### Opción 3 — Verificación de integridad SHA256

```powershell
Get-FileHash "OmegaSolver V4.3.exe" -Algorithm SHA256
```

---

## 🔐 Verificación de firma (usuarios avanzados)

### ¿Qué es el archivo `OmegaSolver.cer`?

Es la **clave pública** del certificado de firma digital con el que se firman los ejecutables. Permite verificar que un `.exe` fue publicado legítimamente por **OMEGA_ALPHA** y **no ha sido alterado** desde su firma.

### ¿Qué verifica exactamente?

1. **Integridad** — Que el archivo no se modificó después de firmarlo.
2. **Identidad** — Que fue firmado por `CN=OMEGA_ALPHA`.
3. **Autenticidad temporal** — Que la firma se hizo mientras el certificado era válido.

### ⚠️ Lo que NO verifica

Firmar **NO significa** que el software sea seguro. Significa únicamente que fue creado por esa persona y no se modificó después.

### Método gráfico (Windows)

1. Clic derecho sobre el `.exe` → **Propiedades** → pestaña **Firmas digitales**.
2. Debe aparecer: **OMEGA_ALPHA** como firmante.

### Método técnico (PowerShell)

```powershell
# Importar el certificado como confiable (solo una vez)
Import-Certificate -FilePath "OmegaSolver.cer" `
                   -CertStoreLocation "Cert:\CurrentUser\TrustedPublisher"

# Verificar
Get-AuthenticodeSignature "OmegaSolver V4.3.exe" |
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
| **.NET Framework** | 4.7.2 o superior (incluido en Windows actualizado) |
| **Permisos** | Administrador |
| **PowerShell** | No requiere instalación (runtime empaquetado en el `.exe`) |

---

## 🗂️ Estructura de archivos generados

```
%ProgramData%\OmegaSolver\
├── reversible-state.json    # Estado para reversión de cambios
├── theme.txt                # Tema visual seleccionado
├── omega-subcolor.txt       # Sub-paleta de OMEGASOLVER style
├── low-mode.txt             # Estado del Modo Low
├── language.txt             # Idioma seleccionado (ES/EN/PT)
└── omega-warning.ack        # Confirmación de advertencia OMEGASOLVER
```

OmegaSolver es **100% offline y privado**: no recolecta, transmite ni envía telemetría a servidores externos. La única conexión a internet es la comprobación de actualizaciones en GitHub (puedes ignorarla si no hay red).

---

## 🗂️ Historial de versiones

| Versión | Tipo | Destacado |
|---|---|---|
| **V4.3** | ✅ **Release actual** | Multilenguaje ES/EN/PT, Easy Context Menu, Auto-Update, Compartir Archivos, Dism++ tools, Modo Low, Limpieza 1-Clic |
| **V4.2** | 📦 Release estable | OMEGASOLVER style (6 sub-paletas), Custom Chrome, layout balanceado 2 columnas, instancia única |
| V4.1 / ALT | 📦 Histórico | Rediseño del layout, enumeración rápida, caché SSD/HDD |
| V4.0 | 📦 Histórico | WPF completo, 17 temas, manual bilingüe adaptativo, protección SSD |
| V3.9 / V3.9 ALT | 📦 Legacy | 7 temas, Modo Básico/Avanzado, sistema de reversión |
| V3.2.2 | 📦 Legacy | Windows Forms, mantenimiento profundo, QoS |
| V3.0.0 | 📦 Legacy | Primera GUI (OmegaOpti + OmegaFix) |
| V2.0 | 🧪 Antecedente | Scripts empaquetados WinSuite |

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

Este proyecto se distribuye bajo la licencia **GNU General Public License v3 (GPLv3)**. Consulta el archivo [LICENSE](LICENSE) para conocer los términos legales completos. 

Esta licencia garantiza tu libertad para usar, modificar y compartir el software, siempre y cuando cualquier versión derivada se mantenga bajo esta misma licencia de código abierto.


---

## 🔗 Enlaces rápidos

- 📦 [Última versión (V4.3)](https://github.com/OMEGAALPHA10/OmegaSolver/releases/latest)
- 🗃️ [Todas las releases](https://github.com/OMEGAALPHA10/OmegaSolver/releases)
- 📄 [CHANGELOG](CHANGELOG.md)
- 🐛 [Reportar un bug](https://github.com/OMEGAALPHA10/OmegaSolver/issues)
