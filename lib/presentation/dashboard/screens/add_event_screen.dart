import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/app_export.dart';
import '../../../core/utils/date_time_utils.dart';
import '../../../data/models/event/event.dart';
import '../../../widgets/base_button.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../blocs/dashboard_bloc.dart';

class AddEventScreen extends StatelessWidget {
  AddEventScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return BlocProvider<DashBoardBloc>(
      create: (context) => DashBoardBloc(DashBoardState()),
      child: AddEventScreen(),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.background,
      appBar: CustomAppBar(
        isBack: true,
        title: "Add New Event",
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(16.h),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 16.h,
                      children: [
                        CustomTextFormField(
                          controller: titleController,
                          hintText: "Event Title",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter event title';
                            }
                            return null;
                          },
                        ),
                        CustomTextFormField(
                          controller: descriptionController,
                          hintText: "Event Description",
                          maxLines: 4,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter event description';
                            }
                            return null;
                          },
                        ),
                        CustomTextFormField(
                          controller: dateTimeController,
                          hintText: "Event Date & Time",
                          readOnly: true,
                          onTap: () => _selectDateTime(context),
                          suffix: Icon(Icons.calendar_today),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select event date and time';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                BlocConsumer<DashBoardBloc, DashBoardState>(
                  listener: (context, state) {
                    if (state.errorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.errorMessage!),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return CustomElevatedButton(
                      text: "Create Event",
                      buttonState: state.isLoading
                          ? ButtonState.loading
                          : ButtonState.normal,
                      onPressed: () => _createEvent(context),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        dateTimeController.text =
            DateTimeUtils.formatDateTime(selectedDateTime);
      }
    }
  }

  void _createEvent(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final event = Event(
        title: titleController.text,
        description: descriptionController.text,
        dateTime: DateTimeUtils.parseDateTime(dateTimeController.text),
        status: BetStatus.running,
        betLists: [],
      );

      context.read<DashBoardBloc>().add(
        CreateEventEvent(
          event: event,
          callback: () {
            NavigatorService.goBack();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Event created successfully!"),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
      );
    }
  }
}