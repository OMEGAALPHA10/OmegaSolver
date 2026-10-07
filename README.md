<div align="center">

<img src="docs/screenshots/logo.png" alt="OmegaSolver" width="120">

# ⚡ OmegaSolver V4.4

**Suite gráfica de diagnóstico, mantenimiento y optimización para Windows**

[![Versión](https://img.shields.io/badge/version-4.4-FFD400?style=for-the-badge&logo=windowsterminal&logoColor=black)](https://github.com/OMEGAALPHA10/OmegaSolver/releases)
[![Licencia](https://img.shields.io/badge/license-GPLv3-22C55E?style=for-the-badge&logo=gnu&logoColor=white)](https://www.gnu.org/licenses/gpl-3.0)
[![Plataforma](https://img.shields.io/badge/platform-Windows%2010%20%7C%2011-0078D4?style=for-the-badge&logo=windows&logoColor=white)](https://github.com/OMEGAALPHA10/OmegaSolver)
[![PowerShell](https://img.shields.io/badge/PowerShell-7%2B-5391FE?style=for-the-badge&logo=powershell&logoColor=white)](https://github.com/PowerShell/PowerShell)
[![Winget](https://img.shields.io/badge/Winget-disponible-0078D4?style=for-the-badge&logo=windows&logoColor=white)](https://github.com/microsoft/winget-cli)
[![Sitio Web](https://img.shields.io/badge/🌐_Sitio_Web-OmegaSolver-FFD400?style=for-the-badge&logo=githubpages&logoColor=black)](https://omegaalpha10.github.io/OmegaSolver/)

[![Stars](https://img.shields.io/github/stars/OMEGAALPHA10/OmegaSolver?style=flat-square&color=FFD400)](https://github.com/OMEGAALPHA10/OmegaSolver/stargazers)
[![Forks](https://img.shields.io/github/forks/OMEGAALPHA10/OmegaSolver?style=flat-square&color=FFD400)](https://github.com/OMEGAALPHA10/OmegaSolver/forks)
[![Issues](https://img.shields.io/github/issues/OMEGAALPHA10/OmegaSolver?style=flat-square&color=FB923C)](https://github.com/OMEGAALPHA10/OmegaSolver/issues)
[![Último commit](https://img.shields.io/github/last-commit/OMEGAALPHA10/OmegaSolver?style=flat-square&color=38BDF8)](https://github.com/OMEGAALPHA10/OmegaSolver/commits/main)

**🇻🇪 Proyecto personal de código abierto desarrollado desde Venezuela**

[📥 Instalar](#-instalación) · [✨ Características](#-características) · [📸 Capturas](#-capturas) · [🔐 Firma](#-verificación-de-firma) · [🤝 Contribuir](#-contribuciones)

---

### 🌐 [**Visita la página web oficial →**](https://omegaalpha10.github.io/OmegaSolver/)

[![Abrir sitio](https://img.shields.io/badge/🌐_Abrir_Sitio_Web-omegaalpha10.github.io%2FOmegaSolver-FFD400?style=for-the-badge&logo=googlechrome&logoColor=black)](https://omegaalpha10.github.io/OmegaSolver/)
[![Descargar](https://img.shields.io/badge/⬇️_Descargar_Última_Versión-Releases-22C55E?style=for-the-badge&logo=github&logoColor=white)](https://github.com/OMEGAALPHA10/OmegaSolver/releases/latest)
[![Reportar](https://img.shields.io/badge/🐛_Reportar_Issue-Issues-FB923C?style=for-the-badge&logo=github&logoColor=white)](https://github.com/OMEGAALPHA10/OmegaSolver/issues)

</div>

---

**OmegaSolver** es una suite gráfica (GUI) de diagnóstico, mantenimiento y optimización para Windows, desarrollada íntegramente en **PowerShell + WPF** y compilada a `.exe` mediante **PS12EXE**. Diseñada para simplificar tareas técnicas complejas sin sacrificar la potencia para usuarios avanzados.

> 📖 **Documentación completa, capturas interactivas, changelog detallado y FAQ en la página oficial:**
> ### 🌐 **[https://omegaalpha10.github.io/OmegaSolver/](https://omegaalpha10.github.io/OmegaSolver/)**

---

## 🌐 Página Web Oficial

OmegaSolver cuenta con un sitio web propio donde podrás encontrar toda la información del proyecto de forma visual e interactiva:

- 🎨 **Diseño moderno** con temas dinámicos (Amarillo, Rojo, Verde, Morado y Gradiente).
- 📸 **Carrusel 3D interactivo** con capturas de la interfaz.
- 📖 **Historia del proyecto**, filosofía y visión detrás de OmegaSolver.
- 📥 **Guías de instalación** paso a paso (Winget, GitHub Releases, Microsoft Store).
- 📋 **Changelog completo**, requisitos del sistema e issues conocidos.
- 🗺️ **Roadmap público** con las próximas versiones y funciones.
- ❓ **FAQ** con todas las preguntas frecuentes.
- 🌍 **Disponible en 3 idiomas**: Español, Inglés y Portugués.

### 👉 **[Visitar página web](https://omegaalpha10.github.io/OmegaSolver/)**

---

## 🛠️ Código Abierto y Compilación Universal

Los scripts en PowerShell se encuentran organizados dentro de la carpeta [`open source`](open%20source). Para transformar manualmente los archivos `.ps1` en ejecutables `.exe` independientes utilizando la terminal de Windows en cualquier versión actual o futura del proyecto, sigue estos pasos:

<details open>
<summary><b>📦 Ver pasos de compilación manual</b></summary>

<br>

**1. Instalar PowerShell 7+ y el compilador** — Abre una consola de PowerShell 7 como Administrador y ejecuta:

```powershell
Install-Module -Name ps12exe -Scope CurrentUser -Force
