import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common_utility/common_utility.dart';
import '../logger/log_handler.dart';
import '../provider.dart';
import '../styles/res/app_themes.dart';
import '../styles/resources.dart';
import '../widgets/common_widgets/New/background_paws.dart';
import '../widgets/common_widgets/New/continue_button.dart';
import '../widgets/common_widgets/back_button.dart';

class BirthdayScreen extends ConsumerStatefulWidget {
  const BirthdayScreen({super.key});

  @override
  BirthdayScreenState createState() => BirthdayScreenState();
}

class BirthdayScreenState extends ConsumerState<BirthdayScreen> {
  String? selectedMonth;
  String? selectedDay;
  String? selectedYear;
  late final Resources _res;
  late Logger _logger;

  @override
  void initState() {
    super.initState();
    _logger = ref.read(loggerProvider);
    _logger.i('BirthdayScreenState: initState called');
    _res = ref.read(resourceProvider);
  }

  @override
  Widget build(BuildContext context) {
    final birthdayViewModel = ref.watch(birthdayViewModelProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios, color: _res.themes.blackPure),
        //   onPressed: birthdayViewModel.loading ? null : () => Navigator.pop(context),
        // ),
        leading: commonBackButton(context),
        centerTitle: true,
        title: Text(
          "Your Birthday",
          style: TextStyle(
            color: _res.themes.blackPure,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BackgroundPaws(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Section
                Column(
                  children: [
                    const SizedBox(height: 140),
                    Text(
                      "What is your birthdate?",
                      style: TextStyle(
                        fontSize: 16,
                        color: _res.themes.black120,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Date Dropdowns
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _CustomDropdown(
                          hint: "MM",
                          value: selectedMonth,
                          items: List.generate(12, (i) => "${i + 1}"),
                          onChanged: birthdayViewModel.loading
                              ? null
                              : (val) => setState(() => selectedMonth = val),
                          themes: _res.themes,
                        ),
                        const SizedBox(width: 8),
                        _CustomDropdown(
                          hint: "DD",
                          value: selectedDay,
                          items: List.generate(31, (i) => "${i + 1}"),
                          onChanged: birthdayViewModel.loading
                              ? null
                              : (val) => setState(() => selectedDay = val),
                          themes: _res.themes,
                        ),
                        const SizedBox(width: 8),
                        _CustomDropdown(
                          hint: "YYYY",
                          value: selectedYear,
                          items: List.generate(
                              100, (i) => "${DateTime.now().year - 17 - i}"),
                          onChanged: birthdayViewModel.loading
                              ? null
                              : (val) => setState(() => selectedYear = val),
                          themes: _res.themes,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Error Message
                    if (birthdayViewModel.errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: _res.themes.red100.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _res.themes.red100),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: _res.themes.red100, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                birthdayViewModel.errorMessage!,
                                style: TextStyle(
                                  color: _res.themes.red100,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            if (!birthdayViewModel.loading)
                              IconButton(
                                icon: Icon(Icons.close, size: 16, color: _res.themes.red100),
                                onPressed: () => birthdayViewModel.clearError(),
                              ),
                          ],
                        ),
                      ),

                    // Continue Button
                    ContinueButton(
                      label: birthdayViewModel.loading ? "Saving..." : "Continue",
                      onTap: birthdayViewModel.loading
                          ? null
                          : () {
                        if (birthdayViewModel.validateBirthday(
                            selectedMonth, selectedDay, selectedYear)) {
                          birthdayViewModel.saveBirthdayAndNavigate(
                            month: selectedMonth!,
                            day: selectedDay!,
                            year: selectedYear!,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please select a valid birthday',
                                style: TextStyle(color: _res.themes.pureWhite),
                              ),
                              backgroundColor: _res.themes.red100,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      loading: birthdayViewModel.loading,
                      enabled: !birthdayViewModel.loading &&
                          birthdayViewModel.validateBirthday(
                              selectedMonth, selectedDay, selectedYear),
                    ),
                  ],
                ),

                // Bottom Cake Image
                AnimatedOpacity(
                  opacity: birthdayViewModel.loading ? 0.5 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Image.asset(
                    birthdayImage,
                    height: 320,
                    width: 320,
                    fit: BoxFit.contain,
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

// Professional Custom Dropdown Widget
class _CustomDropdown extends StatefulWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final Function(String?)? onChanged;
  final AppThemes themes;

  const _CustomDropdown({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.themes,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<_CustomDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOpen = false;
  }

  void _toggleDropdown() {
    if (widget.onChanged == null) return;

    if (_isOpen) {
      _removeOverlay();
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _removeOverlay,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned(
                left: offset.dx,
                top: offset.dy + size.height + 4,
                width: size.width,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(0, size.height + 4),
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(8),
                    color: widget.themes.pureWhite,
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: 200,
                        minWidth: size.width,
                      ),
                      decoration: BoxDecoration(
                        color: widget.themes.pureWhite,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          final item = widget.items[index];
                          return InkWell(
                            onTap: () {
                              widget.onChanged?.call(item);
                              _removeOverlay();
                            },
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: widget.value == item
                                    ? widget.themes.darkGolden.withOpacity(0.1)
                                    : widget.themes.pureWhite,
                                borderRadius: index == 0
                                    ? const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                )
                                    : index == widget.items.length - 1
                                    ? const BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                )
                                    : null,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    color: widget.themes.black120,
                                    fontSize: 14,
                                    fontWeight: widget.value == item
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isOpen = true;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          width: 85,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: widget.onChanged == null
                ? widget.themes.grey100.withOpacity(0.1)
                : widget.themes.pureWhite,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isOpen
                  ? widget.themes.darkGolden
                  : widget.themes.grey100,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.value ?? widget.hint,
                style: TextStyle(
                  color: widget.value != null
                      ? widget.themes.black120
                      : widget.themes.grey100,
                  fontSize: 14,
                  fontWeight: widget.value != null ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
              Icon(
                _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: widget.themes.grey100,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Alternative: Using MenuAnchor for a simpler approach (iOS-style)
class _SimpleDropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final Function(String?)? onChanged;
  final AppThemes themes;

  const _SimpleDropdown({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.themes,
  });

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (context, controller, child) {
        return GestureDetector(
          onTap: onChanged == null
              ? null
              : () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: Container(
            width: 85,
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: onChanged == null
                  ? themes.grey100.withOpacity(0.1)
                  : themes.pureWhite,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: controller.isOpen ? themes.darkGolden : themes.grey100,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value ?? hint,
                  style: TextStyle(
                    color: value != null ? themes.black120 : themes.grey100,
                    fontSize: 14,
                  ),
                ),
                Icon(
                  controller.isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: themes.grey100,
                  size: 20,
                ),
              ],
            ),
          ),
        );
      },
      menuChildren: items
          .map(
            (item) => MenuItemButton(
          onPressed: () {
            onChanged?.call(item);
          },
          child: Text(
            item,
            style: TextStyle(
              color: themes.black120,
              fontSize: 14,
            ),
          ),
        ),
      )
          .toList(),
    );
  }
}