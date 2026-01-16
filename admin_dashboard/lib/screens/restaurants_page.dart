import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RestaurantsPage extends StatefulWidget {
  const RestaurantsPage({super.key});

  @override
  State<RestaurantsPage> createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  List<dynamic> restaurants = [];
  bool isLoading = true;
  String? errorMessage;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchRestaurants();
  }

  // Admin token-ийг авах функц (SharedPreferences-аас эсвэл state management-аас авна)
  Future<String?> getAdminToken() async {
    // TODO: Энд админы token-ийг storage-аас авах
    // Жишээ нь: SharedPreferences prefs = await SharedPreferences.getInstance();
    // return prefs.getString('admin_token');
    return 'YOUR_ADMIN_TOKEN_HERE'; // Үүнийг бодит token-оор солих
  }

  Future<void> fetchRestaurants() async {
    try {
      final token = await getAdminToken();
      
      if (token == null) {
        setState(() {
          errorMessage = 'Нэвтрэх шаардлагатай';
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('https://mubereats.onrender.com/api/admin/restaurants/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          restaurants = json.decode(response.body);
          isLoading = false;
        });
      } else if (response.statusCode == 401) {
        setState(() {
          errorMessage = 'Нэвтрэх эрх дууссан. Дахин нэвтэрнэ үү';
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Алдаа гарлаа: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Холболт амжилтгүй: $e';
        isLoading = false;
      });
    }
  }

  Future<void> approveRestaurant(int restaurantId) async {
    try {
      final token = await getAdminToken();
      
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Нэвтрэх шаардлагатай')),
        );
        return;
      }

      final response = await http.post(
        Uri.parse('https://mubereats.onrender.com/api/admin/approve/restaurant/$restaurantId/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ресторан амжилттай зөвшөөрөгдлөө'),
            backgroundColor: Colors.green,
          ),
        );
        fetchRestaurants(); // Жагсаалтыг шинэчлэх
      } else {
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['responseText'] ?? 'Алдаа гарлаа'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Алдаа: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<dynamic> get filteredRestaurants {
    if (searchQuery.isEmpty) return restaurants;
    return restaurants.where((restaurant) {
      final name = restaurant['resName']?.toString().toLowerCase() ?? '';
      final email = restaurant['email']?.toString().toLowerCase() ?? '';
      return name.contains(searchQuery.toLowerCase()) ||
          email.contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = restaurants.where((r) => r['status'] == 'active').length;
    final openCount = restaurants.where((r) => r['openNow'] == true).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            centerTitle: false,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 700, bottom: 110),
              title: const Text(
                'Ресторанyуд',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.black87,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue[50]!,
                      Colors.purple[50]!,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 80, left: 16, right: 16),
                  child: Row(
                    children: [
                      _buildStatCard(
                        icon: Icons.restaurant,
                        label: 'Нийт',
                        value: restaurants.length.toString(),
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        icon: Icons.check_circle,
                        label: 'Идэвхтэй',
                        value: activeCount.toString(),
                        color: Colors.green,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        icon: Icons.access_time,
                        label: 'Нээлттэй',
                        value: openCount.toString(),
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Ресторан хайх...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          isLoading
              ? const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : errorMessage != null
                  ? SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.error_outline,
                                  size: 60, color: Colors.red[400]),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Алдаа гарлаа',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                errorMessage!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  isLoading = true;
                                  errorMessage = null;
                                });
                                fetchRestaurants();
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Дахин оролдох'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : filteredRestaurants.isEmpty
                      ? SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.restaurant,
                                      size: 60, color: Colors.grey[400]),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  searchQuery.isEmpty
                                      ? 'Ресторан олдсонгүй'
                                      : 'Хайлт олдсонгүй',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  searchQuery.isEmpty
                                      ? 'Одоогоор бүртгэлтэй ресторан байхгүй байна'
                                      : 'Өөр нэрээр хайж үзнэ үү',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final restaurant = filteredRestaurants[index];
                                return _buildRestaurantCard(restaurant);
                              },
                              childCount: filteredRestaurants.length,
                            ),
                          ),
                        ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(Map<String, dynamic> restaurant) {
    final isActive = restaurant['status'] == 'active';
    final isOpen = restaurant['openNow'] ?? false;
    final restaurantId = restaurant['resID'] ?? restaurant['id'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Дэлгэрэнгүй хуудас руу шилжих
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    // Зураг эсвэл avatar
                    Hero(
                      tag: 'restaurant_$restaurantId',
                      child: Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue[400]!,
                              Colors.purple[400]!,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: restaurant['image'] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  restaurant['image'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Text(
                                        restaurant['resName'][0].toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Center(
                                child: Text(
                                  restaurant['resName'][0].toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Мэдээлэл
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  restaurant['resName'] ?? 'Нэргүй',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w800,
                                    height: 1.2,
                                    color: Colors.grey[900],
                                    letterSpacing: -0.5,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildStatusBadge(
                                label: isActive ? 'Идэвхтэй' : 'Идэвхгүй',
                                color: isActive ? Colors.green : Colors.red,
                                icon: isActive
                                    ? Icons.check_circle
                                    : Icons.cancel,
                              ),
                              const SizedBox(width: 8),
                              if (restaurant['openTime'] != null)
                                _buildStatusBadge(
                                  label: isOpen ? 'Нээлттэй' : 'Хаалттай',
                                  color: isOpen ? Colors.orange : Colors.grey,
                                  icon: Icons.schedule,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Зөвшөөрөх товч (зөвхөн идэвхгүй бол)
                    if (!isActive)
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Ресторан зөвшөөрөх'),
                              content: Text(
                                '${restaurant['resName']} ресторанг зөвшөөрөх үү?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Болих'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    approveRestaurant(restaurantId);
                                  },
                                  child: const Text('Зөвшөөрөх'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        color: Colors.green,
                        tooltip: 'Зөвшөөрөх',
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      if (restaurant['email'] != null)
                        _buildInfoRow(
                          icon: Icons.email_outlined,
                          text: restaurant['email'],
                          iconColor: Colors.blue,
                        ),
                      if (restaurant['phone'] != null) ...[
                        if (restaurant['email'] != null)
                          const SizedBox(height: 8),
                        _buildInfoRow(
                          icon: Icons.phone_outlined,
                          text: restaurant['phone'],
                          iconColor: Colors.green,
                        ),
                      ],
                      if (restaurant['openTime'] != null &&
                          restaurant['closeTime'] != null) ...[
                        if (restaurant['email'] != null ||
                            restaurant['phone'] != null)
                          const SizedBox(height: 8),
                        _buildInfoRow(
                          icon: Icons.access_time_filled,
                          text:
                              '${restaurant['openTime']} - ${restaurant['closeTime']}',
                          iconColor: isOpen ? Colors.orange : Colors.grey,
                        ),
                      ],
                      if (restaurant['description'] != null) ...[
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          icon: Icons.info_outline,
                          text: restaurant['description'],
                          iconColor: Colors.purple,
                        ),
                      ],
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

  Widget _buildStatusBadge({
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.4), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}