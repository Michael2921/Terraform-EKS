FROM eclipse-temurin:21-jdk
EXPOSE 8080
RUN mkdir /opt/app
COPY java-app/build/libs/bootcamp-kubernetes-exercise-project-1.0-SNAPSHOT.jar /opt/app
WORKDIR /opt/app
CMD ["java", "-jar", "bootcamp-kubernetes-exercise-project-1.0-SNAPSHOT.jar"] 