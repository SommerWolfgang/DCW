table 6085614 "CDC Temp File"
{

    fields
    {
        field(1; Path; Text[250])
        {
            Caption = 'Path';
        }
        field(2; "Is A File"; Boolean)
        {
            Caption = 'Is A File';
        }
        field(3; Name; Text[199])
        {
            Caption = 'Name';
        }
        field(4; Size; Integer)
        {
            Caption = 'Size';
        }
        field(5; Date; Date)
        {
            Caption = 'Date';
        }
        field(6; "File Time"; Time)
        {
            Caption = 'File Time';
        }
        field(7; Data; BLOB)
        {
            Caption = 'Data';
        }
        field(10; "File Location"; Option)
        {
            Caption = 'File Location';
            OptionMembers = Memory,"Client File System","Server File System";
        }
        field(11; "Path Hash"; Text[50])
        {
            Caption = 'Path Hash';
        }
    }

    keys
    {
        key(Key1; "Path Hash", Name)
        {
            Clustered = true;
        }
        key(Key2; "Is A File", Name)
        {
        }
    }
    procedure CreateFromFileIfExist(FilePath: Text; InMemoryCopy: Boolean): Boolean
    begin
    end;

    procedure CreateEmpty(FilePath: Text)
    begin
    end;

    procedure CreateTemp(Extension2: Text)
    begin
    end;

    procedure CreateFromStream(FilePath: Text; ReadStream: InStream)
    begin
    end;

    procedure CreateFromClientFilePath(ClientFilePath: Text)
    begin
    end;

    procedure CreateFromDataUrl(var DataUrl: Text): Boolean
    begin
        DataUrl := '';
    end;

    procedure CreateFromUrlPath(FromUrl: Text): Boolean
    begin
    end;

    procedure CreateWithSaveDialog(WindowTitle: Text[50]; FilterString: Text) ClientFilePath: Text
    begin
    end;

    procedure BrowseFile(WindowTitle: Text[50]; DefaultFileName: Text; FilterString: Text) ClientFilePath: Text
    begin
    end;

    procedure SaveFileWithDialog(WindowTitle: Text[50]; FilterString: Text) Ok: Boolean
    begin
    end;

    procedure SetFullFileName(FilePath: Text)
    begin
    end;

    procedure GetDataStream(var ReadStream: InStream)
    begin
    end;

    procedure GetFullFileName() FullFileName: Text
    begin
    end;

    procedure GetFilePath() FilePath: Text
    begin
    end;

    procedure GetClientFilePath() ClientFilePath: Text
    begin
    end;

    procedure GetDataLength() Length: Integer
    begin
    end;

    procedure Extension(): Text
    begin
    end;

    procedure SaveToServerFolderPath(FolderPath: Text): Boolean
    begin
    end;

    procedure SaveToServerFilePath(FilePath: Text): Boolean
    begin
    end;

    procedure SaveToClient(ClientFilePathNew: Text) ClientFilePath: Text
    begin
    end;

    procedure Open()
    begin
    end;

    procedure GetDataAsBase64EncodedText(): Text
    begin
    end;

    procedure GetContentAsDataUrl(): Text
    begin
    end;

    procedure GetContentAsText() ReadText: Text
    var
        ReadStream: InStream;
    begin
        GetDataStream(ReadStream);
        ReadStream.ReadText(ReadText);
    end;


    procedure LoadData()
    begin
    end;

    procedure DeleteFile()
    begin
    end;

    procedure GetExtensionFilter(): Text
    begin
    end;

    procedure GetFromFullFileName(FilePath: Text) Result: Boolean
    begin
    end;

    procedure CheckFilePathLength(ClientFilePath: Text)
    begin
    end;
}