-- =========================================
-- ESCENARIO 1: VENTA EXITOSA EN CHINOOK
-- =========================================

-- Iniciar transacción
BEGIN;

-- Crear una factura nueva
-- Se utiliza un cliente existente
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
    'PRACTICA_VENTA_001',
    city,
    state,
    country,
    postal_code,
    0
FROM customer
ORDER BY customer_id
LIMIT 1
RETURNING invoice_id;

-- Insertar tres canciones existentes
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
    LIMIT 3
) t
WHERE i.billing_address = 'PRACTICA_VENTA_001';

-- Calcular el total automáticamente
UPDATE invoice
SET total = (
    SELECT SUM(unit_price * quantity)
    FROM invoice_line
    WHERE invoice_line.invoice_id = invoice.invoice_id
)
WHERE billing_address = 'PRACTICA_VENTA_001';

-- Consultar factura
SELECT *
FROM invoice
WHERE billing_address = 'PRACTICA_VENTA_001';

-- Consultar detalles
SELECT *
FROM invoice_line
WHERE invoice_id = (
    SELECT invoice_id
    FROM invoice
    WHERE billing_address = 'PRACTICA_VENTA_001'
);

-- NO EJECUTAR COMMIT TODAVÍA.
-- Primero realizaremos la prueba de visibilidad
-- desde la conexión B.