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
    procedure GetGUIDAsText(): Text[36]
    begin
    end;


    procedure OpenXmlFile()
    begin
    end;
}
