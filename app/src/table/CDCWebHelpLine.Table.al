table 6086008 "CDC Web Help Line"
{
    Caption = 'Web Help Line';
    DataPerCompany = false;

    fields
    {
        field(1; Section; Option)
        {
            Caption = 'Section';
            OptionCaption = 'Main';
            OptionMembers = Main;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; Heading; Boolean)
        {
            Caption = 'Heading';
        }
        field(4; Text; Text[250])
        {
            Caption = 'Text';
        }
        field(5; Bold; Boolean)
        {
            Caption = 'Bold';
        }
        field(6; Italic; Boolean)
        {
            Caption = 'Italic';
        }
        field(7; Underline; Boolean)
        {
            Caption = 'Underline';
        }
        field(8; Link; Text[250])
        {
            Caption = 'Link';

            trigger OnValidate()
            begin
                ValidateLinkPath;
            end;
        }
        field(9; "Link Type"; Option)
        {
            Caption = 'Link Type';
            OptionCaption = ' ,Web Address,Local File';
            OptionMembers = " ","Web Address","Local File";

            trigger OnValidate()
            begin
                ValidateLinkPath;
            end;
        }
        field(10; "Open Link in new Window"; Boolean)
        {
            Caption = 'Open Link in new Window';
        }
    }

    keys
    {
        key(Key1; Section, "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text001: Label 'You did not enter an UNC-path for the link.\\Please make sure that you have entered a path that is accessible from the Document Capture web server.';


    procedure ValidateLinkPath()
    begin
        if (Link = '') or ("Link Type" <> "Link Type"::"Local File") then
            exit;

        if CopyStr(Link, 1, 2) <> '\\' then
            Message(Text001);
    end;
}

