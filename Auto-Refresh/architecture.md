```mermaid
flowchart LR
    TIMER["CL_GUI_TIMER"]
    EVENTO["Evento FINISHED"]
    LOGICA["Lógica de Negocio"]
    REINICIO["Reinicio del Timer"]

    TIMER --> EVENTO
    EVENTO --> LOGICA
    LOGICA --> REINICIO
    REINICIO --> TIMER
