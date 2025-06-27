import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(LiverCancerApp());
}

class LiverCancerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Breast Cancer Diagnosis Tool',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal[700],
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[700],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.health_and_safety,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'Breast Cancer\nDiagnosis Tool',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isApiConnected = false;
  bool _isCheckingConnection = true;

  @override
  void initState() {
    super.initState();
    _checkApiConnection();
  }

  Future<void> _checkApiConnection() async {
    try {
      // Use GET request to a simple health check endpoint or use proper POST with valid data
      final response = await http.get(
        Uri.parse('http://192.168.68.102:5000'),  // Add trailing slash
      ).timeout(Duration(seconds: 5));
    
      setState(() {
        _isApiConnected = response.statusCode == 200 || response.statusCode == 404; // 404 is fine, means server is running
        _isCheckingConnection = false;
      });
    } catch (e) {
      setState(() {
        _isApiConnected = false;
        _isCheckingConnection = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Breast Cancer Diagnosis Tool'), // Changed
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.health_and_safety,
                      size: 60,
                      color: Colors.teal[700],
                    ),
                    SizedBox(height: 15),
                    Text(
                      'AI-Powered Breast Cancer Diagnosis', // Changed
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[800],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Get personalized breast cancer diagnosis based on cell nucleus measurements.', // Changed
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            
            // API Connection Status
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(
                  _isCheckingConnection 
                    ? Icons.sync 
                    : _isApiConnected 
                      ? Icons.check_circle 
                      : Icons.error,
                  color: _isCheckingConnection 
                    ? Colors.orange 
                    : _isApiConnected 
                      ? Colors.green 
                      : Colors.red,
                ),
                title: Text('API Connection Status'),
                subtitle: Text(
                  _isCheckingConnection 
                    ? 'Checking connection...' 
                    : _isApiConnected 
                      ? 'Connected to prediction server' 
                      : 'Cannot connect to server',
                ),
                trailing: _isCheckingConnection
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        setState(() {
                          _isCheckingConnection = true;
                        });
                        _checkApiConnection();
                      },
                    ),
              ),
            ),
            SizedBox(height: 30),
            
            // Main Action Button
            ElevatedButton(
              onPressed: _isApiConnected
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PredictionFormScreen(),
                      ),
                    );
                  }
                : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[700],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Start Diagnosis',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 15),
            
            // Secondary Actions
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryScreen(),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.teal[700],
                side: BorderSide(color: Colors.teal[700]!),
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'View Previous Results',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 30),
            
            // Information Cards
            Text(
              'About Breast Cancer Diagnosis Features',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
            SizedBox(height: 15),
            
            _buildInfoCard(
              'Cell Nucleus Size',
              'Mean radius, texture, and perimeter measurements',
              Icons.crop_free,
              Colors.red[100]!,
            ),
            _buildInfoCard(
              'Shape Features',
              'Compactness, concavity, and symmetry analysis',
              Icons.scatter_plot,
              Colors.orange[100]!,
            ),
            _buildInfoCard(
              'Texture Analysis',
              'Surface texture variations and smoothness',
              Icons.texture,
              Colors.blue[100]!,
            ),
            _buildInfoCard(
              'Error Measurements',
              'Standard error values for all features',
              Icons.analytics,
              Colors.green[100]!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String description, IconData icon, Color color) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.teal[700]),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
      ),
    );
  }
}

class PredictionFormScreen extends StatefulWidget {
  @override
  _PredictionFormScreenState createState() => _PredictionFormScreenState();
}

class _PredictionFormScreenState extends State<PredictionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // NEW FORM DATA - matches app.py FEATURES exactly
  Map<String, double> _formData = {};

  // Initialize with default values
  @override
  void initState() {
    super.initState();
    // Initialize all 30 features with default values
    _formData = {
      'mean radius': 14.0,
      'mean texture': 19.0,
      'mean perimeter': 91.0,
      'mean area': 654.0,
      'mean smoothness': 0.096,
      'mean compactness': 0.104,
      'mean concavity': 0.089,
      'mean concave points': 0.048,
      'mean symmetry': 0.181,
      'mean fractal dimension': 0.063,
      'radius error': 0.405,
      'texture error': 1.216,
      'perimeter error': 2.866,
      'area error': 40.337,
      'smoothness error': 0.007,
      'compactness error': 0.025,
      'concavity error': 0.032,
      'concave points error': 0.012,
      'symmetry error': 0.020,
      'fractal dimension error': 0.004,
      'worst radius': 16.269,
      'worst texture': 25.677,
      'worst perimeter': 107.261,
      'worst area': 880.583,
      'worst smoothness': 0.132,
      'worst compactness': 0.254,
      'worst concavity': 0.272,
      'worst concave points': 0.115,
      'worst symmetry': 0.290,
      'worst fractal dimension': 0.084,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cell Measurements Form'), // Changed
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cell Nucleus Measurements',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              
              // Mean measurements
              _buildSectionHeader('Mean Measurements'),
              ..._buildMeanFields(),
              
              // Error measurements  
              _buildSectionHeader('Standard Error Measurements'),
              ..._buildErrorFields(),
              
              // Worst measurements
              _buildSectionHeader('Worst Case Measurements'),
              ..._buildWorstFields(),
              
              SizedBox(height: 30),
              
              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitPrediction,
                  child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Get Diagnosis', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal[700]),
      ),
    );
  }

  List<Widget> _buildMeanFields() {
    return [
      _buildNumericField('Mean Radius', 'mean radius', 'Average distance from center (6-28)'),
      _buildNumericField('Mean Texture', 'mean texture', 'Standard deviation of gray-scale (9-40)'),
      _buildNumericField('Mean Perimeter', 'mean perimeter', 'Perimeter of nucleus (43-189)'),
      _buildNumericField('Mean Area', 'mean area', 'Area of nucleus (143-2501)'),
      _buildNumericField('Mean Smoothness', 'mean smoothness', 'Smoothness (0.05-0.16)'),
      _buildNumericField('Mean Compactness', 'mean compactness', 'Compactness (0.02-0.35)'),
      _buildNumericField('Mean Concavity', 'mean concavity', 'Concavity (0-0.43)'),
      _buildNumericField('Mean Concave Points', 'mean concave points', 'Concave points (0-0.2)'),
      _buildNumericField('Mean Symmetry', 'mean symmetry', 'Symmetry (0.1-0.3)'),
      _buildNumericField('Mean Fractal Dimension', 'mean fractal dimension', 'Fractal dimension (0.05-0.1)'),
    ];
  }

  List<Widget> _buildErrorFields() {
    return [
      _buildNumericField('Radius Error', 'radius error', 'SE of radius (0.1-2.9)'),
      _buildNumericField('Texture Error', 'texture error', 'SE of texture (0.4-4.9)'),
      _buildNumericField('Perimeter Error', 'perimeter error', 'SE of perimeter (0.8-22)'),
      _buildNumericField('Area Error', 'area error', 'SE of area (6-542)'),
      _buildNumericField('Smoothness Error', 'smoothness error', 'SE of smoothness (0.002-0.03)'),
      _buildNumericField('Compactness Error', 'compactness error', 'SE of compactness (0.002-0.14)'),
      _buildNumericField('Concavity Error', 'concavity error', 'SE of concavity (0-0.4)'),
      _buildNumericField('Concave Points Error', 'concave points error', 'SE of concave points (0-0.05)'),
      _buildNumericField('Symmetry Error', 'symmetry error', 'SE of symmetry (0.008-0.08)'),
      _buildNumericField('Fractal Dimension Error', 'fractal dimension error', 'SE of fractal dimension (0.001-0.03)'),
    ];
  }

  List<Widget> _buildWorstFields() {
    return [
      _buildNumericField('Worst Radius', 'worst radius', 'Worst radius (7-36)'),
      _buildNumericField('Worst Texture', 'worst texture', 'Worst texture (12-50)'),
      _buildNumericField('Worst Perimeter', 'worst perimeter', 'Worst perimeter (50-251)'),
      _buildNumericField('Worst Area', 'worst area', 'Worst area (185-4254)'),
      _buildNumericField('Worst Smoothness', 'worst smoothness', 'Worst smoothness (0.07-0.22)'),
      _buildNumericField('Worst Compactness', 'worst compactness', 'Worst compactness (0.03-1.06)'),
      _buildNumericField('Worst Concavity', 'worst concavity', 'Worst concavity (0-1.25)'),
      _buildNumericField('Worst Concave Points', 'worst concave points', 'Worst concave points (0-0.29)'),
      _buildNumericField('Worst Symmetry', 'worst symmetry', 'Worst symmetry (0.16-0.66)'),
      _buildNumericField('Worst Fractal Dimension', 'worst fractal dimension', 'Worst fractal dimension (0.055-0.21)'),
    ];
  }

  Widget _buildNumericField(String label, String key, String hint) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        initialValue: _formData[key]?.toString() ?? '',
        onChanged: (value) {
          _formData[key] = double.tryParse(value) ?? _formData[key]!;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
      ),
    );
  }

  Future<void> _submitPrediction() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.68.102:5000/predict'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(_formData),
      ).timeout(Duration(seconds: 30));

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(result: result),
          ),
        );
      } else {
        final errorBody = json.decode(response.body);
        _showErrorDialog('Server Error: ${errorBody['error'] ?? 'Unknown error'}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Connection Error: Unable to connect to the prediction server.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const ResultScreen({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prediction = result['prediction'] ?? 0;
    final diagnosis = prediction == 1 ? 'Malignant' : 'Benign';
    final confidence = result['probability'] ?? 0.0;
    
    final isMalignant = prediction == 1;
    final color = isMalignant ? Colors.red : Colors.green;
    final icon = isMalignant ? Icons.warning : Icons.check_circle;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Diagnosis Result'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              elevation: 8,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: color,
                ),
                child: Column(
                  children: [
                    Icon(icon, size: 60, color: Colors.white),
                    SizedBox(height: 15),
                    Text(
                      diagnosis.toUpperCase(),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Confidence: ${(confidence * 100).toStringAsFixed(1)}%',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            
            if (isMalignant) ...[
              _buildRecommendationCard(
                'Consult Oncologist',
                'Schedule an appointment with an oncologist for treatment planning.',
                Icons.medical_services,
                Colors.red,
              ),
              _buildRecommendationCard(
                'Further Testing',
                'Additional tests may be needed to determine staging and treatment.',
                Icons.science,
                Colors.orange,
              ),
            ] else ...[
              _buildRecommendationCard(
                'Continue Monitoring',
                'Continue regular check-ups and mammograms as recommended.',
                Icons.schedule,
                Colors.green,
              ),
            ],
            
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => PredictionFormScreen()),
                  (route) => false,
                );
              },
              child: Text('New Diagnosis'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(String title, String description, IconData icon, Color color) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assessment History'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              'No Previous Assessments',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Your assessment history will appear here',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PredictionFormScreen(),
                  ),
                );
              },
              child: Text('Start New Assessment'),
            ),
          ],
        ),
      ),
    );
  }
}