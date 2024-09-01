from fastapi import FastAPI
from app.routers import factors, mining

app = FastAPI()

app.include_router(factors.router)
app.include_router(mining.router)

@app.get("/")
def read_root():
    return {"message": "Welcome to the Factor Chain API"}
