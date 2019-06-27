import string
import random

from locust import HttpLocust, TaskSet, task

def random_id():
    random.randint(1, 2**31)

def random_string(min_length=4, max_length=16):
    return ''.join(random.choice(string.ascii_lowercase) for x in range(random.randint(min_length, max_length)))

def random_items():
    items=[]
    for x in range(1, 42):
        items.append({"id": x, "name": random_string()})
    return items

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
        self.username = random_string()
        self.items=random_items()

    @task(1)
    def add_item(self):
        self.client.post("/cart/{}/add".format(self.username), name="/cart/[username]/add", json=random.choice(self.items))

    @task(2)
    def get_cart(self):
        self.client.get("/cart/{}".format(self.username), name="/cart/[username]")

class WebUser(HttpLocust):
    task_set = ShopperBehavior
