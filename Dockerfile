From openjdk:latest
WORKDIR /myapp
Add . .
run javac SimpleClass.java
cmd java SimpleClass
