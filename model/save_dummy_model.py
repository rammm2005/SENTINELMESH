from sklearn.ensemble import IsolationForest
import joblib
import numpy as np

X_train = np.random.rand(100, 4)

model = IsolationForest()
model.fit(X_train)

joblib.dump(model, "model.pkl")

print("✅ Dummy model.pkl saved.")
