# OmegaSolver
Una herramienta ligera y eficiente para Windows diseñada para limpiar la caché del sistema y automatizar tareas de mantenimiento esenciales con un solo clic. Optimiza el rendimiento, elimina archivos basura y recupera espacio en disco al instante.

# ⚡ WinSuite v2.5 - Centro de Mantenimiento Avanzado

¡Bienvenido a **WinSuite**! Una suite de optimización, limpieza y reparación profunda de Windows diseñada en **PowerShell** y estructurada bajo una interfaz gráfica interactiva utilizando Windows Forms. Este es un proyecto de código abierto enfocado en brindar transparencia técnica total tanto a usuarios comunes como a administradores de sistemas.

---

## 🚀 Módulos y Características Principales

El Toolkit se divide en dos grandes enfoques operativos basados en scripts híbridos avanzados:

| Módulo | Operación Técnica | Beneficio Real |
| :--- | :--- | :--- |
| **WinOpti** (Limpieza) | Purgado de Temporales, Caché DNS, Prefetch y Papelera de Reciclaje | Libera gigabytes de almacenamiento residual de forma inmediata. |
| **WinOpti Advanced** | Mantenimiento Multidisco Automatizado (D:, E:, etc.) | Escanea de forma inteligente unidades secundarias para vaciar carpetas `$Recycle.Bin`. |
| **WinFix** (Reparación) | Verificación SFC, Reparación de Imagen DISM y Reseteo Winsock/IP | Soluciona archivos corruptos del sistema y restablece la pila de red ante fallas. |
| **WinFix 1-Clic** | Diagnóstico Integral Secuencial Automatizado | Ejecuta todo el protocolo de reparación en un solo bloque con reportes en tiempo real. |

---

## 🛠️ Requisitos Técnicos de Ejecución

Debido a que las herramientas nativas modifican registros y dependencias del sistema, el script cuenta con las siguientes políticas:

1. **Privilegios de Administrador Obligatorios:** El script incluye un sistema de auto-elevación nativo. Si no se ejecuta con privilegios elevados, solicitará de forma transparente el Control de Cuentas de Usuario (UAC).
2. **Registro en Tiempo Real (Live Logging):** Todas las acciones se imprimen en una terminal interactiva dentro de la interfaz y se guardan localmente para auditorías.

---

## ⚠️ Advertencias y Seguridad Técnica

* **Uso de DISM:** La velocidad de reparación de la imagen del sistema dependerá directamente del tipo de hardware del usuario (unidades **SSD** procesarán el cambio de forma veloz, mientras que unidades **HDD** mecánicas tomarán notablemente más tiempo).
* **Análisis de Disco (CHKDSK):** Al solicitar un examen en la unidad activa `C:`, el script programará de forma segura la revisión interactiva para el próximo reinicio del sistema operativo.
* **Seguridad de Código:** Al ser Open Source, puedes revisar cada línea antes de presionar el botón de inicio. El software cuenta con una capa de confirmación previa antes de alterar cualquier archivo.

---

## 🧑‍💻 Autor del Proyecto

* **Desarrollador Principal:** OMEGA_ALPHA
* **Edad de inicio del desarrollo:** 16 años
* **Propósito:** Crear herramientas libres, transparentes y potentes para la comunidad.

---

## ⚖️ Licencia

Este proyecto está registrado bajo la **Licencia MIT**. Eres libre de usar, modificar y distribuir este software siempre y cuando mantengas los créditos del autor original. Consulta el archivo `LICENSE` para ver los términos legales de exención de responsabilidad.
