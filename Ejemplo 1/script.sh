#!/bin/bash

# Definir variables
IMAGE_NAME="hello-world-csharp"
CONTAINER_NAME="hello-world-csharp-container"

# Crear el archivo Program.cs
cat <<EOF > Program.cs
using System;
using System.IO;

class Program
{
    static void Main()
    {
        // Imprimir "Hola Mundo"
        Console.WriteLine("Hola Mundo");

        // Configuración del stream de datos
        using (var stream = new MemoryStream())
        using (var writer = new StreamWriter(stream))
        {
            writer.WriteLine("Mensaje de datos en streaming");
            writer.Flush();
            stream.Position = 0;

            // Leer el contenido del stream
            using (var reader = new StreamReader(stream))
            {
                string message = reader.ReadToEnd();
                Console.WriteLine("Contenido del stream: " + message);
            }
        }
    }
}
EOF

# Crear el archivo Dockerfile
cat <<EOF > Dockerfile
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
EOF

# Construir la imagen Docker
docker build -t $IMAGE_NAME .

# Ejecutar el contenedor Docker
docker run --name $CONTAINER_NAME $IMAGE_NAME

# Limpiar recursos
docker rm $CONTAINER_NAME
