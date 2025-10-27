import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_demo/view/lock-pdf/lock_pdf_controller.dart';

class LockPdf extends StatefulWidget {
  const LockPdf({super.key});

  @override
  State<LockPdf> createState() => _LockPdfState();
}

class _LockPdfState extends State<LockPdf> with SingleTickerProviderStateMixin {
  final controller = Get.put(LockPdfController());
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Premium Header
          _buildPremiumHeader(),

          // Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Select Button
                  _buildSelectButton(),

                  const SizedBox(height: 20),

                  // Content Section
                  Obx(
                        () => controller.hasSelectedFile
                        ? _buildContentSection()
                        : _buildEmptyState(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Premium Header with Gradient
  Widget _buildPremiumHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.teal.shade300, Colors.teal.shade600],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // App Bar
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const Spacer(),
                ],
              ),

              // Title Section
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 20),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.lock_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Lock PDF',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Secure with password',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Select Button
  Widget _buildSelectButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(
            () => Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          elevation: 4,
          shadowColor: Colors.black.withValues(alpha: 0.1),
          child: InkWell(
            onTap: controller.isProcessing.value ? null : controller.pickPdfFile,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.teal.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.teal.shade300, Colors.teal.shade600],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      controller.hasSelectedFile
                          ? Icons.sync_rounded
                          : Icons.upload_file_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    controller.hasSelectedFile ? 'Change PDF File' : 'Select PDF File',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Content Section
  Widget _buildContentSection() {
    return FadeTransition(
      opacity: _animationController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // File Info Card
            _buildFileInfoCard(),

            const SizedBox(height: 20),

            // Password Card
            _buildPasswordCard(),

            const SizedBox(height: 20),

            // Lock Button
            _buildLockButton(),

            // Processing Indicator
            Obx(
                  () => controller.isProcessing.value
                  ? _buildProcessingIndicator()
                  : const SizedBox.shrink(),
            ),

            // Result Card
            Obx(
                  () => controller.hasLockedFile
                  ? _buildResultCard()
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // File Info Card
  Widget _buildFileInfoCard() {
    return Obx(
          () => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.teal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.picture_as_pdf_rounded,
                    color: Colors.teal.shade700,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Selected File',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.description_rounded,
              'File Name',
              controller.selectedFileName,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.storage_rounded,
              'File Size',
              controller.formattedFileSize,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Password Card
// Password Card - FIXED VERSION
  Widget _buildPasswordCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.vpn_key_rounded,
                  color: Colors.teal.shade700,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Password Protection',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Password Input - FIXED
          Obx(
                () => TextField(
              controller: controller.passwordController,
              enabled: !controller.isProcessing.value,
              obscureText: !controller.showPassword.value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                labelText: 'Enter Password',
                hintText: 'Minimum 4 characters',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                labelStyle: TextStyle(
                  color: Colors.teal.shade700,
                  fontWeight: FontWeight.w600,
                ),
                prefixIcon: Icon(
                  Icons.lock_outline_rounded,
                  color: Colors.teal.shade700,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.showPassword.value
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: Colors.grey[600],
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.teal.shade600, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Confirm Password Input - FIXED
          Obx(
                () => TextField(
              controller: controller.confirmPasswordController,
              enabled: !controller.isProcessing.value,
              obscureText: !controller.showPassword.value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                hintText: 'Re-enter password',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                labelStyle: TextStyle(
                  color: Colors.teal.shade700,
                  fontWeight: FontWeight.w600,
                ),
                prefixIcon: Icon(
                  Icons.lock_rounded,
                  color: Colors.teal.shade700,
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.teal.shade600, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Lock Button
  Widget _buildLockButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Obx(
            () => Material(
          color: controller.isProcessing.value
              ? Colors.grey.shade300
              : Colors.teal.shade600,
          borderRadius: BorderRadius.circular(16),
          elevation: controller.isProcessing.value ? 0 : 4,
          shadowColor: Colors.teal.withValues(alpha: 0.3),
          child: InkWell(
            onTap: controller.isProcessing.value ? null : controller.lockPdf,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (controller.isProcessing.value)
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  else
                    const Icon(
                      Icons.lock_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  const SizedBox(width: 12),
                  Text(
                    controller.isProcessing.value ? 'Locking...' : 'Lock PDF',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: controller.isProcessing.value
                          ? Colors.grey.shade600
                          : Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Processing Indicator
  Widget _buildProcessingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Obx(
              () => Column(
            children: [
              Text(
                controller.processingStatus.value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Securing your PDF...',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Result Card
  Widget _buildResultCard() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Obx(
            () => Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.teal.shade50, Colors.teal.shade50],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.teal.shade200, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // Success Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withValues(alpha: 0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: Colors.teal.shade600,
                  size: 48,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'PDF Locked Successfully!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 20),

              // Security Badge
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.security_rounded,
                      color: Colors.teal.shade700,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Password Protected',
                      style: TextStyle(
                        color: Colors.teal.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // File Info
              _buildResultInfoCard(
                Icons.description_rounded,
                'Locked File',
                controller.lockedFileName,
              ),

              const SizedBox(height: 10),

              // Location
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.folder_rounded,
                          size: 18,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Saved Location:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      controller.lockedFilePath,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildResultInfoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Empty State
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.upload_file_rounded,
              size: 80,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No File Selected',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select a PDF file to secure it',
            style: TextStyle(fontSize: 15, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}