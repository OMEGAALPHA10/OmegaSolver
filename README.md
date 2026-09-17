# ⚡ OmegaSolver

[![Versión](https://img.shields.io/badge/versi%C3%B3n-V3.9-blue)](https://github.com/OMEGAALPHA10/OmegaSolver/releases/latest)
[![Plataforma](https://img.shields.io/badge/plataforma-Windows%2010%20%7C%2011-0078D4)](https://www.microsoft.com/windows)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%20%7C%207.x-blue)](https://microsoft.com/powershell)
[![Licencia](https://img.shields.io/badge/licencia-MIT-green)](LICENSE)
[![Estado](https://img.shields.io/badge/estado-estable-success)](https://github.com/OMEGAALPHA10/OmegaSolver/releases/latest)

**OmegaSolver** es una herramienta gráfica (GUI) desarrollada en **PowerShell + WPF** diseñada para simplificar el diagnóstico, mantenimiento profundo y optimización de sistemas Windows. Reúne las herramientas nativas de Windows en una interfaz moderna con **Modo Básico/Avanzado**, **7 temas visuales** y **sistema de reversión de cambios**.

---

## ✨ Características principales

### 🎯 Doble modo de uso
- **Modo Básico** (predeterminado): interfaz limpia con nombres simples para usuarios sin experiencia técnica. Oculta estadísticas y registro.
- **Modo Avanzado**: activable con el checkbox superior derecho. Muestra nombres técnicos, panel de estadísticas y registro de actividad.

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
- Genera recomendaciones personalizadas.

### 🛠️ Reparación completa
- **SFC** (`/scannow`) online u offline según disco seleccionado.
- **DISM** (`/RestoreHealth`) online u offline.
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

# ⚡ OmegaSolver V3.2.2

**OmegaSolver** es una herramienta gráfica (GUI) desarrollada en PowerShell y WPF diseñada para simplificar el diagnóstico, mantenimiento profundo y optimización de red en sistemas Windows.

![OmegaSolver GUI](https://raw.githubusercontent.com/OMEGAALPHA10/OmegaSolver/main/preview.png) <!-- Reemplaza con la ruta de una captura de tu interfaz si la tienes -->

---

## 🌟 Características Principales

### 🛠️ Diagnostic & Sistema
* **SFC /Scannow:** Escaneo y reparación de archivos dañados del sistema.
* **DISM /RestoreHealth:** Reparación de la imagen base de Windows.
* **CHKDSK:** Diagnóstico y verificación del estado del disco duro.

### 🌐 Red y Conexión
* **Limpieza DNS:** Vaciado de la caché DNS (`ipconfig /flushdns`).
* **Reset de Red:** Restablecimiento de sockets Winsock e IP.
* **🚀 Desbloqueo de Ancho de Banda QoS:** Ajusta el *Límite de ancho de banda reservable* al `0%` directamente en el registro (`HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched`) para liberar la reserva del sistema.

### 🚀 Mantenimiento & Limpieza Profunda
* **Limpieza de Windows Update:** Vaciado seguro de descargas temporales (`SoftwareDistribution\Download`).
* **Depuración WinSxS:** Eliminación de componentes antiguos e innecesarios (`DISM /StartComponentCleanup /ResetBase`).
* **Depuración de Temporales:** Limpieza de registros CBS, cachés de navegadores Chromium (Edge / Chrome) y archivos temporales de usuario/sistema.
* **Papelera y Mantenimiento:** Vaciado automático de la Papelera de Reciclaje y ejecución del Liberador de Espacio nativo (`cleanmgr`).

### ⚡ Reparación 1-Clic
* Ejecución automatizada en secuencia: **Flush DNS ➡️ Limpieza Profunda Profunda ➡️ Análisis SFC**.

---

## 💻 Requisitos
* **Sistema Operativo:** Windows 10 / Windows 11 (64-bit)
* **Permisos:** Requiere ejecutarse como **Administrador** (UAC).

---

## OmegaSolver v3.0 - Centro de Mantenimiento Avanzado
¡Bienvenido a OmegaSolver! Una suite de optimización, limpieza y reparación profunda de Windows diseñada en PowerShell y estructurada bajo una interfaz gráfica interactiva utilizando Windows Forms. Este es un proyecto de código abierto enfocado en brindar transparencia técnica total tanto a usuarios comunes como a administradores de sistemas.
------------------------------
## 🚀 Módulos y Características Principales
El Toolkit se divide en dos grandes enfoques operativos basados en scripts híbridos avanzados:

| Módulo | Operación Técnica | Beneficio Real |
|---|---|---|
| OmegaOpti (Limpieza) | Purgado de Temporales, Caché DNS, Prefetch y Papelera de Reciclaje | Libera gigabytes de almacenamiento residual de forma inmediata. |
| OmegaOpti Advanced | Mantenimiento Multidisco Automatizado (D:, E:, etc.) | Escanea de forma inteligente unidades secundarias para vaciar carpetas $Recycle.Bin. |
| OmegaFix (Reparación) | Verificación SFC, Reparación de Imagen DISM y Reseteo Winsock/IP | Soluciona archivos corruptos del sistema y restablece la pila de red ante fallas. |
| OmegaFix 1-Clic | Diagnóstico Integral Secuencial Automatizado | Ejecuta todo el protocolo de reparación en un solo bloque con reportes en tiempo real. |

------------------------------
## 🛠️ Requisitos Técnicos de Ejecución
Debido a que las herramientas nativas modifican registros y dependencias del sistema, el script cuenta con las siguientes políticas:

   1. Privilegios de Administrador Obligatorios: El script incluye un sistema de auto-elevación nativo. Si no se ejecuta con privilegios elevados, solicitará de forma transparente el Control de Cuentas de Usuario (UAC).
   2. Registro en Tiempo Real (Live Logging): Todas las acciones se imprimen en una terminal interactiva dentro de la interfaz y se guardan localmente para auditorías.

------------------------------
## ⚠️ Advertencias y Seguridad Técnica

* Uso de DISM: La velocidad de reparación de la imagen del sistema dependerá directamente del tipo de hardware del usuario (unidades SSD procesarán el cambio de forma veloz, mientras que unidades HDD mecánicas tomarán notablemente más tiempo).
* Análisis de Disco (CHKDSK): Al solicitar un examen en la unidad activa C:, el script programará de forma segura la revisión interactiva para el próximo reinicio del sistema operativo.
* Seguridad de Código: Al ser Open Source, puedes revisar cada línea antes de presionar el botón de inicio. El software cuenta con una capa de confirmación previa antes de alterar cualquier archivo.

------------------------------
## 🧑‍💻 Autor del Proyecto

* Desarrollador Principal: OMEGA_ALPHA
* Edad de inicio del desarrollo: 16 años
* Propósito: Crear herramientas libres, transparentes y potentes para la comunidad.
* [![Descargar OmegaSolver](https://shields.io)](https://github.com)

------------------------------
## ⚖️ Licencia
Este proyecto está registrado bajo la Licencia MIT. Eres libre de usar, modificar y distribuir este software siempre y cuando mantengas los créditos del autor original. Consulta el archivo LICENSE para ver los términos legales de exención de responsabilidad.



