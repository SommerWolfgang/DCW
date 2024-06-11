table 12032013 "DC - Document Print Queue"
{
    // Copyright (Exclusive Rights): COSMO CONSULT Licensing GmbH, Sarnen, Switzerland
    // cc|document configurator (CCDC)

    Caption = 'Document Print Queue';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Document Layout No."; Code[20])
        {
            Caption = 'Document Layout No.';
        }
        field(3; Position; Text[250])
        {
            Caption = 'Position';
        }
        field(4; "Language Code"; Code[20])
        {
            Caption = 'Language Code';
        }
        field(5; "No Of Copies"; Integer)
        {
            Caption = 'No. of Copies';
        }
        field(6; "Printer Name"; Text[250])
        {
            Caption = 'Printer Name';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

