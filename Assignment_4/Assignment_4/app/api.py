# app/api.py

from flask import Flask, request, jsonify
from app.db_utils import get_db_connection

app = Flask(__name__)

# Root endpoint to welcome users
@app.route('/', methods=['GET'])
def home():
    return jsonify({
        "1. message": "Welcome to the PotionCraft Webpage API!",

        "2. instructions": "Use the following endpoints to interact with the API:",

        "3. endpoints": {
            "View All Potions": "/potions [GET]",
            "View All Ingredients": "/ingredients [GET]",
            "Create an Order": "/orders [POST]",
            "View All Orders": "/orders [GET]",
            "View Potion Ingredients": "/potion_ingredients [GET]"
        }
    }), 200

# Endpoint to get all potions
@app.route('/potions', methods=['GET'])
def get_potions():
    connection = get_db_connection()
    if not connection:
        return jsonify({'error': 'Database connection failed'}), 500

    cursor = connection.cursor(dictionary=True)
    cursor.execute("SELECT * FROM potions")
    potions = cursor.fetchall()
    cursor.close()
    connection.close()

    return jsonify(potions)

# Endpoint to get all ingredients
@app.route('/ingredients', methods=['GET'])
def get_ingredients():
    connection = get_db_connection()
    if not connection:
        return jsonify({'error': 'Database connection failed'}), 500

    cursor = connection.cursor(dictionary=True)
    cursor.execute("SELECT * FROM ingredients")
    ingredients = cursor.fetchall()
    cursor.close()
    connection.close()

    return jsonify(ingredients)

# Endpoint to get all orders
@app.route('/orders', methods=['GET'])
def get_orders():
    connection = get_db_connection()
    if not connection:
        return jsonify({'error': 'Database connection failed'}), 500

    cursor = connection.cursor(dictionary=True)
    cursor.execute("SELECT * FROM orders")
    orders = cursor.fetchall()
    cursor.close()
    connection.close()

    return jsonify(orders)

# Endpoint to create an order for a potion
@app.route('/orders', methods=['POST'])
def create_order():
    connection = get_db_connection()
    if not connection:
        return jsonify({'error': 'Database connection failed'}), 500

    data = request.get_json()
    potion_id = data.get('potion_id')
    user_name = data.get('user_name')
    delivery_address = data.get('delivery_address')
    quantity = data.get('quantity')

    cursor = connection.cursor(dictionary=True)

    # Get the ingredients required for the potion
    cursor.execute("""
        SELECT ingredient_id, quantity_needed 
        FROM potion_ingredients 
        WHERE potion_id = %s
    """, (potion_id,))
    ingredients_needed = cursor.fetchall()

    # Check if there are enough ingredients in stock
    for ingredient in ingredients_needed:
        ingredient_id = ingredient['ingredient_id']
        quantity_needed = ingredient['quantity_needed'] * quantity

        cursor.execute("""
            SELECT quantity_in_stock 
            FROM ingredients 
            WHERE id = %s
        """, (ingredient_id,))
        ingredient_stock = cursor.fetchone()['quantity_in_stock']

        if ingredient_stock < quantity_needed:
            return jsonify({'error': f"Not enough stock for ingredient ID {ingredient_id}"}), 400

    # Deduct the ingredients from inventory
    for ingredient in ingredients_needed:
        ingredient_id = ingredient['ingredient_id']
        quantity_needed = ingredient['quantity_needed'] * quantity

        cursor.execute("""
            UPDATE ingredients
            SET quantity_in_stock = quantity_in_stock - %s
            WHERE id = %s
        """, (quantity_needed, ingredient_id))

    # Insert the order into the orders table
    cursor.execute(
        "INSERT INTO orders (potion_id, user_name, delivery_address, quantity) VALUES (%s, %s, %s, %s)",
        (potion_id, user_name, delivery_address, quantity)
    )

    connection.commit()
    cursor.close()
    connection.close()

    return jsonify({'message': 'Order created successfully'}), 201


# Endpoint to get all potion ingredients
@app.route('/potion_ingredients', methods=['GET'])
def get_potion_ingredients():
    connection = get_db_connection()
    if not connection:
        return jsonify({'error': 'Database connection failed'}), 500

    cursor = connection.cursor(dictionary=True)
    cursor.execute("SELECT * FROM potion_ingredients")
    potion_ingredients = cursor.fetchall()
    cursor.close()
    connection.close()

    return jsonify(potion_ingredients)
