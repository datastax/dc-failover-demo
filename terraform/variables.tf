variable region1 {
  default = "us-east-1"
}

variable region2 {
  default = "us-west-2"
}

variable amis {
  type = map
  default = {
    "us-east-1" = "ami-b374d5a5"
    "us-west-2" = "ami-4b32be2b"
  }
}