-- Revertir toda la operación
ROLLBACK;

-- Comprobar que no quedó la factura
SELECT *
FROM invoice
WHERE billing_address = 'PRACTICA_ROLLBACK_002';