-- ============================================
-- SaaS Inventario Premium (PostgreSQL)
-- Multi-tenant, avanzado y escalable
-- ============================================

-- Tenants (multiempresa)
CREATE TABLE tenants (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    tax_id VARCHAR(50),
    country VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Roles y Usuarios
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    tenant_id INT REFERENCES tenants(id) ON DELETE CASCADE,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE role_permissions (
    id SERIAL PRIMARY KEY,
    role_id INT REFERENCES roles(id) ON DELETE CASCADE,
    permission_key VARCHAR(100) NOT NULL
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    tenant_id INT REFERENCES tenants(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role_id INT REFERENCES roles(id),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categorías y Productos
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    tenant_id INT REFERENCES tenants(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    tenant_id INT REFERENCES tenants(id) ON DELETE CASCADE,
    sku VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    category_id INT REFERENCES categories(id),
    unit_cost NUMERIC(12,2) NOT NULL,
    unit_price NUMERIC(12,2) NOT NULL,
    tax_rate NUMERIC(5,2) DEFAULT 0,
    barcode VARCHAR(50),
    valuation_method VARCHAR(20) CHECK (valuation_method IN ('FIFO','LIFO','PROMEDIO')),
    is_active BOOLEAN DEFAULT TRUE
);

-- Almacenes y Localizaciones
CREATE TABLE warehouses (
    id SERIAL PRIMARY KEY,
    tenant_id INT REFERENCES tenants(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(200),
    capacity INT
);

CREATE TABLE locations (
    id SERIAL PRIMARY KEY,
    warehouse_id INT REFERENCES warehouses(id),
    code VARCHAR(50),
    description TEXT
);

-- Inventario
CREATE TABLE inventory (
    id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(id),
    warehouse_id INT REFERENCES warehouses(id),
    location_id INT REFERENCES locations(id),
    quantity NUMERIC(12,2) DEFAULT 0
);

-- Movimientos de Inventario
CREATE TABLE inventory_movements (
    id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(id),
    warehouse_id INT REFERENCES warehouses(id),
    location_id INT REFERENCES locations(id),
    type VARCHAR(20) CHECK (type IN ('ENTRADA','SALIDA','TRANSFERENCIA','AJUSTE')),
    quantity NUMERIC(12,2) NOT NULL,
    cost NUMERIC(12,2),
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT REFERENCES users(id),
    reference_doc VARCHAR(100)
);

-- Proveedores y Compras
CREATE TABLE suppliers (
    id SERIAL PRIMARY KEY,
    tenant_id INT REFERENCES tenants(id) ON DELETE CASCADE,
    name VARCHAR(150) NOT NULL,
    tax_id VARCHAR(50),
    address VARCHAR(200),
    contact_info JSONB
);

CREATE TABLE purchase_orders (
    id SERIAL PRIMARY KEY,
    tenant_id INT REFERENCES tenants(id) ON DELETE CASCADE,
    supplier_id INT REFERENCES suppliers(id),
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) CHECK (status IN ('PENDIENTE','APROBADO','CANCELADO','RECIBIDO')),
    total_amount NUMERIC(12,2)
);

CREATE TABLE purchase_order_items (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES purchase_orders(id) ON DELETE CASCADE,
    product_id INT REFERENCES products(id),
    quantity NUMERIC(12,2) NOT NULL,
    unit_cost NUMERIC(12,2) NOT NULL,
    total NUMERIC(12,2) GENERATED ALWAYS AS (quantity * unit_cost) STORED
);

-- Clientes y Ventas
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    tenant_id INT REFERENCES tenants(id) ON DELETE CASCADE,
    name VARCHAR(150) NOT NULL,
    tax_id VARCHAR(50),
    address VARCHAR(200),
    contact_info JSONB
);

CREATE TABLE sales_orders (
    id SERIAL PRIMARY KEY,
    tenant_id INT REFERENCES tenants(id) ON DELETE CASCADE,
    customer_id INT REFERENCES customers(id),
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) CHECK (status IN ('PENDIENTE','FACTURADO','CANCELADO','ENTREGADO')),
    total_amount NUMERIC(12,2)
);

CREATE TABLE sales_order_items (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES sales_orders(id) ON DELETE CASCADE,
    product_id INT REFERENCES products(id),
    quantity NUMERIC(12,2) NOT NULL,
    unit_price NUMERIC(12,2) NOT NULL,
    total NUMERIC(12,2) GENERATED ALWAYS AS (quantity * unit_price) STORED
);

-- Facturación y Legal
CREATE TABLE invoices (
    id SERIAL PRIMARY KEY,
    tenant_id INT REFERENCES tenants(id) ON DELETE CASCADE,
    order_id INT REFERENCES sales_orders(id),
    customer_id INT REFERENCES customers(id),
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) CHECK (status IN ('EMITIDA','ANULADA','PAGADA')),
    total_amount NUMERIC(12,2),
    tax_amount NUMERIC(12,2),
    electronic_code VARCHAR(100),
    currency VARCHAR(10) DEFAULT 'USD',
    payment_method VARCHAR(50)
);

-- Auditoría y Seguridad
CREATE TABLE audit_logs (
    id SERIAL PRIMARY KEY,
    tenant_id INT REFERENCES tenants(id) ON DELETE CASCADE,
    user_id INT REFERENCES users(id),
    action VARCHAR(100),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    details JSONB
);

-- Reportes
CREATE TABLE reports (
    id SERIAL PRIMARY KEY,
    tenant_id INT REFERENCES tenants(id) ON DELETE CASCADE,
    type VARCHAR(50),
    parameters JSONB,
    status VARCHAR(20) DEFAULT 'GENERADO',
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Integraciones externas
CREATE TABLE integrations (
    id SERIAL PRIMARY KEY,
    tenant_id INT REFERENCES tenants(id) ON DELETE CASCADE,
    type VARCHAR(50),
    config JSONB,
    is_active BOOLEAN DEFAULT TRUE
);
