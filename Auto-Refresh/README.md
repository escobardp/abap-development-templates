# Auto-Refresh

## Objetivo

Template reutilizable para ejecutar procesos automáticos de actualización utilizando la clase estándar SAP CL_GUI_TIMER.

## Casos de uso

### Monitoreo

Actualización automática de ALV sin intervención del usuario.

### Keep Alive

Prevención de cierre de sesión por inactividad en entornos con tiempos de espera reducidos.

## Funcionamiento

El temporizador dispara periódicamente el evento FINISHED.

Al finalizar cada ciclo:

1. Se ejecuta la lógica requerida.
2. Se reinicia el temporizador.
3. Se mantiene la ejecución continua.

## Consideraciones

* Evitar intervalos demasiado pequeños.
* Controlar impacto sobre base de datos.
* Detener el temporizador al abandonar la transacción.

## Clase SAP utilizada

CL_GUI_TIMER
