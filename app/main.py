from fastapi import FastAPI,HTTPException
from pydantic import BaseModel
import calendar
import datetime
# import uvicorn
import joblib
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# CORS setup
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"],  # Replace with the origin where your React app is running
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load the model from the file
# model_xgb_file_path = 'C:/Users/dell/Downloads/xgb_model.pkl'
model_xgb_file_path = '/fastapi-app/xgb_model.pkl'
model_xgb = joblib.load(model_xgb_file_path)

def convert_time_to_timestamp(real_time):
        # Adjust format string to match 'YYYY-MM-DDTHH:MM:SS.sssZ' format
        ts = datetime.datetime.strptime(real_time, '%Y-%m-%dT%H:%M:%S.%fZ')
        # Use calendar.timegm to get the Unix timestamp
        timestamp = calendar.timegm(ts.utctimetuple())
        return float(timestamp)

class Item(BaseModel):
    latitude : str # here if we remove the value is will be required field
    longitude : str 
    Timestamp : str
    depth : str


#to run the app we should use uvicorn which is server and we wrote this
#  uvicorn main:app --reload 
@app.get('/')
def root():
    return {"message":"Earthquake Magnitude Prediction"}

# add new item to the list and we test it using this command in bash terminal
# curl -X POST -H "Content-Type: application/json" 'http://127.0.0.1:8000/items?item=orange'
# when we add Item class for more complex data structure in to do app we should pass the data as json like this
# curl -X POST -H "Content-Type: application/json" -d '{"text":"hello"}' 'http://127.0.0.1:8000/items'
@app.post('/predict')
def make_predict(data: Item):
    data = data.dict()
    latitude=float(data['latitude'])
    longitude=float(data['longitude'])
    Timestamp=data['Timestamp']
    stamp = convert_time_to_timestamp(Timestamp)
    depth=float(data['depth'])

    prediction = model_xgb.predict([[latitude, longitude,stamp,depth]])
    # Convert the prediction to a regular float
    prediction_value = float(prediction[0])

    return {
        'prediction': prediction_value
    }

# if __name__=='__main__':
#      uvicorn.run(app)