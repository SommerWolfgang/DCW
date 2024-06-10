table 12032011 "DC - Document Line"
{
    // Copyright (Exclusive Rights): COSMO CONSULT Licensing GmbH, Sarnen, Switzerland
    // cc|document configurator (CCDC)

    Caption = 'Document Line';

    fields
    {
        field(1; "Page No."; Integer)
        {
            Caption = 'Page No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; Section; Option)
        {
            Caption = 'Section';
            OptionCaption = 'Header,Line,Footer';
            OptionMembers = Header,Line,Footer;
        }
        field(6; Pages; Option)
        {
            Caption = 'Pages';
            OptionCaption = 'All,First,Last,Not First,Not Last';
            OptionMembers = All,First,Last,"Not First","Not Last";
        }
        field(7; "Horizontal Line"; Boolean)
        {
            Caption = 'Horizontal Line';
        }
        field(8; "Page Break Counter"; Integer)
        {
            Caption = 'Page Break Counter';
        }
    }

    keys
    {
        key(Key1; "Page No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

