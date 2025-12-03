import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../core/state/user_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF6366f1);
    final user = Provider.of<UserState>(context, listen: false);
    final isClient = user.roles.contains('CLIENTE');
    final tiles = <_NavTile>[
      _NavTile('Videos en vivo', Icons.ondemand_video, '/videos', 'Compra viendo streams y lives.'),
      _NavTile('Catálogo', Icons.storefront, '/catalog', 'Explora productos y servicios.'),
      if (isClient) ...[
        _NavTile('Carrito', Icons.shopping_cart_outlined, '/cart', 'Revisa lo que agregarás.'),
        _NavTile('Checkout', Icons.credit_score, '/checkout', 'Planes y entrega.'),
        _NavTile('Mis pedidos', Icons.receipt_long, '/orders', 'Historial de compras.'),
        _NavTile('Pagos', Icons.payments, '/payments', 'Cuotas y comprobantes.'),
        _NavTile('Mis entregas', Icons.local_shipping, '/deliveries', 'Estado de envíos.'),
        _NavTile('Citas', Icons.event_available, '/appointments', 'Agenda con prestadores.'),
      ],
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
                    Consumer<UserState>(
                      builder: (_, userState, __) {
                        final logged = userState.userId != null;
                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEEF2FF), Color(0xFFE0E7FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.white,
                                child: Icon(logged ? Icons.verified_user : Icons.person_outline, color: accent),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      logged ? (userState.name.isNotEmpty ? userState.name : 'Usuario') : 'Bienvenido',
                                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF0F172A)),
                                    ),
                                    Text(
                                      logged ? 'Listo para comprar o agendar' : 'Entra o regístrate para vivir la experiencia',
                                      style: const TextStyle(color: Color(0xFF475569), fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              if (!logged) ...[
                                OutlinedButton.icon(
                                  onPressed: () => Navigator.pushNamed(context, '/register'),
                                  icon: const Icon(Icons.edit_outlined, size: 16),
                                  label: const Text('Regístrate'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: accent,
                                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  onPressed: () => Navigator.pushNamed(context, '/login'),
                                  icon: const Icon(Icons.login, size: 16),
                                  label: const Text('Entrar'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: accent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                ),
                              ] else
                                TextButton(
                                  onPressed: () async {
                                    await Provider.of<AppState>(context, listen: false).setToken(null);
                                    Provider.of<UserState>(context, listen: false).clear();
                                  },
                                  child: const Text('Salir'),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    const Text('Crefigex Live', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                    const SizedBox(height: 6),
                    const Text('Marketplace con live commerce y servicios.', style: TextStyle(color: Color(0xFF475569))),
                    const SizedBox(height: 16),
                    _SearchBar(),
                    const SizedBox(height: 12),
                    _FilterChips(),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  childAspectRatio: 0.98,
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
    const accent = Color(0xFF6366f1);
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

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: const [
          Icon(Icons.search, color: Color(0xFF94A3B8)),
          SizedBox(width: 10),
          Expanded(child: Text('Buscar productos, servicios, videos', style: TextStyle(color: Color(0xFF94A3B8)))),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final chips = const ['Destacados', 'Live ahora', 'Comercios', 'Servicios'];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) => Chip(
          label: Text(chips[i]),
          backgroundColor: i == 0 ? const Color(0xFF0F172A) : Colors.white,
          labelStyle: TextStyle(color: i == 0 ? Colors.white : const Color(0xFF475569)),
          side: BorderSide(color: i == 0 ? Colors.transparent : const Color(0xFFE2E8F0)),
        ),
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: chips.length,
      ),
    );
  }
}
