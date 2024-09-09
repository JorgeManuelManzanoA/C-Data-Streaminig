#!/bin/bash

# Definir variables
IMAGE_NAME="hello-world-csharp"
CONTAINER_NAME="hello-world-csharp-container"

# Crear el archivo Program.cs con manejo de datos continuos
cat <<EOF > Program.cs
using System;
using System.IO;
using System.Text;
using System.Threading.Tasks;

class Program
{
    static async Task Main()
    {
        // Imprimir un mensaje inicial
        Console.WriteLine("Iniciando el streaming de datos...\n");

        // Configuración del stream de datos continuo
        using (var stream = new MemoryStream())
        {
            // Generación continua de datos
            for (int i = 0; i < 5; i++)
            {
                string data = $"Mensaje de datos en streaming #{i + 1}";
                
                // Escribir los datos en el stream
                byte[] buffer = Encoding.UTF8.GetBytes(data);
                await stream.WriteAsync(buffer, 0, buffer.Length);
                stream.Flush();

                // Leer el contenido del stream desde la última posición
                stream.Position = 0;
                using (var reader = new StreamReader(stream, Encoding.UTF8, true, buffer.Length, leaveOpen: true))
                {
                    string message = await reader.ReadToEndAsync();
                    Console.WriteLine($"Contenido del stream: {message}");
                }

                // Limpiar el stream para los próximos datos
                stream.SetLength(0);
                stream.Position = 0;

                // Simular un retraso entre los datos continuos
                await Task.Delay(1000);
            }
        }

        Console.WriteLine("\\nFin del streaming de datos.");
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
RUN dotnet new console -o app && \\
    cp Program.cs app/ && \\
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
