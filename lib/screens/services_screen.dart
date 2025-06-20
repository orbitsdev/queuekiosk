import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:kiosk/controllers/kiosk_controller.dart';
import 'package:kiosk/widgets/modal.dart';
import 'package:kiosk/widgets/service_card.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final _kioskController = KioskController.instance;

  @override
  void initState() {
    super.initState();
    _kioskController.loadServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(_kioskController.branch.value?.name ?? 'Services')),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
                    const SizedBox(width: 12),
                    Text(
                      'Log Out',
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                Modal.confirm(
                  title: 'Log Out',
                  message: 'Are you sure you want to log out from this branch?',
                  onConfirm: () async {
                    _kioskController.clearBranchData();
                    Get.offAllNamed('/branch-code');
                  },
                );
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (_kioskController.isServicesLoading.value) {
          return _buildLoadingShimmer();
        }
        
        if (_kioskController.hasServicesError.value) {
          final theme = Theme.of(context);
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_outline,
                      size: 72,
                      color: theme.colorScheme.error,
                    ),
                  ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
                  const SizedBox(height: 32),
                  Text(
                    'Failed to load services',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.error,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                  const SizedBox(height: 16),
                  Text(
                    'Please check your internet connection and try again',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _kioskController.loadServices,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
                ],
              ),
            ),
          );
        }
        
        if (_kioskController.services.isEmpty) {
          final theme = Theme.of(context);
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/animations/empty_state.json',
                    width: 240,
                    height: 240,
                    fit: BoxFit.contain,
                    repeat: true,
                    animate: true,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'No services available',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                  const SizedBox(height: 16),
                  Text(
                    'There are currently no services available for this branch. Please check back later or contact support.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
                  const SizedBox(height: 32),
                  OutlinedButton.icon(
                    onPressed: _kioskController.loadServices,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                      side: BorderSide(color: theme.colorScheme.primary, width: 2),
                    ),
                    icon: const Icon(Icons.refresh, size: 24),
                    label: const Text('Refresh'),
                  ).animate().fadeIn(delay: 600.ms, duration: 400.ms).shimmer(delay: 1000.ms, duration: 1800.ms),
                ],
              ),
            ),
          );
        }
        
        return RefreshIndicator(
          onRefresh: () async {
            await _kioskController.loadServices();
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: GridView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9, // Slightly taller cards for better touch targets
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: _kioskController.services.length,
              itemBuilder: (context, index) {
                final service = _kioskController.services[index];
                // Stagger the animations for a cascade effect
                return ServiceCard(
                  service: service,
                  icon: _kioskController.getIconForService(service.code),
                  onTap: () => _kioskController.selectService(service),
                )
                  .animate(delay: (50 * index).ms)
                  .fadeIn(duration: 300.ms)
                  .scale(begin: const Offset(0.9, 0.9), duration: 300.ms, curve: Curves.easeOutQuad)
                  .slideY(begin: 0.2, duration: 400.ms, curve: Curves.easeOutQuad);
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _buildLoadingShimmer() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 6, // Show 6 shimmer placeholders
          itemBuilder: (context, index) {
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Circle for icon
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Title placeholder
                  Container(
                    width: 120,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  // Waiting count placeholder
                  Container(
                    width: 80,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }


}