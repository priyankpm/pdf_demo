import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whiskers_flutter_app/src/styles/utils/app_styles.dart';
import 'package:whiskers_flutter_app/src/widgets/common_widgets/back_button.dart';

import '../models/schedule_reminder_model.dart';
import '../provider.dart';
import '../services/SharedPreferencesService.dart';
import '../styles/resources.dart';
import '../styles/utils/common_constants.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  late final Resources _res;

  final TextEditingController _addNameController = TextEditingController();
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();

  int _selectedAmPm = 0;
  String? _petName;
  String? _userId;
  String? _petId;

  @override
  void initState() {
    super.initState();
    _res = ref.read(resourceProvider);
    _loadPetNameAndIds();
  }

  Future<void> _loadPetNameAndIds() async {
    final service = SharedPreferencesService();
    final name = await service.getPetName();
    final userId = await service.getUserId();
    // final petId = await service.getPetId();

    setState(() {
      _petName = name ?? "Cat";
      _userId = userId;
      _petId = '';
    });

    // Initialize the provider with user/pet IDs after loading
    if (_userId != null && _petId != null) {
      ref.read(scheduleProvider.notifier).init();
    }
  }

  @override
  void dispose() {
    _addNameController.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  void _clearInputs() {
    _addNameController.clear();
    _hourController.clear();
    _minuteController.clear();
    _selectedAmPm = 0;
  }

  Future<void> _addNewReminder() async {
    final notifier = ref.read(scheduleProvider.notifier);

    await notifier.addReminder(
      _addNameController.text,
      _hourController.text,
      _minuteController.text,
      _selectedAmPm == 0,
      context,
    );

    if (!mounted) return;

    final state = ref.read(scheduleProvider);
    if (state.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
    } else {
      _clearInputs();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheduleState = ref.watch(scheduleProvider);

    if (scheduleState.loading) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 72,
          backgroundColor: const Color(0xFFFFF3E0),
          elevation: 0,
          leading: commonBackButton(context),
          centerTitle: true,
          title: Text(
            "Schedule",
            style: AppTextStyle().commonTextStyle(
              fontSize: 20,
              appFontStyle: AppFontStyle.bold,
              textColor: _res.themes.blackPure,
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final reminders = scheduleState.currentReminders;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        backgroundColor: const Color(0xFFFFF3E0),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: commonBackButton(context),
        centerTitle: true,
        title: Text(
          "Schedule",
          style: AppTextStyle().commonTextStyle(
            fontSize: 20,
            appFontStyle: AppFontStyle.bold,
            textColor: _res.themes.blackPure,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(scheduleBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SlidableAutoCloseBehavior(
          closeWhenOpened: true,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            children: [
              // Tab Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SizedBox(
                  height: 34,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              ref.read(scheduleProvider.notifier).switchTab(0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              gradient: scheduleState.selectedTab == 0
                                  ? _res.themes.buttonGradient
                                  : null,
                              color: scheduleState.selectedTab == 0
                                  ? null
                                  : _res.themes.greyLight,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                'Your Reminders',
                                style: AppTextStyle().commonTextStyle(
                                  textColor: _res.themes.blackPure,
                                  fontSize: 12,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              ref.read(scheduleProvider.notifier).switchTab(1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              gradient: scheduleState.selectedTab == 1
                                  ? _res.themes.buttonGradient
                                  : null,
                              color: scheduleState.selectedTab == 1
                                  ? null
                                  : _res.themes.greyLight,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                "$_petName Reminders",
                                style: AppTextStyle().commonTextStyle(
                                  textColor: _res.themes.blackPure,
                                  fontSize: 12,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Reminders List
              if (reminders.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      "No reminders yet",
                      style: AppTextStyle().commonTextStyle(
                        textColor: _res.themes.black120,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              else
                ...reminders.asMap().entries.map((entry) {
                  final reminder = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Slidable(
                      key: ValueKey(reminder.id),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: 0.35,
                        children: [
                          const SizedBox(width: 15),
                          Builder(
                            builder: (innerContext) => Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  color: const Color(0x80B15600),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onPressed: () async {
                                    await _showUpdateDialog(reminder).then((_) {
                                      Slidable.of(innerContext)?.close();
                                    });
                                  },
                                  icon: const Icon(Icons.edit, size: 18),
                                  color: Colors.white,
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Builder(
                            builder: (innerContext) => Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  color: const Color(0x80B15600),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onPressed: () async {
                                    await _showDeleteDialog(reminder).then((_) {
                                      Slidable.of(innerContext)?.close();
                                    });
                                  },
                                  icon: const Icon(Icons.delete, size: 18),
                                  color: Colors.white,
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: _res.themes.greyLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                reminder.title,
                                style: AppTextStyle().commonTextStyle(
                                  textColor: _res.themes.blackPure,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: _res.themes.buttonGradient,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Builder(
                                builder: (context) {
                                  final dateTime = DateFormat(
                                    "HH:mm:ss",
                                  ).parse(reminder.time);
                                  return Text(
                                    DateFormat("h:mm a").format(dateTime),
                                    style: AppTextStyle().commonTextStyle(
                                      appFontStyle: AppFontStyle.bold,
                                      fontSize: 16,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

              // Add New Reminder Section
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _res.themes.paleGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: TextField(
                          controller: _addNameController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Add New',
                            counterText: '',
                            hintStyle: AppTextStyle().commonTextStyle(
                              textColor: _res.themes.black120,
                            ),
                            contentPadding: const EdgeInsets.all(5),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _res.themes.grey200,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _res.themes.darkGolden,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: _hourController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        decoration: InputDecoration(
                          hintText: '00',
                          counterText: '',
                          hintStyle: AppTextStyle().commonTextStyle(
                            textColor: _res.themes.black120,
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.all(5),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: _res.themes.grey200),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _res.themes.darkGolden,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Text(" : "),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: _minuteController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        decoration: InputDecoration(
                          hintText: '00',
                          counterText: '',
                          hintStyle: AppTextStyle().commonTextStyle(
                            textColor: _res.themes.black120,
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.all(6),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: _res.themes.grey200),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _res.themes.darkGolden,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ToggleButtons(
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      constraints: BoxConstraints.loose(const Size(50, 50)),
                      borderRadius: BorderRadius.circular(6),
                      isSelected: [_selectedAmPm == 0, _selectedAmPm == 1],
                      onPressed: (index) {
                        setState(() {
                          _selectedAmPm = index;
                        });
                      },
                      selectedColor: Colors.white,
                      fillColor: const Color(0xFFD7A86E),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 9,
                          ),
                          child: Text(
                            "AM",
                            style: AppTextStyle().commonTextStyle(fontSize: 12),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 9,
                          ),
                          child: Text(
                            "PM",
                            style: AppTextStyle().commonTextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _addNewReminder,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _res.themes.greySecondary,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(1.5),
                        child: Icon(Icons.add, color: _res.themes.blackPure),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showUpdateDialog(ReminderModel reminder) async {
    final notifier = ref.read(scheduleProvider.notifier);

    String raw = reminder.time.split('T').last.split('+').first; // handles 12:25:00+05:30
    List<String> parts = raw.split(':');
    int hour24 = int.tryParse(parts[0]) ?? 0;
    int minute = int.tryParse(parts[1]) ?? 0;
    bool isAM = hour24 < 12;
    int hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;


    final titleController = TextEditingController(text: reminder.title);
    final hourController = TextEditingController(text: hour12.toString());
    final minuteController =
    TextEditingController(text: minute.toString().padLeft(2, '0'));
    int selectedAmPm = isAM ? 0 : 1;

    final formKey = GlobalKey<FormState>();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              color: _res.themes.paleGrey,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Update Reminder",
                        style: AppTextStyle().commonTextStyle(
                          fontSize: 18,
                          appFontStyle: AppFontStyle.bold,
                          textColor: _res.themes.blackPure,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.05),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: 'Reminder Name',
                            counterText: '',
                            labelStyle: AppTextStyle().commonTextStyle(
                              textColor: _res.themes.black120,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _res.themes.grey200,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _res.themes.darkGolden,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          // validator: (value) =>
                          //     notifier.validateTitle(value ?? ''),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: hourController,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 2,
                                decoration: InputDecoration(
                                  labelText: 'Hour',
                                  counterText: "",
                                  labelStyle: AppTextStyle().commonTextStyle(
                                    textColor: _res.themes.blackPure,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _res.themes.grey200,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _res.themes.darkGolden,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                // validator: (value) =>
                                //     notifier.validateHour(value ?? ''),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(":", style: TextStyle(fontSize: 20)),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: minuteController,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 2,
                                decoration: InputDecoration(
                                  counterText: "",
                                  labelText: 'Minute',
                                  labelStyle: AppTextStyle().commonTextStyle(
                                    textColor: _res.themes.blackPure,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _res.themes.grey200,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: _res.themes.darkGolden,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                // validator: (value) =>
                                //     notifier.validateMinute(value ?? ''),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ToggleButtons(
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          constraints: const BoxConstraints.expand(
                            width: 80,
                            height: 45,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          isSelected: [selectedAmPm == 0, selectedAmPm == 1],
                          onPressed: (i) {
                            setDialogState(() {
                              selectedAmPm = i;
                            });
                          },
                          selectedColor: Colors.white,
                          fillColor: const Color(0xFFD7A86E),
                          children: [
                            Text(
                              "AM",
                              style: AppTextStyle().commonTextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "PM",
                              style: AppTextStyle().commonTextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFFE5E5E5),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Cancel",
                                style: AppTextStyle().commonTextStyle(
                                  textColor: _res.themes.blackPure,
                                  appFontStyle: AppFontStyle.medium,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              notifier.updateReminder(
                                reminder.id,
                                titleController.text,
                                hourController.text,
                                minuteController.text,
                                selectedAmPm == 0,
                                context,
                              );

                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              gradient: _res.themes.buttonGradient,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFD7A86E,
                                  ).withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "Update",
                                style: AppTextStyle().commonTextStyle(
                                  textColor: _res.themes.blackPure,
                                  appFontStyle: AppFontStyle.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(ReminderModel reminder) async {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _res.themes.paleGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Delete Reminder",
              style: AppTextStyle().commonTextStyle(
                fontSize: 18,
                appFontStyle: AppFontStyle.bold,
                textColor: _res.themes.blackPure,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: Color(0xFF666666),
                ),
              ),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        content: Text(
          "Are you sure you want to delete this reminder?",
          style: AppTextStyle().commonTextStyle(
            textColor: _res.themes.black120,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
        actions: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFE5E5E5),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Cancel",
                        style: AppTextStyle().commonTextStyle(
                          textColor: _res.themes.blackPure,
                          appFontStyle: AppFontStyle.medium,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref
                        .read(scheduleProvider.notifier)
                        .deleteReminder(reminder.id, context);
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      gradient: _res.themes.buttonGradient,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD7A86E).withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Delete",
                        style: AppTextStyle().commonTextStyle(
                          textColor: _res.themes.blackPure,
                          appFontStyle: AppFontStyle.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
