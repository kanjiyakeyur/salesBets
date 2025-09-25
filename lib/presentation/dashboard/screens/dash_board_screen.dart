// Flutter imports:
import 'package:baseproject/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../core/app_export.dart';
import '../../../core/utils/date_time_utils.dart';
import '../../../data/models/event/event.dart';
import '../../../data/services/event_service.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../blocs/dashboard_bloc.dart';
import '../widgets/add_bid_dialog.dart';
import 'add_event_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key})
      : super(
    key: key,
  );

  static Widget builder(BuildContext context) {
    return BlocProvider<DashBoardBloc>(
      create: (context) => DashBoardBloc(
          DashBoardState()
      )..add(InitEvent()),
      child: DashboardScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.background,
      appBar: CustomAppBar(
        showUserProfile: true,
        isBack: false,
        title: "Sales Bets",
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Events",
                    style: CustomTextStyles.primaryS24W600,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      NavigatorService.pushNamed(
                        AppRoutes.addEventScreen,
                      );
                    },
                    child: Icon(Icons.add),
                    backgroundColor: appTheme.primary,
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: BlocListener<DashBoardBloc, DashBoardState>(
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
                  child: StreamBuilder<List<Event>>(
                    stream: EventService.getEventsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 80.h,
                                color: Colors.red,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                "Error loading events",
                                style: CustomTextStyles.blackS18W600,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                snapshot.error.toString(),
                                style: CustomTextStyles.blackS16W400,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }

                      final events = snapshot.data ?? [];

                      if (events.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_note,
                                size: 80.h,
                                color: appTheme.gray,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                "No events yet",
                                style: CustomTextStyles.blackS18W600,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "Create your first event to get started",
                                style: CustomTextStyles.blackS16W400,
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          return _buildEventCard(events[index], context);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(Event event, BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.h),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    event.title ?? "",
                    style: CustomTextStyles.blackS18W600,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: event.status == BetStatus.running
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                  child: Text(
                    event.status == BetStatus.running ? "Running" : "Closed",
                    style: TextStyle(
                      color: event.status == BetStatus.running
                          ? Colors.green
                          : Colors.red,
                      fontSize: 12.fSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              event.description ?? "",
              style: CustomTextStyles.blackS16W400,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(Icons.access_time, size: 16.h, color: appTheme.gray),
                SizedBox(width: 4.h),
                Text(
                  event.dateTime != null
                      ? DateTimeUtils.formatDateTime(event.dateTime!)
                      : "No date set",
                  style: CustomTextStyles.blackS14W600,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _buildBidInfo(event),
            SizedBox(height: 12.h),
            Row(
              children: [
                if (event.status == BetStatus.running)
                  Expanded(
                    child: CustomElevatedButton(
                      text: "Place Bid",
                      height: 36.h,
                      onPressed: () => _showAddBidDialog(context, event),
                    ),
                  ),
                if (event.status == BetStatus.running)
                  SizedBox(width: 8.h),
                if (event.status == BetStatus.running)
                  Expanded(
                    child: CustomElevatedButton(
                      text: "Close Event",
                      height: 36.h,
                      csButtonType: CSButtonType.border,
                      onPressed: () {
                        context.read<DashBoardBloc>().add(
                          UpdateEventStatusEvent(
                            eventId: event.id!,
                            status: BetStatus.closed,
                          ),
                        );
                      },
                    ),
                  ),
                if (event.status == BetStatus.closed)
                  Expanded(
                    child: CustomElevatedButton(
                      text: "Reopen Event",
                      height: 36.h,
                      onPressed: () {
                        context.read<DashBoardBloc>().add(
                          UpdateEventStatusEvent(
                            eventId: event.id!,
                            status: BetStatus.running,
                          ),
                        );
                      },
                    ),
                  ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBidInfo(Event event) {
    final bids = event.betLists ?? [];
    final totalBids = bids.length;
    final totalAmount = bids.fold<double>(
      0.0,
      (sum, bid) => sum + (bid.amount ?? 0.0),
    );

    if (totalBids == 0) {
      return Container(
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: appTheme.primaryLight.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8.h),
        ),
        child: Row(
          children: [
            Icon(Icons.monetization_on, size: 16.h, color: appTheme.primary),
            SizedBox(width: 8.h),
            Text(
              "No bids yet",
              style: CustomTextStyles.blackS14W600,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(12.h),
          decoration: BoxDecoration(
            color: appTheme.primaryLight.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8.h),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.monetization_on, size: 16.h, color: appTheme.primary),
                  SizedBox(width: 8.h),
                  Text(
                    "$totalBids bids",
                    style: CustomTextStyles.blackS14W600,
                  ),
                ],
              ),
              Text(
                "\$${totalAmount.toStringAsFixed(2)}",
                style: CustomTextStyles.primaryS16W500,
              ),
            ],
          ),
        ),
        if (bids.isNotEmpty) ...[
          SizedBox(height: 8.h),
          ...bids.take(3).map((bid) => _buildBidItem(bid)).toList(),
          if (bids.length > 3) ...[
            SizedBox(height: 4.h),
            Text(
              "+${bids.length - 3} more bids",
              style: CustomTextStyles.blackS14W600,
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildBidItem(Bet bid) {
    return Container(
      margin: EdgeInsets.only(top: 4.h),
      padding: EdgeInsets.all(8.h),
      decoration: BoxDecoration(
        color: appTheme.white,
        borderRadius: BorderRadius.circular(6.h),
        border: Border.all(color: appTheme.primaryGray, width: 1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12.h,
            backgroundColor: appTheme.primary,
            child: Text(
              (bid.userName ?? "U").substring(0, 1).toUpperCase(),
              style: TextStyle(
                color: appTheme.white,
                fontSize: 10.fSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 8.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      bid.userName ?? "Unknown User",
                      style: CustomTextStyles.blackS14W600,
                    ),
                    SizedBox(width: 8.h),
                    Text(
                      bid.bidType ?? "",
                      style: CustomTextStyles.primaryS16W500.copyWith(fontSize: 12.fSize),
                    ),
                  ],
                ),
                if (bid.description != null && bid.description!.isNotEmpty)
                  Text(
                    bid.description!,
                    style: CustomTextStyles.blackS14W600.copyWith(fontSize: 10.fSize),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Text(
            "\$${bid.amount?.toStringAsFixed(2) ?? '0.00'}",
            style: CustomTextStyles.primaryS16W500,
          ),
        ],
      ),
    );
  }

  void _showAddBidDialog(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: context.read<DashBoardBloc>(),
          child: AddBidDialog(event: event),
        );
      },
    );
  }

 }
