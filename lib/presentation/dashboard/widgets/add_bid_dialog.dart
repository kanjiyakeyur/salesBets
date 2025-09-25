import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/app_export.dart';
import '../../../data/models/event/event.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../blocs/dashboard_bloc.dart';

class AddBidDialog extends StatelessWidget {
  final Event event;

  AddBidDialog({Key? key, required this.event}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController bidTypeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: appTheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.h),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.h),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Place Bid",
                    style: CustomTextStyles.primaryS24W600,
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close),
                    iconSize: 24.h,
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                "Event: ${event.title}",
                style: CustomTextStyles.blackS16W400,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 24.h),
              CustomTextFormField(
                controller: amountController,
                hintText: "Bid Amount (\$)",

                // keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter bid amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              CustomTextFormField(
                controller: bidTypeController,
                hintText: "Bid Type (e.g., Win, Lose, Over/Under)",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter bid type';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              CustomTextFormField(
                controller: descriptionController,
                hintText: "Description (optional)",
                maxLines: 3,
              ),
              SizedBox(height: 32.h),
              Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      text: "Cancel",
                      csButtonType: CSButtonType.border,
                      height: 48.h,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  SizedBox(width: 16.h),
                  Expanded(
                    child: BlocConsumer<DashBoardBloc, DashBoardState>(
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
                          text: "Place Bid",
                          height: 48.h,
                          // buttonState: state.isLoading
                          //     ? ButtonState.loading
                          //     : ButtonState.normal,
                          onPressed: () => _placeBid(context),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _placeBid(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // For now, we'll use placeholder user info
      // In a real app, you'd get this from auth service or user context
      final bet = Bet(
        userId: "current_user_id", // Replace with actual user ID
        userName: "Current User", // Replace with actual user name
        userEmail: "user@example.com", // Replace with actual user email
        amount: double.parse(amountController.text),
        bidType: bidTypeController.text,
        description: descriptionController.text.isNotEmpty
            ? descriptionController.text
            : null,
      );

      context.read<DashBoardBloc>().add(
        AddBetToEventEvent(
          eventId: event.id!,
          bet: bet,
          callback: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Bid placed successfully!"),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
      );
    }
  }
}