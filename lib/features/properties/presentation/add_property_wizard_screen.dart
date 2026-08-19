import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:mymanager/app/theme/app_theme.dart';
import 'package:mymanager/core/widgets/header_title.dart';
import 'package:mymanager/core/widgets/senior_button.dart';
import 'package:mymanager/core/widgets/senior_chip_selector.dart';
import 'package:mymanager/features/rent/data/app_store.dart';

class AddPropertyWizardScreen extends ConsumerStatefulWidget {
  const AddPropertyWizardScreen({super.key});

  @override
  ConsumerState<AddPropertyWizardScreen> createState() => _AddPropertyWizardScreenState();
}

class _AddPropertyWizardScreenState extends ConsumerState<AddPropertyWizardScreen> {
  int _step = 1;
  final TextEditingController _nameController = TextEditingController(text: 'Sunshine Apartments');
  final TextEditingController _addressController = TextEditingController(text: '45 MG Road, Bengaluru');
  int _selectedFloors = 2;
  int _selectedUnitsPerFloor = 2;
  double _selectedDefaultRent = 15000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.accentLime, size: 20),
          onPressed: () {
            if (_step > 1) {
              setState(() => _step--);
            } else {
              context.pop();
            }
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderTitle(
                title: 'Add New Property',
                subtitle: 'Step $_step of 3',
              ),
              const SizedBox(height: 20),

              if (_step == 1) ...[
                Text(
                  'Property Name',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700),
                  decoration: const InputDecoration(hintText: 'e.g. Green Residency'),
                ),
                const SizedBox(height: 16),
                Text(
                  'Full Address',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _addressController,
                  maxLines: 2,
                  style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(hintText: 'Enter complete property address'),
                ),
              ] else if (_step == 2) ...[
                SeniorChipSelector<int>(
                  label: 'Number of Floors',
                  options: const [
                    SeniorChipOption(label: '1 Floor', value: 1),
                    SeniorChipOption(label: '2 Floors', value: 2),
                    SeniorChipOption(label: '3 Floors', value: 3),
                    SeniorChipOption(label: '4 Floors', value: 4),
                  ],
                  selectedValue: _selectedFloors,
                  onSelected: (val) => setState(() => _selectedFloors = val),
                ),
                const SizedBox(height: 20),
                SeniorChipSelector<int>(
                  label: 'Units Per Floor',
                  options: const [
                    SeniorChipOption(label: '1 Unit', value: 1),
                    SeniorChipOption(label: '2 Units', value: 2),
                    SeniorChipOption(label: '3 Units', value: 3),
                    SeniorChipOption(label: '4 Units', value: 4),
                  ],
                  selectedValue: _selectedUnitsPerFloor,
                  onSelected: (val) => setState(() => _selectedUnitsPerFloor = val),
                ),
              ] else ...[
                SeniorChipSelector<double>(
                  label: 'Default Monthly Rent (₹)',
                  options: const [
                    SeniorChipOption(label: '₹10,000', value: 10000),
                    SeniorChipOption(label: '₹15,000', value: 15000),
                    SeniorChipOption(label: '₹20,000', value: 20000),
                    SeniorChipOption(label: '₹25,000', value: 25000),
                    SeniorChipOption(label: '₹30,000', value: 30000),
                  ],
                  selectedValue: _selectedDefaultRent,
                  onSelected: (val) => setState(() => _selectedDefaultRent = val),
                ),
              ],

              const Spacer(),
              SeniorButton(
                label: _step < 3 ? 'Next Step' : 'Save Property',
                icon: _step < 3 ? Icons.arrow_forward_rounded : Icons.check_circle_outline,
                onPressed: () {
                  if (_step < 3) {
                    setState(() => _step++);
                  } else {
                    ref.read(propertiesProvider.notifier).addProperty(
                          PropertyModel(
                            id: 'prop-${DateTime.now().millisecondsSinceEpoch}',
                            name: _nameController.text,
                            address: _addressController.text,
                            floorsCount: _selectedFloors,
                            unitsCount: _selectedFloors * _selectedUnitsPerFloor,
                            defaultRent: _selectedDefaultRent,
                          ),
                        );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Property added successfully!'),
                        backgroundColor: AppTheme.accentEmerald,
                      ),
                    );
                    context.pop();
                  }
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
