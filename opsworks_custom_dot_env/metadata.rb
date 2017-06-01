name        "opsworks_custom_dot_env"
maintainer  "John Doe"
description "This recipe allow you to use environment variables inside your Rails app when you use a AWS OpsWorks stack."

recipe "opsworks_custom_env::default", "Generate a .env file to contain all environment variables"
