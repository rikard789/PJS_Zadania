import json
from typing import List, Dict, Text, Any
import os

class OrderManager:
    def __init__(self, file_path):
        self.file_path = file_path
        self.orders = self.load_orders()

    def load_orders(self):
        try:
            with open(self.file_path, 'r') as file:
                orders = json.load(file)
        except (FileNotFoundError, json.JSONDecodeError):
            orders = []
        return orders

    def save_orders(self):
        with open(self.file_path, 'w') as file:
            json.dump(self.orders, file, indent=2)

    def add_order(self, order):
        self.orders.append(order)
        self.save_orders()

    def delete_last_order(self):
        if self.orders:
            self.orders.pop()
            self.save_orders()

    def delete_all_orders(self):
        self.orders = []
        self.save_orders()

    def last_order(self):
        if self.orders:
            return self.orders[-1]
        else:
            return None            