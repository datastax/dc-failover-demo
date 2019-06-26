import random

from locust import HttpLocust, TaskSet, task

class UserBehavior(TaskSet):
    def on_start(self):
        self.id = random.randint(1, 2**31)
        self.create()

    def on_stop(self):
        pass

    @task(1)
    def create(self):
        self.client.post("/demo/", json={"id": self.id, "content": "stuff"})

    @task(2)
    def get(self):
        self.client.get("/demo/{}".format(self.id))

class WebsiteUser(HttpLocust):
    task_set = UserBehavior
