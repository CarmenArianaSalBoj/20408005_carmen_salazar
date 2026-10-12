# ACTIVIDAD 10. Política mínima de protección de claves criptográficas

## Objetivo

Establecer reglas básicas para generar, almacenar, utilizar, respaldar, rotar y eliminar claves criptográficas de forma segura, reduciendo el riesgo de exposición y uso no autorizado.

## Comando o procedimiento

Se identificaron las etapas principales del ciclo de vida de las claves criptográficas y se formularon reglas para cada una, considerando su confidencialidad, disponibilidad, control de acceso y eliminación segura.

## Resultado obtenido

Se definió la siguiente política mínima de protección de claves criptográficas:

### Política de protección de claves

**Regla 1. Generación segura**

Las claves criptográficas deben generarse mediante herramientas o bibliotecas criptográficas confiables que utilicen fuentes de aleatoriedad seguras. No deben crearse manualmente con valores predecibles.

**Regla 2. Almacenamiento protegido**

Las claves deben almacenarse en un gestor de secretos, KMS o HSM apropiado para el entorno. No deben guardarse en texto claro dentro del código fuente, archivos SQL, repositorios Git o documentación.

**Regla 3. Acceso restringido**

Únicamente las personas y aplicaciones autorizadas podrán acceder a las claves necesarias para sus funciones. Se aplicará el principio de mínimo privilegio y se revisarán periódicamente los permisos.

**Regla 4. Separación de datos y claves**

Las claves deben mantenerse separadas de los datos cifrados y de los archivos que contienen el código que los procesa. Esto reduce el riesgo de que una sola exposición comprometa tanto los datos como las claves.

**Regla 5. Rotación periódica y por riesgo**

Las claves deberán rotarse de acuerdo con la política de la organización, su periodo de uso y el nivel de riesgo. También deberán cambiarse cuando exista sospecha o confirmación de exposición, considerando cómo se mantendrá el acceso a los datos cifrados anteriormente.

**Regla 6. Respaldo seguro**

Las claves que necesiten respaldo deberán copiarse mediante procedimientos autorizados, cifrarse o protegerse con mecanismos equivalentes y almacenarse en ubicaciones restringidas. Se deberá comprobar que puedan recuperarse de forma segura cuando sea necesario.

**Regla 7. Revocación ante exposición**

Si una clave se expone o se sospecha que ha sido comprometida, deberá restringirse o revocarse su uso según el procedimiento de respuesta a incidentes. También se evaluará qué información pudo verse afectada y si es necesario volver a cifrarla.

**Regla 8. Prevención de exposición accidental**

Antes de publicar cambios en GitLab, se revisarán los archivos para detectar claves, contraseñas, tokens y otros secretos. Si una clave real se publica por error, eliminar el archivo del repositorio no será suficiente: se deberá considerar comprometida y gestionar su rotación o revocación.

**Regla 9. Eliminación segura**

Cuando una clave deje de ser necesaria, deberá retirarse de los sistemas autorizados mediante el procedimiento de eliminación establecido. También se considerarán las copias de respaldo, las réplicas y los requisitos de conservación para evitar que siga disponible indebidamente.

## Análisis

La protección de las claves es fundamental porque una persona que obtiene una clave puede utilizarla para descifrar datos o realizar operaciones no autorizadas, dependiendo de su función. Las reglas definidas buscan reducir este riesgo durante todo el ciclo de vida de las claves, desde su generación hasta su eliminación.

La rotación y la eliminación deben planificarse cuidadosamente para no perder acceso a información legítima. Asimismo, la revisión de los repositorios ayuda a detectar errores, pero no garantiza que todos los secretos sean identificados.

## Conclusión

Una política de protección de claves permite establecer responsabilidades y prácticas claras para reducir la exposición de información confidencial. La generación segura, el almacenamiento protegido, el acceso restringido, la rotación, el respaldo y la revocación son medidas complementarias que deben aplicarse de acuerdo con los riesgos y las necesidades de la organización.
