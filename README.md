# 🧠 Breast Cancer Prediction App

An end-to-end machine learning application that predicts whether a breast tumor is **benign or malignant**. This project includes:

- A machine learning model trained with real diagnostic data
- A RESTful Flask API backend
- A modern Flutter mobile frontend

---

## 📁 Project Structure

breast-cancer-predictor/
├── test.py # ML training script (Python)
├── app.py # Flask backend API
├── scaler.pkl # Saved StandardScaler
├── best_breast_cancer_model.pkl # Trained ML model
├── breast_cancer_diagnostic.csv # Training dataset (not uploaded)
├── flutter_app/ # Flutter mobile app
│ ├── lib/
│ │ └── main.dart
│ └── pubspec.yaml
└── README.md


---

## 🧠 Model Training (`test.py`)

- Uses `scikit-learn` to train and evaluate multiple models:
  - Logistic Regression
  - Random Forest
  - Support Vector Machine (SVM)
  - Gradient Boosting
- Selects the best-performing model by accuracy
- Saves the model and scaler as `.pkl` files for inference

**To run:**
```bash
python test.py
```
A lightweight Flask API that accepts POST requests with diagnostic features and returns a prediction (malignant or benign) and confidence score.

Endpoints:
/: Health check
/predict: Accepts JSON with 30 features and returns prediction

To run:
pip install flask joblib scikit-learn numpy
python app.py

📱 Flutter Frontend (flutter_app/)
A mobile application built using Flutter that lets users enter diagnostic values and get a prediction from the model via the Flask backend.

To run:
cd flutter_app
flutter pub get
flutter run

📦 Requirements
Python:
pandas
scikit-learn
joblib
flask
numpy
Flutter:
Dart SDK (comes with Flutter)
Internet permission (for API call)

🧪 Sample Input (for API)
{
  "mean radius": 17.99,
  "mean texture": 10.38,
  "mean perimeter": 122.8,
  "mean area": 1001.0,
  ...
  "worst symmetry": 0.4601,
  "worst fractal dimension": 0.1189
}
Responce:
{
  "prediction": 1,
  "probability": 0.9732
}

Pulatov Ibrohim
