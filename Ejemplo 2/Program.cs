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

        Console.WriteLine("\nFin del streaming de datos.");
    }
}
