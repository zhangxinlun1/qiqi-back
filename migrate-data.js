const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');

// 数据库配置
const dbConfig = {
  host: 'localhost',
  port: 3306,
  user: 'root',
  password: 'woaini520.',
  database: 'meeting_room_booking_system',
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

// 迁移商品数据
async function migrateProducts(connection) {
  try {
    console.log('📦 开始迁移商品数据...');
    
    // 从localStorage文件读取数据（这里需要您提供数据文件）
    const productsData = JSON.parse(fs.readFileSync('./products.json', 'utf8'));
    
    for (const product of productsData) {
      const query = `
        INSERT INTO products (
          name, code, category, brand, specification, color,
          costPrice, salePrice, stock, alertStock, soldCount,
          totalRevenue, description, images, img, isActive,
          createTime, updateTime
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `;
      
      const values = [
        product.name,
        product.code,
        product.category,
        product.brand || null,
        product.specification || null,
        product.color || null,
        product.costPrice,
        product.salePrice,
        product.stock || 0,
        product.alertStock || 10,
        product.soldCount || 0,
        product.totalRevenue || 0,
        product.description || null,
        product.images || null,
        product.img || null,
        product.isActive !== false,
        new Date(product.createTime || Date.now()),
        new Date(product.updateTime || Date.now())
      ];
      
      await connection.execute(query, values);
    }
    
    console.log(`✅ 商品数据迁移完成，共迁移 ${productsData.length} 条记录`);
  } catch (error) {
    console.error('❌ 商品数据迁移失败:', error.message);
    throw error;
  }
}

// 迁移销售订单数据
async function migrateOrders(connection) {
  try {
    console.log('📋 开始迁移销售订单数据...');
    
    // 从localStorage文件读取数据
    const salesData = JSON.parse(fs.readFileSync('./sales.json', 'utf8'));
    
    for (const sale of salesData) {
      // 插入订单
      const orderQuery = `
        INSERT INTO orders (
          orderNumber, customerName, customerPhone, totalAmount,
          profit, status, remark, createTime, updateTime
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
      `;
      
      const orderValues = [
        sale.id,
        sale.customerName || '匿名客户',
        sale.customerPhone || null,
        sale.totalAmount,
        sale.profit || 0,
        'completed',
        sale.remark || null,
        new Date(sale.saleTime),
        new Date(sale.saleTime)
      ];
      
      const [orderResult] = await connection.execute(orderQuery, orderValues);
      const orderId = orderResult.insertId;
      
      // 插入订单项
      const orderItemQuery = `
        INSERT INTO order_items (
          orderId, productId, productName, productCode,
          quantity, price, subtotal, costPrice, profit,
          createTime, updateTime
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `;
      
      const orderItemValues = [
        orderId,
        sale.productId,
        sale.productName,
        sale.productCode,
        sale.quantity,
        sale.price,
        sale.totalAmount,
        sale.costPrice || 0,
        sale.profit || 0,
        new Date(sale.saleTime),
        new Date(sale.saleTime)
      ];
      
      await connection.execute(orderItemQuery, orderItemValues);
    }
    
    console.log(`✅ 销售订单数据迁移完成，共迁移 ${salesData.length} 条记录`);
  } catch (error) {
    console.error('❌ 销售订单数据迁移失败:', error.message);
    throw error;
  }
}

// 迁移入库数据
async function migrateStockIns(connection) {
  try {
    console.log('📥 开始迁移入库数据...');
    
    // 从localStorage文件读取数据
    const stockInsData = JSON.parse(fs.readFileSync('./stockIns.json', 'utf8'));
    
    for (const stockIn of stockInsData) {
      // 插入入库记录
      const stockInQuery = `
        INSERT INTO stock_ins (
          stockInNumber, supplier, contact, totalAmount,
          totalQuantity, status, remark, createTime, updateTime
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
      `;
      
      const totalQuantity = stockIn.items.reduce((sum, item) => sum + item.quantity, 0);
      const totalAmount = stockIn.items.reduce((sum, item) => sum + (item.price * item.quantity), 0);
      
      const stockInValues = [
        stockIn.id,
        stockIn.supplier || null,
        stockIn.contact || null,
        totalAmount,
        totalQuantity,
        'completed',
        stockIn.remark || null,
        new Date(stockIn.createdAt),
        new Date(stockIn.createdAt)
      ];
      
      const [stockInResult] = await connection.execute(stockInQuery, stockInValues);
      const stockInId = stockInResult.insertId;
      
      // 插入入库项
      for (const item of stockIn.items) {
        const stockInItemQuery = `
          INSERT INTO stock_in_items (
            stockInId, productId, productName, productCode,
            quantity, costPrice, subtotal, createTime, updateTime
          ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        `;
        
        const stockInItemValues = [
          stockInId,
          item.productId || null,
          item.name,
          item.code,
          item.quantity,
          item.price || 0,
          (item.price || 0) * item.quantity,
          new Date(stockIn.createdAt),
          new Date(stockIn.createdAt)
        ];
        
        await connection.execute(stockInItemQuery, stockInItemValues);
      }
    }
    
    console.log(`✅ 入库数据迁移完成，共迁移 ${stockInsData.length} 条记录`);
  } catch (error) {
    console.error('❌ 入库数据迁移失败:', error.message);
    throw error;
  }
}

// 主迁移函数
async function migrateData() {
  let connection;
  
  try {
    console.log('🚀 开始数据迁移...');
    console.log('========================================');
    
    // 连接数据库
    connection = await createConnection();
    
    // 迁移商品数据
    await migrateProducts(connection);
    
    // 迁移销售订单数据
    await migrateOrders(connection);
    
    // 迁移入库数据
    await migrateStockIns(connection);
    
    console.log('========================================');
    console.log('🎉 数据迁移完成！');
    console.log('');
    console.log('💡 提示：');
    console.log('   - 请检查迁移后的数据是否正确');
    console.log('   - 建议在迁移前备份原有数据');
    console.log('   - 迁移完成后可以删除localStorage数据');
    
  } catch (error) {
    console.error('❌ 数据迁移失败:', error.message);
  } finally {
    if (connection) {
      await connection.end();
      console.log('✅ 数据库连接已关闭');
    }
  }
}

// 导出localStorage数据的辅助函数
function exportLocalStorageData() {
  console.log('📤 导出localStorage数据...');
  console.log('');
  console.log('请在浏览器控制台执行以下代码来导出数据：');
  console.log('');
  console.log('// 导出商品数据');
  console.log('console.log(JSON.stringify(JSON.parse(localStorage.getItem("products") || "[]"), null, 2));');
  console.log('');
  console.log('// 导出销售数据');
  console.log('console.log(JSON.stringify(JSON.parse(localStorage.getItem("sales") || "[]"), null, 2));');
  console.log('');
  console.log('// 导出入库数据');
  console.log('console.log(JSON.stringify(JSON.parse(localStorage.getItem("stockIns") || "[]"), null, 2));');
  console.log('');
  console.log('请将输出的JSON数据保存到对应的文件中：');
  console.log('- products.json');
  console.log('- sales.json');
  console.log('- stockIns.json');
}

// 检查数据文件是否存在
function checkDataFiles() {
  const requiredFiles = ['products.json', 'sales.json', 'stockIns.json'];
  const missingFiles = requiredFiles.filter(file => !fs.existsSync(file));
  
  if (missingFiles.length > 0) {
    console.log('❌ 缺少以下数据文件：');
    missingFiles.forEach(file => console.log(`   - ${file}`));
    console.log('');
    console.log('请先导出localStorage数据：');
    exportLocalStorageData();
    return false;
  }
  
  return true;
}

// 主程序
if (require.main === module) {
  if (checkDataFiles()) {
    migrateData();
  }
}

module.exports = { migrateData, exportLocalStorageData }; 