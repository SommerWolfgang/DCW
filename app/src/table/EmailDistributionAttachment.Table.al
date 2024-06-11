table 12032507 "Email Distribution Attachment"
{
    fields
    {
        field(1; "Email Distribution Code"; Code[10])
        {
            Caption = 'Email Distribution Code';
            NotBlank = true;
            TableRelation = "Email Distribution Setup"."Email Distribution Code";
        }
        field(5; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
        }
        field(7; "Use for Code"; Code[20])
        {
            Caption = 'Use for Code';
        }
        field(9; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(15; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(16; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(50; "File BLOB"; BLOB)
        {
            Caption = 'File Uploaded';
        }
        field(51; "Display File Name"; Text[80])
        {
            Caption = 'File Name';
            NotBlank = true;
        }
    }

    keys
    {
        key(Key1; "Email Distribution Code", "Language Code", "Use for Code", "Line No.")
        {
            Clustered = true;
        }
    }
    procedure UploadFile(ClientFileName: Text)
    begin
    end;

    procedure DownloadFile(ClientFileName: Text)
    begin
    end;
}