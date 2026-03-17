-- ============================================
-- Seed Data - SaaS Inventario Premium
-- ============================================

-- Tenants
INSERT INTO tenants (name, tax_id, country) VALUES
('TechGlobal S.A.', '20123456789', 'Perú'),
('RetailMax Corp.', '10987654321', 'México');

-- Roles
INSERT INTO roles (tenant_id, name) VALUES
(1, 'Administrador'),
(1, 'Vendedor'),
(2, 'Gerente'),
(2, 'Almacenero');

-- Usuarios
INSERT INTO users (tenant_id, name, email, password_hash, role_id) VALUES
(1, 'Carlos Pérez', 'carlos@techglobal.com', 'hashed_password_1', 1),
(1, 'Ana Torres', 'ana@techglobal.com', 'hashed_password_2', 2),
(2, 'Luis Gómez', 'luis@retailmax.com', 'hashed_password_3', 3),
(2, 'María Díaz', 'maria@retailmax.com', 'hashed_password_4', 4);

-- Categorías
INSERT INTO categories (tenant_id, name, description) VALUES
(1, 'Electrónica', 'Dispositivos electrónicos y accesorios'),
(1, 'Oficina', 'Materiales de oficina'),
(2, 'Ropa', 'Prendas de vestir'),
(2, 'Calzado', 'Zapatos y sandalias');

-- Productos
INSERT INTO products (tenant_id, sku, name, description, category_id, unit_cost, unit_price, tax_rate, barcode) VALUES
(1, 'ELEC-001', 'Laptop Pro 15"', 'Laptop de alto rendimiento', 1, 800.00, 1200.00, 18.00, '1234567890123'),
(1, 'OFF-010', 'Resma Papel A4', '500 hojas de papel A4', 2, 3.50, 5.00, 18.00, '9876543210987'),
(2, 'ROP-100', 'Camisa Casual', 'Camisa de algodón', 3, 12.00, 25.00, 16.00, '1112223334445'),
(2, 'CAL-200', 'Zapatillas Running', 'Zapatillas deportivas', 4, 30.00, 60.00, 16.00, '5556667778889');

-- Almacenes
INSERT INTO warehouses (tenant_id, name, location, capacity) VALUES
(1, 'Almacén Central Lima', 'Av. Industrial 123, Lima', 10000),
(2, 'Depósito CDMX', 'Zona Industrial, Ciudad de México', 8000);

-- Localizaciones
INSERT INTO locations (warehouse_id, code, description) VALUES
(1, 'A1', 'Estantería A1 - Electrónica'),
(1, 'B2', 'Estantería B2 - Oficina'),
(2, 'C1', 'Rack C1 - Ropa'),
(2, 'D4', 'Rack D4 - Calzado');

-- Inventario
INSERT INTO inventory (product_id, warehouse_id, location_id, quantity) VALUES
(1, 1, 1, 50),
(2, 1, 2, 200),
(3, 2, 3, 150),
(4, 2, 4, 80);

-- Movimientos de Inventario
INSERT INTO inventory_movements (product_id, warehouse_id, location_id, type, quantity, cost, user_id, reference_doc) VALUES
(1, 1, 1, 'ENTRADA', 20, 800.00, 1, 'PO-2026-001'),
(2, 1, 2, 'SALIDA', 50, 3.50, 2, 'SO-2026-010'),
(3, 2, 3, 'TRANSFERENCIA', 30, 12.00, 3, 'TR-2026-005');

-- Proveedores
INSERT INTO suppliers (tenant_id, name, tax_id, address, contact_info) VALUES
(1, 'Distribuidora TechParts', '20112233445', 'Av. Tecnología 456, Lima', '{"phone":"(01) 555-1234","email":"ventas@techparts.com"}'),
(2, 'ModaTex S.A.', '10998877665', 'Av. Moda 789, CDMX', '{"phone":"(55) 444-5678","email":"contacto@modatex.com"}');

-- Órdenes de compra
INSERT INTO purchase_orders (tenant_id, supplier_id, status, total_amount) VALUES
(1, 1, 'RECIBIDO', 16000.00),
(2, 2, 'APROBADO', 5000.00);

-- Items de compra
INSERT INTO purchase_order_items (order_id, product_id, quantity, unit_cost) VALUES
(1, 1, 20, 800.00),
(2, 3, 400, 12.50);

-- Clientes
INSERT INTO customers (tenant_id, name, tax_id, address, contact_info) VALUES
(1, 'Empresa ABC', '20123334455', 'Av. Negocios 321, Lima', '{"phone":"(01) 333-2222","email":"compras@abc.com"}'),
(2, 'Boutique Fashion', '10997766554', 'Av. Reforma 654, CDMX', '{"phone":"(55) 222-1111","email":"ventas@fashion.com"}');

-- Órdenes de venta
INSERT INTO sales_orders (tenant_id, customer_id, status, total_amount) VALUES
(1, 1, 'FACTURADO', 6000.00),
(2, 2, 'ENTREGADO', 2500.00);

-- Items de venta
INSERT INTO sales_order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 2, 100, 5.00),
(2, 4, 40, 62.50);

-- Facturas
INSERT INTO invoices (tenant_id, order_id, customer_id, status, total_amount, tax_amount, electronic_code, currency, payment_method) VALUES
(1, 1, 1, 'EMITIDA', 6000.00, 1080.00, 'SUNAT-INV-2026-001', 'PEN', 'Transferencia'),
(2, 2, 2, 'PAGADA', 2500.00, 400.00, 'SAT-INV-2026-002', 'MXN', 'Tarjeta');

-- Auditoría
INSERT INTO audit_logs (tenant_id, user_id, action, details) VALUES
(1, 1, 'CREAR_ORDEN_COMPRA', '{"order_id":1,"supplier":"TechParts"}'),
(2, 3, 'REGISTRAR_MOVIMIENTO', '{"movement_id":3,"type":"TRANSFERENCIA"}');

-- Reportes
INSERT INTO reports (tenant_id, type, parameters, status) VALUES
(1, 'Inventario Valorizado', '{"warehouse":"Almacén Central Lima"}', 'GENERADO'),
(2, 'Ventas Mensuales', '{"month":"Febrero 2026"}', 'GENERADO');

-- Integraciones
INSERT INTO integrations (tenant_id, type, config) VALUES
(1, 'Shopify', '{"api_key":"abc123","store_url":"techglobal.myshopify.com"}'),
(2, 'Amazon', '{"seller_id":"retailmax001","auth_token":"xyz789"}');
