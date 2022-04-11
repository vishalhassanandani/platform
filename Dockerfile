From openjdk:latest
WORKDIR /myapp
Add . .
run javac app/SimpleClass.java
cmd java app/SimpleClass
