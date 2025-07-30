const mysql = require('mysql2/promise');

// 数据库配置 - 修改为Docker容器中的MySQL
const dbConfig = {
  host: 'qiqi-back-mysql-1', // 使用Docker容器名称
  port: 3306,
  user: 'root',
  password: 'woaini520.',
  charset: 'utf8mb4'
};

// 创建数据库连接
async function createConnection() {
  try {
    const connection = await mysql.createConnection(dbConfig);
    console.log('✅ 数据库连接成功');
    return connection;
  } catch (error) {
    console.error('❌ 数据库连接失败:', error.message);
    throw error;
  }
}

// 创建数据库
async function createDatabase(connection) {
  try {
    console.log('📦 创建数据库...');
    
    // 创建数据库
    await connection.query('CREATE DATABASE IF NOT EXISTS apparel_admin_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
    console.log('✅ 数据库 apparel_admin_db 创建成功');
    
    // 使用数据库
    await connection.query('USE apparel_admin_db');
    console.log('✅ 切换到数据库 apparel_admin_db');
    
  } catch (error) {
    console.error('❌ 创建数据库失败:', error.message);
    throw error;
  }
}

// 创建订单表
async function createOrdersTable(connection) {
  try {
    console.log('📋 创建订单表...');
    
    const createOrdersTableSQL = `
      CREATE TABLE IF NOT EXISTS orders (
        id INT AUTO_INCREMENT PRIMARY KEY,
        orderNumber VARCHAR(50) UNIQUE COMMENT '订单编号',
        customerName VARCHAR(100) COMMENT '客户姓名',
        customerPhone VARCHAR(20) COMMENT '客户电话',
        totalAmount DECIMAL(10,2) COMMENT '订单总金额',
        profit DECIMAL(10,2) DEFAULT 0 COMMENT '订单利润',
        status VARCHAR(20) DEFAULT 'completed' COMMENT '订单状态',
        remark VARCHAR(500) COMMENT '备注',
        createTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updateTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    `;
    
    await connection.query(createOrdersTableSQL);
    console.log('✅ 订单表创建成功');
    
  } catch (error) {
    console.error('❌ 创建订单表失败:', error.message);
    throw error;
  }
}

// 创建订单项表
async function createOrderItemsTable(connection) {
  try {
    console.log('📋 创建订单项表...');
    
    const createOrderItemsTableSQL = `
      CREATE TABLE IF NOT EXISTS order_items (
        id INT AUTO_INCREMENT PRIMARY KEY,
        orderId INT NOT NULL COMMENT '订单ID',
        productId INT NOT NULL COMMENT '商品ID',
        productName VARCHAR(100) COMMENT '商品名称',
        productCode VARCHAR(50) COMMENT '商品编码',
        quantity INT COMMENT '销售数量',
        price DECIMAL(10,2) COMMENT '销售单价',
        subtotal DECIMAL(10,2) COMMENT '小计金额',
        costPrice DECIMAL(10,2) COMMENT '成本价',
        profit DECIMAL(10,2) DEFAULT 0 COMMENT '利润',
        createTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updateTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_orderId (orderId),
        INDEX idx_productId (productId)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    `;
    
    await connection.query(createOrderItemsTableSQL);
    console.log('✅ 订单项表创建成功');
    
  } catch (error) {
    console.error('❌ 创建订单项表失败:', error.message);
    throw error;
  }
}

// 创建商品表
async function createProductsTable(connection) {
  try {
    console.log('📦 创建商品表...');
    
    const createProductsTableSQL = `
      CREATE TABLE IF NOT EXISTS products (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100) COMMENT '商品名称',
        code VARCHAR(50) UNIQUE COMMENT '商品编码',
        category VARCHAR(50) COMMENT '商品分类',
        brand VARCHAR(50) COMMENT '品牌',
        specification VARCHAR(100) COMMENT '规格',
        color VARCHAR(50) COMMENT '颜色',
        costPrice DECIMAL(10,2) COMMENT '进货价',
        salePrice DECIMAL(10,2) COMMENT '销售价',
        stock INT DEFAULT 0 COMMENT '库存数量',
        alertStock INT DEFAULT 10 COMMENT '预警库存',
        soldCount INT DEFAULT 0 COMMENT '已售数量',
        totalRevenue DECIMAL(10,2) DEFAULT 0 COMMENT '总销售额',
        description VARCHAR(500) COMMENT '商品描述',
        images VARCHAR(500) COMMENT '商品图片',
        img VARCHAR(100) COMMENT '主图',
        isActive BOOLEAN DEFAULT TRUE COMMENT '是否上架',
        createTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updateTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    `;
    
    await connection.query(createProductsTableSQL);
    console.log('✅ 商品表创建成功');
    
  } catch (error) {
    console.error('❌ 创建商品表失败:', error.message);
    throw error;
  }
}

// 主函数
async function initDatabase() {
  let connection;
  
  try {
    console.log('🚀 开始初始化数据库...');
    console.log('========================================');
    
    // 连接数据库
    connection = await createConnection();
    
    // 创建数据库
    await createDatabase(connection);
    
    // 创建表
    await createProductsTable(connection);
    await createOrdersTable(connection);
    await createOrderItemsTable(connection);
    
    console.log('========================================');
    console.log('🎉 数据库初始化完成！');
    console.log('');
    console.log('💡 提示：');
    console.log('   - 数据库名: apparel_admin_db');
    console.log('   - 表已创建: products, orders, order_items');
    console.log('   - 现在可以重启后端服务');
    
  } catch (error) {
    console.error('❌ 数据库初始化失败:', error.message);
  } finally {
    if (connection) {
      await connection.end();
      console.log('✅ 数据库连接已关闭');
    }
  }
}

// 运行初始化
initDatabase(); 