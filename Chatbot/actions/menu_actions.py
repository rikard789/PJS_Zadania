from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
import json
import os

def loadMenu() -> any:
    script_directory = os.path.dirname(os.path.realpath(__file__))
    chatbot_folder = os.path.dirname(script_directory)
    json_path = os.path.join(chatbot_folder, "data", "menu.json")

    with open(json_path, "r") as file:
        menu = json.load(file)
        return menu

class ListMenuItems(Action):
    items_menu = loadMenu()

    def name(self) -> Text:
        return "action_list_menu"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        items_menu = self.items_menu    
        menulist = "\nFood in menu:\n"

        if items_menu != None:
            for item in self.items_menu["items"]:
                menulist += f" - {item['name']}     ${item['price']}   avg. prep time(hours): {item['preparation_time']}\n"
            
        dispatcher.utter_message(text=menulist)

        return []    