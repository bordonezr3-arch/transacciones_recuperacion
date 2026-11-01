-- =========================================
-- ESCENARIO 2: ERROR Y ROLLBACK TOTAL
-- =========================================

-- Verificar que la canción no existe
SELECT *
FROM track
WHERE track_id = -999999;

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
    'PRACTICA_ROLLBACK_002',
    city,
    state,
    country,
    postal_code,
    0
FROM customer
ORDER BY customer_id
LIMIT 1
RETURNING invoice_id;

-- Agregar un detalle válido
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
    LIMIT 1
) t
WHERE i.billing_address = 'PRACTICA_ROLLBACK_002';

-- Provocar error de FOREIGN KEY
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
WHERE billing_address = 'PRACTICA_ROLLBACK_002';