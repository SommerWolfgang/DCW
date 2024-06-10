table 6086237 "CTS-CDN Document Receipt"
{
    Caption = 'Document Receipt';

    fields
    {
        field(1; "System ID"; Integer)
        {
            AutoIncrement = true;
            Caption = 'System ID';
        }
        field(2; "Document ID"; Integer)
        {
            Caption = 'Document ID';
        }
        field(3; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Success,Error';
            OptionMembers = Success,Error;
        }
        field(4; "Error Code"; Code[20])
        {
            Caption = 'Error Code';
        }
        field(5; "Error Message"; Text[250])
        {
            Caption = 'Error Message';
        }
        field(10; "XML File"; BLOB)
        {
            Caption = 'XML File';
        }
        field(20; "CDN GUID"; Guid)
        {
            Caption = 'CDN GUID';
        }
        field(21; Created; DateTime)
        {
            Caption = 'Created Date-Time';
        }
    }

    keys
    {
        key(Key1; "System ID")
        {
            Clustered = true;
        }
        key(Key2; "CDN GUID")
        {
        }
    }

    fieldgroups
    {
    }

    procedure GetGUIDAsText(): Text[36]
    begin
        exit(DelChr(Rec."CDN GUID", '<>', '{}'))
    end;


    procedure OpenXmlFile()
    var
        TempBlob: Record "CSC Temp Blob" temporary;
        CDNFileMgt: Codeunit "CTS-CDN File Management";
        Success: Boolean;
    begin
        TempBlob.Init;
        Rec.CalcFields("XML File");
        TempBlob.Blob := Rec."XML File";
        CDNFileMgt.SaveFileWithDialog(TempBlob, GetGUIDAsText + '.xml', 'Download', 'File (*.xml)|*.xml', Success);
    end;
}

