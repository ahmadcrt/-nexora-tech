import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/app_config.dart';
import '../data/supabase_admin_repository.dart';
import '../data/unavailable_admin_repository.dart';
import '../domain/admin_repository.dart';
import '../domain/enquiry.dart';
import '../domain/enquiry_status.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  if (!AppConfig.hasSupabase) {
    return const UnavailableAdminRepository();
  }
  return SupabaseAdminRepository(Supabase.instance.client);
});

/// Filter applied to the enquiry list.
class EnquiryFilter {
  const EnquiryFilter({this.status, this.search = ''});

  final EnquiryStatus? status;
  final String search;

  EnquiryFilter copyWith({
    EnquiryStatus? status,
    bool clearStatus = false,
    String? search,
  }) {
    return EnquiryFilter(
      status: clearStatus ? null : (status ?? this.status),
      search: search ?? this.search,
    );
  }
}

final enquiryFilterProvider =
    StateProvider<EnquiryFilter>((ref) => const EnquiryFilter());

final enquiryListProvider =
    FutureProvider.autoDispose<List<Enquiry>>((ref) {
  final filter = ref.watch(enquiryFilterProvider);
  return ref
      .watch(adminRepositoryProvider)
      .listEnquiries(status: filter.status, search: filter.search);
});

final enquiryDetailProvider =
    FutureProvider.autoDispose.family<Enquiry, String>((ref, id) {
  return ref.watch(adminRepositoryProvider).getEnquiry(id);
});
