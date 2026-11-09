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
import '../application/admin_auth_controller.dart';
import '../application/admin_providers.dart';
import '../domain/enquiry.dart';
import '../domain/enquiry_status.dart';
import 'admin_gate.dart';
import 'format.dart';

/// Administration home: sign-in, then the enquiry dashboard.
class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteScaffold(
      title: 'Administration | NEXORA TECH',
      currentPath: '/admin',
      child: Column(
        children: [
          const PageHeader(title: 'Administration'),
          Section(
            child: AdminGate(builder: (context) => const _EnquiryDashboard()),
          ),
        ],
      ),
    );
  }
}

class _EnquiryDashboard extends ConsumerStatefulWidget {
  const _EnquiryDashboard();

  @override
  ConsumerState<_EnquiryDashboard> createState() => _EnquiryDashboardState();
}

class _EnquiryDashboardState extends ConsumerState<_EnquiryDashboard> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _applySearch() {
    ref
        .read(enquiryFilterProvider.notifier)
        .update((filter) => filter.copyWith(search: _search.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(enquiryFilterProvider);
    final enquiries = ref.watch(enquiryListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  'Enquiries',
                  style:
                      context.h2Style.copyWith(color: BrandColors.midnightNavy),
                ),
              ),
            ),
            SecondaryButton(
              label: 'Sign out',
              onPressed: () => ref.read(adminAuthProvider.notifier).signOut(),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _FilterChip(
              label: 'All',
              selected: filter.status == null,
              onSelected: () => ref
                  .read(enquiryFilterProvider.notifier)
                  .update((f) => f.copyWith(clearStatus: true)),
            ),
            for (final status in EnquiryStatus.values)
              _FilterChip(
                label: status.label,
                selected: filter.status == status,
                onSelected: () => ref
                    .read(enquiryFilterProvider.notifier)
                    .update((f) => f.copyWith(status: status)),
              ),
          ],
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: TextField(
            controller: _search,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              labelText: 'Search by name or email',
              suffixIcon: IconButton(
                tooltip: 'Search',
                icon: const Icon(Icons.search),
                onPressed: _applySearch,
              ),
            ),
            onSubmitted: (_) => _applySearch(),
          ),
        ),
        const SizedBox(height: 24),
        enquiries.when(
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
                title: 'Enquiries could not be loaded.',
                message:
                    'Check your connection and that you are still signed in, then try again.',
              ),
              const SizedBox(height: 16),
              SecondaryButton(
                label: 'Try again',
                onPressed: () => ref.invalidate(enquiryListProvider),
              ),
            ],
          ),
          data: (items) => items.isEmpty
              ? const Notice(
                  icon: Icons.inbox_outlined,
                  title: 'No enquiries found.',
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final item in items) _EnquiryTile(enquiry: item),
                    const SizedBox(height: 8),
                    Text(
                      'Showing the latest ${items.length} matching enquiries.',
                      style: context.smallStyle,
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      showCheckmark: false,
      backgroundColor: BrandColors.white,
      selectedColor: BrandColors.midnightNavy,
      side: const BorderSide(color: BrandColors.silver),
      labelStyle: TextStyle(
        color: selected ? BrandColors.white : BrandColors.midnightNavy,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _EnquiryTile extends StatelessWidget {
  const _EnquiryTile({required this.enquiry});

  final Enquiry enquiry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: BrandColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: BrandColors.silver),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => context.go('/admin/enquiries/${enquiry.id}'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        enquiry.name,
                        style: context.bodyStyle.copyWith(
                          fontWeight: FontWeight.w700,
                          color: BrandColors.midnightNavy,
                        ),
                      ),
                      Text(enquiry.email, style: context.smallStyle),
                      const SizedBox(height: 4),
                      Text(
                        '${enquiry.serviceInterest?.label ?? 'Service not set'}'
                        ' \u00B7 ${formatDateTime(enquiry.createdAt)}',
                        style: context.smallStyle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: BrandColors.graphite),
                  ),
                  child: Text(
                    enquiry.status.label,
                    style: context.smallStyle.copyWith(
                      fontWeight: FontWeight.w700,
                      color: BrandColors.graphite,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
