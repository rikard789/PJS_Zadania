from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
from datetime import datetime
import json
import os

def loadOpenHours() -> any:
    script_directory = os.path.dirname(os.path.realpath(__file__))
    chatbot_folder = os.path.dirname(script_directory)
    json_path = os.path.join(chatbot_folder, "data", "opening_hours.json")

    with open(json_path, "r") as file:
        opening_hours_data = json.load(file)
        opening_hours_data = opening_hours_data["items"]
        return opening_hours_data


class ListOpenHours(Action):
    opening_hours_data = loadOpenHours()

    def name(self) -> Text:
        return "action_list_open_hours"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        open_list = "\nOur opening hours:\n"

        for day, hours in self.opening_hours_data.items():
            open_list += " - "
            if hours['open'] == hours['close']:
                open_list += f"{day}: CLOSED\n"
            else:
                open_list += f"{day}: {hours['open']} - {hours['close']}\n"

        dispatcher.utter_message(text=open_list)

        return []
    

class openHoursDay(Action):
    open_hours_data = loadOpenHours()

    def name(self) -> Text:
        return "action_open_hours_for_day"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        entities = tracker.latest_message.get('entities', [])

        for entity in entities:
            if entity['entity'] == 'day_of_week':
                day = entity['value']
                if day in self.open_hours_data:
                    open_hours_data = self.open_hours_data[day.capitalize()]
                    if open_hours_data['open'] != open_hours_data['close']:
                        dispatcher.utter_message(f"On {day}, we are open from {open_hours_data['open']} to {open_hours_data['close']}.")
                    else:
                        dispatcher.utter_message(f"Restaurant is closed on {day}.")
                else:
                    dispatcher.utter_message(f"Sorry, I don't have information about the opening hours for {day}.")

        return []

class openHoursDayTime(Action):
    open_hours_data = loadOpenHours()

    def name(self) -> Text:
        return "action_open_hours_for_day_time"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        entities = tracker.latest_message.get('entities', [])

        for entity in entities:
            if entity['entity'] == 'day_of_week':
                day = entity['value']

                if day in self.open_hours_data:
                    open_hours_data = self.open_hours_data[day.capitalize()]
                    time = int(tracker.get_slot('time'))

                    if open_hours_data['open'] <= time <= open_hours_data['close']:
                        dispatcher.utter_message(f"Yes, we are open from {open_hours_data['open']} to {open_hours_data['close']}.")
                    else:
                        dispatcher.utter_message(f"Restaurant is closed on {day} at {time}.")
                else:
                    dispatcher.utter_message(f"Sorry, I don't have information about the opening hours for {day}.")

        return []
    
class openHoursNow(Action):
    open_hours_data = loadOpenHours()

    def name(self) -> Text:
        return "action_check_open_now"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        time = datetime.now().hour
        entities = tracker.latest_message.get('entities', [])

        for entity in entities:
            if entity['entity'] == 'day_of_week':
                day = entity['value']
                if day in self.open_hours_data:
                    open_hours_data = self.open_hours_data[day.capitalize()]
                    if open_hours_data['open'] <= time <= open_hours_data['close']:
                        dispatcher.utter_message(f"Yes, we are open from {open_hours_data['open']} to {open_hours_data['close']}.")
                    else:
                        dispatcher.utter_message(f"Restaurant is closed on {day} at {time}.")
                else:
                    dispatcher.utter_message(f"Sorry, I don't have information about the opening hours for {day}.")

        return []