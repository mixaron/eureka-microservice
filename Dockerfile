# 1. Используем официальный базовый образ OpenJDK с минимальной версией JRE
FROM maven:3.8.5-openjdk-17-slim as builder

# 2. Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app

# 3. Копируем файл сборки проекта (обычно это pom.xml для Maven или build.gradle для Gradle)
COPY pom.xml ./

# 4. Загружаем зависимости для ускорения последующих сборок
RUN --mount=type=cache,target=/root/.m2 mvn dependency:go-offline -B

# 5. Копируем остальные исходные файлы проекта
COPY src ./src

# 6. Собираем jar-файл приложения
RUN mvn clean package -DskipTests

# 7. Используем минимальный образ JRE для запуска приложения
FROM openjdk:17-jdk-slim

# 8. Устанавливаем рабочую директорию для запуска приложения
WORKDIR /app

# 9. Копируем jar-файл из предыдущего этапа
COPY --from=builder /app/target/*.jar app.jar


# 11. Устанавливаем команду для запуска приложения
ENTRYPOINT ["java","-jar","app.jar"]
