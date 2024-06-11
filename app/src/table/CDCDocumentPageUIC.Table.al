table 6085602 "CDC Document Page (UIC)"
{
    Caption = 'Document Page (Unidentified Company)';
    DataPerCompany = false;

    fields
    {
        field(2; "Page No."; Integer)
        {
            Caption = 'Page No.';
        }
        field(3; "Bottom Word Pos."; Integer)
        {
            Caption = 'Bottom Word Pos.';
        }
        field(4; Height; Integer)
        {
            Caption = 'Height';
        }
        field(5; Width; Integer)
        {
            Caption = 'Width';
        }
        field(6; "Original Filename"; Text[250])
        {
            Caption = 'Original Filename';
        }
        field(7; "TIFF Image Color Mode"; Option)
        {
            Caption = 'TIFF Image Color Mode';
            OptionCaption = 'Black & White,Gray,Color';
            OptionMembers = "Black & White",Gray,Color;
        }
        field(8; "TIFF Image Resolution"; Integer)
        {
            Caption = 'TIFF Image Resolution';
            InitValue = 100;
            MinValue = 0;
        }
        field(10; "PNG Data"; BLOB)
        {
            Caption = 'PNG Data';
        }
        field(100; "Document Code"; Code[50])
        {
            Caption = 'Document Code';
        }
    }

    keys
    {
        key(Key1; "Document Code", "Page No.")
        {
            Clustered = true;
        }
    }
    // procedure GetPngFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    // begin
    // end;

    // procedure SetPngFile(var TempFile: Record "CDC Temp File" temporary): Boolean
    // begin
    // end;

    procedure HasPngFile(): Boolean
    begin
    end;


    procedure SetCurrentCompany(NewCompanyName: Text[50])
    begin
    end;
}