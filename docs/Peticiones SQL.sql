-- 1. Stock disponible por producto
SELECT p.sku, p.name, w.name AS warehouse, i.quantity
FROM inventory i
JOIN products p ON i.product_id = p.id
JOIN warehouses w ON i.warehouse_id = w.id
WHERE p.is_active = TRUE;

-- 2. Ventas por mes
SELECT DATE_TRUNC('month', so.date) AS mes, SUM(so.total_amount) AS ventas_totales
FROM sales_orders so
WHERE so.status = 'FACTURADO'
GROUP BY mes
ORDER BY mes;

-- 3. Rotación de productos (entradas vs salidas)
SELECT p.name,
       SUM(CASE WHEN im.type = 'ENTRADA' THEN im.quantity ELSE 0 END) AS entradas,
       SUM(CASE WHEN im.type = 'SALIDA' THEN im.quantity ELSE 0 END) AS salidas
FROM inventory_movements im
JOIN products p ON im.product_id = p.id
GROUP BY p.name;

-- 4. Compras pendientes
SELECT po.id, s.name AS proveedor, po.total_amount, po.status
FROM purchase_orders po
JOIN suppliers s ON po.supplier_id = s.id
WHERE po.status = 'PENDIENTE';

-- 5. Facturación electrónica por cliente
SELECT c.name, i.total_amount, i.tax_amount, i.electronic_code, i.currency
FROM invoices i
JOIN customers c ON i.customer_id = c.id
ORDER BY i.date DESC;

