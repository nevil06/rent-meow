import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UserRole { owner, tenant }

class PropertyModel {
  final String id;
  final String name;
  final String address;
  final int floorsCount;
  final int unitsCount;
  final double defaultRent;

  const PropertyModel({
    required this.id,
    required this.name,
    required this.address,
    required this.floorsCount,
    required this.unitsCount,
    required this.defaultRent,
  });
}

class TenancyModel {
  final String id;
  final String propertyName;
  final String unitNumber;
  final String tenantName;
  final String tenantPhone;
  final double rentAmount;
  final double depositAmount;
  final int dueDateDay;
  final String agreementStartDate;
  final String agreementEndDate;

  const TenancyModel({
    required this.id,
    required this.propertyName,
    required this.unitNumber,
    required this.tenantName,
    required this.tenantPhone,
    required this.rentAmount,
    required this.depositAmount,
    required this.dueDateDay,
    required this.agreementStartDate,
    required this.agreementEndDate,
  });
}

class RentRecordModel {
  final String id;
  final String tenancyId;
  final String tenantName;
  final String month;
  final double amountDue;
  final String dueDate;
  final String status; // 'pending', 'paid', 'overdue'
  final String? paidDate;

  const RentRecordModel({
    required this.id,
    required this.tenancyId,
    required this.tenantName,
    required this.month,
    required this.amountDue,
    required this.dueDate,
    required this.status,
    this.paidDate,
  });

  RentRecordModel copyWith({
    String? status,
    String? paidDate,
  }) {
    return RentRecordModel(
      id: id,
      tenancyId: tenancyId,
      tenantName: tenantName,
      month: month,
      amountDue: amountDue,
      dueDate: dueDate,
      status: status ?? this.status,
      paidDate: paidDate ?? this.paidDate,
    );
  }
}

class MaintenanceRequestModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final String date;
  final String status; // 'open', 'in_progress', 'resolved'

  const MaintenanceRequestModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.date,
    required this.status,
  });
}

// -----------------------------------------------------------------------------
// RIVERPOD PROVIDERS
// -----------------------------------------------------------------------------

final activeRoleProvider = StateProvider<UserRole>((ref) => UserRole.owner);

class PropertiesNotifier extends StateNotifier<List<PropertyModel>> {
  PropertiesNotifier()
      : super([
          const PropertyModel(
            id: 'prop-1',
            name: 'Green Residency',
            address: '102 Indiranagar 100ft Rd, Bengaluru',
            floorsCount: 3,
            unitsCount: 6,
            defaultRent: 15000,
          ),
        ]);

  void addProperty(PropertyModel property) {
    state = [...state, property];
  }
}

final propertiesProvider = StateNotifierProvider<PropertiesNotifier, List<PropertyModel>>(
  (ref) => PropertiesNotifier(),
);

class RentRecordsNotifier extends StateNotifier<List<RentRecordModel>> {
  RentRecordsNotifier()
      : super([
          const RentRecordModel(
            id: 'rent-101',
            tenancyId: 'ten-1',
            tenantName: 'Rahul Sharma',
            month: 'August 2026',
            amountDue: 15000,
            dueDate: '2026-08-05',
            status: 'overdue',
          ),
          const RentRecordModel(
            id: 'rent-102',
            tenancyId: 'ten-2',
            tenantName: 'Priya Patel',
            month: 'August 2026',
            amountDue: 18000,
            dueDate: '2026-08-10',
            status: 'paid',
            paidDate: '2026-08-04',
          ),
        ]);

  void markAsPaid(String recordId) {
    state = state.map((rec) {
      if (rec.id == recordId) {
        return rec.copyWith(
          status: 'paid',
          paidDate: DateTime.now().toString().substring(0, 10),
        );
      }
      return rec;
    }).toList();
  }
}

final rentRecordsProvider = StateNotifierProvider<RentRecordsNotifier, List<RentRecordModel>>(
  (ref) => RentRecordsNotifier(),
);

class MaintenanceNotifier extends StateNotifier<List<MaintenanceRequestModel>> {
  MaintenanceNotifier()
      : super([
          const MaintenanceRequestModel(
            id: 'maint-1',
            title: 'Water Leakage in Kitchen Sink',
            category: 'Plumbing',
            description: 'Water leaking under cabinet near pipe joint.',
            date: '2026-08-16',
            status: 'open',
          ),
        ]);

  void addRequest(MaintenanceRequestModel req) {
    state = [req, ...state];
  }
}

final maintenanceProvider = StateNotifierProvider<MaintenanceNotifier, List<MaintenanceRequestModel>>(
  (ref) => MaintenanceNotifier(),
);
