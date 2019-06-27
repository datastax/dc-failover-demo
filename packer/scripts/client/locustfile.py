import string
import random

from locust import HttpLocust, TaskSet, task

ITEMS=[
        {"id": 1, "name": "Computer"},
        {"id": 2, "name": "Pizza"},
        {"id": 3, "name": "Tea"},
        {"id": 4, "name": "Coffee"},
        {"id": 5, "name": "Television"},
        {"id": 6, "name": "Laptop"},
        {"id": 7, "name": "Milk"},
        {"id": 8, "name": "Orange"},
        {"id": 9, "name": "Apple"},
        {"id": 10, "name": "Mouse"},
        {"id": 11, "name": "Keyboard"},
        {"id": 12, "name": "Video Game"},
        {"id": 13, "name": "Cup"},
        {"id": 14, "name": "Kettle"},
        {"id": 15, "name": "MP3 Player"},
        {"id": 16, "name": "Video Card"},
        {"id": 17, "name": "Printer Paper"},
        {"id": 18, "name": "Ramen"},
        {"id": 19, "name": "Pens"},
        {"id": 20, "name": "Pencils"},
        {"id": 21, "name": "Permanent Marker"},
        {"id": 22, "name": "Webcam"},
        {"id": 23, "name": "Monitor"},
        {"id": 24, "name": "Headphones"},
        {"id": 25, "name": "32GB SSD Drive"},
        {"id": 26, "name": "1TB Hard Drive"},
        {"id": 27, "name": "Mouse Pad"},
        {"id": 28, "name": "eBook"},
        {"id": 29, "name": "Toaster"},
        {"id": 30, "name": "Butter"},
        {"id": 31, "name": "Googles"},
        {"id": 32, "name": "Camera"},
        {"id": 33, "name": "Envelopes"},
        {"id": 34, "name": "Salt"},
        {"id": 35, "name": "Pepper"},
        {"id": 36, "name": "Pillow"},
        {"id": 37, "name": "Office Chair"},
        {"id": 38, "name": "Exercise Ball"},
        {"id": 39, "name": "eBook Reader"},
        {"id": 40, "name": "Shoes"},
        {"id": 41, "name": "USB 3.0 Cable"},
        {"id": 42, "name": "Ethernet Cable"},
        ]

def random_id():
    random.randint(1, 2**31)

def random_username():
    return ''.join(random.choice(string.ascii_lowercase) for x in range(random.randint(4, 16)))

def random_item():
    global ITEMS
    return random.choice(ITEMS)

class DemoBehavior(TaskSet):
    def on_start(self):
        self.id = random_id()
        self.create()

    @task(1)
    def create(self):
        self.client.post("/demo/", json={"id": self.id, "content": "stuff"}, )

    @task(2)
    def get(self):
        self.client.get("/demo/{}".format(self.id), name="demo/[id]")

class ShopperBehavior(TaskSet):
    def on_start(self):
        self.username = random_username()

    @task(1)
    def add_item(self):
        self.client.post("/cart/{}/add".format(self.username), name="/cart/[username]/add", json=random_item())

    @task(2)
    def get_cart(self):
        self.client.get("/cart/{}".format(self.username), name="/cart/[username]")

class WebUser(HttpLocust):
    task_set = ShopperBehavior
