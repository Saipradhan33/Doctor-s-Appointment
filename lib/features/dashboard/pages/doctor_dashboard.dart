import 'package:flutter/material.dart';
import 'package:doct_appointment/core/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  final SupabaseClient _supabase = SupabaseService.client;
  List<Map<String, dynamic>> _appointments = [];
  int _totalPatients = 0;
  bool _isLoading = true;
  String _activeView = "Dashboard";

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      // Fetch Appointments
      final appointmentsData = await _supabase
          .from('appointments')
          .select()
          .order('scheduled_at', ascending: true);
      
      // Fetch Total Patient Count from profiles
      final patientsResponse = await _supabase
          .from('profiles')
          .select(
            'id',
            count: CountOption.exact,
          )
          .eq('role', 'patient');
      
      if (mounted) {
        setState(() {
          _appointments = List<Map<String, dynamic>>.from(appointmentsData);
          _totalPatients = patientsResponse.length; // Profiles count
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    await _supabase.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF11131B),
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF6C63FF)))
                : _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    switch (_activeView) {
      case "Dashboard":
        return _buildDashboardView();
      case "Patients":
        return _buildPlaceholderView("Patient Management System");
      case "Appointments":
        return _buildPlaceholderView("Full Appointment Schedule");
      case "Prescriptions":
        return _buildPlaceholderView("Prescription Records");
      case "Settings":
        return _buildPlaceholderView("Account Settings");
      default:
        return _buildDashboardView();
    }
  }

  Widget _buildDashboardView() {
    return CustomScrollView(
      slivers: [
        _buildTopBar(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome back, Dr. Sai",
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                _buildStatsRow(),
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Upcoming Patients",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _activeView = "Appointments"),
                      child: const Text("View all", style: TextStyle(color: Color(0xFF6C63FF))),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildPatientQueue(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderView(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text("Coming soon in Phase 5...", style: TextStyle(color: Colors.white.withOpacity(0.5))),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => setState(() => _activeView = "Dashboard"),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF)),
            child: const Text("Back to Dashboard"),
          )
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 280,
      color: const Color(0xFF0C0E15),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("ClinicOS", style: TextStyle(color: Color(0xFF6C63FF), fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 60),
          _sidebarItem(Icons.grid_view_rounded, "Dashboard"),
          _sidebarItem(Icons.people_alt_rounded, "Patients"),
          _sidebarItem(Icons.calendar_today_rounded, "Appointments"),
          _sidebarItem(Icons.assignment_rounded, "Prescriptions"),
          const Spacer(),
          _sidebarItem(Icons.settings_rounded, "Settings"),
          const SizedBox(height: 20),
          ListTile(
            onTap: _logout,
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text("Log Out", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String label) {
    bool active = _activeView == label;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF6C63FF).withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () => setState(() => _activeView = label),
        leading: Icon(icon, color: active ? const Color(0xFF6C63FF) : Colors.white54),
        title: Text(label, style: TextStyle(color: active ? Colors.white : Colors.white54, fontWeight: active ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }

  Widget _buildTopBar() {
    return SliverAppBar(
      backgroundColor: const Color(0xFF11131B),
      automaticallyImplyLeading: false,
      elevation: 0,
      pinned: true,
      actions: [
        IconButton(icon: const Icon(Icons.refresh_rounded, color: Colors.white54), onPressed: _fetchData),
        IconButton(icon: const Icon(Icons.notifications_none_rounded, color: Colors.white54), onPressed: () {}),
        const SizedBox(width: 8),
        const CircleAvatar(backgroundColor: Color(0xFF6C63FF), radius: 18, child: Icon(Icons.person, color: Colors.white, size: 20)),
        const SizedBox(width: 32),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _GlassStatCard(
            title: "Today's Appointments",
            value: "${_appointments.length}",
            trend: "+2 vs yesterday",
            icon: Icons.calendar_today_rounded,
            color: const Color(0xFF6C63FF),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _GlassStatCard(
            title: "Total Patients",
            value: "$_totalPatients",
            trend: "+12 this month",
            icon: Icons.people_alt_rounded,
            color: const Color(0xFF56D6F3),
          ),
        ),
        const SizedBox(width: 24),
        const Expanded(
          child: _GlassStatCard(
            title: "Pending Reports",
            value: "5",
            trend: "Action required",
            icon: Icons.report_problem_rounded,
            color: Color(0xFFFF6B6B),
          ),
        ),
      ],
    );
  }

  Widget _buildPatientQueue() {
    if (_appointments.isEmpty) {
      return Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xFF1D1F27),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Center(child: Text("No appointments scheduled", style: TextStyle(color: Colors.white.withOpacity(0.3)))),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _appointments.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final appt = _appointments[index];
        return _PatientListTile(appt: appt);
      },
    );
  }
}

class _GlassStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String trend;
  final IconData icon;
  final Color color;

  const _GlassStatCard({
    required this.title,
    required this.value,
    required this.trend,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 28),
              Text(trend, style: TextStyle(color: color.withOpacity(0.8), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 24),
          Text(value, style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14)),
        ],
      ),
    );
  }
}

class _PatientListTile extends StatelessWidget {
  final Map<String, dynamic> appt;
  const _PatientListTile({required this.appt});

  @override
  Widget build(BuildContext context) {
    String scheduledAt = "09:30 AM";
    if (appt['scheduled_at'] != null) {
      final dt = DateTime.parse(appt['scheduled_at']).toLocal();
      scheduledAt = "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour >= 12 ? 'PM' : 'AM'}";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1F27),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          const CircleAvatar(backgroundColor: Color(0xFF33343D), child: Icon(Icons.person, color: Colors.white54)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(appt['patient_name'] ?? "Unknown Patient", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                Text(appt['visit_type'] ?? "Consultation", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
              ],
            ),
          ),
          Text(scheduledAt, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(width: 24),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF6C63FF)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text("View Record", style: TextStyle(color: Color(0xFF6C63FF))),
          ),
        ],
      ),
    );
  }
}
