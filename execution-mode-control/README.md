# Execution Mode Control (ABAP Template)

## Overview

Template reutilizable para controlar el modo de ejecución de reportes ABAP, permitiendo habilitar o deshabilitar ejecución en modo:

* Online
* Background Job

---

## Purpose

* Evitar ejecuciones incorrectas
* Controlar comportamiento de reportes
* Estandarizar lógica reutilizable

---

## How it works

El template modifica dinámicamente las opciones disponibles en la pantalla de selección utilizando:

* AT SELECTION-SCREEN OUTPUT
* Exclusión de códigos de función (SJOB / ONLI)

---

## Features

* Control dinámico de ejecución
* Encapsulado en clase
* Fácil integración en reportes existentes

---

## Usage

1. Instanciar la clase
2. Configurar modo de ejecución
3. Llamar método `check` en evento de pantalla

---

## Notes

Este template puede combinarse con otros como:

* Exception Framework
* Logging
* Job Control

---

## Author

Daniel Escobar
SAP Technical Lead
