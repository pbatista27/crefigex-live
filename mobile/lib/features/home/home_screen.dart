import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      _NavTile('Videos en vivo', Icons.ondemand_video, '/videos', 'Compra viendo streams y lives.'),
      _NavTile('Catálogo', Icons.storefront, '/catalog', 'Explora productos y servicios.'),
      _NavTile('Carrito', Icons.shopping_cart_outlined, '/cart', 'Revisa lo que agregarás.'),
      _NavTile('Checkout', Icons.credit_score, '/checkout', 'Planes BNPL y entrega.'),
      _NavTile('Mis pedidos', Icons.receipt_long, '/orders', 'Historial de compras.'),
      _NavTile('Pagos BNPL', Icons.payments, '/payments', 'Cuotas y comprobantes.'),
      _NavTile('Mis entregas', Icons.local_shipping, '/deliveries', 'Estado de envíos.'),
      _NavTile('Citas', Icons.event_available, '/appointments', 'Agenda con prestadores.'),
      _NavTile('Panel comercio', Icons.business_center, '/vendor/commerce', 'Gestiona productos y entregas.'),
      _NavTile('Panel prestador', Icons.handshake, '/vendor/prestador', 'Gestiona servicios y agenda.'),
    ];

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/register'),
                          child: const Text('Regístrate'),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () => Navigator.pushNamed(context, '/login'),
                          child: const Text('Entrar'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text('Crefigex Live', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    const Text('Marketplace BNPL con live commerce y servicios.', style: TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final t = tiles[index];
                    return _GradientCard(tile: t);
                  },
                  childCount: tiles.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.95,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavTile {
  final String title;
  final IconData icon;
  final String route;
  final String subtitle;
  _NavTile(this.title, this.icon, this.route, this.subtitle);
}

class _GradientCard extends StatelessWidget {
  final _NavTile tile;
  const _GradientCard({required this.tile});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF0E9384);
    return InkWell(
      onTap: () => Navigator.pushNamed(context, tile.route),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 6)),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: accent.withOpacity(0.12),
              child: Icon(tile.icon, color: accent),
            ),
            const Spacer(),
            Text(tile.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 6),
            Text(tile.subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.arrow_forward, size: 14, color: accent),
                  SizedBox(width: 6),
                  Text('Entrar', style: TextStyle(fontSize: 12, color: accent, fontWeight: FontWeight.w600)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
