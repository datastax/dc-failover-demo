import string
import random
import gevent

from requests.exceptions import ConnectionError, ReadTimeout
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
    MAX_NUM_RETRIES = 2
    RETRY_DELAY = 1
    RETRY_DELAY_CONNECTION = 2
    TIMEOUT = 0.6

    def on_start(self):
        self.username = random_string()
        self.items=random_items()

    @task(1)
    def add_item(self):
        self.send_request("post", "/cart/{}/add".format(self.username), "/cart/[username]/add",
                          random.choice(self.items))

    @task(2)
    def get_cart(self):
        self.send_request("get", "/cart/{}".format(self.username), "/cart/[username]", None)

    def send_request(self, method, path, name, json):
        retry = True
        num_retry = 0
        num_retry_connection = 0

        while retry:

            try:
                with getattr(self.client, method)(path, name=name, json=json, catch_response=True,
                                                  timeout=self.TIMEOUT) as response:
                    retry = False

                    if response.ok:
                        response.success()
                    elif response.status_code == 504:
                        # 504 Gateway timeouts occur when the Global Accelerator / ELB timeouts obtaining a response
                        # from endpoints / target group
                        if num_retry < self.MAX_NUM_RETRIES:
                            response.success()
                            # Retry a few times to simulate a client device obtaining a Gateway timeout as
                            # part of the normal app flow
                            num_retry += 1
                            retry = True
                            gevent.sleep(self.RETRY_DELAY)
                        else:
                            response.failure("504 Gateway timeout failure after {} retries".format(num_retry))
                    else:
                        response.failure("Failed with status code {}: {}".format(response.status_code, response.text))

            except (ConnectionError, ReadTimeout):
                # Connections are dropped from the Global Accelerator to the ELB instance when we are removing
                # the security group
                if num_retry_connection >= self.MAX_NUM_RETRIES:
                    raise

                # Retry part of the normal app flow
                num_retry_connection += 1
                gevent.sleep(self.RETRY_DELAY_CONNECTION)

class WebUser(HttpLocust):
    task_set = ShopperBehavior
