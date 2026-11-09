import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/brand_colors.dart';
import '../../../core/theme/responsive_text.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/notice.dart';
import '../../../core/widgets/section.dart';
import '../../../core/widgets/site_scaffold.dart';
import '../../website/presentation/widgets/page_header.dart';
import '../application/admin_providers.dart';
import '../domain/enquiry.dart';
import '../domain/enquiry_status.dart';
import 'admin_gate.dart';
import 'format.dart';

class EnquiryDetailPage extends StatelessWidget {
  const EnquiryDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return SiteScaffold(
      title: 'Enquiry | NEXORA TECH',
      currentPath: '/admin',
      child: Column(
        children: [
          const PageHeader(title: 'Enquiry'),
          Section(
            child: AdminGate(builder: (context) => _EnquiryDetail(id: id)),
          ),
        ],
      ),
    );
  }
}

class _EnquiryDetail extends ConsumerWidget {
  const _EnquiryDetail({required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enquiry = ref.watch(enquiryDetailProvider(id));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () => context.go('/admin'),
          child: const Text('\u2190 All enquiries'),
        ),
        const SizedBox(height: 16),
        enquiry.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stackTrace) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Notice(
                icon: Icons.error_outline,
                title: 'This enquiry could not be loaded.',
                message: 'It may not exist, or your session may have ended.',
              ),
              const SizedBox(height: 16),
              SecondaryButton(
                label: 'Try again',
                onPressed: () => ref.invalidate(enquiryDetailProvider(id)),
              ),
            ],
          ),
          data: (item) => _EnquiryEditor(enquiry: item),
        ),
      ],
    );
  }
}

enum _SavePhase { idle, saving, saved, failed }

class _EnquiryEditor extends ConsumerStatefulWidget {
  const _EnquiryEditor({required this.enquiry});

  final Enquiry enquiry;

  @override
  ConsumerState<_EnquiryEditor> createState() => _EnquiryEditorState();
}

class _EnquiryEditorState extends ConsumerState<_EnquiryEditor> {
  late EnquiryStatus _status = widget.enquiry.status;
  late final TextEditingController _notes =
      TextEditingController(text: widget.enquiry.internalNotes ?? '');
  _SavePhase _phase = _SavePhase.idle;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _phase = _SavePhase.saving);
    try {
      await ref.read(adminRepositoryProvider).updateEnquiry(
            widget.enquiry.id,
            status: _status,
            internalNotes: _notes.text,
          );
      ref
        ..invalidate(enquiryListProvider)
        ..invalidate(enquiryDetailProvider(widget.enquiry.id));
      if (mounted) {
        setState(() => _phase = _SavePhase.saved);
      }
    } on Exception {
      if (mounted) {
        setState(() => _phase = _SavePhase.failed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final enquiry = widget.enquiry;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 720),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Field(label: 'Name', value: enquiry.name),
          _Field(label: 'Email', value: enquiry.email),
          _Field(label: 'Phone', value: enquiry.phone ?? 'Not given'),
          _Field(
            label: 'Service of interest',
            value: enquiry.serviceInterest?.label ?? 'Not set',
          ),
          _Field(label: 'Received', value: formatDateTime(enquiry.createdAt)),
          _Field(label: 'Message', value: enquiry.message),
          const SizedBox(height: 8),
          Text(
            'Status',
            style: context.bodyStyle.copyWith(
              fontWeight: FontWeight.w700,
              color: BrandColors.midnightNavy,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final status in EnquiryStatus.values)
                ChoiceChip(
                  label: Text(status.label),
                  selected: _status == status,
                  showCheckmark: false,
                  backgroundColor: BrandColors.white,
                  selectedColor: BrandColors.midnightNavy,
                  side: const BorderSide(color: BrandColors.silver),
                  labelStyle: TextStyle(
                    color: _status == status
                        ? BrandColors.white
                        : BrandColors.midnightNavy,
                    fontWeight: FontWeight.w500,
                  ),
                  onSelected: (_) => setState(() {
                    _status = status;
                    _phase = _SavePhase.idle;
                  }),
                ),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _notes,
            decoration: const InputDecoration(
              labelText: 'Internal notes (not visible to the visitor)',
              alignLabelWithHint: true,
            ),
            minLines: 3,
            maxLines: 8,
            maxLength: 5000,
            onChanged: (_) {
              if (_phase != _SavePhase.idle) {
                setState(() => _phase = _SavePhase.idle);
              }
            },
          ),
          const SizedBox(height: 16),
          if (_phase == _SavePhase.saved) ...[
            const Notice(
              icon: Icons.check_circle_outline,
              title: 'Changes saved.',
            ),
            const SizedBox(height: 16),
          ],
          if (_phase == _SavePhase.failed) ...[
            const Notice(
              icon: Icons.error_outline,
              title: 'Your changes could not be saved.',
              message: 'Check your connection and that you are still signed in.',
            ),
            const SizedBox(height: 16),
          ],
          PrimaryButton(
            label: 'Save changes',
            loading: _phase == _SavePhase.saving,
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.smallStyle.copyWith(fontWeight: FontWeight.w700),
          ),
          SelectableText(value, style: context.bodyStyle),
        ],
      ),
    );
  }
}
