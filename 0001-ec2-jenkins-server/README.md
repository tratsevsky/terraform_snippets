AWS Region: us-east-1 (N. Virginia)  
AMI:        ami-04505e74c0741db8d (Ubuntu 20.04 LTS)  
Instance:   t2.micro  

Userdata:
+  Install Apache (latest) (optional)  
+  Install Java 11  
+  Install Jenkins (latest)

Security group open ports:
+  tcp/22 (SSH)
+  tcp/80 (Webserver)
+  tcp/8080 (Jenkins)
