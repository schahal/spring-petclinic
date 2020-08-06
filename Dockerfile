FROM openjdk:8-jre-alpine as base
FROM maven:3.6.3 as builder

LABEL name="Spring PetClinic Sample App" version="1.0"

WORKDIR /code

# Copy source to the maven container and build the jar.
# We want to build on maven:3.6.3 as that what the app documents,
# but once built, we'll pull the jar into the small alpin base image.
COPY ./ /code/
RUN unset MAVEN_CONFIG && ./mvnw -B -DskipTests clean package

FROM base

# Now copy the jar(s) from the builder (big) to the base image (which
# should be considerably smaller for distribution

WORKDIR /app

COPY --from=builder /code/target/*.jar /app/

EXPOSE 8080

CMD java -jar /app/*.jar

