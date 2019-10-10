# Internal lookup map
variable "direction" {
  type = map(list(string))

  default = {
    up   = ["GreaterThanOrEqualToThreshold", "scale_out"]
    down = ["LessThanThreshold", "scale_in"]
  }
}

# Sets the cluster_name 
variable "cluster_name" {
}

# Sets the ecs_service name
variable "ecs_service_name" {
}

# Do we create resources
variable "create" {
}

# The minimum capacity in tasks for this service
variable "desired_min_capacity" {
}

# The maximum capacity in tasks for this service
variable "desired_max_capacity" {
}

# List of maps with scaling properties
variable "scaling_properties" {
  default = []
}

