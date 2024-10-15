# console_app.py

import requests

BASE_URL = "http://127.0.0.1:5000"

def get_potions():
    response = requests.get(f"{BASE_URL}/potions")
    return response.json() if response.status_code == 200 else []


def view_ingredients():
    response = requests.get(f"{BASE_URL}/ingredients")
    if response.status_code == 200:
        ingredients = response.json()
        print("\nAvailable Ingredients:")
        print("{:<10} {:<20} {:<15}".format('ID', 'Name', 'Quantity'))
        print('-' * 45)
        for ingredient in ingredients:
            print("{:<10} {:<20} {:<15}".format(ingredient['id'], ingredient['name'], ingredient['quantity_in_stock']))
    else:
        print("Error retrieving ingredients.")

def create_order():
    try:
        potion_id = int(input("Enter the potion ID you want to order: "))
        user_name = input("Enter your name: ")
        delivery_address = input("Enter your delivery address: ")
        quantity = int(input("Enter the quantity you want to order: "))

        data = {
            "potion_id": potion_id,
            "user_name": user_name,
            "delivery_address": delivery_address,
            "quantity": quantity
        }

        response = requests.post(f"{BASE_URL}/orders", json=data)

        if response.status_code == 201:
            print("Order created successfully!")
        else:
            print(f"Error placing order: {response.status_code}, {response.text}")

    except ValueError:
        print("Invalid input. Please enter valid information.")

def view_orders():
    response = requests.get(f"{BASE_URL}/orders")
    if response.status_code == 200:
        orders = response.json()
        print("\nAll Orders Placed:")
        print("{:<5} {:<10} {:<15} {:<35} {:<10}".format('ID', 'Potion ID', 'User Name', 'Address', 'Quantity'))
        print('-' * 75)
        for order in orders:
            print("{:<5} {:<10} {:<15} {:<35} {:<10}".format(
                order['id'], order['potion_id'], order['user_name'], order['delivery_address'], order['quantity']
            ))
    else:
        print("Error retrieving orders.")

def run():
    print('############################')
    print('Welcome to PotionCraft!')
    print('############################')

    while True:
        print("\nWhat would you like to do?")
        print("1. View all potions")
        print("2. View available ingredients")
        print("3. Place an order for a potion")
        print("4. View all orders placed")
        print("0. Exit")

        choice = input("Enter your choice: ")

        if choice == "1":
            potions = get_potions()
            print("\nAvailable Potions:")
            print("{:<10} {:<20} {:<30} {:<10} {:<25}".format(
                'ID', 'Name', 'Ingredients', 'Brewing Time', 'Magical Effect'))
            print('-' * 100)
            for potion in potions:
                print("{:<10} {:<20} {:<30} {:<10} {:<25}".format(
                    potion['id'], potion['name'], potion['ingredients'], potion['brewing_time'], potion['magical_effect']
                ))
        elif choice == "2":
            view_ingredients()
        elif choice == "3":
            # Display available potions before creating an order
            potions = get_potions()
            print("\nAvailable Potions:")
            print("{:<10} {:<20} {:<30} {:<10} {:<25}".format(
                'ID', 'Name', 'Ingredients', 'Brewing Time', 'Magical Effect'))
            print('-' * 100)
            for potion in potions:
                print("{:<10} {:<20} {:<30} {:<10} {:<25}".format(
                    potion['id'], potion['name'], potion['ingredients'], potion['brewing_time'],
                    potion['magical_effect']
                ))
            # Call the create_order function after showing potions
            create_order()
        elif choice == "4":
            view_orders()
        elif choice == "0":
            print("Thank you for visiting PotionCraft! Goodbye!")
            break
        else:
            print("\n!!! Invalid choice. Please try again.")

if __name__ == "__main__":
    run()
