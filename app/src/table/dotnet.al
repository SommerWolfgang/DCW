dotnet
{
    assembly("mscorlib")
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';

        type("System.IO.File"; "File")
        {
        }

        type("System.IO.FileInfo"; "FileInfo")
        {
        }
    }

}
