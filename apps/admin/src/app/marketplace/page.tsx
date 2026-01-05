/**
 * 마켓플레이스 관리 페이지
 * @path /marketplace
 */

'use client';

import { useState, useEffect } from 'react';

interface Product {
  id: string;
  name: string;
  category: 'cartridge' | 'device' | 'subscription' | 'accessory';
  price: number;
  stock: number;
  sold: number;
  status: 'active' | 'out_of_stock' | 'discontinued';
  rating: number;
  reviews: number;
}

interface Order {
  id: string;
  userId: string;
  userName: string;
  productName: string;
  quantity: number;
  total: number;
  status: 'pending' | 'processing' | 'shipped' | 'delivered' | 'cancelled';
  orderDate: string;
}

export default function MarketplacePage() {
  const [activeTab, setActiveTab] = useState<'products' | 'orders' | 'analytics'>('products');
  const [products, setProducts] = useState<Product[]>([]);
  const [orders, setOrders] = useState<Order[]>([]);

  useEffect(() => {
    const sampleProducts: Product[] = [
      { id: 'p1', name: '만파식 측정 카트리지 (30개입)', category: 'cartridge', price: 45000, stock: 1250, sold: 3420, status: 'active', rating: 4.8, reviews: 256 },
      { id: 'p2', name: '만파식 리더기 Pro', category: 'device', price: 350000, stock: 89, sold: 1240, status: 'active', rating: 4.9, reviews: 189 },
      { id: 'p3', name: '프리미엄 구독 (월간)', category: 'subscription', price: 29000, stock: -1, sold: 5680, status: 'active', rating: 4.7, reviews: 412 },
      { id: 'p4', name: '보관 케이스', category: 'accessory', price: 25000, stock: 0, sold: 890, status: 'out_of_stock', rating: 4.5, reviews: 67 },
      { id: 'p5', name: '만파식 리더기 Lite', category: 'device', price: 150000, stock: 45, sold: 2100, status: 'active', rating: 4.6, reviews: 310 },
      { id: 'p6', name: '카트리지 (10개입)', category: 'cartridge', price: 18000, stock: 2340, sold: 8920, status: 'active', rating: 4.7, reviews: 521 },
    ];

    const sampleOrders: Order[] = [
      { id: 'o1', userId: 'u1', userName: '김건강', productName: '측정 카트리지 (30개입)', quantity: 2, total: 90000, status: 'delivered', orderDate: '2026-01-04' },
      { id: 'o2', userId: 'u2', userName: '이운동', productName: '만파식 리더기 Pro', quantity: 1, total: 350000, status: 'shipped', orderDate: '2026-01-03' },
      { id: 'o3', userId: 'u3', userName: '박의사', productName: '프리미엄 구독 (월간)', quantity: 1, total: 29000, status: 'processing', orderDate: '2026-01-05' },
      { id: 'o4', userId: 'u4', userName: '최건강', productName: '카트리지 (10개입)', quantity: 5, total: 90000, status: 'pending', orderDate: '2026-01-05' },
      { id: 'o5', userId: 'u1', userName: '김건강', productName: '보관 케이스', quantity: 1, total: 25000, status: 'cancelled', orderDate: '2026-01-02' },
    ];

    setProducts(sampleProducts);
    setOrders(sampleOrders);
  }, []);

  const categoryLabels: Record<string, { label: string; color: string }> = {
    cartridge: { label: '카트리지', color: 'bg-blue-600' },
    device: { label: '기기', color: 'bg-purple-600' },
    subscription: { label: '구독', color: 'bg-green-600' },
    accessory: { label: '액세서리', color: 'bg-amber-600' },
  };

  const statusLabels: Record<string, { label: string; color: string }> = {
    pending: { label: '대기', color: 'bg-gray-500' },
    processing: { label: '처리중', color: 'bg-yellow-500' },
    shipped: { label: '배송중', color: 'bg-blue-500' },
    delivered: { label: '배송완료', color: 'bg-green-500' },
    cancelled: { label: '취소', color: 'bg-red-500' },
  };

  const totalRevenue = orders.filter(o => o.status !== 'cancelled').reduce((sum, o) => sum + o.total, 0);
  const totalSold = products.reduce((sum, p) => sum + p.sold, 0);

  return (
    <div className="p-6 bg-gray-900 min-h-screen text-white">
      <h1 className="text-3xl font-bold mb-6">🛒 마켓플레이스 관리</h1>

      {/* 통계 */}
      <div className="grid grid-cols-4 gap-4 mb-6">
        <div className="bg-gradient-to-r from-cyan-800 to-cyan-600 p-4 rounded-lg">
          <div className="text-2xl font-bold">₩{totalRevenue.toLocaleString()}</div>
          <div className="text-cyan-200">이번 달 매출</div>
        </div>
        <div className="bg-gradient-to-r from-green-800 to-green-600 p-4 rounded-lg">
          <div className="text-2xl font-bold">{orders.length}</div>
          <div className="text-green-200">주문 수</div>
        </div>
        <div className="bg-gradient-to-r from-purple-800 to-purple-600 p-4 rounded-lg">
          <div className="text-2xl font-bold">{totalSold.toLocaleString()}</div>
          <div className="text-purple-200">총 판매량</div>
        </div>
        <div className="bg-gradient-to-r from-amber-800 to-amber-600 p-4 rounded-lg">
          <div className="text-2xl font-bold">{products.filter(p => p.stock === 0).length}</div>
          <div className="text-amber-200">품절 상품</div>
        </div>
      </div>

      {/* 탭 */}
      <div className="flex gap-2 mb-6">
        {['products', 'orders', 'analytics'].map((tab) => (
          <button
            key={tab}
            onClick={() => setActiveTab(tab as any)}
            className={`px-4 py-2 rounded-lg font-semibold ${
              activeTab === tab ? 'bg-cyan-600' : 'bg-gray-700 hover:bg-gray-600'
            }`}
          >
            {tab === 'products' ? '📦 상품 관리' : tab === 'orders' ? '📋 주문 관리' : '📊 분석'}
          </button>
        ))}
      </div>

      {/* 상품 관리 탭 */}
      {activeTab === 'products' && (
        <div className="bg-gray-800 rounded-lg overflow-hidden">
          <div className="p-4 border-b border-gray-700 flex justify-between items-center">
            <h2 className="text-xl font-bold">상품 목록</h2>
            <button className="px-4 py-2 bg-cyan-600 hover:bg-cyan-700 rounded-lg">+ 상품 추가</button>
          </div>
          <table className="w-full">
            <thead className="bg-gray-700">
              <tr>
                <th className="px-4 py-3 text-left">상품명</th>
                <th className="px-4 py-3 text-left">카테고리</th>
                <th className="px-4 py-3 text-right">가격</th>
                <th className="px-4 py-3 text-right">재고</th>
                <th className="px-4 py-3 text-right">판매량</th>
                <th className="px-4 py-3 text-left">평점</th>
                <th className="px-4 py-3 text-left">상태</th>
                <th className="px-4 py-3 text-center">작업</th>
              </tr>
            </thead>
            <tbody>
              {products.map((product) => (
                <tr key={product.id} className="border-t border-gray-700 hover:bg-gray-750">
                  <td className="px-4 py-3 font-medium">{product.name}</td>
                  <td className="px-4 py-3">
                    <span className={`px-2 py-1 rounded text-xs ${categoryLabels[product.category].color}`}>
                      {categoryLabels[product.category].label}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-right">₩{product.price.toLocaleString()}</td>
                  <td className="px-4 py-3 text-right">
                    {product.stock === -1 ? '∞' : product.stock.toLocaleString()}
                  </td>
                  <td className="px-4 py-3 text-right">{product.sold.toLocaleString()}</td>
                  <td className="px-4 py-3">
                    <span className="text-yellow-400">★</span> {product.rating} ({product.reviews})
                  </td>
                  <td className="px-4 py-3">
                    <span className={`px-2 py-1 rounded text-xs ${
                      product.status === 'active' ? 'bg-green-600' :
                      product.status === 'out_of_stock' ? 'bg-red-600' : 'bg-gray-600'
                    }`}>
                      {product.status === 'active' ? '판매중' : product.status === 'out_of_stock' ? '품절' : '단종'}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-center">
                    <button className="px-2 py-1 bg-gray-600 hover:bg-gray-500 rounded text-sm mr-1">편집</button>
                    <button className="px-2 py-1 bg-red-600 hover:bg-red-500 rounded text-sm">삭제</button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {/* 주문 관리 탭 */}
      {activeTab === 'orders' && (
        <div className="bg-gray-800 rounded-lg overflow-hidden">
          <div className="p-4 border-b border-gray-700">
            <h2 className="text-xl font-bold">주문 목록</h2>
          </div>
          <table className="w-full">
            <thead className="bg-gray-700">
              <tr>
                <th className="px-4 py-3 text-left">주문번호</th>
                <th className="px-4 py-3 text-left">고객</th>
                <th className="px-4 py-3 text-left">상품</th>
                <th className="px-4 py-3 text-right">수량</th>
                <th className="px-4 py-3 text-right">금액</th>
                <th className="px-4 py-3 text-left">상태</th>
                <th className="px-4 py-3 text-left">주문일</th>
                <th className="px-4 py-3 text-center">작업</th>
              </tr>
            </thead>
            <tbody>
              {orders.map((order) => (
                <tr key={order.id} className="border-t border-gray-700 hover:bg-gray-750">
                  <td className="px-4 py-3 font-mono">{order.id}</td>
                  <td className="px-4 py-3">{order.userName}</td>
                  <td className="px-4 py-3">{order.productName}</td>
                  <td className="px-4 py-3 text-right">{order.quantity}</td>
                  <td className="px-4 py-3 text-right">₩{order.total.toLocaleString()}</td>
                  <td className="px-4 py-3">
                    <span className={`px-2 py-1 rounded text-xs ${statusLabels[order.status].color}`}>
                      {statusLabels[order.status].label}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-gray-400">{order.orderDate}</td>
                  <td className="px-4 py-3 text-center">
                    <button className="px-2 py-1 bg-cyan-600 hover:bg-cyan-500 rounded text-sm">상세</button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {/* 분석 탭 */}
      {activeTab === 'analytics' && (
        <div className="grid grid-cols-2 gap-6">
          <div className="bg-gray-800 rounded-lg p-6">
            <h2 className="text-xl font-bold mb-4">카테고리별 판매</h2>
            <div className="space-y-4">
              {Object.entries(categoryLabels).map(([cat, info]) => {
                const catProducts = products.filter(p => p.category === cat);
                const catSold = catProducts.reduce((sum, p) => sum + p.sold, 0);
                return (
                  <div key={cat}>
                    <div className="flex justify-between mb-1">
                      <span className={info.color.replace('bg-', 'text-')}>{info.label}</span>
                      <span>{catSold.toLocaleString()}개</span>
                    </div>
                    <div className="h-2 bg-gray-700 rounded-full overflow-hidden">
                      <div 
                        className={info.color}
                        style={{ width: `${(catSold / totalSold) * 100}%` }}
                      />
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
          <div className="bg-gray-800 rounded-lg p-6">
            <h2 className="text-xl font-bold mb-4">주문 상태</h2>
            <div className="space-y-4">
              {Object.entries(statusLabels).map(([status, info]) => {
                const count = orders.filter(o => o.status === status).length;
                return (
                  <div key={status}>
                    <div className="flex justify-between mb-1">
                      <span>{info.label}</span>
                      <span>{count}건</span>
                    </div>
                    <div className="h-2 bg-gray-700 rounded-full overflow-hidden">
                      <div 
                        className={info.color}
                        style={{ width: `${(count / orders.length) * 100}%` }}
                      />
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
