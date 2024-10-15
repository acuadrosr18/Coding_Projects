# PotionCraft API

PotionCraft is an API for managing magical potions, ingredients, and customer orders. It allows users to view available potions, ingredients, place orders, and manage inventory, all via a Flask-based API and an interactive console application.

## **Project Overview**
PotionCraft helps you manage your potion inventory, keep track of ingredients, and create customer orders. The project uses Flask for the backend, MySQL for data storage, and a console-based client for interacting with the API.

## **Installation Instructions**

### **Requirements**
- **Python 3.8+**
- **MySQL Server**
- **Virtual Environment** 

### **Steps**

1. **Clone the Repository**

2. **Install Dependencies**
   ```sh
   pip install -r requirements.txt
   ```

3. **Set Up the Database**
   - **Start MySQL Server**.
   - Run the SQL script provided in `Assignment_4_script.sql` to create the `potioncraft` database and populate it with initial data.
   
   ```sh
   mysql -u root -p < Assignment_4_script.sql>
   ```

4.**Configure Database Credentials**
   - Edit the `config.py` file to add your database credentials.
   
   ```python
   db_config = {
       'user': 'your_user',
       'password': 'your_password',
       'host': 'localhost',
       'database': 'potioncraft'
   }
   ```

## **How to Run the Project**

### **Running the API**

1. **Run `main.py`**
   ```sh
   python main.py
   ```
   - The Flask server should start, and you can access the API at `http://127.0.0.1:5000/`.


2. **Available Endpoints**
   - **Root Endpoint**: `GET /` - Welcome message for the API.
   - **View All Potions**: `GET /potions` - Returns a list of all available potions.
   - **View All Ingredients**: `GET /ingredients` - Returns a list of all ingredients.
   - **Create an Order**: `POST /orders` - Create a new order for a potion.
   - **View All Orders**: `GET /orders` - Returns all the orders placed.

### **Running the Console Application**
1. **Run `console_app.py`**
   ```sh
   python console_app.py
   ```
   - **Menu Options**:
     1. **View All Potions**: Displays all available potions with their details.
     2. **View Available Ingredients**: Shows the current stock of ingredients.
     3. **Place an Order**: Allows you to place an order for a specific potion.
     4. **View All Orders**: Displays all customer orders.
     5. **Exit**: Exit the console application.

## **Configuration Instructions**

- The configuration file (`config.py`) should include placeholders for database credentials. Replace these with your own credentials.


## **API Endpoints Overview**

- **GET `/potions`**
  - Returns all potions.
  - **Example Response**:
    ```json
    [
      {
        "id": 1,
        "name": "Moonlight Serenade",
        "ingredients": "Moon Dust, Lavender",
        "brewing_time": 45,
        "magical_effect": "Brings peaceful sleep and vivid dreams"
      }
    ]
    ```

- **GET `/ingredients`**
  - Returns all ingredients available.

- **POST `/orders`**
  - Creates a new order.
  - **Example Request**:
    ```json
    {
      "potion_id": 1,
      "user_name": "Gabo",
      "delivery_address": "123 Magic Lane, Dreamtown",
      "quantity": 2
    }
    ```

- **GET `/orders`**
  - Returns all placed orders.

## **Example Usage**

- **Viewing Potions**: Run the console application and select option **1** to view all available potions.
- **Placing an Order**: Select option **3** in the console app, and follow the prompts to place an order.
