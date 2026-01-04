import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ============================================================================
// STATES
// ============================================================================

abstract class MarketplaceState extends Equatable {
  const MarketplaceState();

  @override
  List<Object> get props => [];
}

class MarketplaceInitial extends MarketplaceState {
  const MarketplaceInitial();
}

class MarketplaceLoading extends MarketplaceState {
  const MarketplaceLoading();
}

class ProductsLoaded extends MarketplaceState {
  final List<Product> products;
  final String category; // health, cartridges, subscriptions
  final int totalCount;

  const ProductsLoaded({
    required this.products,
    required this.category,
    required this.totalCount,
  });

  @override
  List<Object> get props => [products, category, totalCount];
}

class ProductDetailLoaded extends MarketplaceState {
  final Product product;
  final List<Review> reviews;
  final List<Product> relatedProducts;

  const ProductDetailLoaded({
    required this.product,
    required this.reviews,
    required this.relatedProducts,
  });

  @override
  List<Object> get props => [product, reviews, relatedProducts];
}

class CartUpdated extends MarketplaceState {
  final List<CartItem> items;
  final double totalPrice;
  final int itemCount;

  const CartUpdated({
    required this.items,
    required this.totalPrice,
    required this.itemCount,
  });

  @override
  List<Object> get props => [items, totalPrice, itemCount];
}

class CheckoutInitiated extends MarketplaceState {
  final double totalAmount;
  final int itemCount;
  final String orderId;

  const CheckoutInitiated({
    required this.totalAmount,
    required this.itemCount,
    required this.orderId,
  });

  @override
  List<Object> get props => [totalAmount, itemCount, orderId];
}

class OrdersLoaded extends MarketplaceState {
  final List<Order> orders;
  final int totalOrders;

  const OrdersLoaded({
    required this.orders,
    required this.totalOrders,
  });

  @override
  List<Object> get props => [orders, totalOrders];
}

class SearchResultsLoaded extends MarketplaceState {
  final List<Product> results;
  final String query;
  final int resultCount;

  const SearchResultsLoaded({
    required this.results,
    required this.query,
    required this.resultCount,
  });

  @override
  List<Object> get props => [results, query, resultCount];
}

class PaymentProcessing extends MarketplaceState {
  final String orderId;
  final double amount;
  final String paymentMethod;

  const PaymentProcessing({
    required this.orderId,
    required this.amount,
    required this.paymentMethod,
  });

  @override
  List<Object> get props => [orderId, amount, paymentMethod];
}

class PaymentSuccess extends MarketplaceState {
  final String orderId;
  final DateTime timestamp;
  final String receiptUrl;

  const PaymentSuccess({
    required this.orderId,
    required this.timestamp,
    required this.receiptUrl,
  });

  @override
  List<Object> get props => [orderId, timestamp, receiptUrl];
}

class MarketplaceError extends MarketplaceState {
  final String message;
  final Exception? exception;

  const MarketplaceError({
    required this.message,
    this.exception,
  });

  @override
  List<Object> get props => [message];
}

// ============================================================================
// EVENTS
// ============================================================================

abstract class MarketplaceEvent extends Equatable {
  const MarketplaceEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends MarketplaceEvent {
  final String category; // health, cartridges, subscriptions
  final int page;
  final int limit;

  const LoadProducts({
    required this.category,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object> get props => [category, page, limit];
}

class LoadProductDetail extends MarketplaceEvent {
  final String productId;

  const LoadProductDetail({required this.productId});

  @override
  List<Object> get props => [productId];
}

class AddToCart extends MarketplaceEvent {
  final String productId;
  final int quantity;

  const AddToCart({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object> get props => [productId, quantity];
}

class RemoveFromCart extends MarketplaceEvent {
  final String cartItemId;

  const RemoveFromCart({required this.cartItemId});

  @override
  List<Object> get props => [cartItemId];
}

class UpdateCartItemQuantity extends MarketplaceEvent {
  final String cartItemId;
  final int newQuantity;

  const UpdateCartItemQuantity({
    required this.cartItemId,
    required this.newQuantity,
  });

  @override
  List<Object> get props => [cartItemId, newQuantity];
}

class LoadCart extends MarketplaceEvent {
  const LoadCart();
}

class InitiateCheckout extends MarketplaceEvent {
  const InitiateCheckout();
}

class ProcessPayment extends MarketplaceEvent {
  final String paymentMethod;
  final String cardToken;

  const ProcessPayment({
    required this.paymentMethod,
    required this.cardToken,
  });

  @override
  List<Object> get props => [paymentMethod, cardToken];
}

class LoadOrders extends MarketplaceEvent {
  const LoadOrders();
}

class SearchProducts extends MarketplaceEvent {
  final String query;
  final String? category;

  const SearchProducts({
    required this.query,
    this.category,
  });

  @override
  List<Object> get props => [query, category ?? ''];
}

class ApplyCoupon extends MarketplaceEvent {
  final String couponCode;

  const ApplyCoupon({required this.couponCode});

  @override
  List<Object> get props => [couponCode];
}

class WriteReview extends MarketplaceEvent {
  final String productId;
  final int rating;
  final String review;

  const WriteReview({
    required this.productId,
    required this.rating,
    required this.review,
  });

  @override
  List<Object> get props => [productId, rating, review];
}

// ============================================================================
// BLOC
// ============================================================================

class MarketplaceBloc extends Bloc<MarketplaceEvent, MarketplaceState> {
  MarketplaceBloc() : super(const MarketplaceInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductDetail>(_onLoadProductDetail);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<LoadCart>(_onLoadCart);
    on<InitiateCheckout>(_onInitiateCheckout);
    on<ProcessPayment>(_onProcessPayment);
    on<LoadOrders>(_onLoadOrders);
    on<SearchProducts>(_onSearchProducts);
    on<ApplyCoupon>(_onApplyCoupon);
    on<WriteReview>(_onWriteReview);
  }

  final List<CartItem> _cartItems = [];
  double _totalPrice = 0.0;
  final List<Order> _orders = [];

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<MarketplaceState> emit,
  ) async {
    try {
      emit(const MarketplaceLoading());

      await Future.delayed(const Duration(milliseconds: 500));

      final products = _generateMockProducts(event.category);

      emit(ProductsLoaded(
        products: products,
        category: event.category,
        totalCount: products.length,
      ));
    } catch (e) {
      emit(MarketplaceError(
        message: 'Failed to load products: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onLoadProductDetail(
    LoadProductDetail event,
    Emitter<MarketplaceState> emit,
  ) async {
    try {
      emit(const MarketplaceLoading());

      await Future.delayed(const Duration(milliseconds: 500));

      final product = Product(
        id: event.productId,
        name: '프리미엄 혈당 측정 카트리지',
        price: 89900,
        rating: 4.8,
        reviewCount: 235,
        description: 'FDA 승인된 의료 기기로 가정에서 전문적인 수준의 혈당 측정을 가능하게 합니다.',
        imageUrl: '',
        category: 'cartridges',
        inStock: true,
      );

      final reviews = [
        Review(
          id: '1',
          author: '사용자1',
          rating: 5,
          content: '정확하고 빠릅니다. 매우 만족합니다.',
          date: DateTime.now(),
        ),
        Review(
          id: '2',
          author: '사용자2',
          rating: 4,
          content: '좋은 제품이지만 가격이 조금 비싼 편',
          date: DateTime.now(),
        ),
      ];

      final relatedProducts = [
        Product(
          id: '2',
          name: '혈당 측정기',
          price: 129900,
          rating: 4.7,
          reviewCount: 198,
          description: '스마트 혈당 측정기',
          imageUrl: '',
          category: 'health',
          inStock: true,
        ),
      ];

      emit(ProductDetailLoaded(
        product: product,
        reviews: reviews,
        relatedProducts: relatedProducts,
      ));
    } catch (e) {
      emit(MarketplaceError(
        message: 'Failed to load product detail: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onAddToCart(
    AddToCart event,
    Emitter<MarketplaceState> emit,
  ) async {
    try {
      final cartItem = CartItem(
        id: 'cart_${_cartItems.length + 1}',
        productId: event.productId,
        productName: 'Product ${event.productId}',
        price: 89900,
        quantity: event.quantity,
      );

      _cartItems.add(cartItem);
      _calculateTotal();

      emit(CartUpdated(
        items: List.from(_cartItems),
        totalPrice: _totalPrice,
        itemCount: _cartItems.length,
      ));
    } catch (e) {
      emit(MarketplaceError(
        message: 'Failed to add to cart: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<MarketplaceState> emit,
  ) async {
    try {
      _cartItems.removeWhere((item) => item.id == event.cartItemId);
      _calculateTotal();

      emit(CartUpdated(
        items: List.from(_cartItems),
        totalPrice: _totalPrice,
        itemCount: _cartItems.length,
      ));
    } catch (e) {
      emit(MarketplaceError(
        message: 'Failed to remove from cart: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onUpdateCartItemQuantity(
    UpdateCartItemQuantity event,
    Emitter<MarketplaceState> emit,
  ) async {
    try {
      final itemIndex = _cartItems.indexWhere((item) => item.id == event.cartItemId);
      if (itemIndex >= 0) {
        final item = _cartItems[itemIndex];
        _cartItems[itemIndex] = CartItem(
          id: item.id,
          productId: item.productId,
          productName: item.productName,
          price: item.price,
          quantity: event.newQuantity,
        );
      }

      _calculateTotal();

      emit(CartUpdated(
        items: List.from(_cartItems),
        totalPrice: _totalPrice,
        itemCount: _cartItems.length,
      ));
    } catch (e) {
      emit(MarketplaceError(
        message: 'Failed to update cart: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onLoadCart(
    LoadCart event,
    Emitter<MarketplaceState> emit,
  ) async {
    try {
      emit(const MarketplaceLoading());

      await Future.delayed(const Duration(milliseconds: 300));

      _calculateTotal();

      emit(CartUpdated(
        items: List.from(_cartItems),
        totalPrice: _totalPrice,
        itemCount: _cartItems.length,
      ));
    } catch (e) {
      emit(MarketplaceError(
        message: 'Failed to load cart: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onInitiateCheckout(
    InitiateCheckout event,
    Emitter<MarketplaceState> emit,
  ) async {
    try {
      emit(const MarketplaceLoading());

      await Future.delayed(const Duration(milliseconds: 500));

      final orderId = 'ORD_${DateTime.now().millisecondsSinceEpoch}';

      emit(CheckoutInitiated(
        totalAmount: _totalPrice,
        itemCount: _cartItems.length,
        orderId: orderId,
      ));
    } catch (e) {
      emit(MarketplaceError(
        message: 'Failed to initiate checkout: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onProcessPayment(
    ProcessPayment event,
    Emitter<MarketplaceState> emit,
  ) async {
    try {
      emit(MarketplaceLoading());

      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      final orderId = 'ORD_${DateTime.now().millisecondsSinceEpoch}';
      
      final order = Order(
        id: orderId,
        items: List.from(_cartItems),
        totalAmount: _totalPrice,
        paymentMethod: event.paymentMethod,
        status: 'completed',
        createdAt: DateTime.now(),
      );

      _orders.add(order);
      _cartItems.clear();
      _totalPrice = 0.0;

      emit(PaymentSuccess(
        orderId: orderId,
        timestamp: DateTime.now(),
        receiptUrl: '/receipts/$orderId.pdf',
      ));
    } catch (e) {
      emit(MarketplaceError(
        message: 'Payment failed: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onLoadOrders(
    LoadOrders event,
    Emitter<MarketplaceState> emit,
  ) async {
    try {
      emit(const MarketplaceLoading());

      await Future.delayed(const Duration(milliseconds: 500));

      // Add mock orders if empty
      if (_orders.isEmpty) {
        _orders.addAll([
          Order(
            id: 'ORD_001',
            items: [
              CartItem(
                id: '1',
                productId: '1',
                productName: '프리미엄 혈당 측정 카트리지',
                price: 89900,
                quantity: 2,
              ),
            ],
            totalAmount: 179800,
            paymentMethod: 'card',
            status: 'shipped',
            createdAt: DateTime.now().subtract(const Duration(days: 5)),
          ),
          Order(
            id: 'ORD_002',
            items: [
              CartItem(
                id: '2',
                productId: '2',
                productName: '비타민 D3 60정',
                price: 29900,
                quantity: 1,
              ),
            ],
            totalAmount: 29900,
            paymentMethod: 'card',
            status: 'delivered',
            createdAt: DateTime.now().subtract(const Duration(days: 10)),
          ),
        ]);
      }

      emit(OrdersLoaded(
        orders: List.from(_orders),
        totalOrders: _orders.length,
      ));
    } catch (e) {
      emit(MarketplaceError(
        message: 'Failed to load orders: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<MarketplaceState> emit,
  ) async {
    try {
      emit(const MarketplaceLoading());

      await Future.delayed(const Duration(milliseconds: 500));

      final allProducts = _generateMockProducts('all');
      final results = allProducts
          .where((p) => p.name.toLowerCase().contains(event.query.toLowerCase()))
          .toList();

      emit(SearchResultsLoaded(
        results: results,
        query: event.query,
        resultCount: results.length,
      ));
    } catch (e) {
      emit(MarketplaceError(
        message: 'Search failed: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onApplyCoupon(
    ApplyCoupon event,
    Emitter<MarketplaceState> emit,
  ) async {
    try {
      // Coupon validation logic
      if (event.couponCode.startsWith('SAVE')) {
        _totalPrice *= 0.9; // 10% discount
      }

      _calculateTotal();

      emit(CartUpdated(
        items: List.from(_cartItems),
        totalPrice: _totalPrice,
        itemCount: _cartItems.length,
      ));
    } catch (e) {
      emit(MarketplaceError(
        message: 'Coupon application failed: $e',
        exception: e as Exception?,
      ));
    }
  }

  Future<void> _onWriteReview(
    WriteReview event,
    Emitter<MarketplaceState> emit,
  ) async {
    try {
      emit(const MarketplaceLoading());

      await Future.delayed(const Duration(milliseconds: 500));

      // Review saved
      add(LoadProductDetail(productId: event.productId));
    } catch (e) {
      emit(MarketplaceError(
        message: 'Failed to write review: $e',
        exception: e as Exception?,
      ));
    }
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  void _calculateTotal() {
    _totalPrice = _cartItems.fold(0, (total, item) => total + (item.price * item.quantity));
  }

  List<Product> _generateMockProducts(String category) {
    if (category == 'cartridges' || category == 'all') {
      return [
        Product(
          id: '1',
          name: '프리미엄 혈당 측정 카트리지',
          price: 89900,
          rating: 4.8,
          reviewCount: 235,
          description: '10개 박스',
          imageUrl: '',
          category: 'cartridges',
          inStock: true,
        ),
        Product(
          id: '2',
          name: '표준 혈당 측정 카트리지',
          price: 69900,
          rating: 4.5,
          reviewCount: 156,
          description: '10개 박스',
          imageUrl: '',
          category: 'cartridges',
          inStock: true,
        ),
      ];
    } else if (category == 'health' || category == 'all') {
      return [
        Product(
          id: '3',
          name: '비타민 D3 60정',
          price: 29900,
          rating: 4.7,
          reviewCount: 189,
          description: '하루 1정',
          imageUrl: '',
          category: 'health',
          inStock: true,
        ),
        Product(
          id: '4',
          name: '혈당 측정기',
          price: 129900,
          rating: 4.7,
          reviewCount: 198,
          description: '스마트 기기',
          imageUrl: '',
          category: 'health',
          inStock: true,
        ),
      ];
    }
    return [];
  }
}

// ============================================================================
// MODELS
// ============================================================================

class Product extends Equatable {
  final String id;
  final String name;
  final double price;
  final double rating;
  final int reviewCount;
  final String description;
  final String imageUrl;
  final String category;
  final bool inStock;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.inStock,
  });

  @override
  List<Object> get props =>
      [id, name, price, rating, reviewCount, description, imageUrl, category, inStock];
}

class CartItem extends Equatable {
  final String id;
  final String productId;
  final String productName;
  final double price;
  final int quantity;

  const CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
  });

  @override
  List<Object> get props => [id, productId, productName, price, quantity];
}

class Order extends Equatable {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final String paymentMethod;
  final String status; // completed, shipped, delivered, cancelled
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, items, totalAmount, paymentMethod, status, createdAt];
}

class Review extends Equatable {
  final String id;
  final String author;
  final int rating;
  final String content;
  final DateTime date;

  const Review({
    required this.id,
    required this.author,
    required this.rating,
    required this.content,
    required this.date,
  });

  @override
  List<Object> get props => [id, author, rating, content, date];
}
