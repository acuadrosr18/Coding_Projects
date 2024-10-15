-- ASSIGNMENT 4

-- Create the database
CREATE DATABASE potioncraft;

USE potioncraft;

-- Create the potions table
CREATE TABLE potions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    ingredients TEXT NOT NULL,
    brewing_time INT NOT NULL,
    magical_effect VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the ingredients table
CREATE TABLE ingredients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    quantity_in_stock INT NOT NULL
);

-- Create the orders table
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    potion_id INT,
    user_name VARCHAR(100) NOT NULL,
    delivery_address TEXT NOT NULL,
    quantity INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (potion_id) REFERENCES potions(id)
);

USE potioncraft;
SELECT * FROM potions;

-- Create potion_ingredients so we can link every ingredient to its potion
CREATE TABLE potion_ingredients (
    potion_id INT,
    ingredient_id INT,
    quantity_needed INT,
    FOREIGN KEY (potion_id) REFERENCES potions(id),
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(id)
);

-- Insert data into ingredients table
INSERT INTO ingredients (name, quantity_in_stock) VALUES
    ('Moon Dust', 50),
    ('Lavender', 100),
    ('Unicorn Tears', 30),
    ('Dragon Scales', 20),
    ('Phoenix Feather', 15),
    ('Mandrake Root', 40),
    ('Nightshade', 25),
    ('Ginseng', 60),
    ('Silver Shavings', 45),
    ('Rose Petals', 80);

-- Insert data into potions table
INSERT INTO potions (name, ingredients, brewing_time, magical_effect) VALUES
    ('Moonlight Serenade', 'Moon Dust, Lavender', 45, 'Brings peaceful sleep and vivid dreams'),
    ('Dragons Breath', 'Dragon Scales, Phoenix Feather', 60, 'Gives temporary fire resistance'),
    ('Loves Whisper', 'Rose Petals, Unicorn Tears', 30, 'Helps express emotions softly'),
    ('Elixir of Vitality', 'Ginseng, Mandrake Root', 50, 'Restores stamina and energy'),
    ('Nightshade Elixir', 'Nightshade, Silver Shavings', 40, 'Grants night vision for a limited time');

-- Insert data into potion_ingredients table
INSERT INTO potion_ingredients (potion_id, ingredient_id, quantity_needed) VALUES
	(1, 1, 2),  -- Moonlight Serenade needs 2 units of Moon Dust
    (1, 2, 1),  -- Moonlight Serenade needs 1 units of Lavender
    (2, 4, 2),  -- Dragon's Breath needs 2 units of Dragon Scales
    (2, 5, 2),  -- Dragon's Breath needs 2 units of Phoenix Feather
    (3, 10, 2), -- Love's Whisper needs 2 units of Rose Petals
    (3, 3, 2),  -- Love's Whisper needs 2 units of Unicorn Tears
    (4, 8, 1),  -- Elixir of Vitality needs 1 units of Ginseng
    (4, 6, 1),  -- Elixir of Vitality needs 1 units of Mandrake Root
    (5, 7, 1),  -- Nightshade Elixir needs 1 units of Nightshade
    (5, 9, 2);  -- Nightshade Elixir needs 2 units of Silver Shavings

-- Insert data into orders table
INSERT INTO orders (potion_id, user_name, delivery_address, quantity) VALUES
    (1, 'Gabo', '123 Magic Lane, Dreamtown', 2),
    (2, 'Asma', '456 Enchanted Ave, Spellcity', 1),
    (3, 'Altyn', '789 Mystic Blvd, Potionville', 3),
    (4, 'Shaan', '321 Sorcery St, Magictown', 1),
    (5, 'Amon', '654 Witchwood Dr, Hexham', 2);
    
SELECT * FROM orders;


