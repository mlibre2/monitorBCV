# Monitor BCV - Tipo de Cambio 🇻🇪

Un widget ligero y elegante para Windows desarrollado en **AutoIt** que permite consultar en tiempo real las tasas oficiales de divisas (USD y EUR) publicadas por el **Banco Central de Venezuela (BCV)**.

## ✨ Características

* **Tasas en Tiempo Real:** Obtiene los datos directamente desde el portal oficial del BCV.
* **Interfaz Adaptativa:** Incluye soporte para **Modo Oscuro** y **Modo Claro** con detección automática del tema de Windows.
* **Minimalista:** Diseño tipo widget sin bordes, posicionable en la esquina inferior derecha de la pantalla.
* **Funciones Rápidas:**
    * **Click para Copiar:** Al hacer clic sobre el precio, el valor se copia automáticamente al portapapeles.
    * **Acceso a Calculadora:** Botón integrado para abrir la calculadora de Windows rápidamente.
    * **Actualización Manual:** Botón de refresco para forzar la actualización de los datos.
* **Sin Instalación:** Ejecutable ligero que no requiere dependencias externas complejas.

## 🚀 Instalación y Uso

1.  Asegúrate de tener instalado [AutoIt v3](https://www.autoitscript.com/site/autoit/downloads/) si deseas ejecutar el script fuente `.au3`.
2.  Descarga el archivo `mbcv.au3`.
3.  Ejecuta el script haciendo doble clic o compílalo en un `.exe` para mayor portabilidad.

## 🛠️ Tecnologías Utilizadas

* **Lenguaje:** AutoIt v3.
* **Comunicación:** WinHttp para peticiones web ( scraping de datos oficiales).
* **Interfaz:** GUI personalizada con manejo de eventos de Windows (Win32 API).
* **Regex:** Procesamiento de texto para la extracción precisa de valores numéricos del HTML.

## 📸 Interfaz de Usuario

<img width="391" height="315" alt="en" src="https://github.com/mlibre2/monitorBCV/blob/main/img.jpg" />

## 📂 Estructura del Código

El script está organizado de la siguiente manera:
- **Manejador de Errores:** Gestión de errores COM para evitar cierres inesperados.
- **Detección de Tema:** Consulta el registro de Windows (`AppsUseLightTheme`) para ajustar los colores.
- **Web Scraping:** Uso de expresiones regulares para localizar los IDs `dolar` y `euro` en el código fuente del BCV.

## 📝 Licencia

Este proyecto es de código abierto. Siéntete libre de modificarlo y mejorarlo. 

---
*Desarrollado con ❤️ para simplificar la consulta de divisas en Venezuela.*
