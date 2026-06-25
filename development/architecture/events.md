# Estandarización de Arquitectura de Eventos - MDK

Este documento define el estándar de arquitectura para el manejo de eventos en los microservicios de **MDK | Markitos DevSecOps Kulture**. La filosofía subyacente es *El camino del artesano*: simplicidad, resiliencia y desacoplamiento.

---

## 1. Filosofía de Resiliencia Híbrida

Hemos clasificado los eventos en dos carriles operativos para optimizar el rendimiento y garantizar la consistencia donde es estrictamente necesario.

### Carril 1: Eventos Efímeros

* **Propósito:** Telemetría, logs, notificaciones, auditoría no crítica.
* **Tolerancia:** Se acepta la pérdida de datos ante un fallo catastrófico del nodo (evento de "mejor esfuerzo").
* **Infraestructura:** Sidecar `event-relay` + `SQLite` (Volumen `emptyDir`).
* **Ventaja:** Baja latencia, cero carga en la base de datos principal, desacoplamiento total.

### Carril 2: Eventos Críticos

* **Propósito:** Transacciones financieras, cambios de estado del negocio, auditoría legal.
* **Tolerancia:** Consistencia absoluta. No se permite la pérdida de datos.
* **Infraestructura:** Patrón `Outbox` dentro de la base de datos principal (PostgreSQL) + `event-relay` leyendo de la tabla `outbox`.
* **Ventaja:** Garantía de atomicidad (el evento se guarda en la misma transacción que el cambio de estado).

---

## 2. El Productor: Golden Client SDK

Todo microservicio debe utilizar el SDK centralizado para emitir eventos. Esto garantiza uniformidad, validación de esquemas y facilidad de mantenimiento.

* **Repositorio:** `github.com/markitos-it/go-sdk`
* **Contrato:** El servicio de dominio interactúa mediante la interfaz `EventClient`.
* **Validación:** El SDK implementa validación estricta de `JSON` antes de persistir, evitando *poison pills* en el relayer.

### Ejemplo de uso en microservicio

```go
// Inicialización (Inyección de dependencias)
client, _ := eventclient.NewSQLiteClient("/var/lib/outbox/events.db")

// Emisión de evento (el dominio no conoce la infraestructura)
err := client.Publish(ctx, `{"user_id": 123, "action": "login"}`)

```

---

## 3. El Consumidor: Event Relay (Sidecar)

El `event-relay` es un binario independiente desplegado como *sidecar* en Kubernetes. Su única responsabilidad es el transporte seguro y eficiente de datos.

* **Repositorio:** `github.com/markitos-it/event-relay`
* **Patrón de Despliegue:** Sidecar en POD (via `emptyDir` para SQLite).
* **Factory Pattern:** El `main.go` utiliza una variable de entorno `BUS_TYPE` para inyectar el adaptador de bus necesario (`pubsub`, `kafka`, `mock`), manteniendo el código agnóstico al proveedor.
* **Resiliencia:**
* **WAL Mode:** Uso obligatorio de `?_journal_mode=WAL` en SQLite para permitir lectura/escritura concurrente.
* **Graceful Shutdown:** Captura de señales (`SIGTERM`) para cerrar conexiones limpiamente.
* **Backoff Exponencial:** Gestión inteligente de reintentos ante fallos del bus.



---

## 4. Observabilidad y Estándares de Operación

Todo el sistema está diseñado para integrarse con el stack **LGTM (Loki, Grafana, Tempo, Mimir/Prometheus)**.

* **Métricas:** El relayer expone métricas en `/metrics` (Prometheus) siguiendo el formato:
* `outbox_events_total{status, type}`
* `outbox_delivery_duration_seconds`


* **Logs:** Uso de niveles estructurados (`[INFO]`, `[PROCESS]`, `[WARN]`, `[SUCCESS]`) para facilitar el filtrado en Loki mediante `logfmt`.
* **Trazabilidad:** Inyección de `TraceID` en los metadatos del evento para permitir la correlación de extremo a extremo mediante **Tempo**.

---

## 5. Configuración de Despliegue (Kubernetes)

Cada microservicio debe incluir el sidecar en su especificación de despliegue siguiendo este patrón:

```yaml
spec:
  containers:
    - name: app
      volumeMounts:
        - name: event-buffer
          mountPath: /var/lib/outbox
    - name: event-relay
      image: europe-southwest1-docker.pkg.dev/markitos-it-local/images/event-relay:latest
      env:
        - name: BUS_TYPE
          value: "pubsub"
      volumeMounts:
        - name: event-buffer
          mountPath: /var/lib/outbox
  volumes:
    - name: event-buffer
      emptyDir: {}

```

---

## 6. Ciclo de Vida del Desarrollo

1. **Iteración:** El `event-relay` se desarrolla de forma aislada para asegurar calidad mediante *unit tests* y *benchmarks*.
2. **Versión:** El relayer y el SDK se versionan semánticamente (`SemVer`).
3. **Actualización:** Al actualizar la imagen del relayer en el *deployment*, los microservicios obtienen mejoras de seguridad y rendimiento automáticamente al reiniciar el POD.

*Este documento es un estándar vivo; cualquier modificación en el contrato de eventos o en la capa de persistencia debe ser revisada y aprobada bajo los criterios de resiliencia aquí expuestos.*