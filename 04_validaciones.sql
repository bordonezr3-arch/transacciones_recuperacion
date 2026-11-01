-- =========================================
-- ESCENARIO 4: VALIDACIONES DE LAS VENTAS
-- =========================================

-- 1. Verificar la venta exitosa
SELECT
    i.invoice_id,
    i.billing_address,
    i.total,
    COUNT(il.invoice_line_id) AS cantidad_detalles,
    SUM(il.unit_price * il.quantity) AS total_calculado
FROM invoice i
JOIN invoice_line il
ON i.invoice_id = il.invoice_id
WHERE i.billing_address = 'PRACTICA_VENTA_001'
GROUP BY i.invoice_id, i.billing_address, i.total;

-- 2. Verificar la venta recuperada con SAVEPOINT
SELECT
    i.invoice_id,
    i.billing_address,
    i.total,
    COUNT(il.invoice_line_id) AS cantidad_detalles,
    SUM(il.unit_price * il.quantity) AS total_calculado
FROM invoice i
JOIN invoice_line il
ON i.invoice_id = il.invoice_id
WHERE i.billing_address = 'PRACTICA_SAVEPOINT_003'
GROUP BY i.invoice_id, i.billing_address, i.total;

-- 3. Verificar que el ROLLBACK eliminó la factura
SELECT *
FROM invoice
WHERE billing_address = 'PRACTICA_ROLLBACK_002';

-- 4. Comprobar que los totales coinciden
SELECT
    i.invoice_id,
    i.total AS total_factura,
    SUM(il.unit_price * il.quantity) AS suma_detalles,
    CASE
        WHEN i.total = SUM(il.unit_price * il.quantity)
        THEN 'CORRECTO'
        ELSE 'INCORRECTO'
    END AS resultado
FROM invoice i
JOIN invoice_line il
ON i.invoice_id = il.invoice_id
WHERE i.billing_address IN (
    'PRACTICA_VENTA_001',
    'PRACTICA_SAVEPOINT_003'
)
GROUP BY i.invoice_id, i.total;
