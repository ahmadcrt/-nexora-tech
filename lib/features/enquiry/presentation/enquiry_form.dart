import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/brand_colors.dart';
import '../../../core/theme/responsive_text.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/notice.dart';
import '../application/enquiry_controller.dart';
import '../domain/enquiry_draft.dart';
import '../domain/enquiry_validators.dart';
import '../domain/service_interest.dart';

/// Enquiry form (FR-013 to FR-021).
class EnquiryForm extends ConsumerStatefulWidget {
  const EnquiryForm({super.key, this.initialService});

  final ServiceInterest? initialService;

  @override
  ConsumerState<EnquiryForm> createState() => _EnquiryFormState();
}

class _EnquiryFormState extends ConsumerState<EnquiryForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _message = TextEditingController();

  ServiceInterest? _service;
  bool _consent = false;
  String? _serviceError;
  String? _consentError;

  @override
  void initState() {
    super.initState();
    _service = widget.initialService;
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _message.dispose();
    super.dispose();
  }

  void _clear() {
    _name.clear();
    _email.clear();
    _phone.clear();
    _message.clear();
    _service = null;
    _consent = false;
    _serviceError = null;
    _consentError = null;
  }

  Future<void> _submit() async {
    final fieldsValid = _formKey.currentState?.validate() ?? false;
    final serviceError = EnquiryValidators.service(_service);
    final consentError = EnquiryValidators.consent(_consent);
    setState(() {
      _serviceError = serviceError;
      _consentError = consentError;
    });
    if (!fieldsValid || serviceError != null || consentError != null) {
      return;
    }
    await ref.read(enquiryControllerProvider.notifier).submit(
          EnquiryDraft(
            name: _name.text,
            email: _email.text,
            phone: _phone.text,
            serviceInterest: _service!,
            message: _message.text,
            consentGiven: _consent,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(enquiryControllerProvider);

    ref.listen<EnquiryState>(enquiryControllerProvider, (previous, next) {
      if (next.phase == SubmissionPhase.success) {
        setState(_clear);
      }
    });

    if (state.phase == SubmissionPhase.success) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Notice(
            icon: Icons.check_circle_outline,
            title: 'Your enquiry has been sent.',
            message: 'Thank you for contacting NEXORA TECH.',
          ),
          const SizedBox(height: 16),
          SecondaryButton(
            label: 'Send another enquiry',
            onPressed: () =>
                ref.read(enquiryControllerProvider.notifier).reset(),
          ),
        ],
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (state.phase == SubmissionPhase.unavailable) ...[
            const Notice(
              icon: Icons.info_outline,
              title: 'Online enquiries are not open yet.',
              message: 'Please check back soon.',
            ),
            const SizedBox(height: 16),
          ],
          if (state.phase == SubmissionPhase.rateLimited) ...[
            const Notice(
              icon: Icons.schedule,
              title: 'Too many enquiries have been sent recently.',
              message: 'Please try again later.',
            ),
            const SizedBox(height: 16),
          ],
          if (state.phase == SubmissionPhase.failure) ...[
            const Notice(
              icon: Icons.error_outline,
              title: 'Your enquiry could not be sent.',
              message: 'Your details are still here. Please try again.',
            ),
            const SizedBox(height: 16),
          ],
          TextFormField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Name'),
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.name],
            inputFormatters: [
              LengthLimitingTextInputFormatter(EnquiryValidators.nameMax),
            ],
            validator: EnquiryValidators.name,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _email,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            inputFormatters: [
              LengthLimitingTextInputFormatter(EnquiryValidators.emailMax),
            ],
            validator: EnquiryValidators.email,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phone,
            decoration: const InputDecoration(labelText: 'Phone (optional)'),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.telephoneNumber],
            inputFormatters: [
              LengthLimitingTextInputFormatter(EnquiryValidators.phoneMax),
            ],
            validator: EnquiryValidators.phone,
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) => DropdownMenu<ServiceInterest>(
              width: constraints.maxWidth,
              label: const Text('Service of interest'),
              initialSelection: _service,
              errorText: _serviceError,
              onSelected: (value) => setState(() {
                _service = value;
                _serviceError = null;
              }),
              dropdownMenuEntries: [
                for (final item in ServiceInterest.values)
                  DropdownMenuEntry<ServiceInterest>(
                    value: item,
                    label: item.label,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _message,
            decoration: const InputDecoration(
              labelText: 'Message',
              alignLabelWithHint: true,
            ),
            keyboardType: TextInputType.multiline,
            minLines: 4,
            maxLines: 8,
            inputFormatters: [
              LengthLimitingTextInputFormatter(EnquiryValidators.messageMax),
            ],
            validator: EnquiryValidators.message,
          ),
          const SizedBox(height: 8),
          CheckboxListTile(
            value: _consent,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (value) => setState(() {
              _consent = value ?? false;
              _consentError = null;
            }),
            // Draft wording; final consent text needs legal review (TBD-009).
            title: Text(
              'I agree to NEXORA TECH using these details to respond to my '
              'enquiry.',
              style: context.bodyStyle,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => context.push('/privacy'),
              child: const Text('Read the privacy notice'),
            ),
          ),
          if (_consentError != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.error_outline,
                      size: 18, color: BrandColors.graphite),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _consentError!,
                      style: context.smallStyle.copyWith(
                        fontWeight: FontWeight.w700,
                        color: BrandColors.graphite,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: PrimaryButton(
              label: 'Send enquiry',
              loading: state.isSubmitting,
              onPressed: _submit,
            ),
          ),
        ],
      ),
    );
  }
}
