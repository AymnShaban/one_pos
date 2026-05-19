
import '../../../../../../core/helper/helper.dart';

/// Small numeric box that shows an externally-computed [value] but is also
/// editable like a text field. Edits flow through [onChanged]; the displayed
/// value is only re-synced from outside while the field is not focused, so
/// typing isn't interrupted.
class EditableSmallBox extends StatefulWidget {
  final String value;
  final Function(String) onChanged;

  const EditableSmallBox({required this.value, required this.onChanged});

  @override
  State<EditableSmallBox> createState() => _EditableSmallBoxState();
}

class _EditableSmallBoxState extends State<EditableSmallBox> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant EditableSmallBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reflect the recomputed value only when the user isn't editing.
    if (!_focusNode.hasFocus && widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        style: AppTextTheme.captionBold,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}
