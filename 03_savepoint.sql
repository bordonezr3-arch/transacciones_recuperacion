-- =========================================
-- ESCENARIO 3: RECUPERACION PARCIAL
-- =========================================

-- Iniciar transacción
BEGIN;

-- Crear una factura nueva
INSERT INTO invoice (
    customer_id,
    invoice_date,
    billing_address,
    billing_city,
    billing_state,
    billing_country,
    billing_postal_code,
    total
)
SELECT
    customer_id,
    CURRENT_TIMESTAMP,
    'PRACTICA_SAVEPOINT_003',
    city,
    state,
    country,
    postal_code,
    0
FROM customer
ORDER BY customer_id
LIMIT 1
RETURNING invoice_id;

-- Agregar dos canciones válidas
INSERT INTO invoice_line (
    invoice_id,
    track_id,
    unit_price,
    quantity
)
SELECT
    i.invoice_id,
    t.track_id,
    t.unit_price,
    1
FROM invoice i
CROSS JOIN (
    SELECT track_id, unit_price
    FROM track
    ORDER BY track_id
    LIMIT 2
) t
WHERE i.billing_address = 'PRACTICA_SAVEPOINT_003';

-- Crear punto de recuperación
SAVEPOINT sp1;

-- Intentar agregar canción inexistente
INSERT INTO invoice_line (
    invoice_id,
    track_id,
    unit_price,
    quantity
)
SELECT
    invoice_id,
    -999999,
    1.00,
    1
FROM invoice
WHERE billing_address = 'PRACTICA_SAVEPOINT_003';


-- Recuperar la transacción
ROLLBACK TO SAVEPOINT sp1;

-- Agregar una canción válida corregida
INSERT INTO invoice_line (
    invoice_id,
    track_id,
    unit_price,
    quantity
)
SELECT
    i.invoice_id,
    t.track_id,
    t.unit_price,
    1
FROM invoice i
CROSS JOIN (
    SELECT track_id, unit_price
    FROM track
    ORDER BY track_id
    OFFSET 2 LIMIT 1
) t
WHERE i.billing_address = 'PRACTICA_SAVEPOINT_003';

-- Calcular el total
UPDATE invoice
SET total = (
    SELECT SUM(unit_price * quantity)
    FROM invoice_line
    WHERE invoice_line.invoice_id = invoice.invoice_id
)
WHERE billing_address = 'PRACTICA_SAVEPOINT_003';

-- Liberar el punto de recuperación
RELEASE SAVEPOINT sp1;

-- Confirmar la venta
COMMIT;

-- Mostrar los detalles
SELECT *
FROM invoice_line
WHERE invoice_id = (
    SELECT invoice_id
    FROM invoice
    WHERE billing_address = 'PRACTICA_SAVEPOINT_003'
);

-- Comprobar total y cantidad de detalles
SELECT
    i.invoice_id,
    i.total,
    SUM(il.unit_price * il.quantity) AS total_calculado,
    COUNT(*) AS cantidad_detalles
FROM invoice i
JOIN invoice_line il
ON i.invoice_id = il.invoice_id
WHERE i.billing_address = 'PRACTICA_SAVEPOINT_003'
GROUP BY i.invoice_id, i.total;
