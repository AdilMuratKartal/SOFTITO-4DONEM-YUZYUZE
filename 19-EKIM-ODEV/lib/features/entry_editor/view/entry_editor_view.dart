import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/extensions/date_extensions.dart';
import '../controllers/entry_editor_controller.dart';
import '../models/journal_entry_model.dart';
import '../widgets/mood_picker_widget.dart';
import '../widgets/text_formatting_bar.dart';

/// Günlük Yazma ve Düzenleme Ekranı (Clean UI, 40 satır altı build kuralına sadık).
class EntryEditorView extends StatefulWidget {
  final JournalEntry? initialEntry;
  final DateTime? targetDate;
  final String? initialMood;

  const EntryEditorView({
    super.key,
    this.initialEntry,
    this.targetDate,
    this.initialMood,
  });

  @override
  State<EntryEditorView> createState() => _EntryEditorViewState();
}

class _EntryEditorViewState extends State<EntryEditorView> {
  late final EntryEditorController _controller;
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _tagController;

  @override
  void initState() {
    super.initState();
    _controller = EntryEditorController(
      initialEntry: widget.initialEntry,
      targetDate: widget.targetDate,
      initialMood: widget.initialMood,
    );
    _titleController =
        TextEditingController(text: widget.initialEntry?.title ?? '');
    _contentController =
        TextEditingController(text: widget.initialEntry?.content ?? '');
    _tagController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = context.journalStyle;

    return Scaffold(
      appBar: AppBar(
        title: _buildAppBarTitle(style),
        actions: [
          _buildSaveAction(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MoodPickerWidget(
              selectedMoodNotifier: _controller.selectedMoodNotifier,
              onMoodSelected: _controller.setMood,
            ),
            const SizedBox(height: 16),
            _buildTitleInput(style),
            const Divider(height: 24),
            _buildFormattingRow(),
            const SizedBox(height: 8),
            _buildContentInput(style),
            const Divider(height: 24),
            _buildTagsSection(style),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarTitle(dynamic style) {
    final effectiveDate =
        widget.initialEntry?.createdAt ?? widget.targetDate;

    if (effectiveDate != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.initialEntry == null
                ? AppStrings.newEntryTitle
                : AppStrings.editEntryTitle,
            style: style.headerFont.copyWith(fontSize: 16.0),
          ),
          Text(
            effectiveDate.toJournalDate(),
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.normal,
              color: context.colors.onSurface.withValues(alpha: 0.65),
            ),
          ),
        ],
      );
    }

    return Text(
      widget.initialEntry == null
          ? AppStrings.newEntryTitle
          : AppStrings.editEntryTitle,
      style: style.headerFont,
    );
  }

  Widget _buildSaveAction() {
    return ValueListenableBuilder<bool>(
      valueListenable: _controller.isSavingNotifier,
      builder: (context, isSaving, _) {
        if (isSaving) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        return IconButton(
          icon: const Icon(Icons.check),
          tooltip: AppStrings.saveButton,
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            final navigator = Navigator.of(context);
            final errorColor = context.colors.error;

            final success = await _controller.saveEntry();
            if (!mounted) return;

            if (success) {
              messenger.showSnackBar(
                const SnackBar(content: Text(AppStrings.saveSuccess)),
              );
              navigator.pop();
            } else if (_controller.errorMessageNotifier.value != null) {
              messenger.showSnackBar(
                SnackBar(
                  content: Text(_controller.errorMessageNotifier.value!),
                  backgroundColor: errorColor,
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildTitleInput(dynamic style) {
    return TextField(
      controller: _titleController,
      onChanged: _controller.updateTitle,
      style: style.headerFont.copyWith(
        fontSize: 22.0,
        color: context.colors.onSurface,
      ),
      decoration: const InputDecoration(
        hintText: AppStrings.titleHint,
        border: InputBorder.none,
      ),
    );
  }

  Widget _buildFormattingRow() {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextFormattingBar(
        onAddDate: () {
          final stamp = '\n📅 ${DateTime.now().toJournalDate()}\n';
          _contentController.text += stamp;
          _controller.updateContent(_contentController.text);
        },
        onAddBullet: () {
          _contentController.text += '\n• ';
          _controller.updateContent(_contentController.text);
        },
        onAddQuote: () {
          _contentController.text += '\n> "';
          _controller.updateContent(_contentController.text);
        },
      ),
    );
  }

  Widget _buildContentInput(dynamic style) {
    return TextField(
      controller: _contentController,
      onChanged: _controller.updateContent,
      maxLines: null,
      minLines: 8,
      keyboardType: TextInputType.multiline,
      style: TextStyle(
        fontSize: 16.0,
        height: 1.5,
        color: context.colors.onSurface.withValues(alpha: 0.9),
      ),
      decoration: const InputDecoration(
        hintText: AppStrings.contentHint,
        border: InputBorder.none,
      ),
    );
  }

  Widget _buildTagsSection(dynamic style) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _tagController,
                decoration: const InputDecoration(
                  hintText: AppStrings.tagHint,
                  border: InputBorder.none,
                ),
                onSubmitted: (tag) {
                  _controller.addTag(tag);
                  _tagController.clear();
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _controller.addTag(_tagController.text);
                _tagController.clear();
              },
            ),
          ],
        ),
        ValueListenableBuilder<List<String>>(
          valueListenable: _controller.tagsNotifier,
          builder: (context, tags, _) {
            if (tags.isEmpty) return const SizedBox.shrink();
            return Wrap(
              spacing: 6,
              children: tags.map((tag) {
                return Chip(
                  label: Text('#$tag'),
                  onDeleted: () => _controller.removeTag(tag),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(style.borderRadius / 2),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
