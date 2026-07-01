import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final VoidCallback? onClear;

  const CustomSearchBar({
    super.key,
    required this.onChanged,
    this.controller,
    this.onClear,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final showClear = widget.onClear != null && (widget.controller?.text.isNotEmpty ?? false);

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(Icons.search, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: widget.controller,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                isCollapsed: true,
              ),
              onChanged: widget.onChanged,
            ),
          ),
          if (showClear)
            IconButton(
              icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant),
              splashRadius: 20,
              onPressed: widget.onClear,
            ),
        ],
      ),
    );
  }
}
