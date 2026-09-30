import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/category_icons.dart';
import '../../domain/entities/person.dart';
import '../../domain/usecases/add_person.dart';

/// Returns why the details were refused, or null once they are saved.
typedef PersonSave =
    Future<FailureCode?> Function({
      required String name,
      required int colorValue,
      String? phone,
    });

/// Add a person, or change one's name, phone or color.
///
/// The details are checked where they are saved. A refused save keeps the
/// sheet open with the reason under the field, so nothing typed is lost.
class PersonEditorSheet extends StatefulWidget {
  const PersonEditorSheet({
    super.key,
    required this.onSave,
    this.existing,
    this.suggestedColor,
  });

  final PersonSave onSave;
  final Person? existing;

  /// The color a new person starts with.
  final int? suggestedColor;

  static Future<void> show(
    BuildContext context, {
    required PersonSave onSave,
    Person? existing,
    int? suggestedColor,
  }) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => PersonEditorSheet(
      onSave: onSave,
      existing: existing,
      suggestedColor: suggestedColor,
    ),
  );

  @override
  State<PersonEditorSheet> createState() => _PersonEditorSheetState();
}

class _PersonEditorSheetState extends State<PersonEditorSheet> {
  // Controllers belong to the State, never to build().
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  // Local UI state: the chosen color, a save in flight, and why the last
  // one was refused.
  late int _colorValue;
  bool _saving = false;
  FailureCode? _error;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _nameController = TextEditingController(text: existing?.name ?? '');
    _phoneController = TextEditingController(text: existing?.phone ?? '');
    _colorValue =
        existing?.colorValue ??
        widget.suggestedColor ??
        CategoryColors.defaultColor;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_saving) return;
    setState(() => _saving = true);
    final navigator = Navigator.of(context);
    final error = await widget.onSave(
      name: _nameController.text,
      colorValue: _colorValue,
      phone: _phoneController.text,
    );
    if (!mounted) return;
    if (error == null) {
      navigator.pop();
    } else {
      setState(() {
        _saving = false;
        _error = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final isEditing = widget.existing != null;
    final error = _error;
    final phoneError = error == FailureCode.phoneInvalid;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? strings.editPerson : strings.newPerson,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              autofocus: !isEditing,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              maxLength: AddPerson.maxNameLength,
              decoration: InputDecoration(
                labelText: strings.personName,
                counterText: '',
                errorText: error != null && !phoneError
                    ? strings.failure(error)
                    : null,
                prefixIcon: Icon(
                  Icons.person_outline_rounded,
                  color: Color(_colorValue),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              maxLength: AddPerson.maxPhoneLength,
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: strings.phoneOptional,
                counterText: '',
                errorText: phoneError ? strings.failure(error!) : null,
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              strings.color,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            _ColorRow(
              selected: _colorValue,
              onSelected: (value) => setState(() => _colorValue = value),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _saving ? null : _submit,
              child: Text(isEditing ? strings.saveChanges : strings.addPerson),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorRow extends StatelessWidget {
  const _ColorRow({required this.selected, required this.onSelected});

  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: CategoryColors.palette.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final value = CategoryColors.palette[index];
          final isSelected = value == selected;
          return GestureDetector(
            onTap: () => onSelected(value),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(value),
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 3,
                      )
                    : null,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 20,
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
