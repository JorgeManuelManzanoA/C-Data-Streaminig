# Usar la imagen base de .NET SDK
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar el archivo de código fuente
COPY Program.cs .

# Compilar la aplicación
RUN dotnet new console -o app && \
    cp Program.cs app/ && \
    dotnet publish -c Release -o out app

# Establecer el directorio de trabajo para la imagen final
WORKDIR /app/out

# Ejecutar la aplicación
ENTRYPOINT ["dotnet", "app.dll"]
