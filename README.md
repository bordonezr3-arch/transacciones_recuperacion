# transacciones_recuperacion
Conectar la base de datos
Se abre DataGrip y se establece una conexión con PostgreSQL. Después se selecciona la base de datos Chinook, donde se encuentran las tablas de clientes, facturas, detalles y canciones.
2. Ejecutar el primer código: Venta exitosa
Se abre el archivo 01_venta_exitosa.sql y se ejecuta el código. Este crea una factura nueva, agrega tres canciones existentes y calcula automáticamente el total de la venta.
3. Ejecutar el segundo código: ROLLBACK
Se abre 02_rollback_total.sql. Este crea una factura y provoca intencionalmente un error al intentar agregar una canción inexistente. Después se ejecuta ROLLBACK para cancelar toda la operación
4,Ejecutar el tercer código: SAVEPOINT
Se abre 03_savepoint.sql. Se agregan dos canciones válidas y se establece un punto de recuperación. Cuando ocurre un error, se utiliza ROLLBACK TO SAVEPOINT para recuperar los datos anteriores, agregar una canción correcta y confirmar la venta.
5. Ejecutar el cuarto código: Validaciones
Se abre 04_validaciones.sql para comprobar que las facturas se hayan registrado correctamente, que los totales coincidan con los detalles y que la factura revertida no exista.
6. Comprobar las conexiones
Se utilizan dos conexiones independientes, A y B. Desde A se realiza una venta sin confirmarla y desde B se consulta si existe. Después de ejecutar COMMIT en A, se vuelve a consultar desde B para comprobar que la factura ya es visible.
