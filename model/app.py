from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import joblib
import os

app = FastAPI()

model = None
if os.path.exists("model.pkl"):
    model = joblib.load("model.pkl")
else:
    print("⚠️ Warning: model.pkl not found. Prediction endpoint will fail.")

class Features(BaseModel):
    features: list[float]

@app.post("/predict")
def predict(data: Features):
    if model is None:
        raise HTTPException(status_code=503, detail="Model not loaded.")
    result = model.predict([data.features])[0]
    return {"result": result}
