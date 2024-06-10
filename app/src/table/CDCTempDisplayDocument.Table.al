table 6085772 "CDC Temp. Display Document"
{
    Caption = 'Document';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Document ID"; Text[250])
        {
            Caption = 'Document ID';
        }
        field(3; "File Name"; Text[250])
        {
            Caption = 'Filename';
        }
        field(4; "File Path"; Text[250])
        {
            Caption = 'File Path';
        }
        field(5; "Date/Time"; DateTime)
        {
            Caption = 'Date/Time';
        }
        field(6; "Is Cloud OCR"; Boolean)
        {
            Caption = 'Is Cloud OCR';
        }
        field(7; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'OCR,Import,Error';
            OptionMembers = OCR,Import,Error;
        }
        field(8; "Document Category Code"; Code[20])
        {
            Caption = 'Document Category Code';
        }
        field(9; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(10; "From E-Mail Address"; Text[200])
        {
            Caption = 'From Email Address';
        }
        field(11; "E-Mail Subject"; Text[200])
        {
            Caption = 'Email Subject';
        }
        field(12; "E-Mail Received"; DateTime)
        {
            Caption = 'Email Received';
        }
        field(13; "OCR Processed"; DateTime)
        {
            Caption = 'OCR Processed';
        }
        field(14; "File Name with Extension"; Text[250])
        {
            Caption = 'File Name with Extension';
        }
        field(15; "Scanned File"; Boolean)
        {
            Caption = 'Scanned File';
        }
        field(20; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Email,File Path,Continia Delivery Network';
            OptionMembers = Email,LocalPath,CDN;
        }
        field(21; From; Text[200])
        {
            Caption = 'From';
        }
        field(22; "CDN GUID"; Guid)
        {
            Caption = 'CDN GUID';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    procedure ShowFile()
    begin
    end;

    procedure Import()
    begin
    end;

    procedure ShowXmlStyledFile()
    begin
    end;

    procedure GetErrorText(): Text[1024]
    begin
    end;

    procedure Retry()
    begin
    end;
}