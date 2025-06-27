from flask import Flask, request, jsonify
import joblib
import numpy as np

app = Flask(__name__)

# Load the trained model and scaler
model = joblib.load("best_breast_cancer_model.pkl")
scaler = joblib.load("scaler.pkl")

@app.route('/')
def home():
    return "Breast Cancer Prediction API is Running"

@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.get_json()
        
        # Ensure input data is in the correct order as expected by the model
        features = [
            'mean radius', 'mean texture', 'mean perimeter', 'mean area',
            'mean smoothness', 'mean compactness', 'mean concavity',
            'mean concave points', 'mean symmetry', 'mean fractal dimension',
            'radius error', 'texture error', 'perimeter error', 'area error',
            'smoothness error', 'compactness error', 'concavity error',
            'concave points error', 'symmetry error', 'fractal dimension error',
            'worst radius', 'worst texture', 'worst perimeter', 'worst area',
            'worst smoothness', 'worst compactness', 'worst concavity',
            'worst concave points', 'worst symmetry', 'worst fractal dimension'
        ]
        
        input_data = [data[feature] for feature in features]
        input_array = np.array([input_data])  # Make it 2D for the model
        
        # Scale input using the saved scaler
        input_scaled = scaler.transform(input_array)

        # Predict
        prediction = model.predict(input_scaled)[0]
        probability = model.predict_proba(input_scaled)[0][prediction]

        result = {
            "prediction": int(prediction),  # 1 = malignant, 0 = benign
            "probability": round(probability, 4)
        }
        return jsonify(result)
    
    except Exception as e:
        return jsonify({"error": str(e)})

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)
