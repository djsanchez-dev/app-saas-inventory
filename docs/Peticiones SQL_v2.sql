-- 1. Inventario valorizado por almacén
SELECT w.name AS warehouse,
       p.name AS product,
       i.quantity,
       p.unit_cost,
       (i.quantity * p.unit_cost) AS total_cost
FROM inventory i
JOIN products p ON i.product_id = p.id
JOIN warehouses w ON i.warehouse_id = w.id
WHERE p.is_active = TRUE
ORDER BY w.name, p.name;

-- 2. Movimientos de inventario recientes
SELECT im.date,
       u.name AS user,
       p.name AS product,
       im.type,
       im.quantity,
       im.reference_doc
FROM inventory_movements im
JOIN products p ON im.product_id = p.id
JOIN users u ON im.user_id = u.id
WHERE im.date >= NOW() - INTERVAL '30 days'
ORDER BY im.date DESC;

-- 3. Órdenes de compra pendientes por proveedor
SELECT s.name AS supplier,
       po.id AS order_id,
       po.date,
       po.status,
       po.total_amount
FROM purchase_orders po
JOIN suppliers s ON po.supplier_id = s.id
WHERE po.status = 'PENDIENTE'
ORDER BY po.date ASC;

-- 4. Ventas mensuales por cliente
SELECT c.name AS customer,
       DATE_TRUNC('month', so.date) AS month,
       SUM(so.total_amount) AS total_sales
FROM sales_orders so
JOIN customers c ON so.customer_id = c.id
WHERE so.status IN ('FACTURADO','ENTREGADO')
GROUP BY c.name, DATE_TRUNC('month', so.date)
ORDER BY month DESC, total_sales DESC;

-- 5. Facturas emitidas y estado de pago
SELECT i.id AS invoice_id,
       c.name AS customer,
       i.date,
       i.total_amount,
       i.tax_amount,
       i.status,
       i.payment_method
FROM invoices i
JOIN customers c ON i.customer_id = c.id
WHERE i.date >= DATE_TRUNC('year', CURRENT_DATE)
ORDER BY i.date DESC;

-- 6. Auditoría de acciones críticas
SELECT a.timestamp,
       u.name AS user,
       a.action,
       a.details
FROM audit_logs a
JOIN users u ON a.user_id = u.id
WHERE a.action IN ('CREAR_ORDEN_COMPRA','CREAR_FACTURA','REGISTRAR_MOVIMIENTO')
ORDER BY a.timestamp DESC;

-- 7. Integraciones activas por tenant
SELECT t.name AS tenant,
       i.type AS integration,
       i.is_active,
       i.config
FROM integrations i
JOIN tenants t ON i.tenant_id = t.id
WHERE i.is_active = TRUE;

-- 