import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score, classification_report
import joblib

df = pd.read_csv("breast_cancer_diagnostic.csv")

df = df[[
    'mean radius', 'mean texture', 'mean perimeter', 'mean area',
    'mean smoothness', 'mean compactness', 'mean concavity',
    'mean concave points', 'mean symmetry', 'mean fractal dimension',
    'radius error', 'texture error', 'perimeter error', 'area error',
    'smoothness error', 'compactness error', 'concavity error',
    'concave points error', 'symmetry error', 'fractal dimension error',
    'worst radius', 'worst texture', 'worst perimeter', 'worst area',
    'worst smoothness', 'worst compactness', 'worst concavity',
    'worst concave points', 'worst symmetry', 'worst fractal dimension',
    'diagnosis'
]]

df['diagnosis'] = df['diagnosis'].map({'malignant': 1, 'benign': 0})

X = df.drop(columns='diagnosis')
y = df['diagnosis']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=15)

scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

models = {
    "Logistic Regression": LogisticRegression(max_iter=1000),
    "Random Forest": RandomForestClassifier(n_estimators=100, random_state=15),
    "SVM": SVC(probability=True),  
    "Gradient Boosting": GradientBoostingClassifier(n_estimators=100, random_state=15)
}

best_model = None
best_score = 0
for name, model in models.items():
    model.fit(X_train_scaled, y_train)
    y_pred = model.predict(X_test_scaled)
    acc = accuracy_score(y_test, y_pred)
    print(f"\n🔍 {name} Accuracy: {acc:.4f}")
    print(classification_report(y_test, y_pred))
    
    if acc > best_score:
        best_score = acc
        best_model = model
        best_model_name = name


joblib.dump(best_model, "best_breast_cancer_model.pkl")
joblib.dump(scaler, "scaler.pkl")
print(f"\n✅ Best Model: {best_model_name} (Accuracy: {best_score:.4f})")
print("💾 Model saved as 'best_breast_cancer_model.pkl'")
print("💾 Scaler saved as 'scaler.pkl'")
