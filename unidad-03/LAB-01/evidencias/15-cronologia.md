## Exportación e integridad de la bitácora

La bitácora vigente se exportó desde el servidor con la contraseña del rol desechable de la Actividad 6 sustituida por `<REDACTED>` antes de que el texto saliera de la base de datos. Comprobé que la contraseña original ya no aparece en el archivo (`grep -c` devuelve 0).

**Hash SHA-256 de `evidencias/bitacora-lab01.log`:**
```
77ea28c381bacd9c73d3356fd3dac92cee40a28a1929e50094c06bb18f7e8edf
```

**1. Un resumen SHA-256, ¿impide que alguien modifique la bitácora? ¿Qué permite demostrar?**
No impide nada: cualquiera con acceso al archivo puede editarlo. Lo que permite es detectar la modificación, porque si cambia un solo carácter el hash resultante es completamente distinto. Si el hash que guardé hoy coincide con el del archivo que me presentan después, puedo demostrar que es idéntico al que exporté en ese momento. Lo que no demuestra es que el contenido sea verdadero, ni quién lo generó, ni que nadie lo haya alterado antes de calcular el hash.

**2. ¿Dónde debería guardarse el hash para que sea útil como control de integridad?**
En un lugar distinto e independiente del archivo, de preferencia de solo lectura y bajo la custodia de otra persona o área. Si el hash vive junto al `.log`, quien pueda modificar el archivo también puede recalcular y reemplazar el hash, y el control no sirve. Lo ideal sería registrarlo en el momento de la exportación en un sistema externo (por ejemplo, un repositorio con permisos restringidos o un registro que administre el área de seguridad), con fecha. Esto se relaciona con la separación de funciones: quien opera la base no debería custodiar la evidencia.

**3. La guía NIST SP 800-92 trata la conservación y protección de bitácoras. ¿Qué riesgos tiene conservar la bitácora solo en el servidor que la produce?**
Varios. Pérdida: si el contenedor se elimina, el servidor se reinstala o el archivo rota sin que nadie lo respalde, la evidencia desaparece. Alteración: en este laboratorio vimos que un administrador con control total puede cambiar `log_statement` o desactivar el disparador, y también podría editar o borrar los archivos. Compromiso del servidor: si alguien lo vulnera, puede borrar sus propias huellas en el mismo lugar donde se guardan. Acceso de terceros y secretos expuestos: la bitácora puede contener datos sensibles, como la contraseña en texto claro de la Actividad 6, y cualquiera con acceso al servidor la puede leer. Y además, si el servidor falla, no hay una copia independiente para investigar. Por eso conviene enviarla a un sistema externo administrado por otra área.

**4. Propón durante cuánto tiempo conservarías esta bitácora y justifica tu criterio.**
Propongo conservarla un año como mínimo, disponible para consulta. Mi criterio es que un cambio erróneo como el del RFC puede descubrirse meses después, cuando facturación hace un cierre o una conciliación, así que la bitácora debe cubrir al menos un ciclo completo de ese tipo de revisiones. No la conservaría indefinidamente, porque contiene datos personales, direcciones IP y posibles secretos, y mantenerla más tiempo del necesario aumenta el riesgo y choca con el principio de minimización de la política de retención de la Unidad II. El plazo definitivo no lo decidiría yo sola: debe fijarlo el responsable de los datos junto con el área legal o de cumplimiento, y es lo que se formaliza en el LAB-03.
