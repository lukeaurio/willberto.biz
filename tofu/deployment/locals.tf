locals {
  project_name_sanitized = lower(var.project_name) #This is to prevent unnecessary recreates from the lower function. 
}