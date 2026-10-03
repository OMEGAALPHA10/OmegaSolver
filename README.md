# ⚡ OmegaSolver V4.4

**OmegaSolver** es una suite gráfica (GUI) de diagnóstico, mantenimiento y optimización para Windows, desarrollada íntegramente en **PowerShell + WPF** y compilada a `.exe` mediante **PS12EXE**. Diseñada para simplificar tareas técnicas complejas sin sacrificar la potencia para usuarios avanzados.

> 🇻🇪 Proyecto personal de código abierto desarrollado desde Venezuela.

---

## 🛠️ Código Abierto y Compilación Universal

Los scripts en PowerShell se encuentran organizados dentro de la carpeta [`open source`](open%20source). Para transformar manualmente los archivos `.ps1` en ejecutables `.exe` independientes utilizando la terminal de Windows en cualquier versión actual o futura del proyecto, sigue estos pasos:

1. **Instalar PowerShell 7+ y el compilador**: Abre una consola de PowerShell 7 como Administrador y ejecuta:

   ```powershell
   Install-Module -Name ps12exe -Scope CurrentUser -Force
