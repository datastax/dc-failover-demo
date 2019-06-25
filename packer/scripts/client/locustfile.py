from locust import HttpLocust, TaskSet, task

class UserBehavior(TaskSet):
    def on_start(self):
        """ on_start is called when a Locust start before any task is scheduled """
        pass

    def on_stop(self):
        """ on_stop is called when the TaskSet is stopping """
        pass

    @task
    def index(self):
        self.client.get("/")

    @task
    def status(self):
        self.client.get("/status")

    @task
    def sample_get(self):
        self.client.get("/demo/%i" % 1, name="/demo/[id]")

    @task
    def sample_post(self):
        self.client.post("/demo/", json={"id": 100 })

class WebsiteUser(HttpLocust):
    task_set = UserBehavior