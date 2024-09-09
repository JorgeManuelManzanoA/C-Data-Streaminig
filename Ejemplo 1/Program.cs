using System;
using System.IO;

class Program
{
    static void Main()
    {
        // Imprimir "Hola Mundo"
        Console.WriteLine("Hola Mundo");

        // Crear un MemoryStream para datos en memoria
        using (var stream = new MemoryStream())
        // Crear un StreamWriter para escribir en el stream
        using (var writer = new StreamWriter(stream))
        {
            // Escribir un mensaje en el stream
            writer.WriteLine("Mensaje de datos en streaming");
            // Asegurarse de que los datos se escriban
            writer.Flush();
            // Reiniciar la posición del stream
            stream.Position = 0;

            // Crear un StreamReader para leer el stream
            using (var reader = new StreamReader(stream))
            {
                // Leer y mostrar el contenido del stream
                string message = reader.ReadToEnd();
                Console.WriteLine("Contenido del stream: " + message);
            }
        }
    }
}
