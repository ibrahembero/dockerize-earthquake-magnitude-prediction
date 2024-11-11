# Start with a lightweight Python image
FROM python:3.11-slim

# create working directory
WORKDIR /fastapi-app

# Copy the requirements file to the container
COPY requirements.txt .
# 
RUN pip --default-timeout=1000 install -r requirements.txt

# Install Python dependencies
RUN pip install -r requirements.txt
# # Install xgboost
# RUN pip install xgboost

# copy app folder inside container with the same name
COPY ./app ./app

# copy the model
# Copy the model file into the container (assuming it's in the same directory as the Dockerfile)
COPY ./xgb_model.pkl /fastapi-app/xgb_model.pkl

# specify the entry point
# Run the application (replace with your actual command)
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]


# the name of image is python-fastapi
# to build the image we run: docker build -t python-fastapi .
# then we run it by: docker run -p 8000:8000 python-fastapi
# to run the model we use: docker run -p 8000:8000 -v /c/Users/dell/Downloads/xgb_model.pkl:/fastapi-app/xgb_model.pkl python-fastapi
# to stop the container: docker stop 3400c785e552
# to remove the continer:  docker rm 3400c785e552
# #############################docker push###########
# docker tag local-image:tagname new-repo:tagname
# docker tag python-fastapi:latest berobee/earthquake_prediction_images:fastapi
#  docker push new-repo:tagname
#  docker push berobee/earthquake_prediction_images:fastapi