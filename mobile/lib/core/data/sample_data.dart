import '../config/api_config.dart';

class SampleVideo {
  final String id;
  final String title;
  final String vendorName;
  final bool live;
  final String thumbnail;
  final List<String> productIds;
  final List<String> serviceIds;
  SampleVideo({
    required this.id,
    required this.title,
    required this.vendorName,
    required this.live,
    required this.thumbnail,
    this.productIds = const [],
    this.serviceIds = const [],
  });
}

class SampleProduct {
  final String id;
  final String name;
  final String vendor;
  final String vendorId;
  final String category;
  final int price;
  final int stock;
  final bool active;
  SampleProduct({
    required this.id,
    required this.name,
    required this.vendor,
    required this.vendorId,
    required this.category,
    required this.price,
    this.stock = 0,
    this.active = true,
  });
}

class SampleService {
  final String id;
  final String name;
  final String vendor;
  final String vendorId;
  final String type;
  final int price;
  SampleService({
    required this.id,
    required this.name,
    required this.vendor,
    required this.vendorId,
    required this.type,
    required this.price,
  });
}

class SampleDelivery {
  final String id;
  final String orderId;
  final String status;
  final String type;
  final String? photo;
  SampleDelivery({
    required this.id,
    required this.orderId,
    required this.status,
    required this.type,
    this.photo,
  });
}

class SampleInstallment {
  final String id;
  final String orderId;
  final int amount;
  final String dueDate;
  final bool paid;
  SampleInstallment({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.dueDate,
    required this.paid,
  });
}

class SampleAppointment {
  final String id;
  final String serviceName;
  final String vendor;
  final String date;
  final String status;
  SampleAppointment({
    required this.id,
    required this.serviceName,
    required this.vendor,
    required this.date,
    required this.status,
  });
}

class SampleChatMessage {
  final String user;
  final String role;
  final String message;
  final String time;
  SampleChatMessage(this.user, this.role, this.message, this.time);
}

class SampleData {
  static String apiBase = ApiConfig.baseUrl;

  static final products = <SampleProduct>[
    SampleProduct(id: 'p1', name: 'iPhone 14 Pro', vendor: 'Comercio Uno', vendorId: 'vendor1', category: 'Electrónica', price: 1200),
    SampleProduct(id: 'p2', name: 'Sneakers X', vendor: 'Street Wear', vendorId: 'vendor2', category: 'Moda', price: 180),
    SampleProduct(id: 'p3', name: 'Monitor 27"', vendor: 'Tech Hub', vendorId: 'vendor3', category: 'Computación', price: 320),
  ];

  static final services = <SampleService>[
    SampleService(id: 's1', name: 'Corte + Barba', vendor: 'Barber Pro', vendorId: 'vendor4', type: 'Belleza', price: 20),
    SampleService(id: 's2', name: 'Consulta General', vendor: 'MedSalud', vendorId: 'vendor5', type: 'Salud', price: 30),
  ];

  static final videos = <SampleVideo>[
    SampleVideo(
      id: 'v1',
      title: 'Lanzamiento Sneakers',
      vendorName: 'Street Wear',
      live: true,
      thumbnail: '$apiBase/assets/live1.jpg',
      productIds: ['p2'],
    ),
    SampleVideo(
      id: 'v2',
      title: 'Unboxing iPhone',
      vendorName: 'Comercio Uno',
      live: false,
      thumbnail: '$apiBase/assets/live2.jpg',
      productIds: ['p1'],
    ),
    SampleVideo(
      id: 'v3',
      title: 'Agenda tu cita',
      vendorName: 'Barber Pro',
      live: true,
      thumbnail: '$apiBase/assets/live3.jpg',
      serviceIds: ['s1'],
    ),
  ];

  static final deliveries = <SampleDelivery>[
    SampleDelivery(id: 'd1', orderId: 'ORD-1001', status: 'PENDING_DELIVERY', type: 'INTERNAL'),
    SampleDelivery(id: 'd2', orderId: 'ORD-1002', status: 'DELIVERED', type: 'INTERNAL', photo: 'https://picsum.photos/200'),
    SampleDelivery(id: 'd3', orderId: 'ORD-1003', status: 'IN_DELIVERY', type: 'CREFIGEX'),
  ];

  static final installments = <SampleInstallment>[
    SampleInstallment(id: 'i1', orderId: 'ORD-1001', amount: 120, dueDate: '2024-08-15', paid: true),
    SampleInstallment(id: 'i2', orderId: 'ORD-1001', amount: 120, dueDate: '2024-08-30', paid: false),
    SampleInstallment(id: 'i3', orderId: 'ORD-1002', amount: 50, dueDate: '2024-08-20', paid: false),
  ];

  static final appointments = <SampleAppointment>[
    SampleAppointment(id: 'a1', serviceName: 'Corte + Barba', vendor: 'Barber Pro', date: '2024-08-12 15:00', status: 'CONFIRMED'),
    SampleAppointment(id: 'a2', serviceName: 'Consulta General', vendor: 'MedSalud', date: '2024-08-18 10:00', status: 'PENDING'),
  ];

  static final chat = <SampleChatMessage>[
    SampleChatMessage('Carlos', 'CLIENTE', '¿Qué colores tienes disponibles?', '14:20'),
    SampleChatMessage('Street Wear', 'VENDEDOR', 'Tenemos rojo y blanco. Te muestro en cámara.', '14:21'),
    SampleChatMessage('Ana', 'CLIENTE', '¿Envían a Maracaibo?', '14:22'),
  ];
}
