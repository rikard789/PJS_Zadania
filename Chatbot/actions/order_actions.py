from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
import json
import os
from save_load_orders import OrderManager

FILE_ORDER_PATH = "orders.json"

def loadMenu() -> any:
    script_directory = os.path.dirname(os.path.realpath(__file__))
    chatbot_folder = os.path.dirname(script_directory)
    json_path = os.path.join(chatbot_folder, "data", "menu.json")

    with open(json_path, "r") as file:
        menu = json.load(file)
        menu = menu["items"]
        return menu

class PlaceOrder(Action):
    def name(self) -> Text:
        return "action_place_order"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        food_name = tracker.get_slot("dish")
        quantity = tracker.get_slot("number")
        menu_items = loadMenu()
        order_manager = OrderManager(FILE_ORDER_PATH)
        existing_orders = order_manager.load_orders()
        print(existing_orders)

        selected_food = next((item for item in menu_items if item["name"].lower() == food_name.lower()), None)
        print(selected_food)
        if selected_food:
            total_price = selected_food["price"] * int(quantity)
            total_pt = selected_food["preparation_time"] * float(quantity)

            order_manager.add_order({
                    "name": food_name,
                    "quantity": int(quantity),
                    "price": int(total_price),
                    "preparation_time": float(total_pt)
                })
            if existing_orders != None:
                total_price += sum(int(order["price"]) for order in existing_orders)
                total_pt += sum(float(order["preparation_time"]) for order in existing_orders)

            dispatcher.utter_message(
                f"You have ordered {quantity} {food_name}(s). "
                f"The total price is ${total_price:.2f} and the total preparation time is {total_pt} hours."
            )
        else:
            dispatcher.utter_message(f"Sorry, {food_name} is not available on the menu.")


class PlaceOrderOneItem(Action):
    def name(self) -> Text:
        return "action_place_order_one_item"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        food_name = tracker.get_slot("dish")
        quantity = 1
        menu_items = loadMenu()
        order_manager = OrderManager(FILE_ORDER_PATH)
        existing_orders = order_manager.load_orders()
        print(existing_orders)

        selected_food = next((item for item in menu_items if item["name"].lower() == food_name.lower()), None)
        print(selected_food)
        if selected_food:
            total_price = selected_food["price"] * int(quantity)
            total_pt = selected_food["preparation_time"] * float(quantity)

            order_manager.add_order({
                    "name": food_name,
                    "quantity": int(quantity),
                    "price": int(total_price),
                    "preparation_time": float(total_pt)
                })
            if existing_orders != None:
                total_price += sum(int(order["price"]) for order in existing_orders)
                total_pt += sum(float(order["preparation_time"]) for order in existing_orders)

            dispatcher.utter_message(
                f"You have ordered {quantity} {food_name}(s). "
                f"The total price is ${total_price:.2f} and the total preparation time is {total_pt} hours."
            )
        else:
            dispatcher.utter_message(f"Sorry, {food_name} is not available on the menu.")
            

class ConfirmAddsRequests(Action):
    def name(self) -> Text:
        return "action_confirm_adds_requests"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        type = tracker.get_slot("addition_type")
        addition = tracker.get_slot("addition")

        dispatcher.utter_message(f"Your request for {type} {addition} was added to order.")
        return []

class ConfirmOrder(Action):
    def name(self) -> Text:
        return "action_confrimed_order"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        order_manager = OrderManager(FILE_ORDER_PATH)
        existing_orders = order_manager.load_orders()

        if existing_orders:
            order_summary = "\n".join([f"{order['quantity']} {order['name']} - ${order['price']:.2f}" for order in existing_orders])

            total_price = sum(int(order["price"]) for order in existing_orders)
            total_pt = sum(float(order["preparation_time"]) for order in existing_orders)

            dispatcher.utter_message(
                f"Order confirmed, here is your order summary:\n{order_summary}\n"
                f"The total price is ${total_price:.2f} and the total preparation time is {total_pt} minutes.")
        else:
            dispatcher.utter_message("You don't have any items in your order yet.")

        return []
    
class DeleteCancelledOrder(Action):
    def name(self) -> Text:
        return "action_delete_cancelled_order"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        order_manager = OrderManager(FILE_ORDER_PATH)
        last_order = order_manager.last_order()

        if last_order:
            dispatcher.utter_message(f"Your last order ({last_order['quantity']} {last_order['name']}) has been removed.")
        else:
            dispatcher.utter_message("You don't have any items in your order to delete.")
        return []


