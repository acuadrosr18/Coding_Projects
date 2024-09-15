"""
TRIVIA CHALLENGE
The program retrieves multiple trivia questions from the Open Trivia Database API
based on the category, difficulty, and number of questions chosen by the user.
The user has to select a category from a list and choose the difficulty level (easy, medium, or hard).

The program then provides trivia questions from the API and shuffles the answer options for each question.

As each question is displayed, the user selects their answer,
and the program checks whether it is correct or incorrect, providing immediate feedback.

The final score, the selected category and difficulty, is saved to a file.
The program makes sure that all the inputs (category, difficulty, and answer)
are valid by encouraging the user to retry if an invalid input is entered.

The game is user-friendly and provides helpful messages throughout the process.

Is so easy to play, but not easy to win, for that you need knowledge! :)

Let the game begin...
"""

# This API is free to use and does not require an API key.
# We use this API to get trivia questions in JSON format.

import requests
import random
import html # We import this to decode HTML entities provided by the API
import datetime
import time  # Imported track how long the user takes to answer questions.
# time module is built into Python, so no additional installation is needed.

#  Get questions from the API
def get_trivia_questions(category, num_questions, difficulty):
    """
    Obtains trivia questions from the Open Trivia Database API.
    # Example of API response:
    #     {
    #   "response_code": 0,
    #   "results": [
    #     {
    #       "type": "multiple",
    #       "difficulty": "hard",
    #       "category": "Science: Mathematics",
    #       "question": "What is the fourth digit of &pi;?",
    #       "correct_answer": "1",
    #       "incorrect_answers": [
    #         "2",
    #         "3",
    #         "4"
    #       ]
    #     },

    """
    url = f"https://opentdb.com/api.php?amount={num_questions}&category={category}&difficulty={difficulty}&type=multiple"
    response = requests.get(url)
    return response.json()["results"]

# Asks the questions to the user
def ask_question(question_data):
    """
    Asks a trivia question and returns True if the user answers correctly
    """
    # Decode HTML entities in the question to handle special characters like &quot;
    question = html.unescape(question_data["question"])
    correct_answer = html.unescape(question_data["correct_answer"])
    incorrect_answers = [html.unescape(incorrect_answers) for incorrect_answers in question_data["incorrect_answers"]]

    # Shuffle answers
    all_answers = incorrect_answers + [correct_answer]
    random.shuffle(all_answers)

    # Display the question and the shuffled answer options
    print(f"Question: {question}")
    for i, answer in enumerate(all_answers):
        print(f"{i+1}.{answer}")

    # Start timing the user's response
    start_time = time.time()

    # Get user answer
    user_answer = int(input("Enter the number of your answer: "))

    # Stop timing after user submits their answer
    end_time = time.time()

    # Calculate the time taken to answer
    time_taken = end_time - start_time
    print(f"It took you {time_taken:.2f} seconds to answer.\n")

    # Make sure user enters a valid answer number
    while user_answer < 1 or user_answer > len(all_answers):
        print(f"Invalid choice. Please choose a number between 1 and {len(all_answers)}.\n")
        user_answer = int(input("Enter the number of your answer: "))

    # Check if the answer is correct
    if all_answers[user_answer - 1] == correct_answer:
        print("You are Correct! :)\n")
        return True
    else:
        print(f"You are wrong! :( The correct answer was: {correct_answer}\n")
        return False

# Choosing a category:
categories = {
    "General Knowledge":9,
    "Entertainment: Books":10,
    "Entertainment: Film":11,
    "Entertainment: Music":12,
    "Entertainment: Musicals & Theatre":13,
    "Entertainment: Television":14,
    "Entertainment: Video Games":15,
    "Entertainment: Board Games":16,
    "Science & Nature":17,
    "Science: Computers":18,
    "Science: Mathematics":19,
    "Mythology":20,
    "Sports":21,
    # "Geography": 22,
    # "History":23,
    # "Politics":24,
    # "Art":25,
    # "Celebrities":26,
    # "Animals":27,
    # "Vehicles":28,
    # "Entertainment: Comics":29,
    # "Science: Gadgets":30,
    # "Entertainment: Japanese Anime & Manga": 31,
    # "Entertainment: Cartoon & Animations": 32,
}

def choose_category():
    """
    Displays categories so user can choose one
    """
    print ("From this categories... ")
    for i, (category_name,category_id) in enumerate(categories.items()):
        print(f"\t{i+1}.{category_name}")

    choice = int(input("\nWhich one do you choose? \nEnter the number of the category you want to play with: "))

    # Make sure user enters a valid answer number
    while choice < 1 or choice > len(categories):
        print(f"Invalid choice, Please choose a number between 1 and {len(categories)}.\n")
        choice = int(input("Enter the number of the category: "))

    category_name, category_id = list(categories.items())[choice - 1]
    print(f"You chose: {category_name}.\n")
    return category_id, category_name

# Choosing the difficulty:
def choose_difficulty():
    """
    Lets the user choose the difficulty of the trivia questions
    """
    print("\nChoose difficulty level:")
    difficulties = ['easy', 'medium', 'hard']
    for i, difficulty in enumerate(difficulties):
        print(f"{i + 1}. {difficulty.capitalize()}")

    choice = int(input("Enter the number of your difficulty choice: "))

    # Make sure user enters a valid answer number
    while choice < 1 or choice > len(difficulties):
        print(f"Invalid choice, Please choose a number between 1 and {len(difficulties)}.\n")
        choice = int(input("Enter the number of the difficulty: "))

    difficulty = difficulties[choice - 1]
    print(f"You chose: {difficulty.capitalize()}, Let the game begin!\n")
    return difficulty


# Saving the scores in a file
def save_trivia_results_to_file(category,difficulty, score, num_questions):
    """
    Saves the user score to a file with a timestamp.
    """
    # Get the current date and time for logging the trivia
    current_time = str(datetime.datetime.now())

    # Use string slicing to extract the date and time
    date = current_time[:10]  # YYYY-MM-DD format
    clock = current_time[11:16]  # HH:MM format

    # Append the results to the trivia_results.txt file
    with open("trivia_results.txt","a") as text_file:
        text_file.write(f"Date: {date}, Time:{clock}, Category: {category}, Difficulty: {difficulty.capitalize()}, Score: {score}/{num_questions}\n")

# Track the score
def run_trivia(category_id, category_name, num_questions, difficulty):
    """
    Runs the trivia and track's the user's score
    """
    questions = get_trivia_questions(category_id, num_questions, difficulty)
    score = 0

    # Record the start time for the entire trivia
    trivia_start_time = time.time()

    # Loop through each question
    for question_data in questions:
        if ask_question(question_data):
            score += 1

    # Record the end time after all questions are answered
    trivia_end_time = time.time()

    # Calculate total time taken for the trivia
    total_time_taken = trivia_end_time - trivia_start_time

    # Display the final score and total time taken
    print(f"Your final score is {score}/{num_questions}")
    print(f"It took you {total_time_taken:.2f} seconds to complete the trivia.\n")

    save_trivia_results_to_file(category_name, difficulty, score, num_questions)


def main():
    """
    Main function for running the trivia.
    """
    print("Welcome everyone to the Trivia Game!\n")

    # User chooses a category
    category_id, category_name = choose_category()

    # User chooses how many questions wants to answer
    num_questions = int(input("How many questions would you like to answer? "))

    # User chooses the difficulty
    difficulty = choose_difficulty()

    # Run the trivia
    run_trivia(category_id, category_name, num_questions, difficulty)

if __name__ == "__main__": # Runs the code below only if the script is run directly, good coding technique.
    main()

