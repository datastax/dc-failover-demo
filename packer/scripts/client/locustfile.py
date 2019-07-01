import string
import random
import gevent

from locust import HttpLocust, Locust, TaskSet, task, clients

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

class HttpSessionWithRetry(clients.HttpSession):
    RETRY_DELAY=10
    MAX_NUM_RETRIES=1

    def __init__(self, base_url, *args, **kwargs):
        super(HttpSessionWithRetry, self).__init__(base_url, *args, **kwargs)

    def _send_request_safe_mode(self, method, url, **kwargs):
        """
        Send a HTTP request and retry if a HTTP 504 "Gateway Timeout" occurs.
        """
        response = clients.HttpSession._send_request_safe_mode(self, method, url, **kwargs)
        num_retries = 0
        while response.status_code == 504 and num_retries < self.MAX_NUM_RETRIES: # Retry on HTTP error: 504 Gateway Timeout
            gevent.sleep(self.RETRY_DELAY) 
            num_retries += 1
            response = clients.HttpSession._send_request_safe_mode(self, method, url, **kwargs)
        return response

class HttpLocustWithRetry(Locust):
    def __init__(self):
        super(HttpLocustWithRetry, self).__init__()
        if self.host is None:
            raise LocustError("You must specify the base host. Either in the host attribute in the Locust class, or on the command line using the --host option.")
        self.client = HttpSessionWithRetry(base_url=self.host)

class DemoBehavior(TaskSet):
    TIMEOUT=2

    def on_start(self):
        self.id = random_id()
        self.create()

    @task(1)
    def create(self):
        self.client.post("/demo/", json={"id": self.id, "content": "stuff"}, timeout=self.TIMEOUT)

    @task(2)
    def get(self):
        self.client.get("/demo/{}".format(self.id), name="demo/[id]", timeout=self.TIMEOUT)

class ShopperBehavior(TaskSet):
    TIMEOUT=2

    def on_start(self):
        self.username = random_string()
        self.items=random_items()

    @task(1)
    def add_item(self):
        self.client.post("/cart/{}/add".format(self.username), name="/cart/[username]/add", json=random.choice(self.items), timeout=self.TIMEOUT)

    @task(2)
    def get_cart(self):
        self.client.get("/cart/{}".format(self.username), name="/cart/[username]", timeout=self.TIMEOUT)

class WebUser(HttpLocustWithRetry):
    task_set = ShopperBehavior
