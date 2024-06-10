table 12032012 "DC - Document Field"
{
    // Copyright (Exclusive Rights): COSMO CONSULT Licensing GmbH, Sarnen, Switzerland
    // cc|document configurator (CCDC)
    // cc|formatted documents (CCFD)

    Caption = 'Document Field';

    fields
    {
        field(1; "Page No."; Integer)
        {
            Caption = 'Document Page No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
        field(3; "Field No."; Integer)
        {
            Caption = 'Field No.';
        }
        field(4; Text; Text[250])
        {
            Caption = 'Text';
        }
        field(5; Indentation; Integer)
        {
            Caption = 'Indentation';
        }
        field(6; "Font Style"; Option)
        {
            Caption = 'Font Style';
            Description = 'Internal Enum: Do not translate options';
            OptionMembers = Normal,Italic;
        }
        field(7; "Font Family"; Text[30])
        {
            Caption = 'Font Family';
        }
        field(8; "Font Size"; Integer)
        {
            Caption = 'Font Size';
        }
        field(9; "Font Weight"; Option)
        {
            Caption = 'Font Weight';
            Description = 'Internal Enum: Do not translate options';
            OptionMembers = Normal,Lighter,Thin,"Extra Light",Light,Medium,"Semi-bold",Bold,"Extra Bold",Heavy,Bolder;
        }
        field(10; "Text Alignment"; Option)
        {
            Caption = 'Text Alignment';
            Description = 'Internal Enum: Do not translate options';
            OptionMembers = Left,Center,Right;
        }
        field(11; "Text Decoration"; Option)
        {
            Caption = 'Text Decoration';
            Description = 'Internal Enum: Do not translate options';
            OptionMembers = "None",Underline,Overline,LineThrough;
        }
        field(12; "Vertical Alignment"; Option)
        {
            Caption = 'Vertical Alignment';
            Description = 'Internal Enum: Do not translate options';
            OptionMembers = Top,Middle;
        }
        field(13; Width; Integer)
        {
            Caption = 'Width';
        }
        field(14; "Fore Color"; Text[30])
        {
            Caption = 'Fore Color';
        }
        field(20; "Is BLOB Field"; Boolean)
        {
        }
        field(21; "Binary Large Object"; BLOB)
        {
            Caption = 'FD Blob';
        }
        field(22; "BLOB Field Usage"; Option)
        {
            Caption = 'BLOB Field Usage';
            Description = 'CCFD';
            OptionCaption = 'Ignore,Image,,,,,Formatted Documents';
            OptionMembers = Ignore,Image,,,,,"Formatted Documents";
        }
        field(23; "BLOB Use by System"; Boolean)
        {
            Caption = 'BLOB Use by System';
        }
        field(25; "Carry Over"; Option)
        {
            Caption = 'Carry Over';
            OptionCaption = ' ,Create,,,,,Stop';
            OptionMembers = " ",Create,,,,,Stop;
        }
        field(26; "Numeric Value"; Decimal)
        {
            Caption = 'Numeric Value';
        }
    }

    keys
    {
        key(Key1; "Page No.", "Line No.", "Field No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

