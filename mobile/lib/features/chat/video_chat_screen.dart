import 'package:flutter/material.dart';
import '../../core/services/chat_service.dart';
import '../../core/state/user_state.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class VideoChatScreen extends StatefulWidget {
  const VideoChatScreen({super.key});

  @override
  State<VideoChatScreen> createState() => _VideoChatScreenState();
}

class _VideoChatScreenState extends State<VideoChatScreen> {
  final _chat = ChatService();
  final _controller = TextEditingController();
  final List<ChatMessageDto> _messages = [];
  Timer? _poller;
  String _videoId = '';
  bool _loading = true;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _videoId = (ModalRoute.of(context)?.settings.arguments as String?) ?? '';
      _loadMessages();
      _startPolling();
    });
  }

  @override
  void dispose() {
    _poller?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startPolling() {
    _poller?.cancel();
    _poller = Timer.periodic(const Duration(seconds: 5), (_) => _loadMessages(sinceOnly: true));
  }

  Future<void> _loadMessages({bool sinceOnly = false}) async {
    if (_videoId.isEmpty) return;
    final since = sinceOnly && _messages.isNotEmpty ? _messages.last.createdAt : null;
    try {
      final msgs = await _chat.listMessages(_videoId, since: since);
      if (msgs.isEmpty && sinceOnly) return;
      setState(() {
        if (sinceOnly && _messages.isNotEmpty) {
          _messages.addAll(msgs);
        } else {
          _messages
            ..clear()
            ..addAll(msgs);
        }
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Chat del video')),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? const Center(child: Text('Sé el primero en comentar'))
                    : ListView.builder(
                        itemCount: _messages.length,
                        itemBuilder: (_, i) {
                          final m = _messages[i];
                          final isVendor = m.senderRole.toUpperCase().contains('VENDOR');
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isVendor ? const Color(0xFF0E9384) : Colors.grey.shade300,
                              child: Text(m.senderId.isNotEmpty ? m.senderId[0] : '?'),
                            ),
                            title: Text('${m.senderId} · ${m.senderRole}'),
                            subtitle: Text(m.message),
                            trailing: Text(m.createdAt, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                          );
                        },
                      ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(hintText: 'Escribe un mensaje'))),
                IconButton(
                  onPressed: _sending
                      ? null
                      : () async {
                          if (_controller.text.isEmpty) return;
                          if (user.userId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Inicia sesión para chatear')));
                            Navigator.pushNamed(context, '/login');
                            return;
                          }
                          setState(() => _sending = true);
                          try {
                            await _chat.sendMessage(_videoId, _controller.text);
                            _controller.clear();
                            await _loadMessages();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
                          } finally {
                            if (mounted) setState(() => _sending = false);
                          }
                        },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
