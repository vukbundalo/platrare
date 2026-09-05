# Política de privacidad — Platrare

**Fecha de entrada en vigor:** 4 de septiembre de 2026

Platrare es una aplicación de finanzas personales de tipo local-first. Esta política describe los datos a los que accede la aplicación, cómo se utilizan y sus derechos.

---

## 1. Quiénes somos

Platrare es publicada por un desarrollador individual, que es el responsable del tratamiento a efectos del RGPD. Puede contactar con el desarrollador en **[support email]**, desde App Store o Google Play, o mediante **Ajustes → Acerca de → Contactar con soporte** en la aplicación.

---

## 2. Datos almacenados en su dispositivo

Todos los datos que crea en Platrare permanecen **únicamente en su dispositivo**. No operamos ningún servidor que reciba o almacene su información financiera.

**Qué se almacena localmente:**

| Categoría | Detalles |
|---|---|
| Libro de contabilidad | Cuentas, saldos, límites de descubierto, historial de transacciones, transacciones planificadas y categorías |
| Archivos adjuntos | Fotos de recibos y documentos que elija añadir a las transacciones |
| Preferencias | Moneda base, moneda secundaria, tema, idioma, configuración de visibilidad de saldo |
| Seguridad | Estado del bloqueo de la app; hash criptográfico unidireccional de su PIN (el PIN en bruto nunca se almacena) |
| Caché de tipos de cambio | Datos públicos de tasas de cambio descargados de una API de terceros y almacenados localmente |
| Recordatorios | Si activa los recordatorios de transacciones planificadas, la fecha de vencimiento, la descripción y el importe de cada transacción planificada próxima se entregan al programador de notificaciones locales del sistema operativo para que pueda mostrar el recordatorio incluso con la aplicación cerrada. Nunca salen del dispositivo. |
| Instantánea del widget de pantalla de inicio (iOS) | Un pequeño resumen precalculado (saldos proyectados para los próximos días y las etiquetas que muestra el widget) almacenado en el contenedor compartido privado de la app para que el widget pueda mostrarse sin abrir la aplicación. Cuando el bloqueo de la app está activado, los importes de esta instantánea se ocultan salvo que elija lo contrario en Ajustes. |

---

## 3. Datos enviados por Internet

### 3.1 Tipos de cambio

La aplicación obtiene periódicamente datos de tipos de cambio de la **API Frankfurter** (api.frankfurter.dev / api.frankfurter.app), que publica datos del **Banco Central Europeo (BCE)**. Estas solicitudes no contienen información personal: son llamadas HTTP anónimas estándar. Sus cuentas, saldos y transacciones nunca se transmiten. Los datos se almacenan en caché hasta **6 horas**.

### 3.2 Sin analíticas ni publicidad

Platrare **no incluye ningún SDK de analíticas, servicio de informes de fallos ni red publicitaria**. No se recopilan datos de uso, identificadores de dispositivos ni telemetría de comportamiento. Los recordatorios, los widgets de pantalla de inicio y los atajos funcionan completamente sin conexión.

---

## 4. Permisos del dispositivo

| Permiso | Propósito | Cuándo se solicita |
|---|---|---|
| Cámara | Capturar fotos de recibos | Solo al pulsar "Tomar foto" |
| Fototeca | Seleccionar imágenes para adjuntar | Solo al pulsar "Elegir de la galería" |
| Archivos | Adjuntar PDFs y documentos | Solo al pulsar "Examinar archivos" |
| Biometría / Face ID | Desbloquear la aplicación | Solo cuando aparece la pantalla de bloqueo |
| Notificaciones | Recordarle poco antes del vencimiento de una transacción planificada | Solo al activar los recordatorios en Ajustes |
| Ejecutar al inicio (Android) | Reprogramar sus recordatorios tras reiniciar el dispositivo | Automáticamente, solo si los recordatorios están activados |
| Red | Obtener tipos de cambio | Automáticamente; no se envían datos personales |

La aplicación no solicita acceso a ubicación, contactos, micrófono, calendario ni ningún otro permiso no indicado arriba.

---

## 5. Bloqueo de la app y biometría

Al activar **Bloquear la app al abrirla**:

- La app usa el framework biométrico seguro del SO (iOS LocalAuthentication / Android BiometricPrompt). Sus datos biométricos son procesados íntegramente en el enclave seguro del SO: la app nunca los ve, almacena ni transmite.
- Si establece un PIN, solo se almacena en el dispositivo un **hash criptográfico unidireccional** de ese PIN. El PIN en bruto nunca se escribe en disco.

---

## 6. Copias de seguridad

**Exportar** crea un archivo `.zip` (sin cifrar) o `.platrare` (cifrado AES-256 con contraseña). Usted elige dónde guardarlo. **Nunca recibimos su copia de seguridad.**

**La copia de seguridad diaria automática** guarda un archivo solo en el almacenamiento privado del dispositivo. No sube nada a la nube automáticamente. Puede compartirlo manualmente mediante **Ajustes → Copia de seguridad automática → Guardar en la nube**.

**Importar** reemplaza todos los datos del dispositivo con el contenido de la copia de seguridad. Importe solo de fuentes de confianza.

Solo las exportaciones `.platrare` cifradas con contraseña incluyen el hash del PIN de bloqueo de la app; las exportaciones sin cifrar y las copias de seguridad diarias automáticas nunca lo incluyen. Al restaurar una copia de seguridad sin PIN, se conserva el PIN ya establecido en el dispositivo.

**Copias de seguridad del dispositivo del sistema operativo.** La función de copia de seguridad propia de su teléfono (iCloud Backup en iOS, Google Auto Backup en Android) puede copiar el libro de contabilidad de la app, las copias de seguridad diarias automáticas y las preferencias a su cuenta de Apple o Google como parte de la copia de seguridad del dispositivo, según los términos de Apple o Google. En Android, los recibos adjuntos quedan excluidos para no superar el límite de la copia de seguridad del sistema. Usted controla las copias de seguridad del dispositivo en los ajustes del sistema operativo; el desarrollador nunca las recibe.

---

## 7. Widgets, atajos y Siri (iOS)

- **Los widgets de pantalla de inicio** muestran saldos proyectados a partir de la instantánea descrita en la sección 2. La instantánea reside en el contenedor compartido privado de la app en su dispositivo y nunca se sube. Cuando el bloqueo de la app está activado, los importes se ocultan de forma predeterminada.
- **Las acciones rápidas y los App Shortcuts** (pulsación larga en el icono de la app, la app Atajos o Siri) solo abren la aplicación en una pantalla determinada, por ejemplo "Añadir transacción". El reconocimiento de voz de Siri lo realiza iOS según los términos de privacidad de Apple; la app recibe únicamente el comando resuelto y nunca envía su libro de contabilidad a Apple.

---

## 8. Menores

Platrare no está destinada a menores de 13 años. No recopilamos información de menores de manera intencional.

---

## 9. Retención y eliminación de datos

Los datos permanecen en su dispositivo hasta que los elimine dentro de la app, use **Ajustes → Borrar datos**, importe una copia de seguridad de reemplazo o desinstale la aplicación. Como no tenemos ninguna copia de sus datos en nuestros servidores, no hay nada que eliminar por nuestra parte.

---

## 10. Sus derechos

- **Acceso y portabilidad** — Todos los datos son visibles en la app. Use **Exportar copia de seguridad** para obtener una copia portable.
- **Corrección** — Edite cualquier registro en cualquier momento.
- **Eliminación** — Use las funciones de eliminación en la app, **Borrar datos** o desinstale.

**Usuarios del EEE/Reino Unido:** El RGPD y el UK GDPR pueden otorgarle derechos adicionales, incluido el derecho a reclamar ante su autoridad supervisora local.

**Residentes en California:** La CCPA/CPRA puede aplicarse. Como no vendemos ni compartimos datos personales, los derechos de exclusión no se aplican en la mayoría de los casos.

---

## 11. Seguridad

- Datos en una base de datos **aislada en la app**, inaccesible para otras apps.
- Copias de seguridad protegidas con **cifrado AES-256** opcional.
- PINs almacenados como **hash criptográfico unidireccional**.
- Tráfico de red exclusivamente por **HTTPS**.

---

## 12. Cambios

Podemos actualizar esta política cuando evolucionen las funciones. La **Fecha de entrada en vigor** reflejará la última revisión. El uso continuado implica la aceptación de los cambios.

---

## 13. Contacto

Para preguntas o solicitudes relacionadas con la privacidad, escriba a **[support email]**, use el método de contacto de App Store o Google Play, o pulse **Ajustes → Acerca de → Contactar con soporte** en la app.
