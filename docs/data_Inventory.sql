-- ============================================
-- Demo Data SaaS Inventario Premium
-- ============================================

-- Tenants
INSERT INTO tenants (name, tax_id, country) VALUES
('Juguería Jampool', '20123456789', 'Perú'),
('TechStore Global', '9876543210', 'España');

-- Roles
INSERT INTO roles (tenant_id, name, permissions) VALUES
(1, 'Admin', '{"inventory":"all","sales":"all","purchases":"all"}'),
(1, 'Vendedor', '{"sales":"create","inventory":"view"}'),
(2, 'Admin', '{"inventory":"all","sales":"all","purchases":"all"}');

-- Usuarios
INSERT INTO users (tenant_id, name, email, password_hash, role_id) VALUES
(1, 'Jampool', 'jampool@jugueria.com', 'hashedpass123', 1),
(1, 'María', 'maria@jugueria.com', 'hashedpass456', 2),
(2, 'Carlos', 'carlos@techstore.com', 'hashedpass789', 3);

-- Categorías
INSERT INTO categories (tenant_id, name, description) VALUES
(1, 'Jugos Naturales', 'Bebidas frescas y saludables'),
(1, 'Snacks', 'Complementos ligeros'),
(2, 'Electrónica', 'Dispositivos tecnológicos');

-- Productos
INSERT INTO products (tenant_id, sku, name, description, category_id, unit_cost, unit_price, tax_rate, barcode) VALUES
(1, 'JUG001', 'Jugo de Naranja', 'Jugo natural recién exprimido', 1, 2.00, 4.50, 18, '1234567890123'),
(1, 'SNK001', 'Sandwich Integral', 'Pan integral con pollo', 2, 3.00, 6.00, 18, '1234567890456'),
(2, 'ELEC001', 'Smartphone X', 'Teléfono inteligente gama media', 3, 200.00, 350.00, 21, '9876543210123');

-- Almacenes
INSERT INTO warehouses (tenant_id, name, location, capacity) VALUES
(1, 'Almacén Principal Juguería', 'Av. Lima 123, Cañete', 500),
(2, 'Central TechStore', 'Madrid, España', 2000);

-- Inventario
INSERT INTO inventory (product_id, warehouse_id, quantity, valuation_method) VALUES
(1, 1, 100, 'FIFO'),
(2, 1, 50, 'PROMEDIO'),
(3, 2, 300, 'FIFO');

-- Movimientos
INSERT INTO inventory_movements (product_id, warehouse_id, type, quantity, cost, user_id, reference_doc) VALUES
(1, 1, 'ENTRADA', 50, 100.00, 1, 'PO-2026-001'),
(2, 1, 'SALIDA', 10, 30.00, 2, 'SO-2026-002'),
(3, 2, 'ENTRADA', 100, 20000.00, 3, 'PO-2026-003');

-- Proveedores
INSERT INTO suppliers (tenant_id, name, tax_id, address, contact_info) VALUES
(1, 'Proveedor Frutas SAC', '20567890123', 'Mercado Mayorista Lima', '{"phone":"987654321"}'),
(2, 'Distribuidor Tech SA', '30456789012', 'Barcelona, España', '{"email":"ventas@techsa.com"}');

-- Órdenes de compra
INSERT INTO purchase_orders (tenant_id, supplier_id, status, total_amount) VALUES
(1, 1, 'APROBADO', 500.00),
(2, 2, 'RECIBIDO', 20000.00);

-- Clientes
INSERT INTO customers (tenant_id, name, tax_id, address, contact_info) VALUES
(1, 'Cliente Local', '10456789012', 'Cañete, Perú', '{"phone":"912345678"}'),
(2, 'Cliente Europa', '20456789012', 'Madrid, España', '{"email":"cliente@europa.com"}');

-- Órdenes de venta
INSERT INTO sales_orders (tenant_id, customer_id, status, total_amount) VALUES
(1, 1, 'FACTURADO', 45.00),
(2, 2, 'ENTREGADO', 350.00);

-- Facturación
INSERT INTO invoices (tenant_id, order_id, customer_id, total_amount, tax_amount, electronic_code, currency) VALUES
(1, 1, 1, 45.00, 8.10, 'SUNAT-INV-2026-001', 'PEN'),
(2, 2, 2, 350.00, 73.50, 'AEAT-INV-2026-002', 'EUR');

-- Auditoría
INSERT INTO audit_logs (tenant_id, user_id, action, details) VALUES
(1, 1, 'LOGIN', '{"ip":"192.168.1.10"}'),
(1, 2, 'VENTA', '{"order":"SO-2026-002"}'),
(2, 3, 'COMPRA', '{"order":"PO-2026-003"}');

-- Integraciones
INSERT INTO integrations (tenant_id, type, config) VALUES
(1, 'SUNAT', '{"endpoint":"https://api.sunat.gob.pe","token":"demo"}'),
(2, 'Shopify', '{"store_url":"https://techstore.myshopify.com","api_key":"demo"}');
